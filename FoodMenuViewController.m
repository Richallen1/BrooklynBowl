//
//  FoodMenuViewController.m
//  BrooklynBowl
//
//  Created by Rich Allen on 03/03/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "FoodMenuViewController.h"

@interface FoodMenuViewController () <UIWebViewDelegate>

@end

@implementation FoodMenuViewController
@synthesize pdfWebView = _pdfWebView;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    return [super init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [_pdfWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
