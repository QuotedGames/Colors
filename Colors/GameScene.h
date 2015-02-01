//
//  GameScene.h
//  Colors
//

//  Copyright (c) 2015 Private. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol GameSceneDelegate <NSObject>

@required
- (void) buttonTouchedWithIndex: (int) index;

@end


@interface GameScene : SKScene
    @property (nonatomic,strong)  id<GameSceneDelegate> delegateContainerViewController;

@end




