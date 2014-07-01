//
//  ContentViewController.h
//  twitter
//
//  Created by Rajeev Nayak on 6/29/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentViewController;

@protocol ContentViewControllerDelegate <NSObject>

- (void)showSlideout:(ContentViewController *)vc;
- (void)hideSlideout:(ContentViewController *)vc;

@end

@interface ContentViewController : UINavigationController <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id <ContentViewControllerDelegate> slideoutDelegate;
@property (nonatomic) BOOL slideoutShowing;

@end
