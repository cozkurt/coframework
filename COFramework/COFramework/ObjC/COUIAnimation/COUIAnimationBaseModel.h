//
//  COUIAnimationBaseModel.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 7/25/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 COUIAnimationModel to map json
 
 Sample Single Animation JSON configuration
 
    [
        {
            "animationType": "opacityAnimation",
            "keyName: "opacityAnimationForButton1",
            "startEvent": "OpacityAnimationEvent",
            "tag": "10",
            "startAfterDelay": "",
            "startAfterEvent": "ScaleEvent",
            "caDuration": "1",
            "caFromValue": "1.0",
            "caToValue": "0.0"
        }
    ]
 
 Sample Animation Groups JSON configuration
 
    [
        {
            "animationType": "groupAnimation",
            "keyName: "groupAnimationForButton2",
            "startEvent": "",
            "tag": "30",
            "startAfterDelay": "",
            "startAfterEvent": "",
            "caDuration": "3",
            "caRepeatCount": "1",
            "caSpeed": "1",
            "caAnimations": [
                    {
                        "animationType": "imagesAnimation",
                        "caValues": "coachCheer.png,coachHandOnHips.png,coachArmUp.png,coachAtComputer.png",
                        "caCalculationMode": "discrete"
                    },
                    {
                        "animationType": "keyframeXAnimation",
                        "caValues": "100,150,200,250",
                        "caCalculationMode": "discrete"
                    }
            ]
        }
    ]
 
*/

@interface COUIAnimationBaseModel : NSObject

// Model properties

/** will create notification when animation did start with event name */
@property (nonatomic, strong) NSString *didStartEvent;

/** will create notification when animation did stop with event name */
@property (nonatomic, strong) NSString *didStopEvent;

/** Posts and event when clicked */
@property (nonatomic, strong) NSString *didClickEvent;

/** Posts and event when swiped */
@property (nonatomic, strong) NSString *didSwipeEvent;

/** Tag will be extracted from the view */
@property (nonatomic, strong) NSString *tag;

/** ToTag will be extracted from the view */
@property (nonatomic, strong) NSString *toTag;

/** Start after delay in secs */
@property (nonatomic, strong) NSNumber *startAfterDelay;

/** Start after event/notification */
@property (nonatomic, strong) NSString *startAfterEvent;

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
