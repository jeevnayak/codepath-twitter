//
//  TwitterClient.h
//  twitter
//
//  Created by Rajeev Nayak on 6/19/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)instance;

- (void)startLogin;
- (void)finishLoginWithRequestURL:(NSURL *)requestURL;

@end
