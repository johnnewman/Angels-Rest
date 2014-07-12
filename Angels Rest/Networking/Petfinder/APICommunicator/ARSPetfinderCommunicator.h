//
//  ARSPetfinderCommunicator.h
//  Angels Rest
//
//  Created by John Newman on 6/12/14.
//  Copyright (c) 2014 John Newman. All rights reserved.
//
//  ARSPetfinderCommunicator is a singleton used to download
//  Petfinder pets.  It allows the caller to define what happens
//  upon success or failure using blocks.  All animals are stored
//  in Core Data. Successfully downloading a fresh set of pets
//  clears the previous set from Core Data before the new is added.
//
//  Note: the Petfinder JSON format presents some challenges and is
//  further explained in the implementation file.
//

#import <Foundation/Foundation.h>

typedef void (^ARSPetfinderAPISuccessBlock)(void);
typedef void (^ARSPetfinderAPIFailureBlock)(void);

@interface ARSPetfinderCommunicator : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (ARSPetfinderCommunicator *)sharedInstance;
- (void)downloadAllAnimals:(ARSPetfinderAPISuccessBlock)success failureBlock:(ARSPetfinderAPIFailureBlock)failure;

@end
