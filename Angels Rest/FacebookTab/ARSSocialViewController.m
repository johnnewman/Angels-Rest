//
//  ARSSocialViewController.m
//  Angels Rest
//
//  Created by John Newman on 7/13/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//

#import "ARSSocialViewController.h"
#import "MBProgressHUD.h"

static NSString * const FacebookURL = @"https://www.facebook.com/AngelsRestAnimalSanctuary";

@interface ARSSocialViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@end

@implementation ARSSocialViewController

@synthesize webView = _webView,
            backButton = _backButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createProgressHUD];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:FacebookURL]]];
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
    progressHUD = [[MBProgressHUD alloc] initWithView:_webView];
    progressHUD.labelFont = [UIFont fontWithName:@"Avenir-Medium" size:16.0f];
    progressHUD.labelText = @"Loading";
    [_webView addSubview:progressHUD];
}


#pragma mark - Button Actions

- (IBAction)backButtonSelected:(id)sender
{
    [_webView goBack];
}

- (IBAction)refreshButtonSelected:(id)sender
{
    [_webView reload];
}


#pragma mark - Web View Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [progressHUD show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([_webView canGoBack] && _backButton.enabled == NO)
        _backButton.enabled = YES;
    else if (![_webView canGoBack])
        _backButton.enabled = NO;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [progressHUD hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    LogMessage(@"Web view failed to load with error: %@", error);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [progressHUD hide:YES];
}

@end
