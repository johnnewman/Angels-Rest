//
//  ARSConstantContactSessionManager.h
//  Angels Rest
//
//  Created by John Newman on 7/11/14.
//  Copyright (c) 2014 John Newman. All rights reserved.
//
//  ARSConstantContactSessionManager is a singleton used by the
//  ARSConstantContactCommunicator to execute all Constant Contact
//  API requests.
//

#import "AFHTTPSessionManager.h"

@interface ARSConstantContactSessionManager : AFHTTPSessionManager

+ (ARSConstantContactSessionManager *)sharedInstance;

@end
