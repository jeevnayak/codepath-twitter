//
//  User.m
//  twitter
//
//  Created by Rajeev Nayak on 6/21/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "User.h"
#import <MTLValueTransformer.h>

NSString * const kCurrentUserKey = @"current_user";

@implementation User

static User *_currentUser = nil;

+ (User *)currentUser {
    if (_currentUser == nil) {
        // try to load from NSUserDefaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *archivedUser = [defaults dataForKey:kCurrentUserKey];
        if (archivedUser) {
            _currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:archivedUser];
        }
    }

    return _currentUser;
}

+ (void)setCurrentUser:(User *)user {
    _currentUser = user;

    // save to NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (user == nil) {
        [defaults removeObjectForKey:kCurrentUserKey];
    } else {
        NSData *archivedUser = [NSKeyedArchiver archivedDataWithRootObject:_currentUser];
        [defaults setObject:archivedUser forKey:kCurrentUserKey];
    }
    [defaults synchronize];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"profileBannerUrl": @"profile_banner_url",
             @"profileImageUrl": @"profile_image_url",
             @"screenName": @"screen_name",
             @"numTweets": @"statuses_count",
             @"numFollowing": @"friends_count",
             @"numFollowers": @"followers_count",
             };
}

+ (NSValueTransformer *)profileBannerUrlJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^(NSString *urlString) {
        return [NSURL URLWithString:urlString];
    }];
}

+ (NSValueTransformer *)profileImageUrlJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^(NSString *urlString) {
        return [NSURL URLWithString:urlString];
    }];
}

@end
