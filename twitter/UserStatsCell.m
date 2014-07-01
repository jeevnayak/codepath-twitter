//
//  UserStatsCell.m
//  twitter
//
//  Created by Rajeev Nayak on 7/1/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "UserStatsCell.h"

@interface UserStatsCell ()

@property (weak, nonatomic) IBOutlet UILabel *numTweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowersLabel;

@end

@implementation UserStatsCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    _user = user;
    [self reloadData];
}

- (void)reloadData {
    self.numTweetsLabel.text = [@(self.user.numTweets) stringValue];
    self.numFollowingLabel.text = [@(self.user.numFollowing) stringValue];
    self.numFollowersLabel.text = [@(self.user.numFollowers) stringValue];
}

@end
