//
//  COUIParticleView.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 11/06/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#import "COUIParticleView.h"

#import <QuartzCore/QuartzCore.h>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - interface
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface COUIParticleView()
    
@property (nonatomic, strong) CAEmitterLayer *emitterLayer;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - implementation
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation COUIParticleView

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - awakeFromNib methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGPoint position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    CAEmitterCell *emitterCell = [self emitterWithImage:@"star.png"];
    
    [self setUpEmitterWithPosition:position emitterCell:emitterCell];
    [self startEmittingWithDuration:5.0];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setUpEmitterWithPosition:(CGPoint)position emitterCell:(CAEmitterCell *)emitter
{
    self.emitterLayer = (CAEmitterLayer *)self.layer;
    
    //self.emitterLayer.renderMode = kCAEmitterLayerPoints;
    //self.emitterLayer.emitterShape = kCAEmitterLayerRectangle;
    //self.emitterLayer.emitterMode = kCAEmitterLayerUnordered;
    
    self.emitterLayer.emitterCells = [NSArray arrayWithObject:emitter];
    self.emitterLayer.renderMode = kCAEmitterLayerOutline; // kCAEmitterLayerAdditive
    
    self.emitterLayer.emitterPosition = position;
    //self.emitterLayer.emitterSize = CGSizeMake(8, 8);
}

- (CAEmitterCell *)emitterWithImage:(NSString *)imageName
{
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    
    emitterCell.birthRate = 0;
    emitterCell.lifetime = 1.5;
    emitterCell.lifetimeRange = 1.0;
    emitterCell.color = [[UIColor colorWithRed:200 green:200 blue:255 alpha:0.5] CGColor];
    emitterCell.contents = (id)[[UIImage imageNamed:imageName] CGImage];
    emitterCell.velocityRange = 500;
    emitterCell.emissionRange = 360;
    emitterCell.scale = 0.5;
    emitterCell.scaleRange = 0.5;
    emitterCell.alphaRange = 0.3;
    emitterCell.alphaSpeed  = 0.5;
    emitterCell.name = @"emitterCell_1";
    
    return emitterCell;
}

- (void)stopEmitting
{
    [self.emitterLayer setValue:[NSNumber numberWithInt:0] forKeyPath:@"emitterCells.emitterCell_1.birthRate"];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)startEmittingWithDuration:(NSTimeInterval)duration
{
    [self.emitterLayer setValue:[NSNumber numberWithInt:50] forKeyPath:@"emitterCells.emitterCell_1.birthRate"];
    
    [self performSelector:@selector(stopEmitting) withObject:nil afterDelay:duration];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - class methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (Class)layerClass
{
    return [CAEmitterLayer class];
}

@end

