//
//  MyScene.m
//  SpriteKitTest
//
//  Created by Richard Allen on 18/03/2014.
//  Copyright (c) 2014 MagicEntertianment. All rights reserved.
//

#import "MyScene.h"
#import "Pin.h"

@implementation MyScene
{
    SKNode *gamePlayNode;
    SKSpriteNode *_background;
    SKSpriteNode *_selectedNode;
    SKSpriteNode *_scoreBoard;
    float offsetX;
    float offsetY;
    BOOL isBowling;
    BOOL hitGully;
    CGPoint currentTranslation;
    Pin *pin1;
    Pin *pin2;
    Pin *pin3;
    Pin *pin4;
    Pin *pin5;
    Pin *pin6;
    Pin *pin7;
    Pin *pin8;
    Pin *pin9;
    Pin *pin10;
    SKSpriteNode *gully1;
    SKSpriteNode *gully2;
    GameState _gameState;
    int score;
    NSString *endLabel;
    BOOL canGutterBall;
    int playersTurn;
    NSMutableArray *pinsOnScreen;
    int scoreFirstGo;
    int scoreSecondGo;
    SKLabelNode *scoreLabel;
    BOOL FirstGoFlag;
    BOOL SecondGoFlag;
}

static NSString * const kAnimalNodeName = @"movable";
static NSTimeInterval const delay = 2.0;


static const uint32_t PinCategory =  0x1 << 0;
static const uint32_t BallCategory =  0x1 << 1;
static const uint32_t GullyCategory =  0x1 << 2;


-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [self LogGameState];
        FirstGoFlag = NO;
        SecondGoFlag = NO;
        canGutterBall = YES;
        endLabel = @"";
        playersTurn = 0;
        scoreFirstGo = 0;
        scoreSecondGo = 0;
        self.physicsWorld.contactDelegate = self;
        _gameState = GameStatePlaying;
        [self BuildWorld];
    }
    return self;
}
-(void)LogGameState
{
    switch (_gameState) {
        case 0:
            NSLog(@"GameStatePlaying");
            break;
        case 1:
            NSLog(@"GameStateBowling");
            break;
        case 2:
            NSLog(@"GameStateBowlingSecondGo");
            break;
        case 3:
            NSLog(@"GameStateGutter");
            break;
        case 4:
            NSLog(@"GameStateGameOve");
            break;
            
        default:
            break;
    }
}
-(void)Restart
{
    [self LogGameState];
    _gameState = GameStateBowling;
    NSLog(@"Restart");
    SKScene *newScene = [[MyScene alloc]initWithSize:self.view.bounds.size];

    SKTransition *transition = [SKTransition fadeWithColor:[SKColor blackColor] duration:0.5];
    [self.view presentScene:newScene transition:transition];
    
    
    
}
#pragma Build Sprite Methods
/* --------------------------------------------------------------------------- */
-(void)BuildWorld
{
    [self LogGameState];
    // 1) Loading the background
    _background = [SKSpriteNode spriteNodeWithImageNamed:@"BG"];
    [_background setName:@"background"];
    [_background setAnchorPoint:CGPointZero];
    [self addChild:_background];
    
    [self BuildBall];
    [self BuildGullys];
    [self BuildPins];
    //[self BuildScoreBoard];
}
-(void)BuildBall
{
    [self LogGameState];
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    CGPoint location = CGPointMake(160, 150);
    
    ball.position = location;
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.width/2];
    ball.physicsBody.affectedByGravity = NO;
    ball.name = @"ball";
    ball.physicsBody.categoryBitMask = BallCategory;
    ball.physicsBody.contactTestBitMask = BallCategory;
    [_background addChild:ball];
}
-(void)BuildScoreBoard
{
    _scoreBoard = [SKSpriteNode spriteNodeWithImageNamed:@"scoreBoard"];
    _scoreBoard.position = CGPointMake(160, 70);
    [_background addChild:_scoreBoard];
}
-(void)BuildGullys
{
    [self LogGameState];
    CGSize gullySize = CGSizeMake(20, 1200);
    gully1 = [SKSpriteNode spriteNodeWithImageNamed:@"Gully"];
    gully1.size = gullySize;
    gully1.position = CGPointMake(45, 0);
    gully1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:gullySize];
    gully1.physicsBody.contactTestBitMask = GullyCategory;
    gully1.physicsBody.affectedByGravity = NO;
    [_background addChild:gully1];
    
    gully2 = [SKSpriteNode spriteNodeWithImageNamed:@"Gully"];
    gully2.size = gullySize;
    gully2.position = CGPointMake(280, 0);
    gully2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:gullySize];
    gully2.physicsBody.affectedByGravity = NO;
    gully2.physicsBody.contactTestBitMask = GullyCategory;
    [_background addChild:gully2];
    
}
-(void)BuildPins
{
    [self LogGameState];
    int height =  [[UIScreen mainScreen] bounds].size.height;
    CGPoint startPoint;
    if (height == 568) {
        NSLog(@"iphone 5");
        startPoint = CGPointMake(90, 515);
    }
    else
    {
        NSLog(@"iphone 4");
        startPoint = CGPointMake(90, 430);
    }

    //Row 1
    pin1 = [[Pin alloc]initWithNumber:1 andPosition:startPoint];
    pin1.physicsBody.contactTestBitMask = PinCategory;
    [_background addChild:pin1];

    
    pin2 = [[Pin alloc]initWithNumber:2 andPosition:CGPointMake(pin1.position.x + 45, startPoint.y)];
    pin2.physicsBody.contactTestBitMask = PinCategory;
    [_background addChild:pin2];
    
    pin3 = [[Pin alloc]initWithNumber:3 andPosition:CGPointMake(pin2.position.x + 45, startPoint.y)];
    pin3.physicsBody.contactTestBitMask = PinCategory;
    [_background addChild:pin3];

    pin4 = [[Pin alloc]initWithNumber:4 andPosition:CGPointMake(pin3.position.x + 45, startPoint.y)];
    pin4.physicsBody.contactTestBitMask = PinCategory;
    [_background addChild:pin4];
    
    //Row 2
    pin5 = [[Pin alloc]initWithNumber:5 andPosition:CGPointMake(startPoint.x + 20, startPoint.y - 30)];
    pin5.physicsBody.contactTestBitMask = PinCategory;
    [_background addChild:pin5];
    
    pin6 = [[Pin alloc]initWithNumber:6 andPosition:CGPointMake(pin5.position.x + 48, startPoint.y - 30)];
    pin6.physicsBody.contactTestBitMask = PinCategory;
    [_background addChild:pin6];

    pin7 = [[Pin alloc]initWithNumber:7 andPosition:CGPointMake(pin6.position.x + 48, startPoint.y - 30)];
    pin7.physicsBody.contactTestBitMask = PinCategory;
    [_background addChild:pin7];

    //Row 3
    pin8 = [[Pin alloc]initWithNumber:8 andPosition:CGPointMake(startPoint.x + 45, startPoint.y - 65)];
    pin8.physicsBody.contactTestBitMask = PinCategory;
    [_background addChild:pin8];

    pin9 = [[Pin alloc]initWithNumber:9 andPosition:CGPointMake(pin8.position.x + 44, startPoint.y - 65)];
    pin9.physicsBody.contactTestBitMask = PinCategory;
    [_background addChild:pin9];

    //Row 4
    pin10 = [[Pin alloc]initWithNumber:10 andPosition:CGPointMake(startPoint.x + 70, startPoint.y - 100)];
    pin10.physicsBody.contactTestBitMask = PinCategory;
    [_background addChild:pin10];
    
    
    pinsOnScreen = [[NSMutableArray alloc]initWithObjects:pin1,pin2,pin3,pin4,pin5,pin6,pin7,pin8,pin9,pin10, nil];
    
}
/* --------------------------------------------------------------------------- */

#pragma Move Ball and Swipe Gesture
/* --------------------------------------------------------------------------- */
- (void)didMoveToView:(SKView *)view
{
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [[self view] addGestureRecognizer:gestureRecognizer];
}
- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    
    
//    if (_gameState == GameStateBowling) {
//        return;
//    }
    
	if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [self convertPointFromView:touchLocation];
        [self selectNodeForTouch:touchLocation];
        NSLog(@"Touch Began");
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = CGPointMake(translation.x, -translation.y);
        currentTranslation = translation;
        [self panForTranslation:translation];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        NSLog(@"Touch Changed");
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        NSLog(@"Touch Ended");
        
        if (![[_selectedNode name] isEqualToString:@"ball"]) {
            float scrollDuration = 0.2;
            CGPoint velocity = [recognizer velocityInView:recognizer.view];

            CGPoint pos = [_selectedNode position];
            CGPoint p = mult(velocity, scrollDuration);
            
            CGPoint newPos = CGPointMake(pos.x + p.x, pos.y + p.y);
            newPos = [self boundLayerPos:newPos];
            [_selectedNode removeAllActions];
            
            SKAction *moveTo = [SKAction moveTo:newPos duration:scrollDuration];
            [moveTo setTimingMode:SKActionTimingEaseOut];
            [_selectedNode runAction:moveTo];
            
            offsetX = p.x;
            offsetY = p.y;
            
        }
       _gameState = GameStateBowling;
    }
}
CGPoint mult(const CGPoint v, const CGFloat s) {
	return CGPointMake(v.x*s, v.y*s);
}

- (void)selectNodeForTouch:(CGPoint)touchLocation {
    //1
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    //2
	if(![_selectedNode isEqual:touchedNode]) {
		[_selectedNode removeAllActions];
		[_selectedNode runAction:[SKAction rotateToAngle:0.0f duration:0.1]];
        
        if([[touchedNode name] isEqualToString:@"background"]) {
            return;
		}
        
		_selectedNode = touchedNode;
        
        NSLog(@"NAME: %@", touchedNode.name);

	}
}

- (CGPoint)boundLayerPos:(CGPoint)newPos {
    CGSize winSize = self.size;
    CGPoint retval = newPos;
    retval.x = MIN(retval.x, 0);
    retval.x = MAX(retval.x, -[_background size].width+ winSize.width);
    retval.y = [self position].y;
    return retval;
}

- (void)panForTranslation:(CGPoint)translation {
    CGPoint position = [_selectedNode position];
    if([[_selectedNode name] isEqualToString:@"ball"]) {
        [_selectedNode setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
        NSLog(@"Point: %f , %f", translation.x, translation.y);
        
    } else {

    }
}
-(void)updateBallPos:(CGPoint)translation withSpeed:(float)speed
{
    CGPoint currentPosition = _selectedNode.position;
    CGPoint newPos = CGPointMake(currentPosition.x + translation.x, currentPosition.y + translation.y);
    
    float scrollDuration = speed;
    SKAction *moveTo = [SKAction moveTo:newPos duration:scrollDuration];
    [moveTo setTimingMode:SKActionTimingEaseOut];
    [_selectedNode runAction:moveTo];
    
}
/* --------------------------------------------------------------------------- */

#pragma Phyisics Engine
/* --------------------------------------------------------------------------- */
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    [self LogGameState];
    
    if ((contact.bodyA.contactTestBitMask == BallCategory && contact.bodyB.contactTestBitMask == GullyCategory) || (contact.bodyA.contactTestBitMask == GullyCategory && contact.bodyB.contactTestBitMask == BallCategory))
    {
        if (canGutterBall == YES) {
            //Hit the Right Gutter
            _gameState = GameStateGutter;
            _selectedNode.physicsBody = nil;
            gully1.physicsBody = nil;
            gully2.physicsBody = nil;
            return;
        }
        
    }
    
    if ((contact.bodyA.contactTestBitMask == BallCategory && contact.bodyB.contactTestBitMask == PinCategory) || (contact.bodyA.contactTestBitMask == PinCategory && contact.bodyB.contactTestBitMask == BallCategory))
    {
        //Hit Pins
        
        if (_gameState == GameStateBowling) {
            canGutterBall = NO;
            [self CheckCollisionForContact:contact];
        }
        return;
    }
    if (contact.bodyA.contactTestBitMask == PinCategory && contact.bodyB.contactTestBitMask == PinCategory)
    {
        //Hit Pins
        if (_gameState == GameStateBowling) {
            canGutterBall = NO;
            [self CheckCollisionForContact:contact];
        }
        return;
    }

}

-(void)GutterBall
{
    [self LogGameState];
    _selectedNode.position = CGPointMake(_selectedNode.position.x, _selectedNode.position.y + 7);
    [self ShowScoreForRound:3];
    
}


-(void)CheckPinToPinCollisionForContact:(SKPhysicsContact *)contact
{
    [self LogGameState];
    if (CGRectContainsPoint(pin1.frame, contact.contactPoint)) {
        
        if (pin1.movementDetected < 3) {
           pin1.movementDetected += 1;
        }
        else
        {
            [self performSelector:@selector(HitPinNumber:) withObject:pin1 afterDelay:1];
        }
        
        
    }
    if (CGRectContainsPoint(pin2.frame, contact.contactPoint)) {
        if (pin2.movementDetected < 3) {
            pin2.movementDetected += 1;
        }
        else
        {
            [self performSelector:@selector(HitPinNumber:) withObject:pin2 afterDelay:1];
        }
    }
    
    if (CGRectContainsPoint(pin3.frame, contact.contactPoint)) {
        if (pin3.movementDetected < 3) {
            pin3.movementDetected += 1;
        }
        else
        {
            [self performSelector:@selector(HitPinNumber:) withObject:pin3 afterDelay:1];
        }
    }
    
    if (CGRectContainsPoint(pin4.frame, contact.contactPoint)) {
        if (pin4.movementDetected < 3) {
            pin4.movementDetected += 1;
        }
        else
        {
            [self performSelector:@selector(HitPinNumber:) withObject:pin4 afterDelay:1];
        }
    }
    
    if (CGRectContainsPoint(pin5.frame, contact.contactPoint)) {
        if (pin5.movementDetected < 3) {
            pin5.movementDetected += 1;
        }
        else
        {
            [self performSelector:@selector(HitPinNumber:) withObject:pin5 afterDelay:1];
        }
    }
    if (CGRectContainsPoint(pin6.frame, contact.contactPoint)) {
        if (pin6.movementDetected < 3) {
            pin6.movementDetected += 1;
        }
        else
        {
            [self performSelector:@selector(HitPinNumber:) withObject:pin6 afterDelay:1];
        }    }
    
    if (CGRectContainsPoint(pin7.frame, contact.contactPoint)) {
        if (pin7.movementDetected < 3) {
            pin7.movementDetected += 1;
        }
        else
        {
            [self performSelector:@selector(HitPinNumber:) withObject:pin7 afterDelay:1];
        }
    }
    
    if (CGRectContainsPoint(pin8.frame, contact.contactPoint)) {
        if (pin8.movementDetected < 3) {
            pin8.movementDetected += 1;
        }
        else
        {
            [self performSelector:@selector(HitPinNumber:) withObject:pin8 afterDelay:1];
        }
    }
    
    if (CGRectContainsPoint(pin9.frame, contact.contactPoint)) {
        if (pin9.movementDetected < 3) {
            pin9.movementDetected += 1;
        }
        else
        {
            [self performSelector:@selector(HitPinNumber:) withObject:pin9 afterDelay:1];
        }
    }
    if (CGRectContainsPoint(pin10.frame, contact.contactPoint)) {
        if (pin10.movementDetected < 3) {
            pin10.movementDetected += 1;
        }
        else
        {
            [self performSelector:@selector(HitPinNumber:) withObject:pin10 afterDelay:1];
        }
    }
    
}

-(void)CheckCollisionForContact:(SKPhysicsContact *)contact
{
    [self LogGameState];
    if (CGRectContainsPoint(pin1.frame, contact.contactPoint)) {

        [self performSelector:@selector(HitPinNumber:) withObject:pin1 afterDelay:1];
    }
    if (CGRectContainsPoint(pin2.frame, contact.contactPoint)) {
        [self performSelector:@selector(HitPinNumber:) withObject:pin2 afterDelay:1];
    }

    if (CGRectContainsPoint(pin3.frame, contact.contactPoint)) {
        [self performSelector:@selector(HitPinNumber:) withObject:pin3 afterDelay:1];
    }

    if (CGRectContainsPoint(pin4.frame, contact.contactPoint)) {
        [self performSelector:@selector(HitPinNumber:) withObject:pin4 afterDelay:1];
    }

    if (CGRectContainsPoint(pin5.frame, contact.contactPoint)) {
        [self performSelector:@selector(HitPinNumber:) withObject:pin5 afterDelay:1];
    }
    if (CGRectContainsPoint(pin6.frame, contact.contactPoint)) {
        [self performSelector:@selector(HitPinNumber:) withObject:pin6 afterDelay:1];
    }

    if (CGRectContainsPoint(pin7.frame, contact.contactPoint)) {
        [self performSelector:@selector(HitPinNumber:) withObject:pin7 afterDelay:1];
    }

    if (CGRectContainsPoint(pin8.frame, contact.contactPoint)) {
        [self performSelector:@selector(HitPinNumber:) withObject:pin8 afterDelay:1];
    }

    if (CGRectContainsPoint(pin9.frame, contact.contactPoint)) {
        [self performSelector:@selector(HitPinNumber:) withObject:pin9 afterDelay:1];
    }
    if (CGRectContainsPoint(pin10.frame, contact.contactPoint)) {
        [self performSelector:@selector(HitPinNumber:) withObject:pin10 afterDelay:1];
    }
}

-(void)HitPinNumber:(SKSpriteNode *)pinForDel
{
    [self LogGameState];
    [pinForDel removeFromParent];
    scoreFirstGo +=1;
}
/* --------------------------------------------------------------------------- */

#pragma Custom Game Methods
/* --------------------------------------------------------------------------- */
-(void)endGame
{
    [self LogGameState];

    NSLog(@"END");
    [pin1 removeFromParent];
    [pin2 removeFromParent];
    [pin3 removeFromParent];
    [pin4 removeFromParent];
    [pin5 removeFromParent];
    [pin6 removeFromParent];
    [pin7 removeFromParent];
    [pin8 removeFromParent];
    [pin9 removeFromParent];
    [pin10 removeFromParent];
    [_selectedNode removeFromParent];
    
    pin1 = nil;
    pin2 = nil;
    pin3 = nil;
    pin4 = nil;
    pin5 = nil;
    pin6 = nil;
    pin7 = nil;
    pin8 = nil;
    pin9 = nil;
    pin10 = nil;
    _selectedNode = nil;
    
    _gameState = GameStatePlaying;
    

    NSTimeInterval delay = 3.0;
    [self performSelector:@selector(Restart) withObject:nil afterDelay:delay];
    
    
    NSLog(@"%d", scoreFirstGo);
    NSLog(@"%d", scoreSecondGo);
}

-(void)ShowScoreForRound:(int)round
{
    [self LogGameState];

    switch (round) {
        case 1:
            NSLog(@"Round 1");
            endLabel = [NSString stringWithFormat:@"You scored %d", scoreFirstGo];
            break;
        case 2:
            NSLog(@"Round 2");
            endLabel = [NSString stringWithFormat:@"You scored %d", scoreSecondGo];
            break;
        case 3:
            NSLog(@"Round - Gutter Ball");
            endLabel = @"Ohhhh.......Gutter Ball!!";
            [self performSelector:@selector(Restart) withObject:nil afterDelay:delay];
            break;
        case 4:
            NSLog(@"Clear Restart");
            endLabel = @"";
            [self performSelector:@selector(Restart) withObject:nil afterDelay:delay];
            break;
            
        default:
            break;
    }
    
    
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    scoreLabel.fontSize = 16;
    scoreLabel.text = endLabel;
    scoreLabel.position = CGPointMake(self.view.bounds.size.width/2 , self.view.bounds.size.height/2 );
    [_background addChild:scoreLabel];
}
-(void)ResetBall
{
    //Reset Ball
    _selectedNode = nil;
    [scoreLabel removeFromParent];
    [self BuildBall];
    
}

-(void)EndFirstGoReset
{
    //Reset Ball
    _selectedNode = nil;
    [scoreLabel removeFromParent];
    [self BuildBall];
    playersTurn = 2;
}

-(void)EndFirstGo
{
    if (FirstGoFlag == NO) {
        FirstGoFlag = YES;
        //Show Score
        
        NSLog(@"CHILDREEN REMAINING: %lu", (unsigned long)[_background.children count]);
        
        int remainingPins = [_background.children count] - 4.0;
        scoreFirstGo = 10 - remainingPins;
        NSLog(@"COUNT: %d",scoreFirstGo);
        
        //[self ShowScoreForRound:1];
        [self performSelector:@selector(EndFirstGoReset) withObject:nil afterDelay:2.0];
        
        
        _gameState = GameStatePlaying;
    }


}

-(void)EndSecondGo
{
    if (SecondGoFlag == NO) {
        int currentPinCount = [_background.children count] - 4.0;
        currentPinCount -= scoreFirstGo;
        
        SecondGoFlag = YES;
        scoreSecondGo = [_background.children count] - currentPinCount;
        
        //[self ShowScoreForRound:2];
        [self performSelector:@selector(endGame) withObject:nil afterDelay:2.0];
    }
}
/* --------------------------------------------------------------------------- */


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if (_selectedNode.position.y > 700) {

        if (FirstGoFlag == NO) {
            if (_gameState != GameStateGutter) {
                [self EndFirstGo];
            }
        }
        else if (playersTurn == 2)
        {
            [self EndSecondGo];
        }
        
    }
    
    switch (_gameState) {
        case GameStatePlaying:
            break;
        case GameStateBowling:
            [self updateBallPos:currentTranslation withSpeed:0.01];
            break;
        case GameStateBowlingSecondGo:
            break;
        case GameStateGutter:
            [self GutterBall];
            break;
        case GameStateGameOver:
            [self endGame];
            break;
        
            
        default:
            break;
    }
    
    
}

@end
