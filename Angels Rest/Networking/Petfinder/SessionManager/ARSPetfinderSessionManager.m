//
//  ARSPetfinderSessionManager.m
//  Angels Rest
//
//  Created by John Newman on 6/12/14.
//  Copyright (c) 2014 John Newman. All rights reserved.
//

#import "ARSPetfinderSessionManager.h"

static ARSPetfinderSessionManager *sharedManager;
static NSString * const PetfinderURL = @"http://api.petfinder.com/";

@implementation ARSPetfinderSessionManager

+ (ARSPetfinderSessionManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ARSPetfinderSessionManager alloc] initWithBaseURL:[NSURL URLWithString:PetfinderURL]];
    });
    return sharedManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url])
    {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

@end
