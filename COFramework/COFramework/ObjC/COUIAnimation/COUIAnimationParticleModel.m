//
//  COUIAnimationParticleModel.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 11/9/13.
//  Copyright (c) 2013 Cenker Ozkurt. All rights reserved.
//

#import "COMacros.h"
#import "COUIAnimationParticleModel.h"

@implementation COUIAnimationParticleModel

- (id)init
{
    self = [super init];
    if (self)
    {
        self.name = nil;
        self.birthRate = nil;
        self.lifetime = nil;
        self.lifetimeRange = nil;
        self.color = nil;
        self.contents = nil;
        self.velocityRange = nil;
        self.emissionRange = nil;
        self.scale = nil;
        self.scaleRange = nil;
        self.alphaRange = nil;
        self.alphaSpeed = nil;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        
        if (IS_VALID_STRING([dict valueForKey:@"name"])) self.name = [dict valueForKey:@"name"];
        if (IS_VALID_STRING([dict valueForKey:@"birthRate"])) self.birthRate = [NSNumber numberWithDouble:[[dict valueForKey:@"birthRate"] doubleValue]];
        if (IS_VALID_STRING([dict valueForKey:@"lifetime"])) self.lifetime = [NSNumber numberWithDouble:[[dict valueForKey:@"lifetime"] doubleValue]];
        if (IS_VALID_STRING([dict valueForKey:@"lifetimeRange"])) self.lifetimeRange = [NSNumber numberWithDouble:[[dict valueForKey:@"lifetimeRange"] doubleValue]];
        if (IS_VALID_STRING([dict valueForKey:@"color"])) self.color = [dict valueForKey:@"color"];
        if (IS_VALID_STRING([dict valueForKey:@"contents"])) self.contents = [dict valueForKey:@"contents"];
        if (IS_VALID_STRING([dict valueForKey:@"velocityRange"])) self.velocityRange = [NSNumber numberWithDouble:[[dict valueForKey:@"velocityRange"] doubleValue]];
        if (IS_VALID_STRING([dict valueForKey:@"emissionRange"])) self.emissionRange = [NSNumber numberWithDouble:[[dict valueForKey:@"emissionRange"] doubleValue]];
        if (IS_VALID_STRING([dict valueForKey:@"scale"])) self.scale = [NSNumber numberWithDouble:[[dict valueForKey:@"scale"] doubleValue]];
        if (IS_VALID_STRING([dict valueForKey:@"scaleRange"])) self.scaleRange = [NSNumber numberWithDouble:[[dict valueForKey:@"scaleRange"] doubleValue]];
        if (IS_VALID_STRING([dict valueForKey:@"alphaRange"])) self.alphaRange = [NSNumber numberWithDouble:[[dict valueForKey:@"alphaRange"] doubleValue]];
        if (IS_VALID_STRING([dict valueForKey:@"alphaSpeed"])) self.alphaSpeed = [NSNumber numberWithDouble:[[dict valueForKey:@"alphaSpeed"] doubleValue]];
        
    }
    return  self;
}

- (NSDictionary *)toDictionary
{
    return @{
             @"name": self.name,
             @"birthRate": self.birthRate,
             @"lifetime": self.lifetime,
             @"lifetimeRange": self.lifetimeRange,
             @"color": self.color,
             @"contents": self.contents,
             @"velocityRange": self.velocityRange,
             @"emissionRange": self.emissionRange,
             @"scale": self.scale,
             @"scaleRange": self.scaleRange,
             @"alphaRange": self.alphaRange,
             @"alphaSpeed": self.alphaSpeed
             };
    
    return  nil;
}

@end
