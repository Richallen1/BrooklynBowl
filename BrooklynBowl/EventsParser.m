//
//  EventsParser.m
//  BrooklynBowl
//
//  Created by Rich Allen on 01/04/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "EventsParser.h"
#import "Reachability.h"

@implementation EventsParser
@synthesize events = _events;
@synthesize delegate;

NSMutableString	*currentNodeContent;
NSXMLParser		*parser;
Events			*currentEvent;
bool            isStatus;
Show            *currentShow;
NSManagedObject *currentShow;



-(id) loadXMLByURL:(NSString *)urlString
{

    NSLog(@"%@", urlString);
    //Core Data Context Declaration from App delegate shared context
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    
    NSLog(@"Parser Started");
	_events			= [[NSMutableArray alloc] init];
	NSURL *url		= [NSURL URLWithString:urlString];
	NSData	*data   = [[NSData alloc] initWithContentsOfURL:url];
	parser			= [[NSXMLParser alloc] initWithData:data];
	parser.delegate = self;
	[parser parse];
    NSLog(@"Parser Done");
    [delegate parserDidFinishLoading];
	return self;
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	currentNodeContent = (NSMutableString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if ([elementname isEqualToString:@"event"])
	{
		currentEvent = [Events alloc];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Show" inManagedObjectContext:context];
        currentShow = [[NSManagedObject alloc]initWithEntity:entityDesc insertIntoManagedObjectContext:context];
        isStatus = YES;
	}
    
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isStatus)
    {
        
        if ([elementname isEqualToString:@"eventName"])
        {
            currentEvent.eventName = currentNodeContent;
            [currentShow setValue:currentNodeContent forKey:@"showName"];
        }
        if ([elementname isEqualToString:@"eventDate"])
        {
            currentEvent.eventDate = currentNodeContent;
            [currentShow setValue:currentNodeContent forKey:@"showDate"];
        }
        if ([elementname isEqualToString:@"eventImage"])
        {
            currentEvent.eventImage = currentNodeContent;

            NSURL * imageURL = [NSURL URLWithString:currentNodeContent];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage * image = [UIImage imageWithData:imageData];
            NSData *savedImageData = UIImagePNGRepresentation(image);
            [currentShow setValue:savedImageData forKey:@"showImage"];

        }
        if ([elementname isEqualToString:@"eventTime"])
        {
            currentEvent.eventTime = currentNodeContent;
            [currentShow setValue:currentNodeContent forKey:@"showTime"];
        }
        if ([elementname isEqualToString:@"eventLink"])
        {
            currentEvent.eventURL = currentNodeContent;
            [currentShow setValue:currentNodeContent forKey:@"showURL"];
        }
        if ([elementname isEqualToString:@"dateAdded"])
        {
            currentEvent.dateAdded = currentNodeContent;
            [currentShow setValue:currentNodeContent forKey:@"dateAdded"];
        }
        
    }
	if ([elementname isEqualToString:@"event"])
	{

		[_events addObject:currentEvent];
        NSLog(@"%@", currentEvent.dateAdded);
        currentEvent = nil;
		currentNodeContent = nil;
        currentShow = nil;
        NSError *err;
        [context save:&err];
	}
}
-(void)CheckNetwork
{
    
}


@end
