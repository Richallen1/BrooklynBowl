//
//  WhatsOnViewController.h
//  BrooklynBowl
//
//  Created by Rich Allen on 15/05/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CoreDataTableViewController.h"

@interface WhatsOnViewController : UIViewController
<CLLocationManagerDelegate>


@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
- (IBAction)segmentChanged:(id)sender;
@end
