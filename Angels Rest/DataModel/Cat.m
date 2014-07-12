//
//  Cat.m
//  Angels Rest
//
//  Created by John Newman on 7/8/14.
//  Copyright (c) 2014 John Newman. All rights reserved.
//

#import "Cat.h"


@implementation Cat

- (UIImage *)backgroundImageForCell
{
    NSString *imageName;
    if ([self.gender isEqualToString:@"M"])
        imageName = @"male_cat_cell_background.png";
    else
        imageName = @"female_cat_cell_background.png";
    return [UIImage imageNamed:imageName];
}

- (UIImage *)backgroundImageForDetailView
{
    NSString *imageName;
    if ([self.gender isEqualToString:@"M"])
        imageName = @"male_cat_background.png";
    else
        imageName = @"female_cat_background.png";
    return [UIImage imageNamed:imageName];
}

- (NSNumber *)animalSortPriority
{
    return @2;
}

@end
