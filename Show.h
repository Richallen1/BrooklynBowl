//
//  Show.h
//  BrooklynBowl
//
//  Created by Rich Allen on 11/05/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Show : NSManagedObject

@property (nonatomic, retain) NSString * showName;
@property (nonatomic, retain) NSString * showDate;
@property (nonatomic, retain) NSString * showTime;
@property (nonatomic, retain) NSData * showImage;
@property (nonatomic, retain) NSString * showURL;
@property (nonatomic, retain) NSString * dateAdded;

@end
