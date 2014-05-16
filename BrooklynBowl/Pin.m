//
//  Pin.m
//  SpriteKitTest
//
//  Created by Richard Allen on 20/03/2014.
//  Copyright (c) 2014 MagicEntertianment. All rights reserved.
//

#import "Pin.h"

@implementation Pin
@synthesize startPosition = _startPosition;
@synthesize movementDetected = _movementDetected;

- (Pin *)initWithNumber:(int)number andPosition:(CGPoint)position
{
    //Row 1
    Pin *pin = [Pin spriteNodeWithImageNamed:@"Pin"];
    pin.position = position;
    pin.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(23, 65)];
    pin.physicsBody.affectedByGravity = NO;
    NSString *unique = [NSString stringWithFormat:@"pin%d", number];
    pin.name = unique;
    pin.movementDetected = 0;
    
    Pin *returnValue = pin;
    return returnValue;
}


@end
