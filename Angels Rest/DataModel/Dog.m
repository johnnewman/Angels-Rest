//
//  Dog.m
//  Angels Rest
//
//  Created by John Newman on 7/8/14.
//  Copyright (c) 2014 John Newman. All rights reserved.
//

#import "Dog.h"


@implementation Dog

- (UIImage *)backgroundImageForCell
{
    NSString *imageName;
    if ([self.gender isEqualToString:@"M"])
        imageName = @"male_dog_cell_background.png";
    else
        imageName = @"female_dog_cell_background.png";
    return [UIImage imageNamed:imageName];
}

- (UIImage *)backgroundImageForDetailView
{
    NSString *imageName;
    if ([self.gender isEqualToString:@"M"])
        imageName = @"male_dog_background.png";
    else
        imageName = @"female_dog_background.png";
    return [UIImage imageNamed:imageName];
}

- (NSNumber *)animalSortPriority
{
    return @1;
}

@end
