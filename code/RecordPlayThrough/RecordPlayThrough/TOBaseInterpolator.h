//
//  WABaseInterpolator.h
//  WeatherApp
//
//  Created by Tobias Ottenweller on 5/7/12.
//  Copyright (c) 2012 Tobias Ottenweller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOBaseInterpolator : NSObject

+ (double)yValueForX:(double)x inLinearFunctionWithPoint:(CGPoint)p1 andPoint:(CGPoint)p2;

@end
