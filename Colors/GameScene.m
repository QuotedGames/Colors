//
//  GameScene.m
//  Colors
//
//  Created by Andrey Gershengoren on 30.01.15.
//  Copyright (c) 2015 Private. All rights reserved.
//

#import "GameScene.h"


#pragma mark - Private properties

@interface GameScene()

/**
    Contains list of colors to be used for blocks and buttons
 */
@property (nonatomic, retain) NSArray * _colors;


/**
    Defines color for area without blocks (blocks were deleted)
 */
@property (nonatomic, retain) UIColor * _emptyColor;

/**
    Scene background color
 */
@property (nonatomic, retain) UIColor * _backgroundColor;


/**
    Contains all available blocks - cache.
 */
@property (nonatomic, retain) NSMutableDictionary * _boxPool;


/**
    Count of game moves made
 */
@property (nonatomic) int _movesMade;

/**
    Default alpha for all box and button colors
 */
@property (nonatomic) CGFloat _colorAlpha;

/**
    View bounds size
 */
@property (nonatomic) CGSize _boundsSize;

/**
    Size of area where the boxes will be drawn. Depends on sreen resolution. Widht = height.
 */
@property (nonatomic) CGSize _boxFrameSize;


/**
    Size of each block. Depends on size of _boxFrame
 */
@property (nonatomic) CGSize _boxSize;


// Sprites

/**
    Box frame
 */
@property (nonatomic, retain) SKSpriteNode * _boxFrameNode;


@property (nonatomic, retain) SKLabelNode * _labelMovesCountNode;

@property (nonatomic, retain) SKSpriteNode * _buttonNewGame;


/**
  Start point for drawing the fist box.
 */
@property (nonatomic) CGPoint _boxStartPoint;


@property (nonatomic) float _topSpaceHeight;
@property (nonatomic) float _bottomSpaceHeight;

@property (nonatomic) NSUInteger _boxCountInRow;

@property (nonatomic) NSUInteger _totalRemoved;


@property (nonatomic, retain) NSString * _emptyColorValue;

@property (nonatomic) float _bombFreq;

/**
    Textures
 */

@property (nonatomic, retain) SKTexture * _gemsTextureAll;

@property (nonatomic, retain) SKTexture * _gemsTextureBlue;
@property (nonatomic, retain) SKTexture * _gemsTextureGreen;
@property (nonatomic, retain) SKTexture * _gemsTextureRed;
@property (nonatomic, retain) SKTexture * _gemsTextureYellow;
@property (nonatomic, retain) SKTexture * _gemsTextureViolet;

@property (nonatomic, retain) SKTexture * _gemsTextureEmpty;
@property (nonatomic, retain) SKTexture * _gemsTextureDark;
@property (nonatomic, retain) SKTexture * _gemsTextureBomb;

@property (nonatomic, retain) SKTexture * _dirtTexture;

@property (nonatomic, retain) NSArray * _textures;



@end



#pragma mark - Constants

/**
    Count of blocks in one row. TODO: make in dynamic.
 */
#define _cBoxCount 15;


@implementation GameScene


- (id) initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        // init game
        [self bootstrap];
        [self createGameObjects];
    }
    
    return self;
}


#pragma mark - Setup methods

- (void) bootstrap {
    
    NSLog(@"Game scene bootstraping");
    
    self._boxPool = [[NSMutableDictionary alloc] init];
    self._movesMade = 0;
    
    // configure colors
    self._colorAlpha = 1.0f;
    self._bombFreq = 0.03f;
    
    self._emptyColorValue = @"99";
    
    UIColor *blueColor      = [UIColor colorWithRed:0.0f green:128.0f/255.0f blue:1.0f alpha:self._colorAlpha];
    UIColor *redColor       = [UIColor colorWithRed:1.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:self._colorAlpha];
    UIColor *carnationColor = [UIColor colorWithRed:1.0f green:111.0f/255.0f blue:207.0f/255.0f alpha:self._colorAlpha];
    UIColor *greenColor     = [UIColor colorWithRed:204.0f/255.0f green:1.0f blue:102.0f/255.0f alpha:self._colorAlpha];
    UIColor *orangeColor    = [UIColor colorWithRed:1.0f green:204.0f/255.0f blue:102.0f/255.0f alpha:self._colorAlpha];
    
    self._colors            = [NSArray arrayWithObjects:blueColor, redColor, carnationColor, greenColor, orangeColor, nil];
    self._emptyColor        = [UIColor colorWithRed:150.0f/255.0f green:220.0f/255.0f blue:1.0f alpha:self._colorAlpha];
    self._backgroundColor   = [UIColor darkGrayColor];

    // size of box drawinf area
    CGSize boundsSize = self.size;
    self._boundsSize = boundsSize;
    NSLog(@"Bounds frame size initialized (w: %f, h: %f)", boundsSize.width, boundsSize.height);
    
    
    self._topSpaceHeight = self._bottomSpaceHeight = self._boundsSize.height * 0.1f;
    
    boundsSize.height = boundsSize.width;
    self._boxFrameSize = boundsSize;
    
    NSLog(@"Box frame size initialized (w: %f, h: %f)", self._boxFrameSize.width, self._boxFrameSize.height);
    
    
    
    // size of one box
    int boxCount = _cBoxCount;
    self._boxCountInRow = boxCount;
    self._boxSize = CGSizeMake(self._boxFrameSize.width / boxCount, self._boxFrameSize.height / boxCount);
    
    NSLog(@"Box size initialized (w: %f, h: %f)", self._boxSize.width, self._boxSize.height);
    
    
    self._boxStartPoint = CGPointMake(0, self._boundsSize.height - self._boxSize.height - self._topSpaceHeight);
    
    
    // Textures
    self._gemsTextureAll    = [SKTexture textureWithImageNamed:@"gems.png"];
    self._gemsTextureBlue   = [SKTexture textureWithRect:CGRectMake(1 - (1/4.f),    1 - (1/4.f)*2,  1/4.0f, 1/4.f) inTexture:self._gemsTextureAll];
    self._gemsTextureRed    = [SKTexture textureWithRect:CGRectMake(1 - (1/4.f)*2,  1 - (1/4.f),    1/4.0f, 1/4.f) inTexture:self._gemsTextureAll];
    self._gemsTextureViolet = [SKTexture textureWithRect:CGRectMake(0,              0,              1/4.0f, 1/4.f) inTexture:self._gemsTextureAll];
    self._gemsTextureYellow = [SKTexture textureWithRect:CGRectMake(1 - (1/4.f),    1 - (1/4.f),    1/4.0f, 1/4.f) inTexture:self._gemsTextureAll];
    self._gemsTextureGreen  = [SKTexture textureWithRect:CGRectMake(1 - (1/4.f)*3,  1 - (1/4.f),    1/4.0f, 1/4.f) inTexture:self._gemsTextureAll];
    
    self._gemsTextureEmpty  = [SKTexture textureWithRect:CGRectMake(1 - (1/4.f),    1 - (1/4.f)*3,  1/4.0f, 1/4.f) inTexture:self._gemsTextureAll];
    self._gemsTextureDark   = [SKTexture textureWithRect:CGRectMake(1 - (1/4.f),    1 - (1/4.f)*4,  1/4.0f, 1/4.f) inTexture:self._gemsTextureAll];
    self._gemsTextureBomb   = [SKTexture textureWithRect:CGRectMake(1 - (1/4.f)*3, 1 - (1/4.f)*4,   1/4.0f, 1/4.f) inTexture:self._gemsTextureAll];
    
    self._textures = [[NSArray alloc] initWithObjects:self._gemsTextureBlue, self._gemsTextureRed, self._gemsTextureViolet, self._gemsTextureYellow, self._gemsTextureGreen, nil];
    
    self._dirtTexture = [SKTexture textureWithImageNamed:@"dirt.png"];
    
}

- (void) createGameObjects {
    NSLog(@"Creating game scene objects");
    
    //self.backgroundColor = self._backgroundColor;
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithTexture:self._dirtTexture size:self._boundsSize];
    bgNode.anchorPoint = CGPointMake(0.0, 0.0);
    [self addChild:bgNode];
    
    self._totalRemoved = 0;
    
    // Draw boxFrame with empty color
    self._boxFrameNode = [SKSpriteNode spriteNodeWithColor:self._backgroundColor
                                                      size:self._boxFrameSize];
    self._boxFrameNode.anchorPoint  = CGPointMake(0, 0);
    self._boxFrameNode.position     = CGPointMake(0, self._boundsSize.height - self._boxFrameSize.height - self._topSpaceHeight);
    self._boxFrameNode.name         = @"box_frame";
    [self addChild:self._boxFrameNode];
    
    
    // Draw buttons
    NSUInteger colorCount = [self._colors count];
    CGSize buttonSize = CGSizeMake(self._boxFrameSize.width / colorCount, self._boxFrameSize.height / colorCount);
    CGPoint buttonStartPoint = CGPointMake(0, self._bottomSpaceHeight);
    
    for (int k = 0; k < colorCount; ++k) {
        
        SKSpriteNode *buttonNode    = [SKSpriteNode spriteNodeWithTexture:self._textures[k] size:buttonSize];
        
        buttonNode.anchorPoint      = CGPointMake(0, 0);
        buttonNode.position         = buttonStartPoint;
        buttonNode.name             = [NSString stringWithFormat:@"color_button_%d", k];
        buttonNode.userData         = [[NSMutableDictionary alloc]
                                       initWithObjectsAndKeys:[NSString stringWithFormat:@"%lu", (unsigned long) k], @"color_key", nil];
        
        
        [self addChild:buttonNode];
        buttonStartPoint.x += buttonSize.width;
    }
    
    
    
    // add label for moves count
    self._labelMovesCountNode = [SKLabelNode labelNodeWithText:@"Moves made: 0"];
    self._labelMovesCountNode.fontColor = [UIColor lightTextColor];
    self._labelMovesCountNode.fontSize = 28.0f;
    self._labelMovesCountNode.position = CGPointMake(self._boundsSize.width / 2, buttonSize.height + self._topSpaceHeight * 1.3);
    [self addChild:self._labelMovesCountNode];
    
    
    
    // add button "new game"
    CGSize ngButtonSize = CGSizeMake(self._boxFrameSize.width / 2, self._topSpaceHeight - 10);
    self._buttonNewGame = [SKSpriteNode spriteNodeWithColor:self._emptyColor size:ngButtonSize];
    self._buttonNewGame.position = CGPointMake(self._boundsSize.width / 2, self._boundsSize.height - self._topSpaceHeight / 2);
    self._buttonNewGame.name = @"button_new_game";
    
    SKLabelNode *buttonLabel = [SKLabelNode labelNodeWithText:@"New Game"];
    buttonLabel.fontColor = [UIColor darkTextColor];
    buttonLabel.fontSize = 18.0f;
    buttonLabel.position = CGPointMake(0, 0);
    buttonLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    buttonLabel.name = @"label_new_game";
    
    [self._buttonNewGame addChild:buttonLabel];
    
    [self addChild:self._buttonNewGame];
    
    
    [self startGame];
}

- (void) startGame {
    
    NSLog(@"Starting new game...");
    
    
    
    self._movesMade = 0;
    self._totalRemoved = 0;
    
    [self updateMovesLabel];
    
    
    for (NSString *key in self._boxPool) {
        SKSpriteNode *b = (SKSpriteNode *)[self._boxPool objectForKey:key];
        [b removeAllActions];
        [b removeFromParent];
    }
    
    [self._boxPool removeAllObjects];
    
    
    // create boxes
    int boxCount = _cBoxCount;
    
    CGPoint startPoint = self._boxStartPoint;
    
    for (int i = 0; i < boxCount; ++i) {
        for (int j = 0; j < boxCount; ++j) {
            
            NSUInteger randomColorIndex     = [self randomColorIndex];
            
            //SKSpriteNode *boxNode           = [SKSpriteNode spriteNodeWithColor:randomColor size:self._boxSize];
            SKSpriteNode *boxNode           = [SKSpriteNode spriteNodeWithTexture: self._gemsTextureDark size:self._boxSize];
            boxNode.anchorPoint             = CGPointMake(0, 0);
            boxNode.position                = startPoint;
            boxNode.name                    = [NSString stringWithFormat:@"%d_%d", i, j];
            boxNode.userData                = [[NSMutableDictionary alloc]
                                               initWithObjectsAndKeys:[NSString stringWithFormat:@"%lu", (unsigned long) randomColorIndex], @"color_key", nil];
            boxNode.alpha                   = 0.0f;
            // add gem texture to box
            SKSpriteNode *boxGemNode = [SKSpriteNode spriteNodeWithTexture:self._textures[randomColorIndex] size:boxNode.size];
            boxGemNode.anchorPoint = CGPointMake(0, 0);
            
            [boxNode addChild:boxGemNode];
            
            [self addChild:boxNode];
            
            // animate appearance
            SKAction *appearAction = [SKAction fadeInWithDuration:0.2f];
            appearAction.timingMode = SKActionTimingEaseIn;
            
            [boxNode runAction:appearAction];
            
            
            
            
            
            [self._boxPool setValue:boxNode forKey:boxNode.name];
            
            startPoint.x += self._boxSize.width;
        }
        
        startPoint.x = self._boxStartPoint.x;
        startPoint.y -= self._boxSize.height;
    }
    
    // "remove" fist box
    SKSpriteNode *firstBox = [self._boxPool objectForKey:@"0_0"];
    firstBox.color = self._emptyColor;
    [firstBox removeAllChildren];
    firstBox.texture = self._gemsTextureEmpty;
    [firstBox.userData setObject:self._emptyColorValue forKey:@"color_key"];
    
}

#pragma mark - Touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    NSLog(@"node %@ touched", node.name);
    
    if ([node.name hasPrefix:@"color_button"]) {
        NSArray *stringChunks = [node.name componentsSeparatedByString:@"_"];
        
        if ([stringChunks count] != 3) {
            return;
        }
        
        NSUInteger buttonIndex = [[stringChunks objectAtIndex:2] integerValue];
        
        [self colorButtonTouched:buttonIndex];
        
    }
    
    if ([node.name isEqualToString:@"button_new_game"] || [node.name isEqualToString:@"label_new_game"]) {
        [self startGame];
    }
    
}

- (void) colorButtonTouched:(NSUInteger) index {
    
    //UIColor *selectedColor = [self._colors objectAtIndex:index];
    NSString *selectedColorKey = [NSString stringWithFormat:@"%lu", (unsigned long) index];
    
    self._movesMade++;
    [self updateMovesLabel];
    
    for (int i = 0; i < self._boxCountInRow; ++i) {
        for (int j = 0; j < self._boxCountInRow; ++j) {
            
            NSString *key           = [NSString stringWithFormat:@"%d_%d", i, j];
            SKSpriteNode *box       = [self._boxPool objectForKey:key];
            NSString *boxColorKey   = [box.userData objectForKey:@"color_key"];
            
            NSLog(@"Box(%@) color-key: %@.", key, boxColorKey);
            
            // check if box has empty color
            if ([boxColorKey isEqualToString:self._emptyColorValue]) {
                int removed = [self removeBoxNeighbours:box andColorKey:selectedColorKey];
                
                NSLog(@"Removed %d neighbours for block [%d, %d]", removed, i, j);
                
                self._totalRemoved += removed;
            }
            
        }
    }
    
    // check end of game
    
    if(self._totalRemoved == [self._boxPool count] - 1) {
        [self gameOver];
    }
    
}

- (int) removeBoxNeighbours:(SKSpriteNode *) boxNode andColorKey: (NSString *)colorKey {
    
    int removedCount = 0;
    
    NSMutableArray *targets = [self boxPossibleTargets:boxNode andColorKey:colorKey];
    NSMutableArray *bombs = [[NSMutableArray alloc] init];
    
    SKAction *fallDownAction    = [SKAction moveToY:-(self._boxSize.height) duration:1.0f];
    fallDownAction.timingMode   = SKActionTimingEaseInEaseOut;
    SKAction *rotationActon     = [SKAction rotateByAngle: M_PI/4.0 duration:0.05f];
    SKAction *repeatRotation    = [SKAction repeatActionForever:rotationActon];
    
    SKAction *groupAction       = [SKAction group:@[fallDownAction, repeatRotation]];
    
    
    for (int i = 0; i < [targets count]; ++i) {
        BOOL isBomb     = false;
        NSUInteger rnd = (arc4random() % 100);
        NSLog(@"rand: %lu", (unsigned long)rnd);
        
        if(rnd / 100.0f <= self._bombFreq) {
            isBomb = YES;
        }
        
        SKSpriteNode *t = (SKSpriteNode *) [targets objectAtIndex:i];
        
        // add empty node to this position
        SKSpriteNode *emptyNode           = [SKSpriteNode spriteNodeWithTexture:self._gemsTextureEmpty size:t.size];
        emptyNode.anchorPoint             = CGPointMake(0, 0);
        emptyNode.position                = t.position;
        emptyNode.name                    = [t.name copy];
        emptyNode.userData                = [[NSMutableDictionary alloc]
                                           initWithObjectsAndKeys:self._emptyColorValue, @"color_key", nil];

        
        t.anchorPoint = CGPointMake(0.5, 0.5);
        t.zPosition++;
        [[t.children objectAtIndex:0] setAnchorPoint:CGPointMake(0.5, 0.5)];
        
        /*
        if(isBomb) {
            SKSpriteNode *bombNode = [SKSpriteNode spriteNodeWithTexture:self._gemsTextureBomb size:emptyNode.size];
            bombNode.anchorPoint = CGPointMake(0.0, 0.0);
            [emptyNode addChild:bombNode];
            
            [bombs addObject:emptyNode];
        }
         */
        
        [t runAction:groupAction];
        
        [self addChild:emptyNode];
        
        [self._boxPool setObject:emptyNode forKey:emptyNode.name];
        //t.color = self._emptyColor;
        
        
        removedCount++;
    }
    
    
    return removedCount;
}

- (NSMutableArray *) boxPossibleTargets:(SKSpriteNode *) boxNode andColorKey: (NSString *) colorKey {
    NSMutableArray *targets = [[NSMutableArray alloc] init];
    
    // each box has 4 possible targets: left, rigth, bottom, top
    NSArray *nameChunks = [boxNode.name componentsSeparatedByString:@"_"];
    int i               = [[nameChunks objectAtIndex:0] intValue];
    int j               = [[nameChunks objectAtIndex:1] intValue];
    
    int tI, tJ;
    
    // top
    tI = i;
    tJ = j - 1;
    
    if (tJ >= 0) {
        SKSpriteNode *targetTop = (SKSpriteNode *) [self._boxPool objectForKey:[NSString stringWithFormat:@"%d_%d", tI, tJ]];
        NSString *targetTopColorKey = [targetTop.userData objectForKey:@"color_key"];
        
        if (targetTop != nil &&
            ![targetTopColorKey isEqualToString:self._emptyColorValue] &&
            [targetTopColorKey isEqualToString:colorKey])
        {
            [targets addObject:targetTop];
        }
    }
    
    // bottom
    tI = i;
    tJ = j + 1;
    SKSpriteNode *targetBottom = (SKSpriteNode *) [self._boxPool objectForKey:[NSString stringWithFormat:@"%d_%d", tI, tJ]];
    NSString *targetBottomColorKey = [targetBottom.userData objectForKey:@"color_key"];
    
    if (targetBottom != nil &&
        ![targetBottomColorKey isEqualToString:self._emptyColorValue] &&
        [targetBottomColorKey isEqualToString:colorKey])    {
        [targets addObject:targetBottom];
    }
    
    // left
    tI = i - 1;
    tJ = j;
    
    if (tI >= 0) {
        SKSpriteNode *targetLeft = (SKSpriteNode *) [self._boxPool objectForKey:[NSString stringWithFormat:@"%d_%d", tI, tJ]];
        NSString *targetLeftColorKey = [targetLeft.userData objectForKey:@"color_key"];
        
        if (targetLeft != nil &&
            ![targetLeftColorKey isEqualToString:self._emptyColorValue] &&
            [targetLeftColorKey isEqualToString:colorKey])
        {
            [targets addObject:targetLeft];
        }
    }
    
    
    // right
    tI = i + 1;
    tJ = j;
    SKSpriteNode *targetRight = (SKSpriteNode *) [self._boxPool objectForKey:[NSString stringWithFormat:@"%d_%d", tI, tJ]];
    NSString *targetRightColorKey = [targetRight.userData objectForKey:@"color_key"];
    
    if (targetRight != nil &&
        ![targetRightColorKey isEqualToString:self._emptyColorValue] &&
        [targetRightColorKey isEqualToString:colorKey])
    {
        [targets addObject:targetRight];
    }
    
    
    return targets;
};


#pragma mark - Utils

- (UIColor *) randomColor {
    
    NSUInteger index = arc4random() % [self._colors count];
    
    return [self._colors objectAtIndex:index];
}

- (NSUInteger) randomColorIndex {
    
    NSUInteger index = arc4random() % [self._colors count];
    
    return index;
}

-(BOOL) equalColor:(UIColor *)color1 andColor:(UIColor *)color2 {
    const CGFloat range = 1.0f/255.f;
    CGFloat alpha1 = 1.0f, alpha2 = 1.0f;
    CGFloat color1Red = 0.0f, color1Green = 0.0f, color1Blue = 0.0f;
    CGFloat color2Red = 0.0f, color2Green = 0.0f, color2Blue = 0.0f;
    
    [color1 getRed:&color1Red green:&color1Green blue:&color1Blue alpha:&alpha1];
    [color2 getRed:&color2Red green:&color2Green blue:&color2Blue alpha:&alpha2];
    
    if(fabs(color1Red - color2Red) < range &&
       fabs(color1Green - color2Green) < range &&
       fabs(color1Blue - color2Blue) < range) {
        return YES;
    }
    
    return NO;
    
};

-(void)gameOver {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Win!"
                                                    message:[NSString stringWithFormat:@"You cleared the area. Moves made: %d", self._movesMade]
                                                   delegate:nil
                                          cancelButtonTitle:@"Yippi!"
                                          otherButtonTitles:nil, nil];
    [alert show];
    
}

#pragma mark - Game loop

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    [self.children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[SKSpriteNode class]]) {
            SKSpriteNode *node = (SKSpriteNode *) obj;
            
            if (node.position.y < 0) {
                [node removeAllActions];
                [node removeFromParent];
            }
        }
    }];
}


-(void)updateMovesLabel {
    self._labelMovesCountNode.text = [NSString stringWithFormat:@"Moves made: %d", self._movesMade];
}

@end
