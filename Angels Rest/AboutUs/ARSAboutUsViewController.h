//
//  ARSAboutUsViewController.h
//  Angels Rest
//
//  Created by John Newman on 7/16/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//
//  ARSAboutUsViewController displays the sanctuary's mission objective
//  and address/website in a text view.  That text is defined in the
//  storyboard.  The phone number and email address are both buttons that
//  can start a call or email draft.  The mailing list button presents a
//  modal form (ARSConstantContactTableViewController) for the user to
//  enroll themselves.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ARSAboutUsViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic, readonly) IBOutlet UIButton *callButton;

@end
