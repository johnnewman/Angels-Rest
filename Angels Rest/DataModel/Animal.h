//
//  Animal.h
//  Angels Rest
//
//  Created by John Newman on 10/6/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//
//  Animal is the abstract superclass of all Petfinder animal
//  types in the app.  It defines some convenience methods for
//  extracting the array of image urls from storage as NSData,
//  displaying user friendly gender and size, and getting the
//  animal/gender speific images.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Animal : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * breed;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSData * imageURLs;

- (void)setImageURLArray:(NSArray *)imageURLArray;
- (NSArray *)imageURLArray;
- (NSString *)thumbnailURLString;

//UI Helper Methods
- (NSString *)sizeDisplayText;
- (NSString *)genderDisplayText;
- (UIImage *)backgroundImageForCell;
- (UIImage *)backgroundImageForDetailView;

- (NSNumber *)animalSortPriority;

@end
