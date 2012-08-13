//
//  TOViewController.h
//  RecordPlayThrough
//
//  Created by Tobias Ottenweller on 08.07.12.
//  Copyright (c) 2012 Tobias Ottenweller. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TORecorder.h"
#import "TORecorderDelegate.h"
#import "TOWaveformViewDatatSource.h"
#import "TOWaveformView.h"
#import "TOAudioMeterView.h"
#import "TOAudioMeterController.h"


@interface TOViewController : UIViewController <TORecorderDelegate, TOWaveformViewDatatSource>

@property (strong, nonatomic) TORecorder *recoder;

@property (weak, nonatomic) IBOutlet UIButton *monitorButton;
@property (weak, nonatomic) IBOutlet UITextField *filenameField;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@property (weak, nonatomic) IBOutlet TOWaveformView *waveFormView;
@property (weak, nonatomic) IBOutlet TOAudioMeterView *audioMeterView;
@property (strong, nonatomic) TOAudioMeterController *audioMeterController;

- (IBAction)changeMonitorSetting:(id)sender;
- (IBAction)prepareRecorder:(id)sender;
- (IBAction)recordPressed:(id)sender;


- (NSArray *)points;


@end