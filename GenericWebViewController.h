//
//  GenericWebViewController.h
//  BrooklynBowl
//
//  Created by Rich Allen on 06/05/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenericWebViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic)IBOutlet UIWebView *webView;
@property (strong, nonatomic)NSString *url;

@end
