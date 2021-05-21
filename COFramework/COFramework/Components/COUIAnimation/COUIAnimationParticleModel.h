//
//  COUIAnimationParticleModel.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 11/9/13.
//  Copyright (c) 2013 Cenker Ozkurt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface COUIAnimationParticleModel : NSObject

// Model properties

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *birthRate;
@property (nonatomic, strong) NSNumber *lifetime;
@property (nonatomic, strong) NSNumber *lifetimeRange;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) id contents;
@property (nonatomic, strong) NSNumber *velocityRange;
@property (nonatomic, strong) NSNumber *emissionRange;
@property (nonatomic, strong) NSNumber *scale;
@property (nonatomic, strong) NSNumber *scaleRange;
@property (nonatomic, strong) NSNumber *alphaRange;
@property (nonatomic, strong) NSNumber *alphaSpeed;

/** Initializes model from dictionary
 
 @param dict dictionary to convert model
 @return self
 */
- (id)initWithDictionary:(NSDictionary *)dict;

/** Converts model to dictionary
 @return NSDictionary
 */
- (NSDictionary *)toDictionary;

@end
