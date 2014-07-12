//
//  ARSConstantContactTableViewController.h
//  Angels Rest
//
//  Created by John Newman on 7/20/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//
//  ARSConstantContactTableViewController displays a table view with static
//  cells for the user to enter their personal data and sign up for the
//  sanctuary's emailing list.  First, Last, and Email are required.  All
//  other fields are optional.  All data is typed into text fields on the
//  cells except for state abbreviation.  For convenience, when the user
//  taps the state cell, a table of states is displayed using the
//  ARSStatePickerTableViewController.
//

#import <UIKit/UIKit.h>
#import "ARSContactCellDelegate.h"
#import "ARSStatePickerDelegate.h"

@class ARSConstantContactCell;
@class MBProgressHUD;

@interface ARSConstantContactTableViewController : UITableViewController <ARSContactCellDelegate, ARSStatePickerDelegate>
{
    __weak ARSConstantContactCell *cellBeingEdited;
}

@property (nonatomic, strong)MBProgressHUD *progressHUD;

@property (weak, nonatomic) IBOutlet ARSConstantContactCell *firstNameCell;
@property (weak, nonatomic) IBOutlet ARSConstantContactCell *lastNameCell;
@property (weak, nonatomic) IBOutlet ARSConstantContactCell *emailCell;
@property (weak, nonatomic) IBOutlet ARSConstantContactCell *cellPhoneCell;
@property (weak, nonatomic) IBOutlet ARSConstantContactCell *addressLine1Cell;
@property (weak, nonatomic) IBOutlet ARSConstantContactCell *addressLine2Cell;
@property (weak, nonatomic) IBOutlet ARSConstantContactCell *cityCell;
@property (weak, nonatomic) IBOutlet ARSConstantContactCell *stateCell;
@property (weak, nonatomic) IBOutlet ARSConstantContactCell *zipCell;

@end
