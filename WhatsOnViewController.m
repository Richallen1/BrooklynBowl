//
//  WhatsOnViewController.m
//  BrooklynBowl
//
//  Created by Rich Allen on 03/03/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "WhatsOnViewController.h"
#import "WhatsOnTableViewCell.h"

@interface WhatsOnViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_events;
    NSArray *_dates;
    IBOutlet UITableView *eventsTableView;
    
}
@end

@implementation WhatsOnViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	_events = [[NSArray alloc]initWithObjects:@"Event 1",@"Event 2",@"Event 4",@"Event 5",@"Event 6", nil];
    _dates = [[NSArray alloc]initWithObjects:@"Today",@"Tomorrow",@"Saturday 1st June",@"Saturday 1st June",@"Saturday 1st June", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_events count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    WhatsOnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
    {
        
        cell = [[WhatsOnTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    cell.mainTitleLabel.text = @"Queen";
    cell.timeLabel.text = @"19:30";
    cell.artistImage.image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"jpeg"]];
    
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_dates objectAtIndex:section];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
