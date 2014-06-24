//
//  TimelineViewController.h
//  twitter
//
//  Created by Rajeev Nayak on 6/21/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeTweetViewController.h"

@interface TimelineViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ComposeTweetViewControllerDelegate>

@end
