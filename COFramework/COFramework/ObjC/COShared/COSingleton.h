//
//  COSingleton.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 7/16/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#ifndef COLibrary_COSingleton_h
#define COLibrary_COSingleton_h

#define CO_SYNTHESIZE_SINGLETON(classname,accessorMethod,initializerBlock)                   \
\
+ (classname *)accessorMethod                                                            \
{                                                                                        \
static classname *sSharedInstance = nil;                                             \
static dispatch_once_t pred;                                                         \
dispatch_once(&pred, ^{                                                              \
sSharedInstance = [self alloc];                                    \
sSharedInstance = (classname *)initializerBlock (sSharedInstance); \
}                                                                      \
);                                                                     \
return sSharedInstance;                                                              \
}

#endif
