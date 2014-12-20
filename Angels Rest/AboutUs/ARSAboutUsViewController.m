//
//  ARSAboutUsViewController.m
//  Angels Rest
//
//  Created by John Newman on 7/16/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//

#import "ARSAboutUsViewController.h"
#import "ARSConstantContactCommunicator.h"

@interface ARSAboutUsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@end

@implementation ARSAboutUsViewController

@synthesize callButton = _callButton,
            infoTextView = _infoTextView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_callButton setTitle:AngelsRestReadablePhoneNumber forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_infoTextView flashScrollIndicators];
}

#pragma mark - Actions

- (IBAction)phoneButtonSelected:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:@"Cancel"
                                                    otherButtonTitles:[NSString stringWithFormat:@"Call %@", AngelsRestPhoneNumber], nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)emailButtonSelected:(id)sender
{
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setToRecipients:@[AngelsRestEmail]];
    [mailComposer setSubject:@"Angel's Rest App"];
    [self presentViewController:mailComposer animated:YES completion:nil];
}


#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *phoneString = [NSString stringWithFormat:@"tel:%@", AngelsRestPhoneNumber];
        NSURL *telephoneURL = [NSURL URLWithString:phoneString];
        [[UIApplication sharedApplication] openURL:telephoneURL];
    }
}


#define Mail Compose Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Unwind Action

- (IBAction)doneUnwind:(UIStoryboardSegue *)segue
{
}

@end
