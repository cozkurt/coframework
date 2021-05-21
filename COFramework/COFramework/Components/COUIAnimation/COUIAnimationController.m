//
//  COUIAnimationController.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 7/25/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#import "COMacros.h"
#import "COLogging.h"

#import "COJSONLoader.h"
#import "COUIAnimationFactory.h"
#import "COUIAnimationController.h"

#import "COUIAnimationCAModel.h"
#import "COUIAnimationBaseModel.h"
#import "COUIAnimationParticleModel.h"
#import "COUIAnimationSpriteLayer.h"

#import "NSObject+Blocks.h"
#import "NSString+Utilities.h"

#import "COUIAnimationController.h"

#define REVERSE_SPEED_FACTOR    3  // this will multiply reverse animation speed

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface COUIAnimationController ()

@property (atomic, weak) UIView *view;
@property (atomic, strong) id <CODataSourceDelegate> dataSource;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - COUIAnimationController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation COUIAnimationController

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - init methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 Initialized COUIAnimationController with provided jsonFileName
 
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
        
        [self registerClickActions];
        [self registerEventHandler];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - dealloc methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)dealloc
{
    self.view = nil;
    self.dataSource = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - click event registration
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/**
 Register clickEvent action for given tag
 */

- (void)registerClickActions
{
    for (NSDictionary *dict in [self.dataSource dataList])
    {
        COUIAnimationBaseModel *model = [[COUIAnimationBaseModel alloc] initWithDictionary:dict];
        
        // do not proceed if didClickEvent defined
        if (IS_VALID_STRING(model.didClickEvent))
        {
            UIView *tagView = (UIView *)[self.view viewWithTag:[model.tag integerValue]];
            
            if ([tagView respondsToSelector:@selector(addTarget:action:forControlEvents:)]) {
                UIButton *button = (UIButton *)tagView;
                
                [button addTarget:self action:@selector(didClickEvent:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickEvent:)];
                tapRecognizer.numberOfTapsRequired = 1;
                
                [tagView addGestureRecognizer:tapRecognizer];
            }
        }
    }
}

/**
 Fires an event for clicked buttons didClickEvent from model
 
 @param sender id will be casted UIView
 @return void
 */

- (void)didClickEvent:(id)sender
{
    UIView *tagView = (UIView *)sender;
    NSString *didClickEvent = [self baseModelForTag:(int) tagView.tag].didClickEvent;
    
    [self postNotificationForEvent:didClickEvent tag:(int)tagView.tag];
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
        LogInfo(@"startAfterEvent registered : %@", startAfterEvent);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEvents:) name:startAfterEvent object:nil];
    }
}

- (void)handleEvents:(NSNotification *)notification
{
    [self playAnimationForEvent:[notification name]];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - perform methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 Perform animations according
 to animationType
 */

- (void)playAllAnimations
{
    [self playAllAnimations:NO];
}

- (void)reverseAllAnimations
{
    [self playAllAnimations:YES];
}

/**
 Plays animation with speed param
 
 @param reversed This is a flag to play animation forward or backward
 */

- (void)playAllAnimations:(BOOL)reversed
{
    for (NSDictionary *dict in [self.dataSource dataList])
    {
        COUIAnimationBaseModel *baseModel = [[COUIAnimationBaseModel alloc] initWithDictionary:dict];
        
        // do not proceed if startAfterEvent defined
        if (!IS_VALID_STRING(baseModel.startAfterEvent))
        {
            COUIAnimationCAModel *caModel = [[COUIAnimationCAModel alloc] initWithDictionary:dict];
            COUIAnimationParticleModel *particleModel = [[COUIAnimationParticleModel alloc] initWithDictionary:dict];
            
            float speed = [caModel.caSpeed floatValue];
            
            if (speed > 0)
            {
                caModel.caSpeed = (reversed) ? @(-speed * REVERSE_SPEED_FACTOR) : @(speed);
            }
            
            [self playAnimationForBaseModel:baseModel caModel:caModel particleModel:particleModel];
        }
    }
}

/**
 Plays Animations on Layer
 
 @param model COUIAnimationModel
 @return void
 @warning *Warning:* Model needs to be filled with data.
 */

- (void)playAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel particleModel:(COUIAnimationParticleModel *)particleModel
{
    NSArray *tags = [baseModel.tag componentsSeparatedByString:@","];
    
    for (NSString *currentTag in tags) {
        
        UIView *view = [self.view viewWithTag:[currentTag integerValue]];
        CALayer *layer = view.layer;
        
        // override tag from tags
        baseModel.tag = currentTag;
        
        // if it's gradient than we need special attention for animation under gradient layer
        
        if ([caModel.animationType isEqualToString:@"gradientColorAnimation"])
        {
            CABasicAnimation *animation = [self caAnimationForBaseModel:baseModel caModel:caModel];
            CALayer *gradientLayer = [COUIAnimationFactory gradientLayerWithView:view baseModel:baseModel caModel:caModel colors:animation.fromValue];
            
            [gradientLayer addAnimation:[self caAnimationForBaseModel:baseModel caModel:caModel] forKey:caModel.keyName];
            [layer addSublayer:gradientLayer];
        }
        else if ([caModel.animationType isEqualToString:@"spriteSheetAnimation"])
        {
            CALayer *spriteSheet = [COUIAnimationFactory spriteSheetLayerWithView:view baseModel:baseModel caModel:caModel];
            
            [spriteSheet addAnimation:[self caAnimationForBaseModel:baseModel caModel:caModel] forKey:caModel.keyName];
            [layer addSublayer:spriteSheet];
        }
        else
        {
            [layer addAnimation:[self caAnimationForBaseModel:baseModel caModel:caModel] forKey:caModel.keyName];
        }
        
        if ((caModel.keyName != nil)) LogInfo(@"keyName = %@ tag = %@", caModel.keyName, baseModel.tag);
    }
}

/**
 Gets CA animation according to animationType
 
 @param model COUIAnimationModel
 @return id values CABasicAnimation, CAAnimationGroup, CAAnimationGroup
 @warning *Warning:* Model needs to be filled with data.
 */

- (id)caAnimationForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel
{
    NSString *animationType = caModel.animationType;
    
    // Predefined Animation Types
    
    if ([animationType isEqualToString:@"pulseAnimation"])
    {
        return [COUIAnimationFactory pulseAnimationForBaseModel:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"moveAnimation"])
    {
        UIView *fromView = [self.view viewWithTag:[baseModel.tag integerValue]];
        UIView *toView = [self.view viewWithTag:[baseModel.toTag integerValue]];
        
        return [COUIAnimationFactory moveAnimationForBaseModel:baseModel fromView:fromView toView:toView caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"minimizeAnimation"])
    {
        return [COUIAnimationFactory minimizeAnimationForBaseModel:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"maximizeAnimation"])
    {
        return [COUIAnimationFactory maximizeAnimationForBaseModel:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"positionXAnimation"])
    {
        return [COUIAnimationFactory positionXAnimationForBaseModel:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"positionYAnimation"])
    {
        return [COUIAnimationFactory positionYAnimationForBaseModel:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"deltaXAnimation"])
    {
        return [COUIAnimationFactory deltaXAnimationWithParentView:self.view baseModel:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"deltaYAnimation"])
    {
        return [COUIAnimationFactory deltaYAnimationWithParentView:self.view baseModel:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"keyframeXAnimation"])
    {
        return [COUIAnimationFactory keyframeXAnimationForBaseModel:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"keyframeYAnimation"])
    {
        return [COUIAnimationFactory keyframeYAnimationForBaseModel:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"shakeAnimation"])
    {
        return [COUIAnimationFactory shakeAnimationForBaseModel:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"opacityAnimation"])
    {
        return [COUIAnimationFactory opacityAnimationWithParentView:self.view baseModel:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"spriteSheetAnimation"])
    {
        return [COUIAnimationFactory spriteSheetAnimation:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"rotateAnimation"])
    {
        return [COUIAnimationFactory rotateAnimation:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"framesAnimation"])
    {
        return [COUIAnimationFactory framesAnimationForBaseModel:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"imagesAnimation"])
    {
        return [COUIAnimationFactory imagesAnimationForBaseModel:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"colorAnimation"])
    {
        return [COUIAnimationFactory colorAnimationForBaseModel:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"gradientColorAnimation"])
    {
        return [COUIAnimationFactory gradientColorAnimationForBaseModel:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"fadeAlphaAnimation"])
    {
        return [COUIAnimationFactory fadeAlphaAnimationForBaseModel:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"contentAnimation"])
    {
        return [COUIAnimationFactory contentAnimationForBaseModel:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"blurAnimation"])
    {
        return [COUIAnimationFactory blurAnimationForBaseModel:baseModel caModel:caModel delegate:self];
    }
    else if ([animationType isEqualToString:@"groupAnimation"])
    {
        // Animation Groups
        
        return [self playGroupAnimationsForBaseModel:baseModel caModel:caModel];
    }
    else
    {
        // Custom Core Animations
        
        return [COUIAnimationFactory caAnimationForBaseModel:baseModel caModel:caModel delegate:self];
    }
}

/**
 Plays animation model for group animations
 
 @param model COUIAnimationModel
 @return id values CABasicAnimation, CAAnimationGroup, CAAnimationGroup
 @warning *Warning:* Model needs to be filled with data.
 */

- (CAAnimationGroup *)playGroupAnimationsForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel
{
    // Animation groups
    
    NSMutableArray *caAnimationsForGroup = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in caModel.caAnimations)
    {
        COUIAnimationCAModel *model = [[COUIAnimationCAModel alloc] initWithDictionary:dict];
        
        [caAnimationsForGroup addObject:[self caAnimationForBaseModel:baseModel caModel:model]];
    }
    
    caModel.caAnimations = [NSArray arrayWithArray:caAnimationsForGroup];
    
    return [COUIAnimationFactory caAnimationGroupForBaseModel:baseModel caModel:caModel delegate:self];
}

/**
 This methods will check if any animations waiting for that event after completion of parent event
 
 @param event Event name for the animation
 @return void
 @warning *Warning:* event needs to match event peoperty in json description
 */

- (void)playAnimationForEvent:(NSString *)event
{
    for (NSDictionary *dict in [self.dataSource dataList])
    {
        COUIAnimationBaseModel *baseModel = [[COUIAnimationBaseModel alloc] initWithDictionary:dict];
        
        if ([[baseModel startAfterEvent] isEqualToString:event])
        {
            COUIAnimationCAModel *caModel = [[COUIAnimationCAModel alloc] initWithDictionary:dict];
            COUIAnimationParticleModel *particleModel = [[COUIAnimationParticleModel alloc] initWithDictionary:dict];
            
            LogInfo(@"Event Handled for : %@", event);
            
            [self playAnimationForBaseModel:baseModel caModel:caModel particleModel:particleModel];
        }
    }
}

/**
 This methods play animation for given tag
 
 @param tag Tag id for the layer
 @return void
 @warning *Warning:* tag needs to match tag property in json description
 */

- (void)playAnimationForTag:(NSString *)tag
{
    for (NSDictionary *dict in [self.dataSource dataList])
    {
        COUIAnimationBaseModel *baseModel = [[COUIAnimationBaseModel alloc] initWithDictionary:dict];
        
        if ([[baseModel tag] isEqualToString:tag])
        {
            COUIAnimationCAModel *caModel = [[COUIAnimationCAModel alloc] initWithDictionary:dict];
            COUIAnimationParticleModel *particleModel = [[COUIAnimationParticleModel alloc] initWithDictionary:dict];
            
            [self playAnimationForBaseModel:baseModel caModel:caModel particleModel:particleModel];
        }
    }
}

/**
 This methods play animation for given keyName
 
 @param tag Tag id for the layer
 @return void
 @warning *Warning:* tag needs to match tag property in json description
 */

- (void)playAnimationForKeyName:(NSString *)keyName
{
    for (NSDictionary *dict in [self.dataSource dataList])
    {
        COUIAnimationCAModel *caModel = [[COUIAnimationCAModel alloc] initWithDictionary:dict];
        
        if ([[caModel keyName] isEqualToString:keyName])
        {
            COUIAnimationBaseModel *baseModel = [[COUIAnimationBaseModel alloc] initWithDictionary:dict];
            COUIAnimationParticleModel *particleModel = [[COUIAnimationParticleModel alloc] initWithDictionary:dict];
            
            [self playAnimationForBaseModel:baseModel caModel:caModel particleModel:particleModel];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - caanimation delegate methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 CAAnimationDelegate handlers
 
 @param anim CAAnimation object to query when aniamtion stopped for event
 @return void
 */

- (void)animationDidStart:(CAAnimation *)anim
{
    COUIAnimationBaseModel *baseModel = [anim valueForKey:@"baseModel"];
    
    NSString *didStartEvent = baseModel.didStartEvent;
    
    // add Reverse at the end of the event string if animation is reverse
    if (anim.speed < 0) didStartEvent = [NSString stringWithFormat:@"%@_REVERSE", didStartEvent];
    
    if (IS_VALID_STRING(baseModel.didStartEvent))
    {
        [self postNotificationForEvent:didStartEvent];
    }
    
    [self playAnimationForEvent:didStartEvent];
}

/**
 CAAnimationDelegate handlers
 
 @param anim CAAnimation object to query when animation is started for event
 @param flag animation stopped flag
 @return void
 */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        COUIAnimationBaseModel *baseModel = [anim valueForKey:@"baseModel"];
        COUIAnimationCAModel *caModel = [anim valueForKey:@"caModel"];
        
        NSString *didStopEvent = baseModel.didStopEvent;
        
        // add Reverse at the end of the event string if animation is reverse
        if (anim.speed < 0) didStopEvent = [NSString stringWithFormat:@"%@_REVERSE", didStopEvent];
        
        if (IS_VALID_STRING(baseModel.didStopEvent))
        {
            [self postNotificationForEvent:didStopEvent];
        }
        
        [self finalPropertiesForBaseModel:baseModel caModel:caModel];
        [self playAnimationForEvent:didStopEvent];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - post notification
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 Send notification with given event name after animation completed
 
 @param event Event name to be dispatched
 @return void
 @warning *Warning:* event needs to match event peoperty in json description
 */

- (void)postNotificationForEvent:(NSString *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:event object:self];
    
    LogInfo(@"Notification posted for following event : %@", event);
}

/**
 Send notification with given event name after animation completed
 
 @param event Event name to be dispatched
 @tag for the view tag
 @return void
 @warning *Warning:* event needs to match event peoperty in json description
 */

- (void)postNotificationForEvent:(NSString *)event tag:(int)tag
{
    [[NSNotificationCenter defaultCenter] postNotificationName:event object:self userInfo:@{ @"tag" : @(tag) }];
    
    LogInfo(@"Notification posted for following event : %@", event);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - helper methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 Returns COUIAnimationModel for given tag id
 
 @param tag for uibutton
 @return COUIAnimationModel
 */

- (COUIAnimationBaseModel *)baseModelForTag:(int)tag
{
    for (NSDictionary *dict in [self.dataSource dataList])
    {
        COUIAnimationBaseModel *model = [[COUIAnimationBaseModel alloc] initWithDictionary:dict];
        
        if ([model.tag integerValue] == tag)
            return model;
    }
    
    return nil;
}

/**
 Sets initial frame for the view
 
 @param model COUIAnimationModel
 @return void
 */

- (void)finalPropertiesForBaseModel:(COUIAnimationBaseModel *)baseModel caModel:(COUIAnimationCAModel *)caModel
{
    UIView *subView =[self.view viewWithTag:[baseModel.tag integerValue]];
    UIView *toView =[self.view viewWithTag:[baseModel.toTag integerValue]];
    
    if (subView == nil) return;
    
    if ([caModel.animationType isEqualToString:@"position"])
    {
        if (toView == nil) return;
        
        [subView setCenter:toView.center];
    }
    
    if ([caModel.caToValue respondsToSelector:@selector(floatValue)])
    {
        float toValue = [[caModel caToValue] floatValue];
        
        if ([caModel.animationType isEqualToString:@"position.x"])
        {
            CGPoint center = CGPointMake(toValue, subView.center.y);
            [subView setCenter:center];
        }
        
        if ([caModel.animationType isEqualToString:@"position.y"])
        {
            CGPoint center = CGPointMake(subView.center.x, toValue);
            [subView setCenter:center];
        }
        
        if ([caModel.animationType isEqualToString:@"transform.scale"] || [caModel.animationType isEqualToString:@"minimizeAnimation"])
        {
            subView.transform = CGAffineTransformMakeScale(toValue, toValue);
        }
        
        if ([caModel.animationType isEqualToString:@"opacity"])
        {
            subView.alpha = toValue;
        }
    }
}

@end
