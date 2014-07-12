//
//  ARSStayClassyViewController.m
//  Angels Rest
//
//  Created by John Newman on 7/21/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//

#import "ARSStayClassyViewController.h"
#import "MBProgressHUD.h"

static NSString * const STAY_CLASSY_URL = @"https://www.stayclassy.org/checkout/donation?eid=21127";

@interface ARSStayClassyViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ARSStayClassyViewController

@synthesize webView = _webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createProgressHUD];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:STAY_CLASSY_URL]]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - View Setup

- (void)createProgressHUD
{
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUD.labelFont = progressHUD.labelFont = [UIFont fontWithName:@"Avenir-Medium" size:16.0f];
    progressHUD.labelText= @"Loading";
    [self.view addSubview:progressHUD];
}


#pragma mark - Web View Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [progressHUD show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [progressHUD hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [progressHUD hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Sorry, there was a problem loading the page."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"Retry", nil];
    [alertView show];
    LogMessage(@"Error loading page: %@", error);
}


#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
        [_webView reload];
}

@end
