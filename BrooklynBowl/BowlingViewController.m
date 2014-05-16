//
//  BowlingViewController.m
//  BrooklynBowl
//
//  Created by Rich Allen on 25/03/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "BowlingViewController.h"
#import "MyScene.h"

@interface BowlingViewController ()

@end

@implementation BowlingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
