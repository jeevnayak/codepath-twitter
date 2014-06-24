//
//  Tweet.m
//  twitter
//
//  Created by Rajeev Nayak on 6/21/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "Tweet.h"
#import <MTLValueTransformer.h>

@implementation Tweet

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
    return dateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"idStr": @"id_str",
             @"createdAt": @"created_at",
             @"retweetedTweet": @"retweeted_status",
             @"retweetCount": @"retweet_count",
             @"favoriteCount": @"favorite_count",
             };
}

+ (NSValueTransformer *)userJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^(NSDictionary *dict) {
        return [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dict error:nil];
    }];
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)retweetedTweetJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^(NSDictionary *dict) {
        if (dict == nil) {
            return (id)nil;
        }
        return [MTLJSONAdapter modelOfClass:[Tweet class] fromJSONDictionary:dict error:nil];
    }];
}

@end
