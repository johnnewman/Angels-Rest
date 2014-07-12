//
//  ARSDonateViewController.m
//  Angels Rest
//
//  Created by John Newman on 7/21/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//

#import "ARSDonateViewController.h"

static CGRect PayPalAlertFrame = {10.0f, 10.0f, 300.0f, 300.0f};

@interface ARSDonateViewController ()
@end

@implementation ARSDonateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark PayPal Actions

//Create the custom data entry alert view
- (IBAction)payPalSelected:(id)sender
{
    UIAlertView *payPalAmountAlert = [[UIAlertView alloc] initWithFrame:PayPalAlertFrame];
    payPalAmountAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *amountTextField = [payPalAmountAlert textFieldAtIndex:0];
    amountTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    amountTextField.font = [UIFont fontWithName:@"Avenir" size:18.0f];
    
    payPalAmountAlert.title = @"PayPal Amount (USD)";
    [payPalAmountAlert addButtonWithTitle:@"Cancel"];
    [payPalAmountAlert addButtonWithTitle:@"Submit"];
    payPalAmountAlert.delegate = self;
    [payPalAmountAlert show];
}

- (void)showPayPalModalWithAmount:(NSString *)amountString
{
#if kPAY_PAL_PRODUCTION
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
#endif
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [[NSDecimalNumber alloc] initWithString:amountString];
    if (payment.amount.floatValue != 0.0f)
    {
        payment.currencyCode = @"USD";
        payment.shortDescription = @"Angel's Rest Donation";
        payment.intent = PayPalPaymentIntentSale;
        
        if (!payment.processable)
        {
            UIAlertView *notProcessableAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                          message:@"Sorry, the donation was not processable at this time."
                                                                         delegate:nil
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
            [notProcessableAlert show];
            return;
        }
        else
        {
            PayPalConfiguration *configuration = [[PayPalConfiguration alloc] init];
            configuration.acceptCreditCards = YES;
            configuration.merchantName = @"Angel's Rest Animal Sanctuary";
            PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                        configuration:configuration
                                                                                                             delegate:self];
            [self presentViewController:paymentViewController animated:YES completion:nil];
        }
    }
    else
    {
        UIAlertView *badAmountAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"Please provide a valid US Dollar amount."
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
        [badAmountAlert show];
    }
}


#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *amountText = [alertView textFieldAtIndex:0].text;
        if (amountText.length > 0)
        {
            [self showPayPalModalWithAmount:amountText];
        }
    }
}


#pragma mark PayPal Delegate

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    UIAlertView *thanksAlert = [[UIAlertView alloc] initWithTitle:@"Thank You"
                                                          message:@"Angel's Rest would like to extend a personal Thank You for your donation!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
    [thanksAlert show];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Unwind Action

- (IBAction)stayClassyUnwind:(UIStoryboardSegue *)segue
{
}

@end
