//
//  TweetCell.m
//  twitter
//
//  Created by Rajeev Nayak on 6/21/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "TweetCell.h"
#import <UIImageView+AFNetworking.h>
#import <NSDate+DateTools.h>

NSInteger const kTweetCellTopPaddingWithoutRetweet = 10;
NSInteger const kTweetCellTopPaddingWithRetweet = 28;

@interface TweetCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retweetedByIcon;
@property (weak, nonatomic) IBOutlet UILabel *retweetedByUserNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPadding;

@end

@implementation TweetCell

- (void)awakeFromNib
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapProfileImage)];
    [self.userProfileImageView addGestureRecognizer:tapGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    [self reloadData];
}

- (void)reloadData {
    self.userProfileImageView.image = nil;

    Tweet *tweetToDisplay;
    if (self.tweet.retweetedTweet == nil) {
        // configure the cell to hide the retweeted status
        tweetToDisplay = self.tweet;
        self.retweetedByIcon.hidden = YES;
        self.retweetedByUserNameLabel.hidden = YES;
        self.topPadding.constant = kTweetCellTopPaddingWithoutRetweet;
    } else {
        // configure the cell to show the retweeted status
        tweetToDisplay = self.tweet.retweetedTweet;
        self.retweetedByIcon.hidden = NO;
        self.retweetedByUserNameLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.user.name];
        self.retweetedByUserNameLabel.hidden = NO;
        self.topPadding.constant = kTweetCellTopPaddingWithRetweet;
    }

    [self.userProfileImageView setImageWithURL:tweetToDisplay.user.profileImageUrl];
    self.userNameLabel.text = tweetToDisplay.user.name;
    self.userScreenNameLabel.text = [NSString stringWithFormat:@"@%@", tweetToDisplay.user.screenName];
    self.createdAtLabel.text = tweetToDisplay.createdAt.shortTimeAgoSinceNow;
    self.tweetTextLabel.text = tweetToDisplay.text;
}

- (void)onTapProfileImage {
    [self.delegate didTapProfileImage:self];
}

@end
