//
//  COUIBehaviorMotion.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 5/2/14.
//  Copyright (c) 2014 Cenker Ozkurt, Inc. All rights reserved.
//

#import "COSingleton.h"
#import "COUIAnimationBaseModel.h"

#import "COUIBehaviorFactory.h"
#import "COUIBehaviorController.h"

#import "COUIBehaviorMotion.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface COUIBehaviorMotion ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, strong) id dataSource;
@property (nonatomic, strong) UIView *view;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - COUIBehaviorMotion
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation COUIBehaviorMotion

CO_SYNTHESIZE_SINGLETON(COUIBehaviorMotion, sharedInstance, ^(COUIBehaviorMotion *sharedInstance) { return [sharedInstance init]; } );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Accelerometer Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)activateAccelerometerWithBehaviorModel:(COUIBehaviorModel *)behaviorModel dataSource:(id <CODataSourceDelegate>)dataSource view:(UIView *)view
{
    self.view = view;
    self.dataSource = dataSource;
    
    if (![self.motionManager isAccelerometerActive])
    {
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = [behaviorModel.frequency floatValue];
        
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^ (CMAccelerometerData *accelerometerData, NSError *error)
         {
             [self playAccelerometer:accelerometerData];
         }];
    }
}

- (void)playAccelerometer:(CMAccelerometerData *)accelerometerData
{
    for (NSDictionary *dict in [self.dataSource dataList])
    {
        COUIBehaviorModel *behaviorModel = [[COUIBehaviorModel alloc] initWithDictionary:dict];
        
        if ([behaviorModel.behaviorType isEqualToString:@"accelerometerBehavior"])
        {
            COUIAnimationBaseModel *baseModel = [[COUIAnimationBaseModel alloc] initWithDictionary:dict];
            
            UIView *view = [self.view viewWithTag:[baseModel.tag integerValue]];
            
            float kFilteringFactorX = [behaviorModel.xFactor floatValue];
            float kFilteringFactorY = [behaviorModel.yFactor floatValue];
            float kFilteringFactorZ = [behaviorModel.zFactor floatValue];
            
            static UIAccelerationValue x = 0, y = 0, z = 0;
            
            x = accelerometerData.acceleration.x * kFilteringFactorX * 0.1;
            y = accelerometerData.acceleration.y * kFilteringFactorY * 0.1;
            z = accelerometerData.acceleration.z * kFilteringFactorZ * 0.1;
            
            if ([behaviorModel.push boolValue])
            {
                behaviorModel.pushDirection = CGPointMake(x, -y);
                [[COUIBehaviorFactory sharedInstance] pushBehaviorWithParentView:self.view views:@[ view ] behaviorModel:behaviorModel];
            }
            else if ([behaviorModel.gravity boolValue])
            {
                behaviorModel.gravityDirection = CGPointMake(x, -y);
                [[COUIBehaviorFactory sharedInstance] gravityBehaviorWithParentView:self.view views:@[ view ] behaviorModel:behaviorModel];
            }
            
            NSLog(@"x = %f, y= %f, z = %f", x, y ,z);
        }
    }
}

- (void)stopAccelerometer
{
    [self.motionManager stopAccelerometerUpdates];
    self.motionManager = nil;
}

@end
