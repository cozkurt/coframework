//
//  COUIBehaviorModel.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 3/12/14.
//  Copyright (c) 2014 Cenker Ozkurt, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface COUIBehaviorModel : NSObject

// Model properties

/** will be used as key */
@property (nonatomic, strong) NSString *keyName;
@property (nonatomic, strong) NSString *behaviorType;

// Gravity Behavior Properties
@property (nonatomic, strong) NSNumber *angle;
@property (nonatomic, strong) NSNumber *magnitude;
@property (nonatomic, assign) CGPoint gravityDirection;

// Push Behavior Properties
@property (nonatomic, assign) CGPoint pushDirection;
@property (nonatomic, strong) NSString *mode;

// Snap Behavior Properties
@property (nonatomic, strong) NSNumber *damping;
@property (nonatomic, assign) CGPoint snapToPoint;

// Attachment Behavior Properties
@property (nonatomic, strong) NSNumber *attachedToItem;  // item = tag
@property (nonatomic, strong) NSNumber *frequency;
@property (nonatomic, strong) NSNumber *length;
@property (nonatomic, assign) CGPoint anchorPoint;

// Dynamic Item Behavior Properties
@property (nonatomic, strong) NSNumber *allowsRotation;
@property (nonatomic, strong) NSNumber *density;
@property (nonatomic, strong) NSNumber *elasticity;
@property (nonatomic, strong) NSNumber *friction;
@property (nonatomic, strong) NSNumber *resistance;
@property (nonatomic, strong) NSNumber *angularResistance;

// Accelerometer Behavior Properties
@property (nonatomic, strong) NSNumber *xFactor;
@property (nonatomic, strong) NSNumber *yFactor;
@property (nonatomic, strong) NSNumber *zFactor;
@property (nonatomic, strong) NSNumber *push;
@property (nonatomic, strong) NSNumber *gravity;

// Gesture Behavior Properties
@property (nonatomic, strong) NSString *swipeDirection; // values : LEFT, RIGHT, UP, DOWN

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
