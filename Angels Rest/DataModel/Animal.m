//
//  Animal.m
//  Angels Rest
//
//  Created by John Newman on 10/6/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//

#import "Animal.h"

@implementation Animal

@dynamic name;
@dynamic age;
@dynamic size;
@dynamic gender;
@dynamic breed;
@dynamic desc;
@dynamic imageURLs;

- (void)setImageURLArray:(NSArray *)imageURLArray
{
    self.imageURLs = [NSKeyedArchiver archivedDataWithRootObject:imageURLArray];
}

- (NSArray *)imageURLArray
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.imageURLs];
}

- (NSString *)sizeDisplayText
{
    if ([self.size isEqualToString:@"S"])
        return @"Small";
    else if ([self.size isEqualToString:@"M"])
        return @"Medium";
    else if ([self.size isEqualToString:@"L"])
        return @"Large";
    else if ([self.size isEqualToString:@"XL"])
        return @"Extra Large";
    else
        return @"";
}

- (NSString *)genderDisplayText
{
    if ([self.gender isEqualToString:@"M"])
        return @"Male";
    else if ([self.gender isEqualToString:@"F"])
        return @"Female";
    else
        return @"";
}

- (NSString *)thumbnailURLString
{
    return [self.imageURLArray firstObject];
}

- (UIImage *)backgroundImageForCell
{
    LogMessage(@"Notice: return a valid UIImage from backgroundImageForCell in an Animal subclass. Returning nil.");
    return nil;
}

- (UIImage *)backgroundImageForDetailView
{
    LogMessage(@"Notice: return a valid UIImage from backgroundImageForDetailView in an Animal subclass. Returning nil.");
    return nil;
}

- (NSNumber *)animalSortPriority
{
    LogMessage(@"Notice: return a valid NSNumber from animalSortPriority in an Animal subclass. Returning @0.");
    return @0;
}

@end
