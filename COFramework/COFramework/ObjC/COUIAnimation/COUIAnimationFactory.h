//
//  COUIAnimationFactory.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 7/16/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#import "COUIAnimationBaseModel.h"
#import "COUIAnimationCAModel.h"

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

@interface COUIAnimationFactory : NSObject

+ (CABasicAnimation *)caAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;
+ (CAAnimationGroup *)caAnimationGroupForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;

+ (CABasicAnimation *)moveAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel fromView:(UIView *)fromView toView:(UIView *)toView caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;

+ (CABasicAnimation *)pulseAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;
+ (CABasicAnimation *)minimizeAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;
+ (CABasicAnimation *)maximizeAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;

+ (CABasicAnimation *)positionXAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;
+ (CABasicAnimation *)positionYAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;

+ (CABasicAnimation *)deltaXAnimationWithParentView:(UIView *)parentView baseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;
+ (CABasicAnimation *)deltaYAnimationWithParentView:(UIView *)parentView baseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;

+ (CABasicAnimation *)contentAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;
+ (CABasicAnimation *)opacityAnimationWithParentView:(UIView *)parentView baseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;
+ (CABasicAnimation *)spriteSheetAnimation:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;
+ (CABasicAnimation *)rotateAnimation:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;

+ (CABasicAnimation *)fadeAlphaAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;
+ (CABasicAnimation *)colorAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;
+ (CABasicAnimation *)gradientColorAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;

+ (CABasicAnimation *)blurAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;

+ (CAKeyframeAnimation *)shakeAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;
+ (CAKeyframeAnimation *)framesAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;
+ (CAKeyframeAnimation *)imagesAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;

+ (CAKeyframeAnimation *)keyframeXAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;
+ (CAKeyframeAnimation *)keyframeYAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate;

+ (CALayer *)spriteSheetLayerWithView:(UIView *)view baseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel;
+ (CALayer *)gradientLayerWithView:(UIView *)view baseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel colors:(NSArray *)colors;

@end
