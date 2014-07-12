//
//  ARSConstantContactCommunicator.m
//  Angels Rest
//
//  Created by John Newman on 7/11/14.
//  Copyright (c) 2014 John Newman. All rights reserved.
//

#import "ARSConstantContactCommunicator.h"
#import "ARSConstantContactSessionManager.h"

static ARSConstantContactCommunicator * sharedCommunicator;
static NSInteger const AddedContactResponse = 201;

@implementation ARSConstantContactCommunicator

+ (ARSConstantContactCommunicator *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCommunicator = [[ARSConstantContactCommunicator alloc] init];
    });
    return sharedCommunicator;
}

//Checks if the contact is already added, marked as removed, or not in the email list yet.
- (void)addContact:(NSDictionary *)contactInfo successBlock:(ARSConstantContactAPISuccessBlock)success failureBlock:(ARSConstantContactAPIFailureBlock)failure
{
    //URL encode the email address
    NSString *email = [contactInfo valueForKey:@"email"];
    NSString *encodedEmail = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)(email), NULL, CFSTR("!*'();@&+$,/?%#[]~=_-.:"), kCFStringEncodingUTF8));
    
    ARSConstantContactSessionManager *operationManager = [ARSConstantContactSessionManager sharedInstance];
    operationManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [operationManager.requestSerializer setValue:ConstantContactAccessToken forHTTPHeaderField:@"Authorization"];
    NSDictionary *urlParameters = @{@"api_key" : ConstantContactAPIKey,
                                    @"email" : encodedEmail};
    
    __weak __typeof(self) weakSelf = self;
    [operationManager GET:@"" parameters:urlParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (((NSHTTPURLResponse *)task.response).statusCode == 200)
        {
            if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSArray *resultArray = responseObject[@"results"];
                if (resultArray.count > 0) //contact already exists
                {
                    if ([[resultArray firstObject][@"status"] isEqualToString:@"REMOVED"]) //contact removed, so add them back
                    {
                        LogMessage(@"Contact was removed, attempting to re-add them to the list");
                        [weakSelf addRemovedContact:[resultArray firstObject][@"id"] withDictionary:contactInfo successBlock:success failureBlock:failure];
                    }
                    else
                    {
                        LogMessage(@"Error: contact already exists");
                        failure(ARSCCAlreadyExists);
                    }
                }
                else //contact does not exist
                {
                    LogMessage(@"Contact does not exist, attempting to add them to the list");
                    [weakSelf postNewContactWithDictionary:contactInfo successBlock:success failureBlock:failure];
                }
            }
            else
            {
                LogMessage(@"Error: responseObject is not an instance of NSDictionary");
                failure(ARSCCFailed);
            }
        }
        else
        {
            LogMessage(@"Error: Failed with status code: %d", ((NSHTTPURLResponse *)task.response).statusCode);
            failure(ARSCCFailed);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LogMessage(@"AFNetworking failure block error: %@", error);
        failure(ARSCCFailed);
    }];
}

//If a contact is marked as removed, this will add it back into an active state.
- (void)addRemovedContact:(NSString *)contactID withDictionary:(NSDictionary *)contactInfo successBlock:(ARSConstantContactAPISuccessBlock)success failureBlock:(ARSConstantContactAPIFailureBlock)failure
{
    NSDictionary *bodyDict = [self packageContactDictionaryForAPI:contactInfo];
    NSString *auxiliaryURL = [NSString stringWithFormat:@"%@?api_key=%@&action_by=ACTION_BY_VISITOR", contactID, ConstantContactAPIKey];
    
    ARSConstantContactSessionManager *operationManager = [ARSConstantContactSessionManager sharedInstance];
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [operationManager.requestSerializer setValue:ConstantContactAccessToken forHTTPHeaderField:@"Authorization"];
    
    [operationManager PUT:auxiliaryURL parameters:bodyDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if (((NSHTTPURLResponse *)task.response).statusCode == 200)
            success();
        else
        {
            LogMessage(@"Error: Failed with status code: %d", ((NSHTTPURLResponse *)task.response).statusCode);
            failure(ARSCCFailed);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LogMessage(@"AFNetworking failure block error: %@", error);
        failure(ARSCCFailed);
    }];
}

//Adds the contact if it's not already there.
- (void)postNewContactWithDictionary:(NSDictionary *)contactInfo successBlock:(ARSConstantContactAPISuccessBlock)success failureBlock:(ARSConstantContactAPIFailureBlock)failure
{
    NSDictionary *bodyDict = [self packageContactDictionaryForAPI:contactInfo];
    NSString *auxiliaryURL = [NSString stringWithFormat:@"api_key=%@&action_by=ACTION_BY_VISITOR", ConstantContactAPIKey];
    
    ARSConstantContactSessionManager *operationManager = [ARSConstantContactSessionManager sharedInstance];
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [operationManager.requestSerializer setValue:ConstantContactAccessToken forHTTPHeaderField:@"Authorization"];
    
    [operationManager POST:auxiliaryURL parameters:bodyDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if (((NSHTTPURLResponse *)task.response).statusCode == AddedContactResponse)
            success();
        else
        {
            LogMessage(@"Error: Failed with status code: %d", ((NSHTTPURLResponse *)task.response).statusCode);
            failure(ARSCCFailed);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LogMessage(@"AFNetworking failure block error: %@", error);
        failure(ARSCCFailed);
    }];
}

//A bit more formatting needs to be done to the contact dictionary before it can be sent.
- (NSDictionary *)packageContactDictionaryForAPI:(NSDictionary *)contactDict
{
    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
    bodyDict[@"lists"] = @[@{@"id": @"1"}];
    bodyDict[@"first_name"] = contactDict[@"first_name"];
    bodyDict[@"last_name"] = contactDict[@"last_name"];
    bodyDict[@"email_addresses"] = @[@{@"email_address" : contactDict[@"email"]}];
    
    if (contactDict[@"cell_phone"] != nil)
        bodyDict[@"cell_phone"] = contactDict[@"cell_phone"];
    
    if (contactDict[@"address_info"] != nil)
        bodyDict[@"addresses"] = @[contactDict[@"address_info"]];
    
    return bodyDict;
}

@end
