//
//  GameViewController.m
//  Colors
//
//  Created by Andrey Gershengoren on 30.01.15.
//  Copyright (c) 2015 Private. All rights reserved.
//

#import "GameViewController.h"


NSArray *_colors;
UIColor *_emptyColor;
int _boxCount = 20;
int _movesDone = 0;

NSMutableDictionary *_boxPool;

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _colors = [NSArray arrayWithObjects:[UIColor greenColor], [UIColor blueColor], [UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], nil];
    _emptyColor = [UIColor lightGrayColor];
    
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}


- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    
    
    
    
    
    SKView *skView = [[SKView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:skView];
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    GameScene *gameScene = [GameScene sceneWithSize:skView.bounds.size];
    gameScene.scaleMode = SKSceneScaleModeResizeFill;
    
    
    [skView presentScene:gameScene];
    
    gameScene.delegateContainerViewController = self;
    
    
    
    
    
    
    [skView presentScene:gameScene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}





#pragma Delegate Methods

- (void) buttonTouchedWithIndex:(int)index
{
    
}

@end
