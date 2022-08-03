//
//  COUIBehaviorModel.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 3/12/14.
//  Copyright (c) 2014 Cenker Ozkurt, Inc. All rights reserved.
//

#import "COMacros.h"
#import "COUIBehaviorModel.h"

#import "NSString+Utilities.h"

@implementation COUIBehaviorModel

@synthesize gravityDirection;
@synthesize pushDirection;
@synthesize snapToPoint;
@synthesize anchorPoint;


- (id)init
{
    self = [super init];
    if (self)
    {
        self.keyName = nil;
        self.behaviorType = nil;
        self.angle = nil;
        self.magnitude = nil;
        self.gravityDirection = CGPointZero;
        
        self.pushDirection = CGPointZero;
        self.mode = nil;
        
        self.damping = nil;
        self.snapToPoint = CGPointZero;
        
        self.attachedToItem = nil;
        self.frequency = nil;
        self.length = nil;
        self.anchorPoint = CGPointZero;
        
        self.allowsRotation = nil;
        self.density = nil;
        self.elasticity = nil;
        self.friction = nil;
        self.resistance = nil;
        self.angularResistance = nil;
        
        self.xFactor = nil;
        self.yFactor = nil;
        self.zFactor = nil;
        self.push = nil;
        self.gravity = nil;
        
        self.swipeDirection = nil;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        
        if (IS_VALID_STRING([dict valueForKey:@"keyName"])) self.keyName = [dict valueForKey:@"keyName"];
        if (IS_VALID_STRING([dict valueForKey:@"behaviorType"])) self.behaviorType = [dict valueForKey:@"behaviorType"];
        if (IS_VALID_STRING([dict valueForKey:@"angle"])) self.angle = [NSNumber numberWithFloat:[[dict valueForKey:@"angle"] floatValue]];
        if (IS_VALID_STRING([dict valueForKey:@"magnitude"])) self.magnitude = [NSNumber numberWithFloat:[[dict valueForKey:@"magnitude"] floatValue]];
        if (IS_VALID_STRING([dict valueForKey:@"gravityDirection"])) self.gravityDirection = CGPointFromString([dict valueForKey:@"gravityDirection"]);
        
        if (IS_VALID_STRING([dict valueForKey:@"pushDirection"])) self.pushDirection = CGPointFromString([dict valueForKey:@"pushDirection"]);
        if (IS_VALID_STRING([dict valueForKey:@"mode"])) self.mode = [dict valueForKey:@"mode"];
        
        if (IS_VALID_STRING([dict valueForKey:@"damping"])) self.damping = [NSNumber numberWithFloat:[[dict valueForKey:@"damping"] floatValue]];
        if (IS_VALID_STRING([dict valueForKey:@"snapToPoint"])) self.snapToPoint = CGPointFromString([dict valueForKey:@"snapToPoint"]);
        
        if (IS_VALID_STRING([dict valueForKey:@"attachedToItem"])) self.attachedToItem = [NSNumber numberWithFloat:[[dict valueForKey:@"attachedToItem"] floatValue]];
        if (IS_VALID_STRING([dict valueForKey:@"frequency"])) self.frequency = [NSNumber numberWithFloat:[[dict valueForKey:@"frequency"] floatValue]];
        if (IS_VALID_STRING([dict valueForKey:@"length"])) self.length = [NSNumber numberWithFloat:[[dict valueForKey:@"length"] floatValue]];
        if (IS_VALID_STRING([dict valueForKey:@"anchorPoint"])) self.anchorPoint = CGPointFromString([dict valueForKey:@"anchorPoint"]);
        
        if (IS_VALID_STRING([dict valueForKey:@"allowsRotation"])) self.allowsRotation = [NSNumber numberWithBool:[[dict valueForKey:@"allowsRotation"] boolValue]];
        if (IS_VALID_STRING([dict valueForKey:@"density"])) self.density = [NSNumber numberWithFloat:[[dict valueForKey:@"density"] floatValue]];
        if (IS_VALID_STRING([dict valueForKey:@"elasticity"])) self.elasticity = [NSNumber numberWithFloat:[[dict valueForKey:@"elasticity"] floatValue]];
        if (IS_VALID_STRING([dict valueForKey:@"friction"])) self.friction = [NSNumber numberWithFloat:[[dict valueForKey:@"friction"] floatValue]];
        if (IS_VALID_STRING([dict valueForKey:@"resistance"])) self.resistance = [NSNumber numberWithFloat:[[dict valueForKey:@"resistance"] floatValue]];
        if (IS_VALID_STRING([dict valueForKey:@"angularResistance"])) self.angularResistance = [NSNumber numberWithFloat:[[dict valueForKey:@"angularResistance"] floatValue]];

        if (IS_VALID_STRING([dict valueForKey:@"xFactor"])) self.xFactor = [NSNumber numberWithFloat:[[dict valueForKey:@"xFactor"] floatValue]];
        if (IS_VALID_STRING([dict valueForKey:@"yFactor"])) self.yFactor = [NSNumber numberWithFloat:[[dict valueForKey:@"yFactor"] floatValue]];
        if (IS_VALID_STRING([dict valueForKey:@"zFactor"])) self.zFactor = [NSNumber numberWithFloat:[[dict valueForKey:@"zFactor"] floatValue]];
        if (IS_VALID_STRING([dict valueForKey:@"push"])) self.push = [NSNumber numberWithFloat:[[dict valueForKey:@"push"] boolValue]];
        if (IS_VALID_STRING([dict valueForKey:@"gravity"])) self.gravity = [NSNumber numberWithFloat:[[dict valueForKey:@"gravity"] boolValue]];

        if (IS_VALID_STRING([dict valueForKey:@"swipeDirection"])) self.swipeDirection = [dict valueForKey:@"swipeDirection"];
    }
    return  self;
}

- (NSDictionary *)toDictionary
{
    return @{
             @"keyName": self.keyName,
             @"behaviorType": self.behaviorType,
             @"angle": self.angle,
             @"magnitude": self.magnitude,
             @"gravityDirection": [NSString CGPointToString:self.gravityDirection],
             @"pushDirection": [NSString CGPointToString:self.pushDirection],
             @"mode": self.mode,
             @"damping": self.damping,
             @"snapToPoint": [NSString CGPointToString:self.snapToPoint],
             @"attachedToItem": self.attachedToItem,
             @"frequency": self.frequency,
             @"length": self.length,
             @"anchorPoint": [NSString CGPointToString:self.anchorPoint],
             @"allowsRotation": self.allowsRotation,
             @"density": self.density,
             @"elasticity": self.elasticity,
             @"friction": self.friction,
             @"resistance": self.resistance,
             @"angularResistance": self.angularResistance,
             @"xFactor": self.xFactor,
             @"yFactor": self.yFactor,
             @"zFactor": self.zFactor,
             @"push": self.push,
             @"gravity": self.gravity,
             @"swipeDirection": self.swipeDirection
             };
    
    return  nil;
}

@end
