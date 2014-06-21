//
//  NSURL+DictionaryFromQueryString.m
//  twitter
//
//  Created by Rajeev Nayak on 6/19/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "NSURL+DictionaryFromQueryString.h"

@implementation NSURL (DictionaryFromQueryString)

- (NSDictionary *)dictionaryFromQueryString
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    NSArray *pairs = [[self query] componentsSeparatedByString:@"&"];

    for(NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];

        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [dictionary setObject:val forKey:key];
    }

    return dictionary;
}

@end
