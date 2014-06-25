//
//  TwitterClient.m
//  twitter
//
//  Created by Rajeev Nayak on 6/19/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "TwitterClient.h"
#import "User.h"
#import <MTLJSONAdapter.h>

@implementation TwitterClient

+ (TwitterClient *)instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"] consumerKey:@"5WH66EbuO9quphSDbTEhD3CIS" consumerSecret:@"XAcUphWOlPwIXqFmx4hVhH1sAqnAUh1GBqfE25IR8NpW5YSiBB"];
    });
    return instance;
}

- (void)startLogin {
    [self fetchRequestTokenWithPath:@"oauth/request_token"
                             method:@"POST"
                        callbackURL:[NSURL URLWithString:@"acoupletweets://oauth_request_token"]
                              scope:nil
                            success:^(BDBOAuthToken *requestToken) {
                                // open the browser so the user can sign in
                                NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
                            } failure:^(NSError *error) {
                                // TODO: notify UI
                                NSLog(@"failed request token");
                            }];
};

- (void)finishLoginWithRequestURL:(NSURL *)requestURL {
    [self fetchAccessTokenWithPath:@"oauth/access_token"
                            method:@"POST"
                      requestToken:[BDBOAuthToken tokenWithQueryString:requestURL.query]
                           success:^(BDBOAuthToken *accessToken) {
                               [[TwitterClient instance].requestSerializer saveAccessToken:accessToken];
                               [self currentUserWithSuccess:^(AFHTTPRequestOperation *operation, User *currentUser) {
                                   // set the current user and notify the UI
                                   [User setCurrentUser:currentUser];
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginCompleteNotification" object:self];
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   // TODO: notify UI
                                   NSLog(@"failed user info");
                               }];
                               [User setCurrentUser:[[User alloc] init]];
                           }
                           failure:^(NSError *error) {
                               // TODO: notify UI
                               NSLog(@"failed access token");
                           }];
}

- (void)logout {
    [self deauthorize];
    [User setCurrentUser:nil];
}

- (void)homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, NSArray *tweets))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [MTLJSONAdapter modelsOfClass:[Tweet class] fromJSONArray:responseObject error:nil];
        success(operation, tweets);
    } failure:failure];
}

- (void)homeTimelineSinceTweetWithIdStr:(NSString *)idStr success:(void (^)(AFHTTPRequestOperation *operation, NSArray *tweets))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:@{@"since_id": idStr} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [MTLJSONAdapter modelsOfClass:[Tweet class] fromJSONArray:responseObject error:nil];
        success(operation, tweets);
    } failure:failure];
}

- (void)homeTimelineWithMaxTweetIdStr:(NSString *)idStr success:(void (^)(AFHTTPRequestOperation *operation, NSArray *tweets))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:@{@"max_id": idStr} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [MTLJSONAdapter modelsOfClass:[Tweet class] fromJSONArray:responseObject error:nil];
        success(operation, tweets);
    } failure:failure];
}

- (void)postTweet:(NSString *)tweetText success:(void (^)(AFHTTPRequestOperation *operation, Tweet *tweet))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self POST:@"1.1/statuses/update.json" parameters:@{@"status": tweetText} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [MTLJSONAdapter modelOfClass:[Tweet class] fromJSONDictionary:responseObject error:nil];
        success(operation, tweet);
    } failure:failure];
}

- (void)postReply:(NSString *)tweetText toTweetWithIdStr:(NSString *)idStr success:(void (^)(AFHTTPRequestOperation *operation, Tweet *tweet))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSLog(@"replying to %@", idStr);
    [self POST:@"1.1/statuses/update.json" parameters:@{@"status": tweetText, @"in_reply_to_status_id": idStr} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [MTLJSONAdapter modelOfClass:[Tweet class] fromJSONDictionary:responseObject error:nil];
        success(operation, tweet);
    } failure:failure];
}

- (void)currentUserWithSuccess:(void (^)(AFHTTPRequestOperation *operation, User *currentUser))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        User *currentUser = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:responseObject error:nil];
        success(operation, currentUser);
    } failure:failure];
}

@end
