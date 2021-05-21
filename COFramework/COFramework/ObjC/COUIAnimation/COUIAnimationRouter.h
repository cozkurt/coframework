//
//  COUIAnimationRouter.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 9/30/13.
//  Copyright (c) 2013 Cenker Ozkurt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class COUIAnimationController;

@interface COUIAnimationRouter : NSObject

// class methods
+ (COUIAnimationRouter *)sharedInstance;

// instance methods
- (void)registerController:(COUIAnimationController *)controller;
- (void)performEvent:(NSString *)event;

@end
