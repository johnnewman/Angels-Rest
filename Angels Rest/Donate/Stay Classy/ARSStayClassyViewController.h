//
//  ARSStayClassyViewController.h
//  Angels Rest
//
//  Created by John Newman on 7/21/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//
//  ARSStayClassyViewController is similar to the ARSSocialViewController
//  but it does not have back and reload capabilities.  Also, it displays
//  page loading errors in a alert view.  The social view controller does
//  not do this because the Facebook site frequently hits the web view's
//  didFailLoadWithError: method, resulting in too freqent alert views.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;

@interface ARSStayClassyViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate>
{
    MBProgressHUD *progressHUD;
}

@property (weak, nonatomic, readonly) IBOutlet UIWebView *webView;

@end
