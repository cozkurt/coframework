//
//  COJSONLoader.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 7/24/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface COJSONLoader : NSObject

@property (readonly, nonatomic, strong, getter = arrayObject) NSArray *array;
@property (readonly, nonatomic, strong, getter = dictionaryObject) NSDictionary *dict;

- (id)initWithData:(NSData *)data;
- (id)initWithJSONString:(NSString *)jsonString;
- (id)initWithFile:(NSString *)file;


@end
