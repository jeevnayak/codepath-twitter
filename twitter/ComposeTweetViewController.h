//
//  ComposeTweetViewController.h
//  twitter
//
//  Created by Rajeev Nayak on 6/23/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol ComposeTweetViewControllerDelegate <NSObject>

- (void)didPostTweet:(Tweet *)tweet;

@end

@interface ComposeTweetViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) Tweet *replyTo;
@property (nonatomic, strong) id <ComposeTweetViewControllerDelegate> delegate;

@end
