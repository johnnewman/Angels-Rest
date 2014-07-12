//
//  ARSConstantContactCommunicator.h
//  Angels Rest
//
//  Created by John Newman on 7/11/14.
//  Copyright (c) 2014 John Newman. All rights reserved.
//
//  ARSConstantContactCommunicator is a singleton used to enroll
//  a user in the sanctuary's emailing list.  It allows the caller
//  to define what happens upon success (enrolled) or failure (already
//  enrolled or API failure) using blocks.  If the account was
//  previously deleted, a second request is automatically made to
//  re-add the account to the list.
//

#import <Foundation/Foundation.h>

typedef enum {
    ARSCCAlreadyExists,
    ARSCCFailed
} ARSCCFailureCode;

typedef void (^ARSConstantContactAPISuccessBlock)(void);
typedef void (^ARSConstantContactAPIFailureBlock)(ARSCCFailureCode failureCode);

@interface ARSConstantContactCommunicator : NSObject

+ (ARSConstantContactCommunicator *)sharedInstance;
- (void)addContact:(NSDictionary *)contactInfo successBlock:(ARSConstantContactAPISuccessBlock)success failureBlock:(ARSConstantContactAPIFailureBlock)failure;

@end
