//
//  COUIBaseView.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 9/30/13.
//  Copyright (c) 2013 Cenker Ozkurt. All rights reserved.
//

#import "COUIBehaviorController.h"
#import "COUIAnimationController.h"

#import "COUIBaseView.h"

/**
 A view that creates animation for given components in the view
 */
@interface COUIBaseView ()

/**
 The json file to read what's the configuration
 */
@property (nonatomic, strong) NSString *configFileName;

@property (nonatomic, strong) COUIBehaviorController *behaviorController;
@property (nonatomic, strong) COUIAnimationController *animationController;


@end

@implementation COUIBaseView

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 Subclass
 Initializes animation controller from file
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CODataSource *dataSource = [[CODataSource alloc] initWithJSONFile:self.configFileName];
    
    if (self.behaviorController == nil)
    {
        self.behaviorController = [[COUIBehaviorController alloc] initWithView:self withDataSource:dataSource];
    }
    
    if (self.animationController == nil)
    {
        self.animationController = [[COUIAnimationController alloc] initWithView:self withDataSource:dataSource];
    }
    
    [self playAll];
}

- (void)playAll
{
    [self.behaviorController playAllBehaviors];
    [self.animationController playAllAnimations];
}

@end
