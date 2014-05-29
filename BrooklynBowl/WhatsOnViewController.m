//
//  WhatsOnViewController.m
//  BrooklynBowl
//
//  Created by Rich Allen on 15/05/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "WhatsOnViewController.h"
#import "WhatsOnTableViewCell.h"
#import "EventsParser.h"
#import "WebViewController.h"
#import "AppDelegate.h"
#import "Reachability.h"

@interface WhatsOnViewController () <UITableViewDataSource, UITableViewDelegate, ParserProtocol>
{
    NSArray *_events;
    NSArray *_coreDataArray;
    NSMutableArray *_dates;
    IBOutlet UITableView *eventsTableView;
    IBOutlet UIImageView *advertImageView;
    UIImage *advert1;
    UIImage *advert2;
    UIImage *advert3;
    UIView *loadingView;
    EventsParser *xmlParser;
    IBOutlet UISegmentedControl *whatsOnSegment;
    NSMutableArray *_justAnnounced;
    NSManagedObjectContext *context;
    BOOL reachable;
}

@end

@implementation WhatsOnViewController


#pragma View Controller Life Cycle Methods
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController navigationBar].hidden = YES;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Core Data Context Declaration from App delegate shared context
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    _coreDataArray = [[NSArray alloc]init];
    whatsOnSegment.selectedSegmentIndex = 0;
    [self SetUpCoreLocation];
   // [self ShowLoadingView];
    [self SetUpFlyers];
    [self CheckServer];
}
#pragma SETUP METHODS
-(void)SetUpFlyers
{
    advert1 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Flyer1" ofType:@"png"]];
    advert2 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Flyer2" ofType:@"png"]];
    advert3 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Flyer3" ofType:@"png"]];
    [self ShowFlyer:[[NSNumber alloc]initWithInt:1]];
}
-(void)SetUpCoreLocation
{
    //Core Location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Create a NSUUID with the same UUID as the broadcasting beacon
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"5ba3bf3c-93ca-4f20-b619-68e54790c4c8"];
    
    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                             identifier:@"com.brooklynbowl.region"];
    
    // Tell location manager to start monitoring for the beacon region
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
}
-(void)setUpJustAnnounced
{
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"dateAdded"
                                        ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSArray *sortedEventArray = [_coreDataArray sortedArrayUsingDescriptors:sortDescriptors];
    
    NSLog(@"COUNT -  %lu", (unsigned long)[sortedEventArray count]);
    _justAnnounced = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <= 3; i++) {
        [_justAnnounced addObject: sortedEventArray[i]];
    }
    NSLog(@"COUNT %lu", (unsigned long)[_justAnnounced count]);
}
#pragma View Methods
-(void)ShowFlyer:(NSNumber *)number
{
    advertImageView.image = nil;
    int Flyer = [number integerValue];
    switch (Flyer) {
        case 1:
            [advertImageView setImage: advert1];
            [self performSelector:@selector(ShowFlyer:) withObject:[[NSNumber alloc]initWithInt:2] afterDelay:2.0];
            //NSLog(@"Show 1");
            break;
        case 2:
            advertImageView.image = advert2;
            [self performSelector:@selector(ShowFlyer:) withObject:[[NSNumber alloc]initWithInt:3] afterDelay:2.0];
            //NSLog(@"Show 2");
            break;
        case 3:
            advertImageView.image = advert3;
            [self performSelector:@selector(ShowFlyer:) withObject:[[NSNumber alloc]initWithInt:1] afterDelay:2.0];
            //NSLog(@"Show 3");
            break;
            
        default:
            break;
    }
}
-(void)ShowLoadingView
{
    UIImage *LoadingImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LoadingView" ofType:@"png"]];
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    baseView.backgroundColor = [UIColor blackColor];
    
    UIImageView *loadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height/2-148, 320, 297)];
    loadingImageView.image = LoadingImage;
    [baseView addSubview:loadingImageView];
    loadingView = baseView;
    [self.view addSubview:loadingView];
}
-(void)noInternetView
{

    UIImage *LoadingImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noInternetView" ofType:@"png"]];
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    baseView.backgroundColor = [UIColor blackColor];
    
    UIImageView *loadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height/2-148, 320, 297)];
    loadingImageView.image = LoadingImage;
    [baseView addSubview:loadingImageView];
    loadingView = baseView;
    [self.view addSubview:loadingView];
}

#pragma Core Data Methods
-(void)EmptyDB
{
    NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"Show"];
    NSError *error = nil;
    NSArray *eventsDB = [context executeFetchRequest:request1 error:&error];
    
    //Delete all invoices matching that unique number!
    for (Show *shwa in eventsDB) {
        [context deleteObject:shwa];
    }
    [context save:&error];
}

- (void)setupFetchedResultsController
{
    NSFetchedResultsController *fetchedResultsController;
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Show"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"showDate" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                   managedObjectContext:context
                                                                     sectionNameKeyPath:nil
                                                                              cacheName:nil];

    _coreDataArray = [context executeFetchRequest:request error:&error];
    
    for (Show *shw in _coreDataArray) {
        NSLog(@"%@", shw.showName);
        NSLog(@"%@", shw.showDate);
    }
    if (_coreDataArray.count != 0) {
        
        [self GetDateSectionHeaders];
        [self setUpJustAnnounced];
        [eventsTableView reloadData];
        //[loadingView removeFromSuperview];
        NSLog(@"LOADING DONE!!");
    }
}

#pragma NETWORK Methods
-(void)CheckServer
{
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.tixter.co.uk"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"REACHABLE!");
        reachable = YES;
        [self PullEventData];
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"UNREACHABLE!");
        reachable = NO;
        [self noInternetView];
        [self setupFetchedResultsController];
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}
-(void)PullEventData
{
    [self EmptyDB];
    xmlParser = [[EventsParser alloc]init];
    [xmlParser setDelegate:self];
    [xmlParser loadXMLByURL:@"http://www.tixter.co.uk/BrooklynBowl/events.xml"];
    [self ShowFlyer:[[NSNumber alloc]initWithInt:1]];
}
-(void)parserDidFinishLoading
{
    NSLog(@"LOADED");
    _events = [xmlParser events];
    [self setupFetchedResultsController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableView Delegate Methods
-(void)GetDateSectionHeaders
{
    
    NSLog(@"<<<<<<<<GetDateSectionHeaders>>>>>>>");
    _dates = [[NSMutableArray alloc]init];
    if (_coreDataArray.count != 0) {
        for (Show *shw in _coreDataArray) {
            [_dates addObject:shw.showDate];
        }
    }
    NSLog(@"Dates: %@", _dates);
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    NSLog(@"%ld",(long)whatsOnSegment.selectedSegmentIndex);
    
    if (whatsOnSegment.selectedSegmentIndex == 0) {
        if (_coreDataArray) {
            return [_coreDataArray count];
            NSLog(@"SDDFSA");
        }
    }
    if (whatsOnSegment.selectedSegmentIndex == 1) {
        if (_justAnnounced) {
            NSLog(@"asdsd");
            return [_justAnnounced count];
        }
    }
    return 1;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    Show *currentEvent;
    
    NSLog(@"<<<<<<<<cellForRowAtIndexPath>>>>>>>");
        if (whatsOnSegment.selectedSegmentIndex == 0) {
            currentEvent = [_coreDataArray objectAtIndex:indexPath.section];
        }
    if (whatsOnSegment.selectedSegmentIndex == 1) {
        currentEvent = [_justAnnounced objectAtIndex:indexPath.section];
    }
    
    NSLog(@"Loading Cell: %@", currentEvent.showName);
    
    WhatsOnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[WhatsOnTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.mainTitleLabel.text = currentEvent.showName;
    cell.timeLabel.text = currentEvent.showTime;
    cell.artistImage.image = [[UIImage alloc]initWithData:currentEvent.showImage];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"tickets_segue"]){
        
        NSIndexPath *indexPath = [eventsTableView indexPathForCell:sender];
        Events *event = [_events objectAtIndex:indexPath.row];
        WebViewController *wvc = segue.destinationViewController;
        wvc.URL = event.eventURL;
    }
}
- (IBAction)segmentChanged:(id)sender
{
    NSLog(@"Chosen Segment: %ld", (long)whatsOnSegment.selectedSegmentIndex);
    [eventsTableView reloadData];
}
@end
