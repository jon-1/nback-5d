//
//  ActiveGameViewController.m
//  nback5d
//
//  Created by Candy on 12/24/15.
//  Copyright © 2015 jon-1. All rights reserved.
//

#import "ActiveGameViewController.h"
#import "ColorConstants.h"
#import "KAProgressLabel.h"
#import "UIView+SingleSideBorder.h"
#import "UIButton+ColorForState.h"

@interface ActiveGameViewController () <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>{
    UIButton* triangleButton;
}
/**
 *
 */
@property (strong, nonatomic) UICollectionView* gridCollectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout* flowLayout;

@property (strong, nonatomic) UIView* topView;
@property (strong, nonatomic) UIView* bottomView;

@property (weak, nonatomic) UILabel* nbackNumericLabel;
@property (weak, nonatomic) UILabel* nbackTextLabel;

@property (weak, nonatomic) UILabel* timerNumericLabel;
@property (weak, nonatomic) UIView* outerTimerCircle;
@property (weak, nonatomic) UIView* innerTimerCircle;
@property (weak, nonatomic) UIButton* startButton;
@property (strong, nonatomic) NSTimer* timer;
@property (strong, nonatomic) KAProgressLabel* timerProgressLabel;

@property (weak, nonatomic) UILabel* myScoreNumericLabel;
@property (weak, nonatomic) UILabel* myScoreTextLabel;
@property (weak, nonatomic) UILabel* questionCountLabel;

@property (assign, nonatomic) CGFloat marginSize;
@property (assign, nonatomic) CGFloat fullWidth;

@property (assign, nonatomic) CGFloat globalTimer;

@property (strong, nonatomic) UIButton* soundButton;
@property (strong, nonatomic) UIButton* colorButton;
@property (strong, nonatomic) UIButton* spaceButton;
@property (strong, nonatomic) UIButton* symbolButton;


@end

@implementation ActiveGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _marginSize = 10.0;
    _fullWidth = CGRectGetWidth(self.view.frame) - 2 * _marginSize;
    _flowLayout = [UICollectionViewFlowLayout new];
    _globalTimer = 0.0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(tapped:)];
    
    [self.view addGestureRecognizer:tap];
    
    [self establishView];
}

- (void)tapped:(UITapGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateRecognized)
    {
        CGPoint point = [recognizer locationInView:recognizer.view];
        NSLog(@"%f %f", point.x, point.y);
        // again, point.x and point.y have the coordinates
    }
}

- (void)establishView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(_marginSize, _marginSize, _fullWidth, CGRectGetHeight(self.view.frame) * .15)];
    _gridCollectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(_marginSize, CGRectGetHeight(_topView.frame) + _marginSize * 2, _fullWidth, CGRectGetHeight(self.view.frame) - 2 * CGRectGetHeight(_topView.frame) - 2 * _marginSize) collectionViewLayout:_flowLayout];
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(_marginSize, CGRectGetHeight(_topView.frame) + CGRectGetHeight(_gridCollectionView.frame) + _marginSize * 3, _fullWidth, CGRectGetHeight(self.view.frame) * .15 - _marginSize*2)];
    
    _topView.backgroundColor = WHITE;
    _gridCollectionView.backgroundColor = WHITE;
    _gridCollectionView.layer.borderWidth = 1.0;
    _gridCollectionView.layer.borderColor = GRAY_M.CGColor;
    _bottomView.backgroundColor = GRAY_L;
    _bottomView.layer.borderWidth = 1;
    _bottomView.layer.borderColor = GRAY_M.CGColor;
    
    [self.view addSubview:_topView];
    [self.view addSubview:_gridCollectionView];
    [self.view addSubview:_bottomView];
    
    _timerProgressLabel.backgroundColor = CLEAR;
    _timerProgressLabel.trackWidth = 22;
    _timerProgressLabel.progressWidth = 22;
    _timerProgressLabel.roundedCornersWidth = 22;
    _timerProgressLabel.isEndDegreeUserInteractive = YES;
    
    _timerProgressLabel = [[KAProgressLabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(_topView.frame), CGRectGetHeight(_topView.frame))];
    [_topView addSubview:_timerProgressLabel];
    _timerProgressLabel.center =  CGPointMake(CGRectGetMidX(_timerProgressLabel.superview.bounds), CGRectGetMidY(_timerProgressLabel.superview.bounds));
  
    [_timerProgressLabel setRoundedCornersWidth:2];
    [_timerProgressLabel setProgressWidth:10];
    [_timerProgressLabel setTrackColor:GRAY_P];
    [_timerProgressLabel setProgressColor:RED_PEPSI];
    [_timerProgressLabel setFont:[UIFont fontWithName:@"BebasNeueBold" size:55]];

    NSTimer *timer;
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                             target: self
                                           selector: @selector(fillTimer:)
                                           userInfo: nil
                                            repeats: YES];
    
    _soundButton = [[UIButton alloc] initWithFrame:CGRectMake(_bottomView.frame.origin.x, _bottomView.frame.origin.y, CGRectGetWidth(_bottomView.frame)/3, CGRectGetHeight(_bottomView.frame))];
    [_soundButton setImage:[UIImage imageNamed:@"ear1"] forState:UIControlStateNormal];
    [_soundButton setImage:[UIImage imageNamed:@"earwhite"] forState:UIControlStateSelected];
    [_soundButton addLeftBorderWithColor:GRAY_M andWidth:1];
    [_soundButton addTopBorderWithColor:GRAY_M andWidth:1];
    [_soundButton addBottomBorderWithColor:GRAY_M andWidth:1];
    [_soundButton setColor:LIGHT_GRAY_1 forState:UIControlStateNormal];
    [_soundButton setColor:LIGHT_GRAY_1 forState:UIControlStateHighlighted];
    [_soundButton setColor:GRAY_P forState:UIControlStateSelected];
    [_soundButton addTarget:self action:@selector(selectSoundButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //_soundButton.layer.borderWidth = 1;
   // _soundButton.backgroundColor = WHITE;
    [self.view addSubview:_soundButton];
    
    _spaceButton = [[UIButton alloc] initWithFrame:CGRectMake(_bottomView.frame.origin.x + CGRectGetWidth(_bottomView.frame)/3, _bottomView.frame.origin.y, CGRectGetWidth(_bottomView.frame)/3, CGRectGetHeight(_bottomView.frame))];
    [_spaceButton setImage:[UIImage imageNamed:@"table128"] forState:UIControlStateNormal];
    [_spaceButton setColor:LIGHT_GRAY_1 forState:UIControlStateNormal];
    [_spaceButton setColor:LIGHT_GRAY_2 forState:UIControlStateHighlighted];
   // _spaceButton.layer.borderWidth = 1;
   // _spaceButton.backgroundColor = WHITE;
    [_spaceButton addLeftBorderWithColor:GRAY_M andWidth:1];
    [_spaceButton addTopBorderWithColor:GRAY_M andWidth:1];
    [_spaceButton addBottomBorderWithColor:GRAY_M andWidth:1];
    [self.view addSubview:_spaceButton];
    
    _colorButton = [[UIButton alloc] initWithFrame:CGRectMake(_bottomView.frame.origin.x + 2*CGRectGetWidth(_bottomView.frame)/3, _bottomView.frame.origin.y, CGRectGetWidth(_bottomView.frame)/3, CGRectGetHeight(_bottomView.frame))];
    [_colorButton setImage:[UIImage imageNamed:@"painter128"] forState:UIControlStateNormal];
    [_colorButton setColor:LIGHT_GRAY_1 forState:UIControlStateNormal];
    [_colorButton setColor:LIGHT_GRAY_2 forState:UIControlStateHighlighted];

    [_colorButton addLeftBorderWithColor:GRAY_M andWidth:1];
    [_colorButton addRightBorderWithColor:GRAY_M andWidth:1];
    [_colorButton addTopBorderWithColor:GRAY_M andWidth:1];
    [_colorButton addBottomBorderWithColor:GRAY_M andWidth:1];
   // _colorButton.layer.borderWidth = 1;
   // _colorButton.backgroundColor = WHITE;
    [self.view addSubview:_colorButton];
    
//    for (NSString *familyName in [UIFont familyNames]){
//        NSLog(@"Family name: %@", familyName);
//        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
//            NSLog(@"--Font name: %@", fontName);
//        }
//    }
//    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
//    CGMutablePathRef path = CGPathCreateMutable();
    // CGPathMoveToPoint    CGPathAddLines
   
    
//    triangleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bottomView.frame), CGRectGetHeight(_bottomView.frame))];
//    [triangleButton addTarget:self action:@selector(doThing) forControlEvents:UIControlEventTouchUpInside];
//
//    [triangleButton setFrame:CGRectMake(_bottomView.frame.origin.x, _bottomView.frame.origin.y, CGRectGetWidth(_bottomView.frame)/2, CGRectGetHeight(_bottomView.frame))];
//    [self.view addSubview:triangleButton];
//    [triangleButton setBackgroundColor:LIGHT_GRAY_1];
//
//    CGPathMoveToPoint(path, nil, 0, 0);
//    CGPathAddLineToPoint(path, nil, CGRectGetWidth(_bottomView.frame)/2, CGRectGetHeight(_bottomView.frame));
//    CGPathAddLineToPoint(path, nil, 0, CGRectGetHeight(_bottomView.frame));
//    CGPathCloseSubpath(path);
//    shapeLayer.path = path;
//    triangleButton.layer.mask = shapeLayer;
//    triangleButton.layer.masksToBounds = YES;
//    NSLog(@"%@", triangleButton);
    
    
}

- (BOOL)selectPathContainingPoint:(CGPoint)point {
    CALayer * layer = (CALayer *) triangleButton.layer;
    CAShapeLayer *mask = (CAShapeLayer *)layer.mask;
    return CGPathContainsPoint(mask.path, nil, point, NO);
    //  return CGPathContainsPoint(mask.path, nil, point);
}

-(void)setupBottomButtons:(NSInteger)numberOfButtons {
    switch (numberOfButtons) {
        case 1:
        {}
            break;
        case 2:
        {}
            break;
        case 3:
        {}
            break;
        case 4:
        {}
        default:
            break;
    }
}

- (void) selectSoundButton:(id)sender {
    if ([(UIButton*)sender isSelected]) {
        [(UIButton*)sender setSelected:NO];
    } else {
        [(UIButton*)sender setSelected:YES];
    }
}
- (void) fillTimer:(id)sender {

    _globalTimer += 1;
    [_timerProgressLabel setProgress:_globalTimer/10 timing:TPPropertyAnimationTimingLinear duration:.95 delay:0.0];
    [_timerProgressLabel setText:[NSString stringWithFormat:@"%ld", 11-(long)(_globalTimer)]];
    NSLog(@"%f", _globalTimer);
    NSLog(@"%ld",(long)(_globalTimer * 10));
    if (_globalTimer >= 11) {
        [(NSTimer*)sender invalidate];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gridAmount;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [UICollectionViewCell new];
    return cell;
}



@end
