//
//  COUIAnimationSpriteLayer.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 12/20/13.
//  Copyright (c) 2013 Cenker Ozkurt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface COUIAnimationSpriteLayer : CALayer

@property (nonatomic, assign) unsigned int frameIndex;

- (id)initWithImage:(CGImageRef)img size:(CGSize)size parentView:(UIView *)parentView frameCount:(int)frameCount;
- (unsigned int)currentFrameIndex;

@end