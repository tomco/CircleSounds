//
//  TORecorder.h
//  RecordPlayThrough
//
//  Created by Tobias Ottenweller on 08.08.12.
//  Copyright (c) 2012 Tobias Ottenweller. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TORecorderDelegate;


@interface TORecorder : NSObject

/**
 Boolean defining wether current signals from the input should be played via output.
 */
@property (readwrite, nonatomic) BOOL monitoringInput;


/**
 Returns the URL set via 'prepareForRecordingWithURL:error:'. Does return garbage
 value before 'prepareForRecordingWithURL:error:' and after 'stopRecording' was
 called.
 */
@property (readonly, nonatomic) NSURL *url;

@property (readonly, nonatomic) BOOL isRecording;
@property (weak, nonatomic) id<TORecorderDelegate> delegate;

/**
 Needs to be set to a positive value. Default value is 1.0
 */
@property (assign, nonatomic) double gain;


/**
 Number of input channels the recorder is using. Contains garbage value
 until 'setup' has been called.
 */
@property (readonly, nonatomic) NSInteger numChannels;


/**
 Returns peak power in decibels for a given channel.
 */
- (double)peakPowerForChannel:(NSInteger)channelNumber;

/**
 Returns average power in decibels for a given channel. 
 */
- (double)averagePowerForChannel:(NSInteger)channelNumber;



/**
 Needs to be called before 'startRecording'. Returns 'YES' on success.
 Return 'NO' if recorder has not been 'setup' or some other error has occured.
 An exception will be thrown if 'url' is 'nil'.
 */
- (BOOL)prepareForRecordingWithFileURL:(NSURL *)url error:(NSError **)error;


/**
 Starts recording. Will return 'NO' and will not start recording if
 'prepareForRecordingWithFileURL:error:' has not been called before.
 */
- (BOOL)startRecording;
- (void)stopRecording;


/**
 Needs to be called before any 'startRecording' and 'prepareForRecordingWithFileURL:error:'
 can be called. Enables monitoring.
 */
- (void)setUp;


/**
 Should be called after recording has been finished. Disables monitoring.
 */
- (void)tearDown;

@end