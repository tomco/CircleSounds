//
//  TOSoundDocumentViewController.h
//  CircleSounds
//
//  Created by Tobias Ottenweller on 29.08.12.
//  Copyright (c) 2012 Tobias Ottenweller. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TOSoundDocument;
@class TOAudioMeterView;
@class TOPlugableSoundController;


@interface TOSoundDocumentViewController : UIViewController

@property (strong, nonatomic) TOSoundDocument *soundDocument;
@property (strong, nonatomic) NSArray *soundControllers;

- (void)addNewSoundAtPosition:(CGPoint)pos;
- (void)removeSoundController:(TOPlugableSoundController *)soundController;


@property (weak, nonatomic) IBOutlet UIView *canvas;

@property (weak, nonatomic) IBOutlet TOAudioMeterView *leftMeterView;
@property (weak, nonatomic) IBOutlet TOAudioMeterView *rightMeterView;

- (IBAction)startPauseButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *startPauseButton;

- (IBAction)resetButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *resetButtonPressed;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

- (IBAction)volumeSliderValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

- (IBAction)loopSwitchValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *loopSwitch;


@property (weak, nonatomic) IBOutlet UIView *currentPositionView;
@property (weak, nonatomic) IBOutlet UIView *addSoundGestureCatcher;

@end
