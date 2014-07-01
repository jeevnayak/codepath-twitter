//
//  TwitterClient.h
//  twitter
//
//  Created by Rajeev Nayak on 6/19/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "Tweet.h"

typedef NS_ENUM(NSInteger, TimelineType) {
    TimelineTypeHome,
    TimelineTypeMentions,
    TimelineTypeCount,
};

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)instance;

- (void)startLogin;
- (void)finishLoginWithRequestURL:(NSURL *)requestURL;
- (void)logout;
- (void)timelineWithType:(TimelineType)type success:(void (^)(AFHTTPRequestOperation *operation, NSArray *tweets))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)timelineWithType:(TimelineType)type sinceTweetWithIdStr:(NSString *)idStr success:(void (^)(AFHTTPRequestOperation *operation, NSArray *tweets))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)timelineWithType:(TimelineType)type maxTweetIdStr:(NSString *)idStr success:(void (^)(AFHTTPRequestOperation *operation, NSArray *tweets))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)timelineForUser:(User *)user success:(void (^)(AFHTTPRequestOperation *operation, NSArray *tweets))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)postTweet:(NSString *)tweetText success:(void (^)(AFHTTPRequestOperation *operation, Tweet *tweet))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)postReply:(NSString *)tweetText toTweetWithIdStr:(NSString *)idStr success:(void (^)(AFHTTPRequestOperation *operation, Tweet *tweet))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
