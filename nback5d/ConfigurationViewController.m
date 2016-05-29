//
//  ConfigurationViewController.m
//  nback5d
//
//  Created by Candy on 5/28/16.
//  Copyright © 2016 jon-1. All rights reserved.
//

#import "ConfigurationViewController.h"

@interface ConfigurationViewController ()

// Label for nback will update when slider is modified
@property (weak, nonatomic) IBOutlet UILabel *nbackLabel;

// Slider for choosing n
@property (weak, nonatomic) IBOutlet UISlider *nbackSlider;

// "selection time" label
@property (weak, nonatomic) IBOutlet UILabel *selectionTimeLabel;

// Slider for choosing number of seconds per round
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;

// Labels for switches
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *switchLabels;

// Switches for space, color, or sound - at least one must be on
@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *switches;
@property (weak, nonatomic) IBOutlet UISwitch *spaceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *colorSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;

// enabled while at least 1 switch on
@property (weak, nonatomic) IBOutlet UIButton *startButton;



@property (assign) BOOL selectionTimeActive;
@property (assign) BOOL switchesActive;

@end

@implementation ConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // disable controls
    _timeSlider.userInteractionEnabled = false;
    
    for (UISwitch* aSwitch in _switches) {
        aSwitch.userInteractionEnabled = false;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)nbackSliderValueChanged:(UISlider *)sender {
    NSInteger value = (NSInteger)sender.value;
    // Change the nback label to reflect a selected n
    _nbackLabel.text = [NSString stringWithFormat:@"%ld-BACK", value];
    
    if (!_selectionTimeActive) {
        _selectionTimeActive = true;
        [self performSelector:@selector(enableSelectionTime) withObject:nil afterDelay:0.5];
    }
}

- (IBAction)selectionTimeSliderValueChanged:(UISlider *)sender {
    NSInteger value = (NSInteger)sender.value;
    // Change the time label to reflect updated time
    
    _selectionTimeLabel.text = [NSString stringWithFormat:@"TIME = %ld SECONDS", value];
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"timeslider_2" ofType:@"aiff"]] error:NULL];
    [audioPlayer play];
    NSLog(@"%@", [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"timeslider_%ld", value] ofType:@"aiff"])
    if (!_switchesActive) {
        _switchesActive = true;
        [self performSelector:@selector(enableSwitches) withObject:nil afterDelay:0.5];
    }
}

- (IBAction)spaceSwitchValueChanged:(UISwitch *)sender {
    
}

- (IBAction)colorSwitchValueChanged:(UISwitch *)sender {
    
}

- (IBAction)soundSwitchValueChanged:(UISwitch *)sender {
    
}

- (void)enableSelectionTime {
    [UIView animateWithDuration:0.5 animations:^{
        _selectionTimeLabel.alpha = 1.0;
        _timeSlider.alpha = 1.0;
    } completion:^(BOOL finished) {
        _timeSlider.userInteractionEnabled = true;
    }];
}

- (void)enableSwitches {
    [UIView animateWithDuration:0.5 animations:^{
        
        for (UILabel* label in _switchLabels) {
            label.alpha = 1.0;
        }
        
        for (UISwitch* aSwitch in _switches) {
            aSwitch.alpha = 1.0;
        }
        
    } completion:^(BOOL finished) {
        for (UISwitch* aSwitch in _switches) {
            aSwitch.userInteractionEnabled = true;
        }
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
}


@end
