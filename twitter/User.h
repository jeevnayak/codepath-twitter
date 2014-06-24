//
//  User.h
//  twitter
//
//  Created by Rajeev Nayak on 6/21/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "MTLModel.h"
#import <MTLJSONAdapter.h>

@interface User : MTLModel <MTLJSONSerializing>

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;

@property (nonatomic, copy, readonly) NSURL *profileImageUrl;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *screenName;

@end
