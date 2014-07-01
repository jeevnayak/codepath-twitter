//
//  ProfileViewController.h
//  twitter
//
//  Created by Rajeev Nayak on 6/30/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetCell.h"
#import "User.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>

@property (nonatomic, strong) User *user;

@end
