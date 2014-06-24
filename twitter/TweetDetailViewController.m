//
//  TweetDetailViewController.m
//  twitter
//
//  Created by Rajeev Nayak on 6/22/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "ComposeTweetViewController.h"
#import <UIImageView+AFNetworking.h>
#import <NSDate+DateTools.h>

NSInteger const kTweetDetailTopPaddingWithoutRetweet = 10;
NSInteger const kTweetDetailTopPaddingWithRetweet = 32;

@interface TweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *numRetweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFavoritesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retweetedByIcon;
@property (weak, nonatomic) IBOutlet UILabel *retweetedByUserNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPadding;

@end

@implementation TweetDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tweet";

        // init the nav bar items
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReplyButton)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    Tweet *tweetToDisplay;
    if (self.tweet.retweetedTweet == nil) {
        // configure the view to hide the retweeted status
        tweetToDisplay = self.tweet;
        self.retweetedByIcon.hidden = YES;
        self.retweetedByUserNameLabel.hidden = YES;
        self.topPadding.constant = kTweetDetailTopPaddingWithoutRetweet;
    } else {
        // configure the view to show the retweeted status
        tweetToDisplay = self.tweet.retweetedTweet;
        self.retweetedByIcon.hidden = NO;
        self.retweetedByUserNameLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.user.name];
        self.retweetedByUserNameLabel.hidden = NO;
        self.topPadding.constant = kTweetDetailTopPaddingWithRetweet;
    }

    [self.userProfileImageView setImageWithURL:tweetToDisplay.user.profileImageUrl];
    self.userNameLabel.text = tweetToDisplay.user.name;
    self.userScreenNameLabel.text = [NSString stringWithFormat:@"@%@", tweetToDisplay.user.screenName];
    self.tweetTextLabel.text = tweetToDisplay.text;
    self.createdAtLabel.text = [tweetToDisplay.createdAt formattedDateWithFormat:@"M/dd/yy, hh:mm a"];
    self.numRetweetsLabel.text = [@(tweetToDisplay.retweetCount) stringValue];
    self.numFavoritesLabel.text = [@(tweetToDisplay.favoriteCount) stringValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onReplyButton {
    ComposeTweetViewController *vc = [[ComposeTweetViewController alloc] init];
    vc.replyTo = self.tweet;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
