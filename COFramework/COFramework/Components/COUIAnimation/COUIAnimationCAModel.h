//
//  COUIAnimationCAModel.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 11/9/13.
//  Copyright (c) 2013 Cenker Ozkurt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface COUIAnimationCAModel : NSObject

/** will be used as ca key */
@property (nonatomic, strong) NSString *keyName;

/** Predefined AnimationType to apply or CA animationKeyPath
 
 Values : pulseAnimation, maximizeAnimation, minimizeAnimation, positionXAnimation, positionYAnimation
 keyframeXAnimation, keyframeYAnimation, shakeAnimation, opacityAnimation, framesAnimation, imagesAnimation, groupAnimation
 or default CAAnimation type like transform.x, opacity, content etc...
 
 @see COUIAnimationController:performAnimationForModel:
 */
@property (nonatomic, strong) NSString *animationType;

/** Animation duration if applicable */
@property (nonatomic, strong) NSNumber *caDuration;

/** Animation repeatCount if applicable */
@property (nonatomic, strong) NSNumber *caRepeatCount;

/** speed of animation */
@property (nonatomic, strong) NSNumber *caSpeed;

/** calculation modes : linear, discrete, paced, cubic, cubicPaced */
@property (nonatomic, strong) NSString *caCalculationMode;

/** autoreverse yes/no */
@property (nonatomic, strong) NSNumber *caAutoReverses;

/** timingFunctions: default easeInEaseOut easeIn easeOut linear bounce(custom) */
@property (nonatomic, strong) NSString *caTimingFunction;

/* fillMode: kCAFillModeForwards kCAFillModeBackwards kCAFillModeBoth kCAFillModeRemoved */
@property (nonatomic, strong) NSString *caFillMode;

// dynamic property types

/** fromValue to animate */
@property (nonatomic, strong) id caFromValue;

/** toValue to animate */
@property (nonatomic, strong) id caToValue;

/** values for key animations, this can be image, foat valued etc. */
@property (nonatomic, strong) id caValues;

/** caAnimations for groupAnimation type */
@property (nonatomic, strong) NSArray *caAnimations;

/** animation image name + frame will be used to fetch image */
@property (nonatomic, strong) NSString *animationImageName;

/** animation number of frames */
@property (nonatomic, strong) NSString *animationFrameCount;

/** animation frame size */
@property (nonatomic, strong) NSString *animationFrameSize;

/** animation number of frames per second */
@property (nonatomic, strong) NSString *animationFPS;

/** gradient startPoint for gradient direction */
@property (nonatomic, strong) NSString *gradientStartPoint;

/** gradient endPoint for gradient direction */
@property (nonatomic, strong) NSString *gradientEndPoint;

/** Initializes model from dictionary
 
 @param dict dictionary to convert model
 @return self
 */
- (id)initWithDictionary:(NSDictionary *)dict;

/** Converts model to dictionary
 @return NSDictionary
 */
- (NSDictionary *)toDictionary;

@end
