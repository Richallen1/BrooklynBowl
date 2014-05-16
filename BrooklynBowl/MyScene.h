//
//  MyScene.h
//  SpriteKitTest
//

//  Copyright (c) 2014 MagicEntertianment. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(int, GameState) {
    GameStatePlaying,
    GameStateBowling,
    GameStateBowlingSecondGo,
    GameStateGutter,
    GameStateGameOver
};


@interface MyScene : SKScene <SKPhysicsContactDelegate>

@end
