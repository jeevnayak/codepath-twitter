//
//  TimelineViewController.m
//  twitter
//
//  Created by Rajeev Nayak on 6/21/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "TimelineViewController.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "TweetDetailViewController.h"
#import "LoginViewController.h"
#import <MBProgressHUD.h>

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
        self.title = @"Home";

        // init the nav bar items
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewButton)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // init the table view
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UINib *businessCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:businessCellNib forCellReuseIdentifier:@"TweetCell"];
    self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];

    // init the refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(onRefreshControl:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

    // fetch the tweets
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadTweetsWithCompletionHandler:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    vc.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didPostTweet:(Tweet *)tweet {
    NSArray *temp = @[tweet];
    self.tweets = [temp arrayByAddingObjectsFromArray:self.tweets];
    [self.tableView reloadData];
}

- (void)onSignOutButton {
    [[TwitterClient instance] logout];
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)onNewButton {
    ComposeTweetViewController *vc = [[ComposeTweetViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onRefreshControl:(UIRefreshControl *)refreshControl
{
    [self loadTweetsWithCompletionHandler:^{
        [refreshControl endRefreshing];
    }];
}

- (void)loadTweetsWithCompletionHandler:(void (^)(void))completionHandler {
    [[TwitterClient instance] homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *tweets) {
        self.tweets = tweets;
        [self.tableView reloadData];
        completionHandler();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show network error view
        completionHandler();
    }];
}

@end
