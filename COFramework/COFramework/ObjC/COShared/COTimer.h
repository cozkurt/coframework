//
//  COTimer.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 12/28/13.
//  Copyright (c) 2013 Cenker Ozkurt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface COTimer : NSObject

+ (COTimer *)sharedInstance;

- (BOOL)waitForKey:(NSString *)key delay:(NSTimeInterval)delay firstPass:(BOOL)firstPass;

@end
