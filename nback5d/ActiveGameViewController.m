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

@property (assign, nonatomic) NSInteger currentRegion;
@property (strong, nonatomic) NSString* cellIdentifier;
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
    self.gridAmount = 9;
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
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)establishView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(_marginSize, _marginSize, _fullWidth, CGRectGetHeight(self.view.frame) * .15)];
    _gridCollectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(_marginSize, CGRectGetHeight(_topView.frame) + _marginSize * 2, _fullWidth, CGRectGetHeight(self.view.frame) - 2 * CGRectGetHeight(_topView.frame) - 2 * _marginSize) collectionViewLayout:_flowLayout];
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(_marginSize, CGRectGetHeight(_topView.frame) + CGRectGetHeight(_gridCollectionView.frame) + _marginSize * 3, _fullWidth, CGRectGetHeight(self.view.frame) * .15 - _marginSize*2)];
    _cellIdentifier = @"cellIdentifier";
    [_gridCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
    _gridCollectionView.dataSource = self;
    _gridCollectionView.delegate = self;
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
    
    _timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
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
    [_soundButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_soundButton];
    
    _spaceButton = [[UIButton alloc] initWithFrame:CGRectMake(_bottomView.frame.origin.x + CGRectGetWidth(_bottomView.frame)/3, _bottomView.frame.origin.y, CGRectGetWidth(_bottomView.frame)/3, CGRectGetHeight(_bottomView.frame))];
    [_spaceButton setImage:[UIImage imageNamed:@"table128"] forState:UIControlStateNormal];
    [_spaceButton setImage:[UIImage imageNamed:@"table128white"] forState:UIControlStateSelected];
    _spaceButton.imageView.contentMode = UIViewContentModeCenter;
    [_spaceButton setColor:LIGHT_GRAY_1 forState:UIControlStateNormal];
    [_spaceButton setColor:LIGHT_GRAY_2 forState:UIControlStateHighlighted];
    [_spaceButton setColor:GRAY_P forState:UIControlStateSelected];
    [_spaceButton addLeftBorderWithColor:GRAY_M andWidth:1];
    [_spaceButton addTopBorderWithColor:GRAY_M andWidth:1];
    [_spaceButton addBottomBorderWithColor:GRAY_M andWidth:1];
    [_spaceButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_spaceButton];
    
    _colorButton = [[UIButton alloc] initWithFrame:CGRectMake(_bottomView.frame.origin.x + 2*CGRectGetWidth(_bottomView.frame)/3, _bottomView.frame.origin.y, CGRectGetWidth(_bottomView.frame)/3, CGRectGetHeight(_bottomView.frame))];
    [_colorButton setImage:[UIImage imageNamed:@"painter128"] forState:UIControlStateNormal];
    [_colorButton setImage:[UIImage imageNamed:@"painter128white"] forState:UIControlStateSelected];
    [_colorButton setColor:LIGHT_GRAY_1 forState:UIControlStateNormal];
    [_colorButton setColor:LIGHT_GRAY_2 forState:UIControlStateHighlighted];
    [_colorButton setColor:GRAY_P forState:UIControlStateSelected];
    [_colorButton addLeftBorderWithColor:GRAY_M andWidth:1];
    [_colorButton addRightBorderWithColor:GRAY_M andWidth:1];
    [_colorButton addTopBorderWithColor:GRAY_M andWidth:1];
    [_colorButton addBottomBorderWithColor:GRAY_M andWidth:1];
    [_colorButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_colorButton];
    _currentRegion = 1;
  
    [_gridCollectionView reloadData];
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

- (void) selectButton:(id)sender {
    if ([(UIButton*)sender isSelected]) {
        [(UIButton*)sender setSelected:NO];
    } else {
        [(UIButton*)sender setSelected:YES];
    }
}
- (void) fillTimer:(id)sender {
    if (_globalTimer == 0) {
        [UIView animateWithDuration:1.0 animations:^{
                [_gridCollectionView reloadData];
        }];

    }
    _globalTimer += 1;
    [_timerProgressLabel setProgress:_globalTimer/10 timing:TPPropertyAnimationTimingLinear duration:.95 delay:0.0];
    [_timerProgressLabel setText:[NSString stringWithFormat:@"%ld", 11-(long)(_globalTimer)]];
    if (_globalTimer > 9) {
        _globalTimer = 0;
        
        
        _currentRegion = arc4random_uniform(8) + 1;
             [(NSTimer*)sender invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                  target: self
                                                selector: @selector(fillTimer:)
                                                userInfo: nil
                                                 repeats: YES];
    
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%ld", self.gridAmount)
    return self.gridAmount;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_gridCollectionView.frame.size.width/3, _gridCollectionView.frame.size.height/3);
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];

    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = GRAY_M.CGColor;
    if (indexPath.row == _currentRegion) {
        [UIView animateWithDuration:2.0 animations:^{
             cell.backgroundColor = RED_PEPSI;
        }];
       
    } else {
        cell.backgroundColor = WHITE;
    }
    
    return cell;
}



@end
