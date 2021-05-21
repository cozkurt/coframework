//
//  COUIAnimationCAModel.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 11/9/13.
//  Copyright (c) 2013 Cenker Ozkurt. All rights reserved.
//

#import "COMacros.h"
#import "COUIAnimationCAModel.h"

@implementation COUIAnimationCAModel

- (id)init
{
    self = [super init];
    if (self)
    {
        self.keyName = nil;
        self.animationType = nil;
        self.caDuration = nil;
        self.caFromValue = nil;
        self.caToValue = nil;
        self.caRepeatCount = nil;
        self.caSpeed = nil;
        self.caValues = nil;
        self.caCalculationMode = nil;
        self.caAutoReverses = @(NO);
        self.caAnimations = nil;
        self.caTimingFunction = nil;
        self.caFillMode = nil;
        self.animationImageName = nil;
        self.animationFrameCount = nil;
        self.animationFrameSize = nil;
        self.animationFPS = nil;
        self.gradientStartPoint = nil;
        self.gradientEndPoint = nil;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        if (IS_VALID_STRING([dict valueForKey:@"keyName"])) self.keyName = [dict valueForKey:@"keyName"];
        if (IS_VALID_STRING([dict valueForKey:@"animationType"])) self.animationType = [dict valueForKey:@"animationType"];
        if (IS_VALID_STRING([dict valueForKey:@"caDuration"])) self.caDuration = [NSNumber numberWithDouble:[[dict valueForKey:@"caDuration"] doubleValue]];
        if (IS_VALID_STRING([dict valueForKey:@"caFromValue"])) self.caFromValue = [dict valueForKey:@"caFromValue"];
        if (IS_VALID_STRING([dict valueForKey:@"caToValue"])) self.caToValue = [dict valueForKey:@"caToValue"];
        if (IS_VALID_STRING([dict valueForKey:@"caRepeatCount"])) self.caRepeatCount = [NSNumber numberWithFloat:[[dict valueForKey:@"caRepeatCount"] floatValue]];
        if (IS_VALID_STRING([dict valueForKey:@"caSpeed"]))
            self.caSpeed = [NSNumber numberWithFloat:[[dict valueForKey:@"caSpeed"] floatValue]];
        else
            self.caSpeed = @(1);
        
        if (IS_VALID_STRING([dict valueForKey:@"caValues"])) self.caValues = [dict valueForKey:@"caValues"];
        if (IS_VALID_STRING([dict valueForKey:@"caCalculationMode"])) self.caCalculationMode = [dict valueForKey:@"caCalculationMode"];
        if (IS_VALID_STRING([dict valueForKey:@"caAutoReverses"])) self.caAutoReverses = [NSNumber numberWithBool:[[dict valueForKey:@"caAutoReverses"] boolValue]];
        if (IS_VALID_ARRAY([dict valueForKey:@"caAnimations"])) self.caAnimations = [dict valueForKey:@"caAnimations"];
        if (IS_VALID_STRING([dict valueForKey:@"caTimingFunction"])) self.caTimingFunction = [dict valueForKey:@"caTimingFunction"];
        if (IS_VALID_STRING([dict valueForKey:@"caFillMode"])) self.caFillMode = [dict valueForKey:@"caFillMode"];
        if (IS_VALID_STRING([dict valueForKey:@"animationImageName"])) self.animationImageName = [dict valueForKey:@"animationImageName"];
        if (IS_VALID_STRING([dict valueForKey:@"animationFrameCount"])) self.animationFrameCount = [dict valueForKey:@"animationFrameCount"];
        if (IS_VALID_STRING([dict valueForKey:@"animationFrameSize"])) self.animationFrameSize = [dict valueForKey:@"animationFrameSize"];
        if (IS_VALID_STRING([dict valueForKey:@"animationFPS"])) self.animationFPS = [dict valueForKey:@"animationFPS"];
        if (IS_VALID_STRING([dict valueForKey:@"gradientStartPoint"])) self.gradientStartPoint = [dict valueForKey:@"gradientStartPoint"];
        if (IS_VALID_STRING([dict valueForKey:@"gradientEndPoint"])) self.gradientEndPoint = [dict valueForKey:@"gradientEndPoint"];

    }
    return  self;
}

- (NSDictionary *)toDictionary
{
    return @{
             @"keyName": self.keyName,
             @"animationType": self.animationType,
             @"caDuration": self.caDuration,
             @"caFromValue": self.caFromValue,
             @"caToValue": self.caToValue,
             @"caRepeatCount": self.caRepeatCount,
             @"caSpeed": self.caSpeed,
             @"caValues": self.caValues,
             @"caCalculationMode": self.caCalculationMode,
             @"caAutoReverses": self.caAutoReverses,
             @"caAnimations": self.caAnimations,
             @"caTimingFunction": self.caTimingFunction,
             @"caFillMode": self.caFillMode,
             @"animationImageName": self.animationImageName,
             @"animationFrameCount": self.animationFrameCount,
             @"animationFrameSize": self.animationFrameSize,
             @"animationFPS": self.animationFPS,
             @"gradientStartPoint": self.gradientStartPoint,
             @"gradientEndPoint": self.gradientEndPoint
             };
    
    return  nil;
}

@end
