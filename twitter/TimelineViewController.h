//
//  TimelineViewController.h
//  twitter
//
//  Created by Rajeev Nayak on 6/21/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeTweetViewController.h"
#import "TweetCell.h"
#import "TwitterClient.h"

@interface TimelineViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate, ComposeTweetViewControllerDelegate>

@property (nonatomic) TimelineType type;

@end
