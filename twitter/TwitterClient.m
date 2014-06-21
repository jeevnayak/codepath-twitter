//
//  TwitterClient.m
//  twitter
//
//  Created by Rajeev Nayak on 6/19/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "TwitterClient.h"

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
                                // open the browser so the user can log in
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
                               NSLog(@"got access token");
                           }
                           failure:^(NSError *error) {
                               // TODO: notify UI
                               NSLog(@"failed access token");
                           }];
}

@end
