//
//  Game.m
//  nback5d
//
//  Created by Jon on 5/30/16.
//  Copyright © 2016 jon-1. All rights reserved.
//

#import "Game.h"

@implementation Game

-(id)initWithN:(NSInteger)n withRoundTime:(NSInteger)roundTime withOptions:(GameModeOption)options {
    if(self = [super init]) {
        _roundTime = roundTime;
        _nAmount = n;
        _gameOptions = options;
    } return self;
}

+(instancetype)gameWithN:(NSInteger)n withRoundTime:(NSInteger)roundTime withOptions:(GameModeOption)options {
    return [[self alloc] initWithN:n withRoundTime:roundTime withOptions:options];
}

@end
