//
//  WebViewController.m
//  BrooklynBowl
//
//  Created by Rich Allen on 01/04/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize webView = _webView;
@synthesize URL = _URL;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController navigationBar].hidden = NO;
    self.navigationController.navigationBar.backItem.title = @"Home";
	NSURL *url = [[NSURL alloc]initWithString:_URL];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
