//
//  ARSOptionsTableViewControllerDelegate.h
//  Angels Rest
//
//  Created by John Newman on 7/22/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARSOptionsTableViewController;

typedef enum
{
    ARSCatAndDogSort,
    ARSCatSort,
    ARSDogSort,
    ARSMaleSort,
    ARSFemaleSort,
}
ARSSortType;

@protocol ARSOptionsTableViewControllerDelegate <NSObject>
- (void)optionsTableViewController:(ARSOptionsTableViewController *)optionsController selectedSortType:(ARSSortType)sortType;
@end
