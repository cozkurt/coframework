//
//  COUIAnimationController.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 7/25/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#import "CODataSource.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface COUIAnimationController : NSObject

- (id)initWithView:(UIView *)view withDataSource:(CODataSource *)dataSource;

- (void)playAllAnimations;
- (void)reverseAllAnimations;

- (void)playAnimationForTag:(NSString *)tag;
- (void)playAnimationForEvent:(NSString *)event;
- (void)playAnimationForKeyName:(NSString *)keyName;

@end
