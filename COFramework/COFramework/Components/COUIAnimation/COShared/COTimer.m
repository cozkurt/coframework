//
//  COTimer.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 12/28/13.
//  Copyright (c) 2013 Cenker Ozkurt. All rights reserved.
//

#import "COLogging.h"
#import "COSingleton.h"

#import "COTimer.h"

@interface COTimer()

@property (nonatomic, strong) NSMutableDictionary *objects;

@end

@implementation COTimer

CO_SYNTHESIZE_SINGLETON(COTimer, sharedInstance, ^(COTimer *sharedInstance) { return [sharedInstance init]; } );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Init Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init
{
    self = [super init];
    if (self)
    {
        self.objects = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Timer Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)waitForKey:(NSString *)key delay:(NSTimeInterval)delay firstPass:(BOOL)firstPass
{
    NSTimeInterval interval;
    NSDate *date = [self.objects valueForKey:key];
    
    // reset date for key
    
    [self.objects setValue:[NSDate date] forKey:key];
    
    // check if date created
    
    if (!date)
    {
        return firstPass;
    }
    
    interval = [[NSDate date] timeIntervalSinceDate:date];
    
    LogInfo(@"key = %@, interval = %f", key, interval);
    
    // confirm time passes or not
    
    if (interval < delay)
    {
        return false;
    }
    else
    {
        return true;
    }
}

@end