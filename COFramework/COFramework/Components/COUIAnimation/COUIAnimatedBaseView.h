//
//  COUIAnimatedBaseView.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 7/24/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface COUIAnimatedBaseView : UIView

- (void)playAnimations;
- (void)reverseAnimations;

- (void)playAnimationForEvent:(NSString *)event;
- (void)playAnimationForEvent:(NSString *)event afterDelay:(NSTimeInterval)delay;

@end
