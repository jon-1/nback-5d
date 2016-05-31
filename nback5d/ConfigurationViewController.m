//
//  ConfigurationViewController.m
//  nback5d
//
//  Created by Candy on 5/28/16.
//  Copyright © 2016 jon-1. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "GameSettings.h"

const NSInteger spaceBasePts = 250, colorBasePts = 300, soundBasePts = 400;
const CGFloat penaltyModifier = 3.1;

@interface ConfigurationViewController ()

// Labels for sliders
@property (weak, nonatomic) IBOutlet UILabel *nbackLabel, *selectionTimeLabel;

// Sliders for choosing n and time per round
@property (weak, nonatomic) IBOutlet UISlider *nbackSlider, *timeSlider;

// stores for slider values
@property (assign) NSInteger nbackSliderValue, timeSliderValue, nbackSliderOldValue, timeSliderOldValue;

// Labels for switches
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *switchLabels;

// Switches for space, color, or sound - at least one must be on
@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *switches;
@property (weak, nonatomic) IBOutlet UISwitch *spaceSwitch, *colorSwitch, *soundSwitch;

@property (nonatomic) NSInteger spacePoints, colorPoints, soundPoints;
@property (weak, nonatomic) IBOutlet UILabel *spacePointsLabel, *colorPointsLabel, *soundPointsLabel;

@property (weak, nonatomic) IBOutlet UILabel *wrongAnswerPenaltyLabel;
// swtich for toggling point deductions for wrong answers
@property (weak, nonatomic) IBOutlet UISwitch *wrongAnswerPenaltySwitch;

// enabled while at least 1 switch on
@property (weak, nonatomic) IBOutlet UIButton *startButton;

// to play sounds (strong reference required)
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

// indicates which controls are active
@property (assign) BOOL selectionTimeActive, switchesActive;

@end

@implementation ConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // disable controls
    _timeSlider.userInteractionEnabled = NO;
    
    for (UISwitch* aSwitch in _switches) {
        aSwitch.userInteractionEnabled = NO;
    }
    
    _nbackSliderValue = 1;
    _timeSliderValue = 1;
    [self updatePointTotals];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Sliders

- (IBAction)nbackSliderValueChanged:(UISlider *)sender {
    
    _nbackSliderValue = (NSInteger)sender.value;
    
    // Change the nback label to reflect a selected n
    _nbackLabel.text = [NSString stringWithFormat:@"%ld-BACK", _nbackSliderValue];
    
    if (_nbackSliderValue != _nbackSliderOldValue) {
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav"]] error:NULL];
        _audioPlayer.volume = 1.0;
        [_audioPlayer play];
    }
    
    _nbackSliderOldValue = _nbackSliderValue;
    
    if (!_selectionTimeActive) {
        _selectionTimeActive = true;
        [self performSelector:@selector(enableSelectionTime) withObject:nil afterDelay:0.5];
    }
    
    [self updatePointTotals];
}

- (IBAction)selectionTimeSliderValueChanged:(UISlider *)sender {

    _timeSliderValue = (NSInteger)sender.value;
  
    // Change the time label to reflect updated time
    _selectionTimeLabel.text = [NSString stringWithFormat:@"TIME = %ld SECONDS", _timeSliderValue];
    
    if (_timeSliderValue != _timeSliderOldValue) {
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav"]] error:NULL];
        _audioPlayer.volume = 1.0;
        [_audioPlayer play];
    }
    
    _timeSliderOldValue = _timeSliderValue;
    
    if (!_switchesActive) {
        [self performSelector:@selector(enableSwitches) withObject:nil afterDelay:0.5];
    }
    
    [self updatePointTotals];
}

#pragma mark - Switches

- (IBAction)spaceSwitchValueChanged:(UISwitch *)sender {
    [UIView animateWithDuration:0.1
                     animations:^{ _spacePointsLabel.alpha = _spaceSwitch.on ? 1.0 : 0.05; }];

}

- (IBAction)colorSwitchValueChanged:(UISwitch *)sender {
    [UIView animateWithDuration:0.1
                     animations:^{ _colorPointsLabel.alpha = _colorSwitch.on ? 1.0 : 0.05; }];
}

- (IBAction)soundSwitchValueChanged:(UISwitch *)sender {
    [UIView animateWithDuration:0.1
                     animations:^{ _soundPointsLabel.alpha = _soundSwitch.on ? 1.0 : 0.05; }];
}

- (IBAction)penaltySwitchValueChanged:(UISwitch *)sender {
    
    [self updatePointTotals];
}


-(void)testMethodWithString:(NSString*)string andInt:(NSInteger)integer {
    [self testMethodWithString:@"hi" andInt:3];
}

#pragma mark - State modification

- (void)enableSelectionTime {
    [UIView animateWithDuration:0.5 animations:^{
        _selectionTimeLabel.alpha = 1.0;
        _timeSlider.alpha = 1.0;
    } completion:^(BOOL finished) {
        _timeSlider.userInteractionEnabled = YES;
    }];
}

- (void)enableSwitches {
    _switchesActive = YES;
    [UIView animateWithDuration:0.5 animations:^{
        
        for (UILabel* label in _switchLabels) {
            label.alpha = 1.0;
        }
        
        for (UISwitch* aSwitch in _switches) {
            aSwitch.alpha = 1.0;
        }
        
    } completion:^(BOOL finished) {
        for (UISwitch* aSwitch in _switches) {
            aSwitch.userInteractionEnabled = YES;
        }
        
        [UIView animateWithDuration:0.5 animations:^{ _wrongAnswerPenaltySwitch.alpha = 1.0;
            _wrongAnswerPenaltyLabel.alpha = 1.0; }];
    }];
}

- (void) updatePointTotals {
    
    CGFloat modifier = (CGFloat)(_nbackSliderValue * _nbackSliderValue) / (CGFloat)((sqrt(_timeSliderValue)) * 10);
    
    modifier *= _wrongAnswerPenaltySwitch.on ? penaltyModifier : 1.0;
    
    _spacePoints = (NSInteger)(spaceBasePts * modifier);
    _colorPoints = (NSInteger)(colorBasePts * modifier);
    _soundPoints = (NSInteger)(soundBasePts * modifier);
    
    _spacePointsLabel.text = [NSString stringWithFormat:@"%ld PTS", _spacePoints];
    _colorPointsLabel.text = [NSString stringWithFormat:@"%ld PTS", _colorPoints];
    _soundPointsLabel.text = [NSString stringWithFormat:@"%ld PTS", _soundPoints];
}

- (GameSettings*) produceGameSettings {
    
    NSMutableDictionary* pointValues;
    
    for (UISwitch* aSwitch in _switches) {
        if (aSwitch.on) {
            if (aSwitch == _spaceSwitch) {
                [pointValues setObject:@(_spacePoints) forKey:GameModeSpace];
                continue;
            }
            if (aSwitch == _colorSwitch) {
                [pointValues setObject:@(_colorPoints) forKey:GameModeColor];
                continue;
            }
            if (aSwitch == _soundSwitch) {
                [pointValues setObject:@(_soundPoints) forKey:GameModeSound];
            }
        }
    }
    
    return [GameSettings gameWithN:_nbackSliderValue withRoundTime:_timeSliderValue withOptionsAndPointValues:pointValues];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
}


@end
