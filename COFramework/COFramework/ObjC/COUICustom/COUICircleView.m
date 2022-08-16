//
//  COUICircleView.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 4/15/14.
//  Copyright (c) 2014 Cenker Ozkurt, Inc. All rights reserved.
//

#import "COMacros.h"
#import "COUICircleView.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface COUICircleView ()

@property (nonatomic, strong) CAShapeLayer *arcLayer;

@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *strokeColor;

@property (nonatomic, strong) NSNumber *startDegree;
@property (nonatomic, strong) NSNumber *fromDegree;
@property (nonatomic, strong) NSNumber *lineWidth;

@property (nonatomic, assign) BOOL animateScale;
@property (nonatomic, assign) BOOL animateStroke;
@property (nonatomic, assign) BOOL animateLineWidth;

@end

@implementation COUICircleView

@synthesize animateScale;
@synthesize animateStroke;
@synthesize animateLineWidth;

- (void)drawRect:(CGRect)rect
{
    ////////////////////////////////////
    // Clear previous layers if any
    ////////////////////////////////////
    
    [self clearView];
    
    ////////////////////////////////////
    // prepare paths
    ////////////////////////////////////
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float radius = rect.size.width/2 - 5;
    
    float from = DEGREES_TO_RADIANS([self.fromDegree integerValue] + [self.startDegree integerValue]);
    float to = DEGREES_TO_RADIANS([self.toDegree integerValue] + [self.startDegree integerValue]);
    
    [path addArcWithCenter:CGPointMake(rect.size.width/2,rect.size.height/2) radius:radius startAngle:from endAngle:to clockwise:YES];
    
    self.arcLayer = [CAShapeLayer layer];
    
    self.arcLayer.path=path.CGPath;
    self.arcLayer.frame = self.bounds;
    
    self.arcLayer.fillColor = self.fillColor.CGColor;
    self.arcLayer.strokeColor = self.strokeColor.CGColor;
    
    self.arcLayer.lineWidth = [self.lineWidth floatValue];

    ////////////////////////////////////
    // Static CA Animations
    ////////////////////////////////////
    
    if (self.animateStroke)
    {
        CABasicAnimation *ca1=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        ca1.duration = 1;
        ca1.fromValue = [NSNumber numberWithFloat:0];
        ca1.toValue = [NSNumber numberWithFloat:1.0];

        [self.arcLayer addAnimation:ca1 forKey:@"circle1"];
    }
    
    if (self.animateLineWidth)
    {
        CABasicAnimation *ca2=[CABasicAnimation animationWithKeyPath:@"lineWidth"];
        ca2.duration = 1;
        ca2.fromValue = [NSNumber numberWithInteger:1];
        ca2.toValue = self.lineWidth;
        
        [self.arcLayer addAnimation:ca2 forKey:@"circle2"];
    }
    
    if (self.animateScale)
    {
        CABasicAnimation *ca3=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
        ca3.duration = 1;
        ca3.fromValue = [NSNumber numberWithFloat:0.6];
        ca3.toValue = [NSNumber numberWithFloat:1.0];
        
        [self.arcLayer addAnimation:ca3 forKey:@"circle3"];
    }
    
    ////////////////////////////////////
    // Add to parent layer
    ////////////////////////////////////
    
    [self.layer addSublayer:self.arcLayer];
}

- (void)clearView
{
    if (self.arcLayer != nil)
    {
        [self.arcLayer removeAllAnimations];
        [self.arcLayer removeFromSuperlayer];
    }
}

@end
