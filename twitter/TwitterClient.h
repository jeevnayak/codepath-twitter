//
//  TwitterClient.h
//  twitter
//
//  Created by Rajeev Nayak on 6/19/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)instance;

- (void)startLogin;
- (void)finishLoginWithRequestURL:(NSURL *)requestURL;
- (void)logout;
- (void)homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, NSArray *tweets))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)postTweet:(NSString *)tweetText success:(void (^)(AFHTTPRequestOperation *operation, Tweet *tweet))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)postReply:(NSString *)tweetText toTweetWithIdStr:(NSString *)idStr success:(void (^)(AFHTTPRequestOperation *operation, Tweet *tweet))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
