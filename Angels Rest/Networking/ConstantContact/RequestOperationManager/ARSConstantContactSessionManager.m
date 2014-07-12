//
//  ARSConstantContactSessionManager.m
//  Angels Rest
//
//  Created by John Newman on 7/11/14.
//  Copyright (c) 2014 John Newman. All rights reserved.
//

#import "ARSConstantContactSessionManager.h"

static ARSConstantContactSessionManager *sharedManager;
static NSString * const ConstantContactURL = @"https://api.constantcontact.com/v2/contacts/";

@implementation ARSConstantContactSessionManager

+ (ARSConstantContactSessionManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ARSConstantContactSessionManager alloc] initWithBaseURL:[NSURL URLWithString:ConstantContactURL]];
    });
    return sharedManager;
}

@end
