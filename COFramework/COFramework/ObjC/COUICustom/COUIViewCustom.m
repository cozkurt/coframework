//
//  COUIViewCustom.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 10/16/13.
//  Copyright (c) 2013 Cenker Ozkurt. All rights reserved.
//

#import "COUIViewCustom.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface COUIViewCustom ()

@property (nonatomic, strong) UIColor *colorStart;
@property (nonatomic, strong) UIColor *colorEnd;
@property (nonatomic, strong) NSNumber *cornerRadius;

@end

@implementation COUIViewCustom

- (void)drawRect:(CGRect)rect
{
    ////////////////////////////////////
    // Set Gradient Values
    ////////////////////////////////////
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [[self layer] bounds];
    
    if (self.colorStart != nil && self.colorEnd != nil)
        gradient.colors = [NSArray arrayWithObjects:(id)self.colorStart.CGColor, (id)self.colorEnd.CGColor, nil];
    
    gradient.locations = [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:1.0], nil];
    
    [[self layer] insertSublayer:gradient atIndex:0];
    
    ////////////////////////////////////
    // Set Radious Value
    ////////////////////////////////////
    
    if (self.cornerRadius != nil)
    {
        [self.layer setCornerRadius:[self.cornerRadius floatValue]];
        self.layer.masksToBounds = YES;
    }
}

@end
