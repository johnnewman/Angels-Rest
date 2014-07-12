//
//  ARSPetfinderSessionManager.h
//  Angels Rest
//
//  Created by John Newman on 6/12/14.
//  Copyright (c) 2014 John Newman. All rights reserved.
//
//  ARSPetfinderSessionManager is a singleton used by the
//  ARSPetfinderCommunicator to execute all Petfinder API
//  requests.
//

#import "AFHTTPSessionManager.h"

@interface ARSPetfinderSessionManager : AFHTTPSessionManager

+ (ARSPetfinderSessionManager *)sharedInstance;

@end
