//
//  COUIBehaviorGestures.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 5/2/14.
//  Copyright (c) 2014 Cenker Ozkurt, Inc. All rights reserved.
//

#import "COUIBehaviorModel.h"
#import "COUIAnimationBaseModel.h"

#import <Foundation/Foundation.h>

@interface COUIBehaviorGestures : NSObject

// class methods
+ (COUIBehaviorGestures *)sharedInstance;

- (void)panGestureWithBaseModel:(COUIAnimationBaseModel *)baseModel behaviorModel:(COUIBehaviorModel *)behaviorModel view:(UIView *)view views:(NSArray *)views;
- (void)swipeGestureWithBaseModel:(COUIAnimationBaseModel *)baseModel behaviorModel:(COUIBehaviorModel *)behaviorModel view:(UIView *)view views:(NSArray *)views;

@end
