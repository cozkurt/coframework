//
//  COUIBehaviorFactory.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 3/13/14.
//  Copyright (c) 2014 Cenker Ozkurt, Inc. All rights reserved.
//

#import "COUIBehaviorModel.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface COUIBehaviorFactory : NSObject

// class methods
+ (COUIBehaviorFactory *)sharedInstance;

- (void)removeAllBehaviorsForParentView:(UIView *)parentView;

- (void)dynamicItemBehaviorWithParentView:(UIView *)parentView views:(NSArray *)views behaviorModel:(COUIBehaviorModel *)behaviorModel;
- (void)attachmentBehaviorWithParentView:(UIView *)parentView views:(NSArray *)views behaviorModel:(COUIBehaviorModel *)behaviorModel;
- (void)gravityBehaviorWithParentView:(UIView *)parentView views:(NSArray *)views behaviorModel:(COUIBehaviorModel *)behaviorModel;
- (void)pushBehaviorWithParentView:(UIView *)parentView views:(NSArray *)views behaviorModel:(COUIBehaviorModel *)behaviorModel;
- (void)snapBehaviorWithParentView:(UIView *)parentView views:(NSArray *)views behaviorModel:(COUIBehaviorModel *)behaviorModel;
- (void)collisionBehaviorWithParentView:(UIView *)parentView views:(NSArray *)views behaviorModel:(COUIBehaviorModel *)behaviorModel delegate:(id <UICollisionBehaviorDelegate>)delegate;

@end
