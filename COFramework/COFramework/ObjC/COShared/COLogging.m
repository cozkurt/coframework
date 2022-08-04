//
//  COLogging.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 3/6/14.
//  Copyright (c) 2014 Cenker Ozkurt. All rights reserved.
//

#import "COLogging.h"

NSString *const LogDebuggingNotification = @"LogDebuggingNotification";

void LogFunction(NSString *debugLevel, const char *filepath, int line, NSString *message)
{
    NSString *debugStr = [NSString stringWithFormat:@"%@ %4d: %@", [[NSString stringWithUTF8String:filepath] lastPathComponent], line, message];
    
    NSLog(@"%@ : %@", debugLevel, debugStr);
    
    NSDictionary *debugDict = @{ @"debugLevel":debugLevel, @"debugStr":debugStr };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LogDebuggingNotification object:nil userInfo:debugDict];
}
