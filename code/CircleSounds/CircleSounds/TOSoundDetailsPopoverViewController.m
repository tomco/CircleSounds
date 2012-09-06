//
//  TOSoundDetailsPopoverViewController.m
//  CircleSounds
//
//  Created by Tobias Ottenweller on 03.09.12.
//  Copyright (c) 2012 Tobias Ottenweller. All rights reserved.
//

#import "TOSoundDetailsPopoverViewController.h"

#import "TOSoundDetailsPopoverViewControllerDelegate.h"
#import "TOEqualizerSound.h"
#import "TOWaveformDrawer.h"


@interface TOSoundDetailsPopoverViewController ()

@end

@implementation TOSoundDetailsPopoverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.loopCountLabel.text = [NSString stringWithFormat:@"%ld", self.sound.loopCount];
    self.loopCountStepper.value = self.sound.loopCount;
    self.songArtistLabel.text = self.sound.fileSongArtist;
    self.songNameLabel.text = self.sound.fileSongName;
    self.songDurationLabel.text = [NSString stringWithFormat:@"%d:%d", (int)self.sound.duration/60, (int)self.sound.duration%60];


    for (NSUInteger i=0; i<self.sound.bands.count; i++) {
        UISlider *slider = (UISlider *)[self.equalizerCanvas viewWithTag:i];
        slider.value = [self.sound gainForBandAtPosition:i];
    }
    
    [self setWaveformImage];
}


- (void)setWaveformImage
{
    // let the drawing of the waveform happen on a background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        TOWaveformDrawer *drawer = [[TOWaveformDrawer alloc] init];
        drawer.mode = TOWaveformDrawerModeRectangle;
        drawer.waveformColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        drawer.imageSize = self.waveformImageView.bounds.size;
        
        UIImage *image = [drawer waveformFromImageAtURL:self.sound.audioFileURL];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.waveformImageView.image = image;
        });
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loopCountStepperValueChanged:(id)sender
{
    self.sound.loopCount = self.loopCountStepper.value;
    self.loopCountLabel.text = [NSString stringWithFormat:@"%ld", self.sound.loopCount];
}


- (IBAction)removeButtonPressed:(id)sender
{
    [self.delegate detailsController:self soundShouldBeRemovedFromDocument:self.sound];
}


- (IBAction)resetEffectsButtonPressed:(id)sender
{
    self.sound.loopCount = 1;
    self.loopCountLabel.text = [NSString stringWithFormat:@"%ld", self.sound.loopCount];
    self.loopCountStepper.value = self.sound.loopCount;
    
    self.sound.globalGain = 0;
    self.sound.playbackRate = 1.0;
    
    for (NSUInteger i=0; i<self.sound.bands.count; i++) {
        UISlider *slider = (UISlider *)[self.equalizerCanvas viewWithTag:i];
        slider.value = 0;
        
        [self.sound setGain:0 forBandAtPosition:i];
    }
    
}


- (IBAction)changeSoundButtonPressed:(id)sender
{
}


- (IBAction)eqSliderValueChanged:(UISlider *)sender
{
    NSInteger bandIndex = sender.tag;
    [self.sound setGain:sender.value forBandAtPosition:bandIndex];
}

@end
