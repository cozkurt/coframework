//
//  COUIBehaviorBaseView.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 3/13/14.
//  Copyright (c) 2014 Cenker Ozkurt, Inc. All rights reserved.
//

#import "COUIBehaviorController.h"

#import "COUIBehaviorBaseView.h"

/**
 A view that creates animation for given components in the view
 */
@interface COUIBehaviorBaseView ()

/**
 The json file to read what's the configuration
 */
@property (nonatomic, strong) NSString *configFileName;
@property (nonatomic, strong) COUIBehaviorController *behaviorController;

@end

@implementation COUIBehaviorBaseView

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 Subclass
 Initializes animation controller from file
 */
- (void)awakeFromNib
{
    if (self.behaviorController == nil)
    {
        self.behaviorController = [[COUIBehaviorController alloc] initWithView:self withDataSource:[[CODataSource alloc] initWithJSONFile:self.configFileName]];
    }
    
    [self playAnimations];
}

- (void)playAnimations
{
    [self.behaviorController playAllBehaviors];
}

@end
