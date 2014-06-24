//
//  Tweet.h
//  twitter
//
//  Created by Rajeev Nayak on 6/21/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "MTLModel.h"
#import "User.h"
#import <MTLJSONAdapter.h>

@interface Tweet : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSString *idStr;
@property (nonatomic, copy, readonly) User *user;
@property (nonatomic, copy, readonly) NSDate *createdAt;
@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, copy, readonly) Tweet *retweetedTweet;
@property (nonatomic, readonly) NSInteger retweetCount;
@property (nonatomic, readonly) NSInteger favoriteCount;

@end
