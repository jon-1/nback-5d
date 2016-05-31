//
//  Game.h
//  nback5d
//
//  Created by Jon on 5/30/16.
//  Copyright © 2016 jon-1. All rights reserved.
//

#import <Foundation/Foundation.h>

__unused static NSString* GameModeSpace = @"GameModeSpace";
__unused static NSString* GameModeColor = @"GameModeColor";
__unused static NSString* GameModeSound = @"GameModeSound";

@interface GameSettings : NSObject

@property (assign) NSInteger nAmount;

@property (assign) NSInteger roundTime;

@property (nonatomic) NSDictionary* pointValuesForOptions;

+(instancetype)gameWithN:(NSInteger)n withRoundTime:(NSInteger)roundTime withOptionsAndPointValues:(NSDictionary*)pointValues;

@end
