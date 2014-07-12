//
//  ARSDonateViewController.h
//  Angels Rest
//
//  Created by John Newman on 7/21/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//
//  ARSDonateViewController allows the user to make a donation to
//  the sanctuary via PayPal or StayClassy.  The PayPal donation
//  amount is input into a custom alert view.  After entry, it is
//  handed to the PayPalPaymentViewController for processing.
//  StayClassy donations are entered in the ARSStayClassyViewController.
//  Its presentation from the StayClassy button is all defined in the
//  storyboard.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

@interface ARSDonateViewController : UIViewController <PayPalPaymentDelegate, UIAlertViewDelegate>

@end
