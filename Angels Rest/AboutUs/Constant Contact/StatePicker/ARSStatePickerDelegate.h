//
//  ARSStatePickerDelegate.h
//  Angels Rest
//
//  Created by John Newman on 7/11/14.
//  Copyright (c) 2014 John Newman. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ARSStatePickerTableViewController;

@protocol ARSStatePickerDelegate <NSObject>
@required
- (void)statePickerTableViewController:(ARSStatePickerTableViewController *)controller selectedState:(NSString *)state;
@end