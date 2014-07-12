//
//  ARSContactCellDelegate.h
//  Angels Rest
//
//  Created by John Newman on 7/20/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ARSConstantContactCell;

@protocol ARSContactCellDelegate <NSObject>
@required
- (void)constantContactCellDidBeginEnteringText:(ARSConstantContactCell *)contactCell;
- (void)constantContactCellTextFieldIsReturning:(ARSConstantContactCell *)contactCell;
@end
