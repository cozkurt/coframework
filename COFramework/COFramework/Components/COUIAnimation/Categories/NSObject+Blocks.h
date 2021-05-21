//
//  NSObject+Blocks.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 7/16/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Blocks)

/**
 performBlock performs block call in thread
 
 @return void
 */

- (void)performBlock:(void (^)(void))block;

/**
 performBlock performs block in new thread
 
 @return void
 */
- (void)performBlockAsync:(void (^)(void))block;

/**
 performBlock performs block call after delay
 
 @param block
 @return void
 */

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

/**
 performBlockInMainThread performs block call in main thread
 
 @param block
 @return void
 */

- (void)performBlockInMainThread:(void (^)(void))block;

/**
 performBlockInMainThread performs block call in main thread after delay
 
 @param block
 @return void
 */

- (void)performBlockInMainThread:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
