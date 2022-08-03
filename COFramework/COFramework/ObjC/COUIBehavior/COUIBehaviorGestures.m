//
//  COUIBehaviorGestures.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 5/2/14.
//  Copyright (c) 2014 Cenker Ozkurt, Inc. All rights reserved.
//

#import "COSingleton.h"
#import "COUIBehaviorFactory.h"

#import "COUIBehaviorGestures.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface COUIBehaviorGestures ()

@property (nonatomic, strong) COUIAnimationBaseModel *baseModel;
@property (nonatomic, strong) COUIBehaviorModel *behaviorModel;

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSArray *views;

@end

@implementation COUIBehaviorGestures

CO_SYNTHESIZE_SINGLETON(COUIBehaviorGestures, sharedInstance, ^(COUIBehaviorGestures *sharedInstance) { return [sharedInstance init]; } );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Pan Gesture Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)panGestureWithBaseModel:(COUIAnimationBaseModel *)baseModel behaviorModel:(COUIBehaviorModel *)behaviorModel view:(UIView *)view views:(NSArray *)views
{
    self.view = view;
    self.views = views;
    self.baseModel = baseModel;
    self.behaviorModel = behaviorModel;
    
    for (UIView *view in self.views)
    {
        view.layer.speed = 0.0;
    }
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)panGestureHandler:(UIPanGestureRecognizer *)recognizer
{
    // get velocity to find direction
    CGPoint velocity = [recognizer velocityInView:self.view];
    BOOL incrementing = (velocity.x > 0);
    
    // get horizontal component of pan gesture
    CGFloat x = [recognizer translationInView:self.view].x;
    
    // convert from points to animation duration
    // using a resonable scale factor
    x /= 200.0f;
    
    for (UIView *view in self.views)
    {
        // *** Important Note *** : Requires caDuration = 1.0 to match swipe duration
        // update timeOffset and clamp result
        
        CFTimeInterval timeOffset = view.layer.timeOffset;
        timeOffset = MIN(0.999, MAX(0.0, timeOffset - x));
        
        view.layer.timeOffset = timeOffset;
        
        // LogDebug(@"timeOffset = %f, incrementing = %d", timeOffset, incrementing);
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self resumeLayer:incrementing];
    }
    
    // reset pan gesture
    [recognizer setTranslation:CGPointZero inView:self.view];
}

- (void)resumeLayer:(BOOL)incrementing
{
    // grab current timeOffest to continue animation to the end
    CFTimeInterval timeOffsetStart = ((UIView *)[self.views firstObject]).layer.timeOffset;
    
    if (incrementing)
    {
        for (CFTimeInterval t = timeOffsetStart; t >= 0; t = t - 0.02)
        {
            for (UIView *view in self.views)
            {
                view.layer.timeOffset = t;
            }
            
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.005]];
        }
    }
    else
    {
        for (CFTimeInterval t = timeOffsetStart; t <= 1; t = t + 0.02)
        {
            for (UIView *view in self.views)
            {
                view.layer.timeOffset = t;
            }
            
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.005]];
        }
    }
    
    for (UIView *view in self.views)
    {
        view.layer.timeOffset = (incrementing ? 0 : 1);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Swipe Gesture Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)swipeGestureWithBaseModel:(COUIAnimationBaseModel *)baseModel behaviorModel:(COUIBehaviorModel *)behaviorModel view:(UIView *)view views:(NSArray *)views
{
    self.view = view;
    self.views = views;
    self.baseModel = baseModel;
    self.behaviorModel = behaviorModel;
    
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureHandler:)];
    NSString *swipeDirection = [behaviorModel.swipeDirection uppercaseString];
    
    if ([swipeDirection isEqualToString:@"DOWN"])
        gestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    else if ([swipeDirection isEqualToString:@"UP"])
        gestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    else if ([swipeDirection isEqualToString:@"LEFT"])
        gestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    else if ([swipeDirection isEqualToString:@"RIGHT"])
        gestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)swipeGestureHandler:(UISwipeGestureRecognizer *)recognizer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:self.baseModel.didSwipeEvent object:self userInfo:nil];
}

@end