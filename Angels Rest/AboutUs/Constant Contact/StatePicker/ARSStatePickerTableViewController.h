//
//  ARSStatePickerTableViewController.h
//  Angels Rest
//
//  Created by John Newman on 5/10/14.
//  Copyright (c) 2014 John Newman. All rights reserved.
//
//  ARSStatePickerTableViewController displays a table of states and
//  notifies its delegate when one is selected.  The list is loaded
//  from States.plist.
//

#import <UIKit/UIKit.h>
#import "ARSStatePickerDelegate.h"

@interface ARSStatePickerTableViewController : UITableViewController
{
    NSArray *states;
}

@property (nonatomic, weak) id<ARSStatePickerDelegate> delegate;
@property (nonatomic, strong) NSString *selectedState;

@end