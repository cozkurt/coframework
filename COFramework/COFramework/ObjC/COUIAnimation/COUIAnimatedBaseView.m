//
//  COUIAnimatedBaseView.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 7/24/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#import "NSObject+Blocks.h"

#import "COUIAnimationController.h"

#import "COUIAnimatedBaseView.h"

/**
 A view that creates animation for given components in the view
 */
@interface COUIAnimatedBaseView ()

/**
 The json file to read what's the configuration
 */
@property (nonatomic, strong) NSString *configFileName;
@property (nonatomic, strong) COUIAnimationController *animationController;

@end

@implementation COUIAnimatedBaseView

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - inits
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

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
    
    if (self.animationController == nil)
    {
        self.animationController = [[COUIAnimationController alloc] initWithView:self withDataSource:[[CODataSource alloc] initWithJSONFile:self.configFileName]];
    }
    
    [self playAnimations];
}

- (void)playAnimations
{
    [self.animationController playAllAnimations];
}

- (void)playAnimationForEvent:(NSString *)event afterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(playAnimationForEvent:) withObject:event afterDelay:delay];
}

- (void)playAnimationForEvent:(NSString *)event
{
    [self.animationController playAnimationForEvent:event];
}

- (void)reverseAnimations
{
    [self.animationController reverseAllAnimations];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - IBActions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)reverseAnimations:(id)sender
{
    [self reverseAnimations];
}

@end
