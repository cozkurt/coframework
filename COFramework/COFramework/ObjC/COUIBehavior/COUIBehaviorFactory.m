//
//  COUIBehaviorFactory.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 1/12/14.
//  Copyright (c) 2014 Cenker Ozkurt. All rights reserved.
//

#import "COSingleton.h"
#import "COUIBehaviorImage.h"
#import "COUIBehaviorFactory.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface COUIBehaviorFactory ()

@property (nonatomic, strong) NSMutableDictionary *dynamicAnimator;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - COUIBehaviorFactory
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation COUIBehaviorFactory

CO_SYNTHESIZE_SINGLETON(COUIBehaviorFactory, sharedInstance, ^(COUIBehaviorFactory *sharedInstance) { return [sharedInstance init]; } );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Init Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init
{
    self = [super init];
    if (self)
    {
        self.dynamicAnimator = [[NSMutableDictionary alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEvents:) name:@"COUI_BEHAVIOR_IMAGE_EVENT" object:nil];
    }
    
    return self;
}

- (void)handleEvents:(NSNotification *)notification
{
    COUIBehaviorImage *item = [notification object];
    
    NSString *key = [NSString stringWithFormat:@"%ld", (long)item.parentView.tag];
    
    [[self.dynamicAnimator objectForKey:key] updateItemUsingCurrentState:item];
}

- (void)createDynamicAnimation:(UIView *)referenceView forKey:(NSString *)key
{
    if ([self.dynamicAnimator objectForKey:key] == nil)
    {
        [self.dynamicAnimator setObject:[[UIDynamicAnimator alloc] initWithReferenceView:referenceView] forKey:key];
    }
}

- (void)removeAllBehaviorsForParentView:(UIView *)parentView
{
    NSString *key = [NSString stringWithFormat:@"%ld", (long)parentView.tag];
    
    [[self.dynamicAnimator objectForKey:key] removeAllBehaviors];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - DynamicItem Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)dynamicItemBehaviorWithParentView:(UIView *)parentView views:(NSArray *)views behaviorModel:(COUIBehaviorModel *)behaviorModel
{
    NSString *key = [NSString stringWithFormat:@"%ld", (long)parentView.tag];
    [self createDynamicAnimation:parentView forKey:key];
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:views];
    
    itemBehavior.allowsRotation = [behaviorModel.allowsRotation boolValue];
    itemBehavior.density = [behaviorModel.density floatValue];
    itemBehavior.elasticity = [behaviorModel.elasticity floatValue];
    itemBehavior.friction = [behaviorModel.friction floatValue];
    itemBehavior.resistance = [behaviorModel.resistance floatValue];
    itemBehavior.angularResistance = [behaviorModel.angularResistance floatValue];
    
    [[self.dynamicAnimator objectForKey:key] addBehavior:itemBehavior];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Attachement Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)attachmentBehaviorWithParentView:(UIView *)parentView views:(NSArray *)views behaviorModel:(COUIBehaviorModel *)behaviorModel
{
    NSString *key = [NSString stringWithFormat:@"%ld", (long)parentView.tag];
    [self createDynamicAnimation:parentView forKey:key];
    
    UIView *attachedView = [parentView viewWithTag:[behaviorModel.attachedToItem floatValue]];
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:[views objectAtIndex:0] attachedToItem:attachedView];
    
    attachmentBehavior.frequency = [behaviorModel.frequency floatValue];
    attachmentBehavior.damping = [behaviorModel.frequency floatValue];
    attachmentBehavior.length = [behaviorModel.length floatValue];
    attachmentBehavior.anchorPoint = behaviorModel.anchorPoint;
    
    [[self.dynamicAnimator objectForKey:key] addBehavior:attachmentBehavior];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Gravity Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)gravityBehaviorWithParentView:(UIView *)parentView views:(NSArray *)views behaviorModel:(COUIBehaviorModel *)behaviorModel
{
    NSString *key = [NSString stringWithFormat:@"%ld", (long)parentView.tag];
    [self createDynamicAnimation:parentView forKey:key];
    
    // find if gravity for item already created, then edit it, otherwise create it.
    UIGravityBehavior *gravityBehavior = [self findBehaviourForView:[views objectAtIndex:0] forKey:behaviorModel.keyName];
    
    if (gravityBehavior == nil) gravityBehavior = [[UIGravityBehavior alloc] initWithItems:views];
    
    gravityBehavior.angle = [behaviorModel.angle floatValue];
    gravityBehavior.magnitude = [behaviorModel.magnitude floatValue];
    gravityBehavior.gravityDirection = CGVectorMake(behaviorModel.gravityDirection.x, behaviorModel.gravityDirection.y);
    
    [[self.dynamicAnimator objectForKey:key] addBehavior:gravityBehavior];
}

- (UIGravityBehavior *)findBehaviourForView:(UIView *)view forKey:(NSString *)key
{
    UIDynamicAnimator *animator = [self.dynamicAnimator objectForKey:key];
    NSArray *behaviors = animator.behaviors;
    
    for (UIDynamicBehavior *behaviour in behaviors)
    {
        if ([behaviour isKindOfClass:[UIGravityBehavior class]])
        {
            UIGravityBehavior *b = (UIGravityBehavior *)behaviour;
            
            for (UIView *v in b.items)
            {
                if ([v isEqual:view])
                    return b;
            }
        }
    }
    
    return nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Push Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)pushBehaviorWithParentView:(UIView *)parentView views:(NSArray *)views behaviorModel:(COUIBehaviorModel *)behaviorModel
{
    NSString *key = [NSString stringWithFormat:@"%ld", (long)parentView.tag];
    [self createDynamicAnimation:parentView forKey:key];
    
    UIPushBehaviorMode mode = UIPushBehaviorModeInstantaneous;
    
    if ([behaviorModel.mode isEqualToString:@"UIPushBehaviorModeContinuous"])
        mode = UIPushBehaviorModeContinuous;
    
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:views mode:mode];
    
    pushBehavior.angle = [behaviorModel.angle floatValue];
    pushBehavior.magnitude = [behaviorModel.magnitude floatValue];
    pushBehavior.pushDirection = CGVectorMake(behaviorModel.pushDirection.x, behaviorModel.pushDirection.y);
    
    [[self.dynamicAnimator objectForKey:key] addBehavior:pushBehavior];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Snap Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)snapBehaviorWithParentView:(UIView *)parentView views:(NSArray *)views behaviorModel:(COUIBehaviorModel *)behaviorModel
{
    NSString *key = [NSString stringWithFormat:@"%ld", (long)parentView.tag];
    [self createDynamicAnimation:parentView forKey:key];
    
    UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:[views objectAtIndex:0] snapToPoint:behaviorModel.snapToPoint];
    snapBehavior.damping = [behaviorModel.damping floatValue];
    
    [[self.dynamicAnimator objectForKey:key] addBehavior:snapBehavior];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Collision Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)collisionBehaviorWithParentView:(UIView *)parentView views:(NSArray *)views behaviorModel:(COUIBehaviorModel *)behaviorModel delegate:(id <UICollisionBehaviorDelegate>)delegate
{
    NSString *key = [NSString stringWithFormat:@"%ld", (long)parentView.tag];
    [self createDynamicAnimation:parentView forKey:key];
    
    UICollisionBehavior *collider = [[UICollisionBehavior alloc] initWithItems:views];
    collider.collisionDelegate = delegate;
    collider.collisionMode = UICollisionBehaviorModeEverything;
    collider.translatesReferenceBoundsIntoBoundary = YES;
    
    [[self.dynamicAnimator objectForKey:key] addBehavior:collider];
}

@end
