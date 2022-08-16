//
//  COUIBehaviorController.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 3/13/14.
//  Copyright (c) 2014 Cenker Ozkurt, Inc. All rights reserved.
//

#import "COMacros.h"

#import "COUIBehaviorGestures.h"
#import "COUIBehaviorMotion.h"

#import "COUIAnimationBaseModel.h"

#import "COUIBehaviorModel.h"
#import "COUIBehaviorFactory.h"

#import "COUIBehaviorController.h"

#import "NSObject+Blocks.h"
#import "NSString+Utilities.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface COUIBehaviorController ()

@property (atomic, strong) UIView *view;
@property (atomic, strong) id <CODataSourceDelegate> dataSource;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - COUIBehaviorController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation COUIBehaviorController

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - init methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 Initialized COUIBehaviorController with provided jsonFileName
 
 @param view to be applied
 @param dataSource CODataSource to load json
 @return self
 */

- (id)initWithView:(UIView *)view withDataSource:(CODataSource *)dataSource
{
    self = [self init];
    if (self)
    {
        self.view = view;
        self.dataSource = dataSource;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [self registerEventHandler];
    }
    return self;
}

- (void)dealloc
{
    [[COUIBehaviorMotion sharedInstance] stopAccelerometer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - register Event Handlers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 This method listens all events
 and perform animation for event
 
 @return void
 */

- (void)registerEventHandler
{
    // make sure we have one set of startAfterEvent to prevent multiple registration
    
    NSMutableSet *uniqueStartAfterEvents = [[NSMutableSet alloc] init];
    
    for (NSDictionary *dict in [self.dataSource dataList])
    {
        COUIAnimationBaseModel *baseModel = [[COUIAnimationBaseModel alloc] initWithDictionary:dict];
        
        // do not proceed if didClickEvent defined
        if (IS_VALID_STRING(baseModel.startAfterEvent))
        {
            [uniqueStartAfterEvents addObject:baseModel.startAfterEvent];
        }
    }
    
    for (NSString *startAfterEvent in uniqueStartAfterEvents)
    {
        NSLog(@"Behavior startAfterEvent registered : %@", startAfterEvent);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEvents:) name:startAfterEvent object:nil];
    }
}

- (void)handleEvents:(NSNotification *)notification
{
    [self playBehaviorForEvent:[notification name]];
}

/**
 Plays behaviors
 */

- (void)playAllBehaviors
{
    for (NSDictionary *dict in [self.dataSource dataList])
    {
        COUIAnimationBaseModel *baseModel = [[COUIAnimationBaseModel alloc] initWithDictionary:dict];
        
        // do not proceed if startAfterEvent defined
        if (!IS_VALID_STRING(baseModel.startAfterEvent))
        {
            COUIBehaviorModel *behaviorModel = [[COUIBehaviorModel alloc] initWithDictionary:dict];
            
            [self playBehaviorForBaseModel:baseModel behaviorModel:behaviorModel];
        }
    }
}

/**
 This methods will check if any animations waiting for that event after completion of parent event
 
 @param event Event name for the animation
 @return void
 @warning *Warning:* event needs to match event peoperty in json description
 */

- (void)playBehaviorForEvent:(NSString *)event
{
    for (NSDictionary *dict in [self.dataSource dataList])
    {
        COUIAnimationBaseModel *baseModel = [[COUIAnimationBaseModel alloc] initWithDictionary:dict];
        
        if ([[baseModel startAfterEvent] isEqualToString:event])
        {
            COUIBehaviorModel *behaviorModel = [[COUIBehaviorModel alloc] initWithDictionary:dict];
            
            NSLog(@"Behavior Event Handled for : %@", event);
            
            [self playBehaviorForBaseModel:baseModel behaviorModel:behaviorModel];
        }
    }
}

/**
 Plays Behaviours on Layer
 
 @param model COUIAnimationModel
 @return void
 @warning *Warning:* Model needs to be filled with data.
 */

- (void)playBehaviorForBaseModel:(COUIAnimationBaseModel *)baseModel behaviorModel:(COUIBehaviorModel *)behaviorModel
{
    NSArray *views = [self tagsFromString:baseModel.tag];
    
    if ([behaviorModel.behaviorType isEqualToString:@"removeAllBehaviors"])
    {
        [[COUIBehaviorFactory sharedInstance] removeAllBehaviorsForParentView:self.view];
    }
    else if ([behaviorModel.behaviorType isEqualToString:@"gravityBehavior"])
    {
        [[COUIBehaviorFactory sharedInstance] gravityBehaviorWithParentView:self.view views:views behaviorModel:behaviorModel];
    }
    else if ([behaviorModel.behaviorType isEqualToString:@"pushBehavior"])
    {
        [[COUIBehaviorFactory sharedInstance] pushBehaviorWithParentView:self.view views:views behaviorModel:behaviorModel];
    }
    else if ([behaviorModel.behaviorType isEqualToString:@"snapBehavior"])
    {
        [[COUIBehaviorFactory sharedInstance] snapBehaviorWithParentView:self.view views:views behaviorModel:behaviorModel];
    }
    else if ([behaviorModel.behaviorType isEqualToString:@"collisionBehavior"])
    {
        [[COUIBehaviorFactory sharedInstance] collisionBehaviorWithParentView:self.view views:views behaviorModel:behaviorModel delegate:self];
    }
    else if ([behaviorModel.behaviorType isEqualToString:@"attachmentBehavior"])
    {
        [[COUIBehaviorFactory sharedInstance] attachmentBehaviorWithParentView:self.view views:views behaviorModel:behaviorModel];
    }
    else if ([behaviorModel.behaviorType isEqualToString:@"dynamicItemBehavior"])
    {
        [[COUIBehaviorFactory sharedInstance] dynamicItemBehaviorWithParentView:self.view views:views behaviorModel:behaviorModel];
    }
    else if ([behaviorModel.behaviorType isEqualToString:@"accelerometerBehavior"])
    {
        [[COUIBehaviorMotion sharedInstance] activateAccelerometerWithBehaviorModel:behaviorModel dataSource:self.dataSource view:self.view];
    }
    else if ([behaviorModel.behaviorType isEqualToString:@"swipeGestureBehavior"])
    {
        [[COUIBehaviorGestures sharedInstance] swipeGestureWithBaseModel:baseModel behaviorModel:behaviorModel view:self.view views:views];
    }
    else if ([behaviorModel.behaviorType isEqualToString:@"panGestureBehavior"])
    {
        [[COUIBehaviorGestures sharedInstance] panGestureWithBaseModel:baseModel behaviorModel:behaviorModel view:self.view views:views];
    }
    
    NSLog(@"Behavior for Tag tag = %@", baseModel.tag);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIColisionBehavior Delegate Handler
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    NSLog(@"*** Collision detected ***");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Helper Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *)tagsFromString:(NSString *)tag
{
    NSMutableArray *views = [[NSMutableArray alloc] init];
    
    for (NSString *i in [tag componentsSeparatedByString:@","])
    {
        UIView *view = [self.view viewWithTag:[i integerValue]];
        
        if (view!=nil)
            [views addObject:view];
    }
    
    return views;
}

@end
