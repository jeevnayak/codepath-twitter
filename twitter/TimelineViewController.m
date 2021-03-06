//
//  TimelineViewController.m
//  twitter
//
//  Created by Rajeev Nayak on 6/21/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "TimelineViewController.h"
#import "TweetDetailViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import <MBProgressHUD.h>
#import <UIScrollView+SVPullToRefresh.h>
#import <UIScrollView+SVInfiniteScrolling.h>

@interface TimelineViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) TweetCell *prototypeCell;
@property (nonatomic, strong) NSArray *tweets;

@end

@implementation TimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // init the nav bar items
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewButton)];
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set the title
    switch (self.type) {
        case TimelineTypeHome:
            self.title = @"Home";
            break;
        case TimelineTypeMentions:
            self.title = @"Mentions";
            break;
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid type" userInfo:nil];
    }

    // init the table view
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];
    self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];

    // init pull to refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self loadNewTweetsWithCompletionHandler:^{
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }];

    // init infinite scroll
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self loadMoreTweetsWithCompletionHandler:^{
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    }];

    // fetch the initial tweets
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadInitialTweetsWithCompletionHandler:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeCell.tweet = self.tweets[indexPath.row];
    [self.prototypeCell layoutSubviews];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112; // height of a 4-line non-retweeted tweet
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    vc.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TweetCellDelegate

- (void)didTapProfileImage:(TweetCell *)cell {
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    vc.user = cell.tweet.user;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ComposeTweetViewControllerDelegate

- (void)didPostTweet:(Tweet *)tweet {
    NSArray *temp = @[tweet];
    self.tweets = [temp arrayByAddingObjectsFromArray:self.tweets];
    [self.tableView reloadData];
}

#pragma mark - event handlers

- (void)onNewButton {
    ComposeTweetViewController *vc = [[ComposeTweetViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - network requests

- (void)loadInitialTweetsWithCompletionHandler:(void (^)(void))completionHandler {
    [[TwitterClient instance] timelineWithType:self.type success:^(AFHTTPRequestOperation *operation, NSArray *tweets) {
        self.tweets = tweets;
        [self.tableView reloadData];
        completionHandler();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show network error view
        completionHandler();
    }];
}

- (void)loadNewTweetsWithCompletionHandler:(void (^)(void))completionHandler {
    [[TwitterClient instance] timelineWithType:self.type sinceTweetWithIdStr:((Tweet *)[self.tweets firstObject]).idStr success:^(AFHTTPRequestOperation *operation, NSArray *tweets) {
        if (tweets.count > 0) {
            // prepend the new tweets to the data
            self.tweets = [tweets arrayByAddingObjectsFromArray:self.tweets];

            // animate the new rows in
            NSMutableArray *newIndexPaths = [NSMutableArray array];
            for (int i = 0; i < tweets.count; i++) {
                [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        completionHandler();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show network error view
        completionHandler();
    }];
}

- (void)loadMoreTweetsWithCompletionHandler:(void (^)(void))completionHandler {
    NSString *lastTweetIdStr = ((Tweet *)[self.tweets lastObject]).idStr;
    long long maxIdToLoad = [lastTweetIdStr longLongValue] - 1;

    [[TwitterClient instance] timelineWithType:self.type maxTweetIdStr:[@(maxIdToLoad) stringValue] success:^(AFHTTPRequestOperation *operation, NSArray *tweets) {
        if (tweets.count > 0) {
            // append the new tweets to the data
            int prevNumTweets = self.tweets.count;
            self.tweets = [self.tweets arrayByAddingObjectsFromArray:tweets];

            // animate the new rows in
            NSMutableArray *newIndexPaths = [NSMutableArray array];
            for (int i = prevNumTweets; i < self.tweets.count; i++) {
                [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        completionHandler();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show network error view
        completionHandler();
    }];
}

@end
