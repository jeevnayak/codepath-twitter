//
//  SlideoutViewController.h
//  twitter
//
//  Created by Rajeev Nayak on 6/29/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SlideoutItem) {
    SlideoutItemProfile,
    SlideoutItemTimeline,
    SlideoutItemMentions,
    SlideoutItemLogout,
    SlideoutItemCount,
};

@class SlideoutViewController;

@protocol SlideoutViewControllerDelegate <NSObject>

- (void)slideoutViewController:(SlideoutViewController *)vc didSelectItem:(SlideoutItem)item;

@end

@interface SlideoutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <SlideoutViewControllerDelegate> delegate;

@end
