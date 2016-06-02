//
//  Game.m
//  nback5d
//
//  Created by Jon on 5/30/16.
//  Copyright © 2016 jon-1. All rights reserved.
//

#import "GameSettings.h"

@implementation GameSettings

-(id)initWithN:(NSInteger)n withRoundTime:(NSInteger)roundTime withOptionsAndPointValues:(NSDictionary*)pointValues {
    
    if(self = [super init]) {
        _roundTime = roundTime;
        _nAmount = n;
        _pointValuesForOptions = pointValues;
    }
    return self;
}

+(instancetype)gameWithN:(NSInteger)n withRoundTime:(NSInteger)roundTime withOptionsAndPointValues:(NSDictionary*)pointValues {
    return [[self alloc] initWithN:n withRoundTime:roundTime withOptionsAndPointValues:pointValues];
}

@end
