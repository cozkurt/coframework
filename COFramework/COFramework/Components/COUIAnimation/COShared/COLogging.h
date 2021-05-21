//
//  COLogging.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 3/6/14.
//  Copyright (c) 2014 Cenker Ozkurt. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const LogDebuggingNotification;

void LogFunction(NSString *debugLevel, const char *filepath, int line, NSString *message);

#ifdef LOG_DEBUG
#  define LogDebug( s, ...) LogFunction( @"DEBUG", __FILE__, __LINE__, [NSString stringWithFormat:(s), ## __VA_ARGS__])
#else
#  define LogDebug( s, ...)
#endif

#ifdef LOG_INFO
#  define LogInfo( s, ...) LogFunction( @"INFO", __FILE__, __LINE__, [NSString stringWithFormat:(s), ## __VA_ARGS__])
#else
#  define LogInfo( s, ...)
#endif

#ifdef LOG_ERROR
#  define LogError( s, ...) LogFunction( @"ERROR", __FILE__, __LINE__, [NSString stringWithFormat:(s), ## __VA_ARGS__])
#else
#  define LogError( s, ...)
#endif
