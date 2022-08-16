//
//  COUIBehaviorImage.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 3/15/14.
//  Copyright (c) 2014 Cenker Ozkurt, Inc. All rights reserved.
//

#import "COUIBehaviorImage.h"

@interface COUIBehaviorImage()

@property (nonatomic, assign) BOOL bringToFront;
@property (nonatomic, assign) CGPoint startLocation;

@end

@implementation COUIBehaviorImage

@synthesize startLocation;

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    self.startLocation = [[touches anyObject] locationInView:self];
    
    if (self.bringToFront)
        [[self superview] bringSubviewToFront:self];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesMoved:touches withEvent:event];
    
    CGPoint pt = [[touches anyObject] locationInView:self];
    
    CGRect frame = [self frame];
    
    frame.origin.x += pt.x - self.startLocation.x;
    frame.origin.y += pt.y - self.startLocation.y;
    
    [self setFrame:frame];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"COUI_BEHAVIOR_IMAGE_EVENT" object:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"COUI_BEHAVIOR_IMAGE_EVENT" object:self];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"COUI_BEHAVIOR_IMAGE_EVENT" object:self];
}

@end


