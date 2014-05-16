//
//  WebViewController.h
//  BrooklynBowl
//
//  Created by Rich Allen on 01/04/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *URL;
@end
