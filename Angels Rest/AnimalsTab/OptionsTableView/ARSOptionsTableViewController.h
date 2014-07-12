//
//  ARSOptionsTableViewController.h
//  Angels Rest
//
//  Created by John Newman on 7/22/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//
//  ARSOptionsTableViewController is used to give the user a
//  list of filter options for the animal collection view.
//  The delegate is notified of the selected filter option.
//

#import <UIKit/UIKit.h>
#import "ARSOptionsTableViewControllerDelegate.h"

@interface ARSOptionsTableViewController : UITableViewController
{
    NSArray *sortingOptions;
    NSIndexPath *selectedIndexPath;
}

@property (nonatomic, weak) id<ARSOptionsTableViewControllerDelegate> delegate;

@end
