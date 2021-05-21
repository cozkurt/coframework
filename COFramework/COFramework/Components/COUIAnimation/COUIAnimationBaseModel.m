//
//  COUIAnimationBaseModel.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 7/25/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#import "COMacros.h"
#import "COUIAnimationBaseModel.h"

@implementation COUIAnimationBaseModel

- (id)init
{
    self = [super init];
    if (self)
    {
        self.tag = nil;
        self.toTag = nil;
        self.didStartEvent = nil;
        self.didStopEvent = nil;
        self.didClickEvent = nil;
        self.didSwipeEvent = nil;
        self.startAfterDelay = nil;
        self.startAfterEvent = nil;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        if (IS_VALID_STRING([dict valueForKey:@"tag"])) self.tag = [dict valueForKey:@"tag"];
        if (IS_VALID_STRING([dict valueForKey:@"toTag"])) self.toTag = [dict valueForKey:@"toTag"];
        if (IS_VALID_STRING([dict valueForKey:@"didStartEvent"])) self.didStartEvent = [dict valueForKey:@"didStartEvent"];
        if (IS_VALID_STRING([dict valueForKey:@"didStopEvent"])) self.didStopEvent = [dict valueForKey:@"didStopEvent"];
        if (IS_VALID_STRING([dict valueForKey:@"didClickEvent"])) self.didClickEvent = [dict valueForKey:@"didClickEvent"];
        if (IS_VALID_STRING([dict valueForKey:@"didSwipeEvent"])) self.didSwipeEvent = [dict valueForKey:@"didSwipeEvent"];
        
        if (IS_VALID_STRING([dict valueForKey:@"startAfterDelay"])) self.startAfterDelay = [NSNumber numberWithDouble:[[dict valueForKey:@"startAfterDelay"] doubleValue]];
        if (IS_VALID_STRING([dict valueForKey:@"startAfterEvent"])) self.startAfterEvent = [dict valueForKey:@"startAfterEvent"];
    }
    return  self;
}

- (NSDictionary *)toDictionary
{
    return @{
             @"tag": self.tag,
             @"toTag": self.toTag,
             @"didStartEvent": self.didStartEvent,
             @"didStopEvent": self.didStopEvent,
             @"didClickEvent": self.didClickEvent,
             @"didSwipeEvent": self.didSwipeEvent,
             @"startAfterDelay": self.startAfterDelay,
             @"startAfterEvent": self.startAfterEvent
             };
    
    return  nil;
}

@end

