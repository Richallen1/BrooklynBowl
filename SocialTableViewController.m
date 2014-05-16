//
//  SocialTableViewController.m
//  BrooklynBowl
//
//  Created by Rich Allen on 06/05/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "SocialTableViewController.h"
#import "GenericWebViewController.h"
#import "Reachability.h"

@interface SocialTableViewController ()
{
    BOOL reachable;
}
@end

@implementation SocialTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self.navigationController navigationBar].hidden = YES;
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.tixter.co.uk"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"REACHABLE!");
        reachable = YES;
        
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"UNREACHABLE!");
        reachable = NO;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet" message:@"You dont have an active internet connection. You will need to connect to the internet to use social media." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    };

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"facebook segue"])
    {
        GenericWebViewController *webView = segue.destinationViewController;
        webView.url = @"https://www.facebook.com/BrooklynBowlLondon?fref=ts";
        
    }
    if ([segue.identifier isEqualToString:@"twitter segue"])
    {
        GenericWebViewController *webView = segue.destinationViewController;
        webView.url = @"https://twitter.com/brooklynbowl";
    }
    if ([segue.identifier isEqualToString:@"instagram segue"])
    {
        GenericWebViewController *webView = segue.destinationViewController;
        webView.url = @"http://instagram.com/BrooklynBowl";
    }
}

@end
