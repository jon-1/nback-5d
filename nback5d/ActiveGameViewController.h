//
//  ActiveGameViewController.h
//  nback5d
//
//  Created by Candy on 12/24/15.
//  Copyright © 2015 jon-1. All rights reserved.
//

#import "ViewController.h"
#import "GameSettings.h"

@interface ActiveGameViewController : ViewController

@property (assign, nonatomic) NSInteger colorsAmount;
@property (assign, nonatomic) NSInteger audioAmount;
@property (assign, nonatomic) NSInteger gridAmount;
@property (assign, nonatomic) NSInteger symbolsAmount;
@property (assign, nonatomic) NSInteger nBackAmount;
@property (assign, nonatomic) CGFloat roundTime;
@property (assign, nonatomic) NSInteger maxRounds;
@property (strong, nonatomic) GameSettings* gameSettings;
@end
