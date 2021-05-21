//
//  NSObject+Blocks.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 7/16/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#import "NSObject+Blocks.h"

@implementation NSObject (Blocks)

- (void)performBlock:(void (^)(void))block
{
    block();
}

- (void)performBlockAsync:(void (^)(void))block
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
                   {
                       block();
                   });
}

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    void (^block_)(void) = [block copy];
    
    [self performSelector:@selector(performBlock:) withObject:block_ afterDelay:delay];
}

- (void)performBlockInMainThread:(void (^)(void))block
{
    [self performBlockInMainThread:block afterDelay:0];
}

- (void)performBlockInMainThread:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    void (^block_)(void) = [block copy];
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self performSelector:@selector(performBlock:) withObject:block_ afterDelay:delay];
                   });
}

@end
