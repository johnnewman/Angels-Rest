//
//  ARSConstantContactCell.h
//  Angels Rest
//
//  Created by John Newman on 7/20/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//
//  ARSConstantContactCell contains a text field for data entry when
//  filling out the ConstantContact form.  The delegate is notified
//  when a text field begins editing and when the user taps the return
//  button on the keyboard.
//

#import <UIKit/UIKit.h>
#import "ARSContactCellDelegate.h"

@interface ARSConstantContactCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic, readonly) IBOutlet UITextField *textField;
@property (weak, nonatomic, readonly) IBOutlet id<ARSContactCellDelegate> delegate;

@end
