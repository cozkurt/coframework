//
//  COUIBehaviorMotion.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 5/2/14.
//  Copyright (c) 2014 Cenker Ozkurt, Inc. All rights reserved.
//

#import "COUIBehaviorModel.h"
#import "CODataSource.h"

#import <CoreMotion/CoreMotion.h>
#import <Foundation/Foundation.h>

@interface COUIBehaviorMotion : NSObject

// class methods
+ (COUIBehaviorMotion *)sharedInstance;

- (void)activateAccelerometerWithBehaviorModel:(COUIBehaviorModel *)behaviorModel dataSource:(id <CODataSourceDelegate>)dataSource view:(UIView *)view;
- (void)stopAccelerometer;

@end
