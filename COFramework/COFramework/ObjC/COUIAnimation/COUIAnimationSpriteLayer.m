//
//  COUIAnimationSpriteLayer.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 12/20/13.
//  Copyright (c) 2013 Cenker Ozkurt. All rights reserved.
//

#import "COUIAnimationSpriteLayer.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface COUIAnimationSpriteLayer ()

@property (nonatomic, assign) int frameCount;

@property (nonatomic, strong) UIImageView *parentImageView;
@property (nonatomic, assign) CGSize parentImageSize;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - COUIAnimationSpriteLayer
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation COUIAnimationSpriteLayer

@synthesize frameCount;
@synthesize frameIndex;
@synthesize parentImageSize;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Initialization
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithImage:(CGImageRef)img size:(CGSize)size parentView:(UIView *)parentView frameCount:(int)frameCount_
{
    self = [super init];
    if (self != nil)
    {
        if ([parentView isKindOfClass:[UIImageView class]])
        {
            self.parentImageSize = size;
            self.parentImageView = (UIImageView *)parentView;
            self.parentImageView.image = nil;
        }
        
        self.frameIndex = 1;
        self.frameCount = frameCount_ - 1;
        
        self.contents = (__bridge id)img;
        
        CGSize sheetSizeNormalized = CGSizeMake(size.width/CGImageGetWidth(img), size.height/CGImageGetHeight(img));
        
        self.bounds = CGRectMake( 0, 0, parentView.bounds.size.width, parentView.bounds.size.height );
        self.position = CGPointMake(parentView.bounds.size.width / 2, parentView.bounds.size.height / 2);
        
        self.contentsRect = CGRectMake( 0, 0, sheetSizeNormalized.width, sheetSizeNormalized.height );
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Frame by frame animation
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//
// frameIndex is the animationKey
//

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    return [key isEqualToString:@"frameIndex"];
}

//
// contentsRect or bounds changes are not animated
//

+ (id < CAAction >)defaultActionForKey:(NSString *)aKey
{
    if ([aKey isEqualToString:@"contentsRect"] || [aKey isEqualToString:@"bounds"])
        return (id < CAAction >)[NSNull null];
    
    return [super defaultActionForKey:aKey];
}

- (unsigned int)currentFrameIndex
{
    return ((COUIAnimationSpriteLayer *)[self presentationLayer]).frameIndex;
}

//
// display method will be called by CoreAnimation
//

- (void)display
{
    unsigned int currentFrameIndex = [self currentFrameIndex];
    if (!currentFrameIndex) return;
    
    CGSize size = self.contentsRect.size;
    
    self.contentsRect = CGRectMake(
                                   ((currentFrameIndex - 1) % (int)( 1 /size.width)) * size.width,
                                   ((currentFrameIndex - 1) / (int)( 1 /size.width)) * size.height,
                                   size.width, size.height
                                   );
    
    if (currentFrameIndex == self.frameCount)
    {
        CGRect rect = CGRectMake(0, 0, self.parentImageSize.width, self.parentImageSize.height);
        
        CGImageRef imageRef = CGImageCreateWithImageInRect((__bridge CGImageRef)self.contents, rect);
        self.parentImageView.image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        [self removeAllAnimations];
        [self removeFromSuperlayer];
    }
}

@end
