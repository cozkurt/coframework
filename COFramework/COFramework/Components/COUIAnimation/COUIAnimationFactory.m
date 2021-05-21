//
//  COUIAnimationFactory.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 7/16/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#import "COMacros.h"
#import "COLogging.h"

#import "COUIAnimationBaseModel.h"
#import "COUIAnimationCAModel.h"
#import "COUIAnimationFactory.h"
#import "COUIAnimationSpriteLayer.h"

#import "NSObject+Blocks.h"
#import "NSString+Utilities.h"
#import "UIImage+ImageEffects.h"

@implementation COUIAnimationFactory

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Common Animation Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (CAAnimationGroup *)caAnimationGroupForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    group.beginTime = CACurrentMediaTime() + [baseModel.startAfterDelay doubleValue];
    group.removedOnCompletion = NO;
    group.repeatCount = 1;
    group.fillMode = kCAFillModeForwards;
    group.delegate = delegate;
    
    if (caModel.caAnimations!=nil) group.animations = caModel.caAnimations;
    if (caModel.caDuration!=nil) group.duration = [caModel.caDuration doubleValue];
    if (caModel.caAutoReverses!=nil) group.autoreverses = [caModel.caAutoReverses boolValue];
    if (caModel.caRepeatCount!=nil) group.repeatCount = [caModel.caRepeatCount doubleValue];
    if (caModel.caSpeed!=nil) group.speed = [caModel.caSpeed floatValue];
    if (caModel.caFillMode!=nil) group.fillMode = caModel.caFillMode;
    
    [group setValue:baseModel forKey:@"baseModel"];
    [group setValue:caModel forKey:@"caModel"];
    
    return group;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Customizable Animations
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (CABasicAnimation *)caAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:caModel.animationType];
    
    if (baseModel.startAfterDelay > 0)
        animation.beginTime = CACurrentMediaTime() + [baseModel.startAfterDelay doubleValue]; // beginTime can not be used with CAAnimationGroup
    
    if ([caModel.caTimingFunction isEqualToString:@"bounce"])
        animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :2.0 :.8 :0.8];
    else if ([caModel.caTimingFunction isEqualToString:@"easeOutBack"])
        animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.175 :0.885 :0.32 :1.275];
    else if ([caModel.caTimingFunction isEqualToString:@"spring"])
        animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5 :1.43 :1 :1];
    else if ([[caModel.caTimingFunction componentsSeparatedByString:@","] count] == 4)
        animation.timingFunction = [self timingFunction:caModel.caTimingFunction];
    else if (caModel.caTimingFunction!=nil)
        animation.timingFunction = [CAMediaTimingFunction functionWithName:caModel.caTimingFunction];

    animation.autoreverses = NO;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = delegate;
    
    if (caModel.caFromValue!=nil)
    {
        if ([caModel.caFromValue isKindOfClass:[NSString class]])
            animation.fromValue = @([caModel.caFromValue floatValue]);
        else
            animation.fromValue = caModel.caFromValue;
    }
    
    if (caModel.caToValue!=nil)
    {
        if ([caModel.caFromValue isKindOfClass:[NSString class]])
            animation.toValue = @([caModel.caToValue floatValue]);
        else
            animation.toValue = caModel.caToValue;
    }

    if (caModel.caDuration!=nil) animation.duration = [caModel.caDuration doubleValue];
    if (caModel.caAutoReverses!=nil) animation.autoreverses = [caModel.caAutoReverses boolValue];
    if (caModel.caRepeatCount!=nil) animation.repeatCount = [caModel.caRepeatCount floatValue];
    if (caModel.caSpeed!=nil) animation.speed = [caModel.caSpeed floatValue];
    if (caModel.caFillMode!=nil) animation.fillMode = caModel.caFillMode;
    
    [animation setValue:baseModel forKey:@"baseModel"];
    [animation setValue:caModel forKey:@"caModel"];
    
    return animation;
}

+ (CAKeyframeAnimation *)caKeyFrameAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:caModel.animationType];
    
    if (baseModel.startAfterDelay > 0)
        animation.beginTime = CACurrentMediaTime() + [baseModel.startAfterDelay doubleValue]; // beginTime can not be used with CAAnimationGroup
    
    animation.autoreverses = NO;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.calculationMode = @"discrete";
    animation.delegate = delegate;
    
    if (caModel.caValues!=nil) animation.values = (NSArray *)caModel.caValues;
    if (caModel.caAutoReverses!=nil) animation.autoreverses = [caModel.caAutoReverses boolValue];
    if (caModel.caRepeatCount!=nil) animation.repeatCount = [caModel.caRepeatCount floatValue];
    if (caModel.caDuration!=nil) animation.duration = [caModel.caDuration doubleValue];
    if (caModel.caCalculationMode!=nil) animation.calculationMode = caModel.caCalculationMode;
    if (caModel.caSpeed!=nil) animation.speed = [caModel.caSpeed floatValue];
    if (caModel.caFillMode!=nil) animation.fillMode = caModel.caFillMode;
    
    [animation setValue:baseModel forKey:@"baseModel"];
    [animation setValue:caModel forKey:@"caModel"];
    
    return animation;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Predefined Animations
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (CABasicAnimation *)moveAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel fromView:(UIView *)fromView toView:(UIView *)toView caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    caModel.animationType = @"position";
    
    caModel.caFromValue = [NSValue valueWithCGPoint:fromView.center];
    caModel.caToValue = [NSValue valueWithCGPoint:toView.center];
    
    return [self caAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CABasicAnimation *)pulseAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    caModel.animationType = @"transform.scale";
    caModel.caFromValue = @([caModel.caFromValue floatValue]);
    caModel.caToValue = @([caModel.caToValue floatValue]);
    caModel.caAutoReverses = @(YES);
    
    if (caModel.caRepeatCount == nil)
        caModel.caRepeatCount = [NSNumber numberWithFloat:FLT_MAX];
    
    return [self caAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CABasicAnimation *)minimizeAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    caModel.animationType = @"transform.scale";
    caModel.caToValue = @(0);

    return [self caAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CABasicAnimation *)maximizeAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    caModel.animationType = @"transform.scale";
    caModel.caFromValue = @(0);
    caModel.caToValue = @(1);

    return [self caAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CABasicAnimation *)positionXAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    caModel.animationType = @"position.x";
    caModel.caFromValue = @([caModel.caFromValue floatValue]);
    caModel.caToValue = @([caModel.caToValue floatValue]);
    
    return [self caAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CABasicAnimation *)positionYAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    caModel.animationType = @"position.y";
    caModel.caFromValue = @([caModel.caFromValue floatValue]);
    caModel.caToValue = @([caModel.caToValue floatValue]);
    
    return [self caAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CABasicAnimation *)deltaXAnimationWithParentView:(UIView *)parentView baseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    UIView *view = [parentView viewWithTag:[baseModel.tag integerValue]];
        
    caModel.animationType = @"position.x";
    caModel.caFromValue = @(CGRectGetMidX(view.frame));
    caModel.caToValue = @(CGRectGetMidX(view.frame) + [caModel.caToValue floatValue]);
        
    return [self caAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}
    
+ (CABasicAnimation *)deltaYAnimationWithParentView:(UIView *)parentView baseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    UIView *view = [parentView viewWithTag:[baseModel.tag integerValue]];
        
    caModel.animationType = @"position.y";
    caModel.caFromValue = @(CGRectGetMidY(view.frame));
    caModel.caToValue = @(CGRectGetMidY(view.frame) + [caModel.caToValue floatValue]);
        
    return [self caAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CAKeyframeAnimation *)keyframeXAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    caModel.animationType = @"position.x";
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (NSString *items in [caModel.caValues componentsSeparatedByString:@","])
        [arr addObject:@([items floatValue])];
    
    caModel.caValues = arr;
    
    return [self caKeyFrameAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CAKeyframeAnimation *)keyframeYAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    caModel.animationType = @"position.y";
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (NSString *items in [caModel.caValues componentsSeparatedByString:@","])
        [arr addObject:@([items floatValue])];
    
    caModel.caValues = arr;
    
    return [self caKeyFrameAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CABasicAnimation *)fadeAlphaAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    caModel.animationType = @"opacity";
    caModel.caFromValue = @([caModel.caFromValue floatValue]);
    caModel.caToValue = @([caModel.caToValue floatValue]);
    caModel.caRepeatCount = @(1);
    
    return [self caAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CABasicAnimation *)colorAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    caModel.animationType = @"backgroundColor";
    caModel.caFromValue = (id)[self rgbaFromString:caModel.caFromValue].CGColor;
    caModel.caToValue = (id)[self rgbaFromString:caModel.caToValue].CGColor;;
    caModel.caAutoReverses = @(YES);
    
    return [self caAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CABasicAnimation *)gradientColorAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    caModel.animationType = @"colors";
    
    NSArray *fromValues = [caModel.caFromValue componentsSeparatedByString:@"|"];
    NSArray *toValues = [caModel.caToValue componentsSeparatedByString:@"|"];
    
    caModel.caFromValue = [NSArray arrayWithObjects:(id)[self rgbaFromString:[fromValues objectAtIndex:0]].CGColor, [self rgbaFromString:[fromValues objectAtIndex:1]].CGColor, nil];
    caModel.caToValue = [NSArray arrayWithObjects:(id)[self rgbaFromString:[toValues objectAtIndex:0]].CGColor, [self rgbaFromString:[toValues objectAtIndex:1]].CGColor, nil];

    caModel.caAutoReverses = @(NO);
    
    return [self caAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CABasicAnimation *)contentAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    caModel.animationType = @"contents";
    caModel.caFromValue = (id)[UIImage imageNamed:caModel.caFromValue].CGImage;
    caModel.caToValue = (id)[UIImage imageNamed:caModel.caToValue].CGImage;
    caModel.caAutoReverses = @(NO);
    
    return [self caAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CABasicAnimation *)blurAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    UIView *sourceView = [[UIApplication sharedApplication].delegate window];
    
    UIImage *fromImage = [self imageOfView:sourceView];
    UIImage *toImage = [fromImage applySubtleEffect];
    
    caModel.animationType = @"contents";
    caModel.caFromValue = (id)fromImage.CGImage;
    caModel.caToValue = (id)toImage.CGImage;
    
    return [self caAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CABasicAnimation *)opacityAnimationWithParentView:(UIView *)parentView baseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    UIView *view = [parentView viewWithTag:[baseModel.tag integerValue]];
        
    CGFloat alpha = view.alpha;
        
        caModel.animationType = @"opacity";
    
    if (caModel.caFromValue == nil) {
        caModel.caFromValue = @(alpha);
    } else {
        caModel.caFromValue = @([caModel.caFromValue floatValue]);
    }
        
    if (caModel.caToValue == nil) {
        caModel.caToValue = @(alpha);
    } else {
        caModel.caToValue = @([caModel.caToValue floatValue]);
    }
        
    caModel.caRepeatCount = @(1);
        
    return [self caAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CABasicAnimation *)spriteSheetAnimation:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    int frameFPS = [caModel.animationFPS floatValue];
    int frameCount = [caModel.animationFrameCount floatValue];
    
    caModel.animationType = @"frameIndex";
    caModel.caFromValue = @(1);
    caModel.caToValue = @(frameCount);
    
    caModel.caDuration = @(frameCount / frameFPS);

    return [self caAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CABasicAnimation *)rotateAnimation:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    caModel.animationType = @"transform.rotation.z";
    caModel.caToValue = @([caModel.caToValue floatValue] * M_PI);
    
    if (caModel.caRepeatCount == nil)
        caModel.caRepeatCount = [NSNumber numberWithFloat:FLT_MAX];
    
    return [self caAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CAKeyframeAnimation *)shakeAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    caModel.animationType = @"transform";
    caModel.caValues = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-2.0f, -1.0f, 0.0f) ],
                        [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(2.0f, 0.0f, 0.0f) ],
                        [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(2.0f, 1.0f, 0.0f) ],
                        [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(2.0f, -1.0f, 0.0f) ]];
    caModel.caAutoReverses = @(YES);
    caModel.caRepeatCount = @(2);
    
    return [self caKeyFrameAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CAKeyframeAnimation *)framesAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    int frameFPS = [caModel.animationFPS floatValue];
    int frameCount = [caModel.animationFrameCount floatValue];
    
    caModel.animationType = @"contents";
    
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:frameCount];
    NSString *animationImageName = caModel.animationImageName;
    
    for (int i = 0; i < frameCount; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"%@%05d", animationImageName, i];
        
        UIImage *uiImage = [UIImage imageNamed:imageName];

        if (uiImage != nil)
            [images addObject:(id)uiImage.CGImage];
        else
            LogInfo(@"image not found for : %@", imageName);
    }
    
    caModel.caValues = images;
    
    if (caModel.caDuration == nil)
        caModel.caDuration = @(frameCount / frameFPS);
    
    return [self caKeyFrameAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

+ (CAKeyframeAnimation *)imagesAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel delegate:(id)delegate
{
    caModel.animationType = @"contents";
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSArray *imageNames = [caModel.caValues componentsSeparatedByString:@","];
    
    for (NSString *imageName in imageNames)
    {
        UIImage *uiImage = [UIImage imageNamed:imageName];
        
        if (uiImage != nil)
            [images addObject:(id)uiImage.CGImage];
        else
            LogInfo(@"image not found for : %@", imageName);
    }
    
    caModel.caValues = images;
    
    return [self caKeyFrameAnimationForBaseModel:baseModel caModel:caModel delegate:delegate];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Sprite Sheet Factory Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (CALayer *)spriteSheetLayerWithView:(UIView *)view baseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel
{
    // remove previous animations
    [[view.layer sublayers] makeObjectsPerformSelector:@selector(removeAllAnimations)];
    [[view.layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    // setup new animation layer
    CGImageRef spriteSheet = [UIImage imageNamed:caModel.animationImageName].CGImage;
    
    int width = (int) [[[caModel.animationFrameSize componentsSeparatedByString:@","] objectAtIndex:0] integerValue];
    int height = (int) [[[caModel.animationFrameSize componentsSeparatedByString:@","] objectAtIndex:1] integerValue];
    int frameCount = (int) [caModel.animationFrameCount integerValue];
    
    COUIAnimationSpriteLayer *spriteLayer = [[COUIAnimationSpriteLayer alloc] initWithImage:spriteSheet size:CGSizeMake(width, height) parentView:view frameCount:frameCount];
    
    return spriteLayer;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Gradient Factory Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 Initialized gradientLayerWithView
 
 @param view to be applied
 @param baseModel COUIAnimationBaseModel
 @param caModel COUIAnimationCAModel
 @param colors NSArray
 @return self UILayer
 */

+ (CALayer *)gradientLayerWithView:(UIView *)view baseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel colors:(NSArray *)colors
{
    CALayer *layer = view.layer;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.frame = view.bounds;
    gradientLayer.colors = colors;
    gradientLayer.cornerRadius = layer.cornerRadius;
    
    if (caModel.gradientStartPoint!=nil) {
        gradientLayer.startPoint = [COUIAnimationFactory gradientPoint:caModel.gradientStartPoint];
    }
    
    if (caModel.gradientEndPoint!=nil) {
        gradientLayer.endPoint = [COUIAnimationFactory gradientPoint:caModel.gradientEndPoint];
    }
    
    return gradientLayer;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Image Effects Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 create image content from view
 
 @param view view to be converted to image
 @return UIImage
 */

+ (UIImage *)imageOfView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return viewImage;
}

/**
 convert incoming gradient points to CGPoint
 
 @param points string format "0,0.5"
 @return CGPoint
 */

+ (CGPoint)gradientPoint:(NSString *)points
{
    NSArray *p = [points componentsSeparatedByString:@","];
    
    float x,y;
    
    x = [[p objectAtIndex:0] floatValue];
    y = [[p objectAtIndex:1] floatValue];

    return CGPointMake(x, y);
}

/**
 convert incoming rgbaString to UIColor
 
 @param rgbaString string format "255,200,120,255"
 @return UIColor
 */

+ (UIColor *)rgbaFromString:(NSString *)rgbaString
{
    NSArray *fromRGBA = [rgbaString componentsSeparatedByString:@","];
    
    float r,g,b,a;
    
    r = [[fromRGBA objectAtIndex:0] floatValue];
    g = [[fromRGBA objectAtIndex:1] floatValue];
    b = [[fromRGBA objectAtIndex:2] floatValue];
    a = [[fromRGBA objectAtIndex:3] floatValue];
    
    return RGBACOLOR(r, g, b, a);
}

/**
 convert incoming timingFunctions values to timingFunction
 
 @param timingFunction string format "0.5,1.1,1.2,0.8" etc.
 @return UIColor
 */

+ (CAMediaTimingFunction *)timingFunction:(NSString *)values
{
    NSArray *valuesArray = [values componentsSeparatedByString:@","];
    
    float f1,f2,f3,f4;
    
    f1 = [[valuesArray objectAtIndex:0] floatValue];
    f2 = [[valuesArray objectAtIndex:1] floatValue];
    f3 = [[valuesArray objectAtIndex:2] floatValue];
    f4 = [[valuesArray objectAtIndex:3] floatValue];
    
    return [CAMediaTimingFunction functionWithControlPoints:f1 :f2 :f3 :f4];
}

@end
