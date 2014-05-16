//
//  GenericWebViewController.m
//  BrooklynBowl
//
//  Created by Rich Allen on 06/05/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "GenericWebViewController.h"

@interface GenericWebViewController ()

@end

@implementation GenericWebViewController
@synthesize webView = _webView;
@synthesize url = _url;

- (void)viewDidLoad
{
    [self.navigationController navigationBar].hidden = NO;
    NSLog(@"%@", _url);
    _webView = [[UIWebView alloc]init];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [self loadURL:_url];
    [super viewDidLoad];
}
-(void)loadURL:(NSString *)urlString
{
    UIWebView *webView;
    
    if (self.view.bounds.size.height == 568)
    {
        //iPhone 5
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 66, 320, 452)];
    }
    else
    {
        //iPhone 4
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 66, 320, 364)];
    }
    
    
    
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [self.view addSubview:webView];
   
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
