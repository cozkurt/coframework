//
//  COJSONLoader.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 7/24/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#import "COLogging.h"
#import "COJSONLoader.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface COJSONLoader ()

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSDictionary *dict;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - COJSONLoader
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation COJSONLoader

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - init methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init
{
    self = [super init];
    if (self)
    {
        self.array = [[NSArray alloc] init];
        self.dict = [[NSDictionary alloc] init];
    }
    return self;
}

-(id)initWithData:(NSData *)data
{
    self = [self init];
    if (self)
    {
        if (data != nil)
        {
            NSError *e = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &e];
            
            if (!jsonObject)
            {
                NSLog(@"Error parsing JSON: %@", e);
            }
            else
            {
                if ([jsonObject isKindOfClass:[NSDictionary class]])
                {
                    self.dict = jsonObject;
                }
                else if ([jsonObject isKindOfClass:[NSArray class]])
                {
                    self.array = jsonObject;
                }
            }
        }
    }
    return self;
}

- (id)initWithJSONString:(NSString *)jsonString
{
    self = [self init];
    if (self)
    {
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        self = [self initWithData:data];
    }
    
    return self;
}

- (id)initWithFile:(NSString *)file
{
    self = [self init];
    if (self)
    {
        if (file!=nil)
        {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:file ofType:@"json"];
            
            NSError *error;
            NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
            
            if (!content)
            {
                NSLog(@"json file missing : %@", file);
            }
            
            self = [self initWithJSONString:content];
        }
    }
    
    return self;
}

@end
