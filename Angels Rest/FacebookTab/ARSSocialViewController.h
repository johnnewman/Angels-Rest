//
//  ARSSocialViewController.h
//  Angels Rest
//
//  Created by John Newman on 7/13/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//
//  ARSSocialViewController displays the sanctuary's Facebook page
//  in a UIWebView.  It has controls for reloading the current
//  page and navigating the web view back.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;

@interface ARSSocialViewController : UIViewController <UIWebViewDelegate>
{
    MBProgressHUD *progressHUD;
}

@property (weak, nonatomic, readonly) IBOutlet UIWebView *webView;
@property (weak, nonatomic, readonly) IBOutlet UIBarButtonItem *backButton;

@end
