//
//  ARSConstantContactCell.m
//  Angels Rest
//
//  Created by John Newman on 7/20/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//

#import "ARSConstantContactCell.h"

@interface ARSConstantContactCell ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet id<ARSContactCellDelegate> delegate;
@end

@implementation ARSConstantContactCell

@synthesize textField = _textField,
             delegate = _delegate;


#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(constantContactCellDidBeginEnteringText:)])
        [_delegate constantContactCellDidBeginEnteringText:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(constantContactCellTextFieldIsReturning:)])
        [_delegate constantContactCellTextFieldIsReturning:self];
    [textField resignFirstResponder];
    return YES;
}

@end
