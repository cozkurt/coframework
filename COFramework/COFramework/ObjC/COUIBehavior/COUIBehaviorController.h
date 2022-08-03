//
//  COUIBehaviorController.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 3/13/14.
//  Copyright (c) 2014 Cenker Ozkurt, Inc. All rights reserved.
//

#import "CODataSource.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface COUIBehaviorController : NSObject <UICollisionBehaviorDelegate>

- (id)initWithView:(UIView *)view withDataSource:(CODataSource *)dataSource;

- (void)playAllBehaviors;

@end
