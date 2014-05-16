//
//  EventsParser.h
//  BrooklynBowl
//
//  Created by Rich Allen on 01/04/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Events.h"
#import "AppDelegate.h"
#import "Show.h"

@protocol ParserProtocol <NSObject>
-(void)parserDidFinishLoading;
@end

@interface EventsParser : NSObject <NSXMLParserDelegate>
{
    NSManagedObjectContext *context;
}

@property (strong, readonly) NSMutableArray *events;
@property (nonatomic, weak) id <ParserProtocol> delegate;

-(id) loadXMLByURL:(NSString *)urlString;

@end
