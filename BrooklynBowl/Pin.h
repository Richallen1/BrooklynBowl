//
//  Pin.h
//  SpriteKitTest
//
//  Created by Richard Allen on 20/03/2014.
//  Copyright (c) 2014 MagicEntertianment. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Pin : SKSpriteNode <SKPhysicsContactDelegate>

@property (nonatomic) CGPoint startPosition;
@property(nonatomic) int movementDetected;

- (SKSpriteNode *)initWithNumber:(int)number andPosition:(CGPoint)position;


@end
