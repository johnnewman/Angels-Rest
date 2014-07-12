//
//  ARSPetfinderCommunicator.m
//  Angels Rest
//
//  Created by John Newman on 6/12/14.
//  Copyright (c) 2014 John Newman. All rights reserved.
//
//  Storing the parsed JSON into an object would be trivial, but Petfinder's
//    JSON is extremely odd...
//    Here's an example:
//    "pets":{
//        "pet":[
//               {
//                   "age":{
//                      "$t":"Young"
//                   },
//                   ...
//               },
//               ...
//              ]
//           } (note pet is the only element in pets)
//  Why can't the keys map directly to their values?
//  Why have intermediary keys to access everything?
//    "age"->"$t"->(value)
//    "pets"->"pet"->[array of dictionaries]
//    "$t" and "pet" are useless filler here
//
#import "ARSPetfinderCommunicator.h"
#import "ARSPetfinderSessionManager.h"
#import "AppDelegate.h"
#import "Animal.h"

static ARSPetfinderCommunicator *sharedCommunicator;
static NSString * const AllPetsResource = @"shelter.getPets";

@implementation ARSPetfinderCommunicator

+ (ARSPetfinderCommunicator *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCommunicator = [[ARSPetfinderCommunicator alloc] init];
    });
    return sharedCommunicator;
}

- (id)init
{
    if (self = [super init])
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _managedObjectContext.parentContext = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    }
    return self;
}


- (void)downloadAllAnimals:(ARSPetfinderAPISuccessBlock)success failureBlock:(ARSPetfinderAPIFailureBlock)failure
{
    NSDictionary *urlParameters = @{@"key" : PetfinderAPIKey,
                                    @"id" : PetfinderShelterId,
                                    @"count" : @1000, //we currently pull down a 1K animal set
                                    @"output" : @"full",
                                    @"format" : @"json"};
    
    __weak __typeof(self) weakSelf = self;
    [[ARSPetfinderSessionManager sharedInstance] GET:AllPetsResource parameters:urlParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (((NSHTTPURLResponse *)task.response).statusCode == 200)
        {
            LogMessage(@"Successful response from Petfinder!");
            if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSArray *pets = responseObject[@"petfinder"][@"pets"][@"pet"]; //<--Petfinder seriously nests their data
                if (pets != nil)
                {
                    __strong __typeof(weakSelf) strongSelf = weakSelf;
                    if (strongSelf != nil && [strongSelf removeOldAnimalsFromCoreData] == YES)
                    {
                        if ([strongSelf storeAnimalsIntoCoreData:pets] == YES)
                            success();
                        else
                        {
                            LogMessage(@"Error: Storing animals into Core Data failed.");
                            failure();
                        }
                    }
                    else
                    {
                        LogMessage(@"Error: Failed to clear old animals out of Core Data.  Aborting new animal additions.");
                        failure();
                    }
                }
                else
                {
                    LogMessage(@"Error: Petfinder returned nil pets \t\t responseObject[petfinder]");
                    failure();
                }
            }
            else
            {
                LogMessage(@"Error: responseObject is not an instance of NSDictionary");
                failure();
            }
        }
        else
        {
            LogMessage(@"Error: Failed with status code: %d", ((NSHTTPURLResponse *)task.response).statusCode);
            failure();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LogMessage(@"AFNetworking failure block error: %@", error);
        failure();
    }];
}


//Clears old Animals out of Core Data for a fresh download.
- (BOOL)removeOldAnimalsFromCoreData
{
    __block BOOL successfullyRemoved;
    [_managedObjectContext performBlockAndWait:^{
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Animal"];
        NSError *fetchError;
        NSArray *animals = [_managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
        if (animals == nil)
        {
            LogMessage(@"Error fetching old animals: %@", fetchError);
            successfullyRemoved = NO;
        }
        else
        {
            [animals enumerateObjectsUsingBlock:^(Animal *animal, NSUInteger idx, BOOL *stop) {
                [_managedObjectContext deleteObject:animal];
            }];
            NSError *saveError;
            if ([self.managedObjectContext save:&saveError] == NO)
            {
                LogMessage(@"Failed to save after deleting old animals: %@", saveError);
                successfullyRemoved = NO;
            }
            else
            {
                LogMessage(@"Successfully cleared old animals from Core Data");
                successfullyRemoved = YES;
            }
        }
    }];
    return successfullyRemoved;
}

//This method will take an array of Petfinder animals and store them into Core Data.
- (BOOL)storeAnimalsIntoCoreData:(NSArray *)animals
{
    [animals enumerateObjectsUsingBlock:^(NSDictionary *petDict, NSUInteger idx, BOOL *stop) {
        [_managedObjectContext performBlock:^{
            NSString *type = petDict[@"animal"][@"$t"];
            if ([type isEqualToString:@"Dog"] || [type isEqualToString:@"Cat"])
            {
                static NSString *RootValueKey = @"$t";
                Animal *animal = [NSEntityDescription insertNewObjectForEntityForName:type inManagedObjectContext:_managedObjectContext];
                id name = petDict[@"name"][RootValueKey];
                if (name != [NSNull null])
                    animal.name = name;
                
                id age = petDict[@"age"][RootValueKey];
                if (age != [NSNull null])
                    animal.age = age;
                
                id size = petDict[@"size"][RootValueKey];
                if (size != [NSNull null])
                    animal.size = size;
                
                id gender = petDict[@"sex"][RootValueKey];
                if (gender != [NSNull null])
                    animal.gender = gender;
                
                id description = petDict[@"description"][RootValueKey];
                if (description != [NSNull null])
                    animal.desc = description;
                
                id breed = [self extractBreed:petDict[@"breeds"][@"breed"]];
                if (breed != [NSNull null])
                    animal.breed = breed;
                
                //no need to check for NSNull here, the method will always return an NSArray
                animal.imageURLArray = [self extractImageURLs:petDict[@"media"][@"photos"][@"photo"]];
            }
            else
            {
                LogMessage(@"Cannot store animal, unknown type: %@", type);
            }
        }];
    }];
    
    __block BOOL successfullySavedAnimals = NO;
    [_managedObjectContext performBlockAndWait:^{
        if ([_managedObjectContext hasChanges])
        {
            NSError *saveError;
            successfullySavedAnimals = [_managedObjectContext save:&saveError];
            if (successfullySavedAnimals == NO)
                LogMessage(@"Error saving managed object context: %@", saveError);
        }
    }];
    return successfullySavedAnimals;
}

//Breed can either be an NSDictionary containing 1 breed, or an NSArray
//  containing multiple dictionaries of breeds.  This method will create
//  a comma separated breed string in either case.
- (NSString *)extractBreed:(id)breedValue
{
    if ([breedValue isKindOfClass:[NSArray class]])
    {
        NSMutableString *mutableBreeds = [NSMutableString string];
        [breedValue enumerateObjectsUsingBlock:^(NSDictionary *breedDict, NSUInteger idx, BOOL *stop) {
            [mutableBreeds appendString:breedDict[@"$t"]];
            if (idx < [breedValue count] - 1)
                [mutableBreeds appendString:@", "];
        }];
        return mutableBreeds;
    }
    else
        return breedValue[@"$t"];
}

//Pulls out each medium sized image URL from the supplied array of
//  Petfinder photo URL dictionaries.
- (NSArray *)extractImageURLs:(NSArray *)imageDataArray
{
    NSMutableArray *imageURLs = [NSMutableArray array];
    for (NSDictionary *photoDict in imageDataArray)
        if ([[photoDict objectForKey:@"@size"] isEqualToString:@"pn"]) //Adding only medium images.
            [imageURLs addObject:[photoDict valueForKey:@"$t"]];
    return imageURLs;
}

@end
