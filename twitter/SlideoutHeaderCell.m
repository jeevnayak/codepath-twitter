//
//  SlideoutHeaderCell.m
//  twitter
//
//  Created by Rajeev Nayak on 7/1/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "SlideoutHeaderCell.h"
#import <UIImageView+AFNetworking.h>

@interface SlideoutHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;

@end

@implementation SlideoutHeaderCell

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
    [self.userProfileImageView setImageWithURL:self.user.profileImageUrl];
    self.userNameLabel.text = self.user.name;
    self.userScreenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
}

@end
