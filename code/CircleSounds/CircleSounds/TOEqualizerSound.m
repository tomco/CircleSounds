//
//  TOBandEqualizer.m
//  EqualizerTest
//
//  Created by Tobias Ottenweller on 17.08.12.
//  Copyright (c) 2012 Tobias Ottenweller. All rights reserved.
//

#import "TOEqualizerSound.h"
#import "TOCAShortcuts.h"


@implementation TOEqualizerSound


- (id)init
{
    self = [super init];
    
    if (self) {
        _equalizerUnit = [[TOAudioUnit alloc] init];
        _equalizerUnit->description = TOAudioComponentDescription(kAudioUnitType_Effect, kAudioUnitSubType_NBandEQ);
        
        _audioUnits = [_audioUnits arrayByAddingObject:_equalizerUnit];
    }
    
    return self;
}


- (void)setupUnits
{
    [super setupUnits];
    [self applyBands];
    [self applyGlobalGain];
}


# pragma mark - EQ wrapper methods

- (UInt32)maxNumberOfBands
{
    UInt32 maxNumBands = 0;
    UInt32 propSize = sizeof(maxNumBands);
    TOThrowOnError(AudioUnitGetProperty(_equalizerUnit->unit,
                                        kAUNBandEQProperty_MaxNumberOfBands,
                                        kAudioUnitScope_Global,
                                        0,
                                        &maxNumBands,
                                        &propSize));
    
    return maxNumBands;
}


- (void)setNumBands:(UInt32)numBands
{
    TOThrowOnError(AudioUnitSetProperty(_equalizerUnit->unit,
                                        kAUNBandEQProperty_NumberOfBands,
                                        kAudioUnitScope_Global,
                                        0,
                                        &numBands,
                                        sizeof(numBands)));
}


- (void)setBands:(NSArray *)bands
{
    NSParameterAssert(bands);
    
    if (_equalizerUnit->unit) {
        @throw [[NSException alloc] initWithName:@"TOInvalidOperationException"
                                          reason:@"The eq unit is already initialized"
                                        userInfo:nil];
    }
    
    _bands = bands;
    _bandGains = [[NSMutableArray alloc] initWithCapacity:bands.count];
    
    for (NSUInteger i=0; i<_bands.count; i++) {
        _bandGains[i] = @0;
    }
}


- (void)applyBands
{
    if (!_bands.count) {
        return;
    }
    
    
    [self setNumBands:_bands.count];
    
    for (NSUInteger i=0; i<_bands.count; i++) {
        
        // set the frequency
        TOThrowOnError(AudioUnitSetParameter(_equalizerUnit->unit,
                                             kAUNBandEQParam_Frequency+i,
                                             kAudioUnitScope_Global,
                                             0,
                                             (AudioUnitParameterValue)[_bands[i] floatValue],
                                             0));
        
        // enable the band
        TOThrowOnError(AudioUnitSetParameter(_equalizerUnit->unit,
                                             kAUNBandEQParam_BypassBand+i,
                                             kAudioUnitScope_Global,
                                             0,
                                             0,
                                             0));
        
        // set the filter type
        TOThrowOnError(AudioUnitSetParameter(_equalizerUnit->unit,
                                             kAUNBandEQParam_FilterType+i,
                                             kAudioUnitScope_Global,
                                             0,
                                             kAUNBandEQFilterType_Parametric,
                                             0));
    }
    
    
    for (NSUInteger i=0; i<_bandGains.count; i++) {
        [self applyGain:[_bandGains[i] doubleValue] forBandAtPosition:i];
    }
}


- (AudioUnitParameterValue)gainForBandAtPosition:(NSUInteger)bandPosition
{
    return [_bandGains[bandPosition] doubleValue];
}


- (void)setGain:(AudioUnitParameterValue)gain forBandAtPosition:(NSUInteger)bandPosition
{
    _bandGains[bandPosition] = @(gain);
    
    if (_equalizerUnit->unit) {
        [self applyGain:gain forBandAtPosition:bandPosition];
    }
}


- (void)applyGain:(AudioUnitParameterValue)gain forBandAtPosition:(NSUInteger)bandPosition
{
    AudioUnitParameterID parameterID = kAUNBandEQParam_Gain + bandPosition;
    
    TOThrowOnError(AudioUnitSetParameter(_equalizerUnit->unit,
                                         parameterID,
                                         kAudioUnitScope_Global,
                                         0,
                                         gain,
                                         0));
}


- (void)setGlobalGain:(AudioUnitParameterValue)globalGain
{
    _globalGain = globalGain;
    
    if (_equalizerUnit->unit) {
        [self applyGlobalGain];
    }
}


- (void)applyGlobalGain
{
    TOThrowOnError(AudioUnitSetParameter(_equalizerUnit->unit,
                                         kAUNBandEQParam_GlobalGain,
                                         kAudioUnitScope_Global,
                                         0,
                                         _globalGain,
                                         0));
}

@end
