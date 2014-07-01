//
//  ProfileViewController.m
//  twitter
//
//  Created by Rajeev Nayak on 6/30/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "ProfileViewController.h"
#import "TweetDetailViewController.h"
#import "UserStatsCell.h"
#import "TwitterClient.h"
#import "UIImage+ImageEffects.h"
#import <MBProgressHUD.h>
#import <UIImageView+AFNetworking.h>

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UIImage *bannerImage;
@property (nonatomic, strong) UserStatsCell *prototypeUserStatsCell;
@property (nonatomic, strong) TweetCell *prototypeTweetCell;
@property (nonatomic, strong) NSArray *tweets;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Profile";
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // init the table view
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];
    self.prototypeTweetCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    UINib *userStatsCellNib = [UINib nibWithNibName:@"UserStatsCell" bundle:nil];
    [self.tableView registerNib:userStatsCellNib forCellReuseIdentifier:@"UserStatsCell"];
    self.prototypeUserStatsCell = [self.tableView dequeueReusableCellWithIdentifier:@"UserStatsCell"];

    // init the header views
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    self.bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    self.bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.headerView addSubview:self.bannerImageView];
    UIView *profileImageContainer = [[UIView alloc] initWithFrame:CGRectMake(128, 20, 64, 64)];
    profileImageContainer.backgroundColor = [UIColor whiteColor];
    profileImageContainer.layer.cornerRadius = 5;
    [self.headerView addSubview:profileImageContainer];
    UIImageView *profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 56, 56)];
    profileImage.layer.cornerRadius = 3;
    profileImage.clipsToBounds = YES;
    [profileImageContainer addSubview:profileImage];
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 320, 20)];
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.font = [UIFont boldSystemFontOfSize:16];
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:userNameLabel];
    UILabel *userScreenNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 108, 320, 20)];
    userScreenNameLabel.textColor = [UIColor whiteColor];
    userScreenNameLabel.font = [UIFont systemFontOfSize:13];
    userScreenNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:userScreenNameLabel];

    // populate the header views
    UIImageView *bannerImageView = self.bannerImageView;
    [bannerImageView setImageWithURLRequest:[NSURLRequest requestWithURL:self.user.profileBannerUrl] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.bannerImage = image;
        self.bannerImageView.image = image;
    } failure:nil];
    [profileImage setImageWithURL:self.user.profileImageUrl];
    userNameLabel.text = self.user.name;
    userScreenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    self.tableView.tableHeaderView = self.headerView;

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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // +1 to include the stats cell
    return self.tweets.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UserStatsCell *userStatsCell = [tableView dequeueReusableCellWithIdentifier:@"UserStatsCell" forIndexPath:indexPath];
        userStatsCell.user = self.user;
        return userStatsCell;
    }

    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row - 1];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.prototypeUserStatsCell.user = self.user;
        [self.prototypeUserStatsCell layoutSubviews];
        CGSize size = [self.prototypeUserStatsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height + 1;
    }

    self.prototypeTweetCell.tweet = self.tweets[indexPath.row - 1];
    [self.prototypeTweetCell layoutSubviews];
    CGSize size = [self.prototypeTweetCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112; // height of a 4-line non-retweeted tweet
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    vc.tweet = self.tweets[indexPath.row - 1];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = self.tableView.contentOffset.y;
    if (offset < 0) {
        // enlarge and blur the header image
        self.headerView.frame = CGRectMake(0, offset, 320, 150 - offset);
        self.bannerImageView.frame = CGRectMake(0, offset, 320, 150 - offset);
        CGFloat blurRadius = -offset/8;
        CGFloat tintAlpha = MIN(-offset/800, 1);
        self.bannerImageView.image = [self.bannerImage applyBlurWithRadius:blurRadius tintColor:[UIColor colorWithWhite:0.97 alpha:tintAlpha] saturationDeltaFactor:1 maskImage:nil];
    } else {
        // restore the header to normal
        self.headerView.frame = CGRectMake(0, 0, 320, 150);
        self.bannerImageView.frame = CGRectMake(0, 0, 320, 150);
        self.bannerImageView.image = self.bannerImage;
    }
}

#pragma mark - TweetCellDelegate

- (void)didTapProfileImage:(TweetCell *)cell {
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    vc.user = cell.tweet.user;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - network requests

- (void)loadTweetsWithCompletionHandler:(void (^)(void))completionHandler {
    [[TwitterClient instance] timelineForUser:self.user success:^(AFHTTPRequestOperation *operation, NSArray *tweets) {
        self.tweets = tweets;
        [self.tableView reloadData];
        completionHandler();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show network error view
        completionHandler();
    }];
}

@end
