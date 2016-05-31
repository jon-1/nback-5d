//
//  Game.h
//  nback5d
//
//  Created by Jon on 5/30/16.
//  Copyright © 2016 jon-1. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, GameModeOption) {
    GameModeSpace = (1 << 0),
    GameModeColor = (1 << 1),
    GameModeSound = (1 << 2)
};

@interface Game : NSObject

@property (assign) NSInteger nAmount;

@property (assign) NSInteger roundTime;

@property GameModeOption gameOptions;

@end
