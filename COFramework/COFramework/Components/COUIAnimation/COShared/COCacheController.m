//
//  COCacheController.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 8/20/13.
//  Copyright (c) 2013 Cenker Ozkurt. All rights reserved.
//

#import "COLogging.h"
#import "COSingleton.h"
#import "COCacheController.h"

@interface COCacheController ()

@property (nonatomic, strong) NSMutableDictionary *keys;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - COCacheController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation COCacheController

CO_SYNTHESIZE_SINGLETON(COCacheController, sharedInstance, ^(COCacheController *sharedInstance) { return [sharedInstance init]; } );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - init methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init
{
    self = [super init];
    if (self)
    {
        self.keys = [[NSMutableDictionary alloc] init];
        self.storageType = kMemory;
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)cachedObject:(id)obj forKey:(NSString *)key
{
    id cachedObj;
    
    if (self.storageType == kMemory)
        cachedObj = [self.keys objectForKey:key];
    else
        cachedObj = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForFileName:key]];
    
    if (cachedObj == nil)
    {
        if (self.storageType == kMemory)
        {
            if (obj != nil) [self.keys setObject:obj forKey:key];
        }
        else
        {
            [NSKeyedArchiver archiveRootObject:obj toFile:[self pathForFileName:key]];
        }
        
        return obj;
    }
    else
    {
        return cachedObj;
    }
}

- (void)saveObject:(id)obj forKey:(NSString *)key
{
    if (self.storageType == kMemory)
    {
        if (obj != nil) [self.keys setObject:obj forKey:key];
    }
    else
    {
        [NSKeyedArchiver archiveRootObject:obj toFile:[self pathForFileName:key]];
    }
}

- (id)cachedObjectForKey:(NSString *)key
{
    if (self.storageType == kMemory)
        return [self.keys objectForKey:key];
    else
        return [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForFileName:key]];
}

- (void)deleteCache
{
    if (self.storageType == kMemory)
    {
        [self.keys removeAllObjects];
    }
    else
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSError *error = nil;
        
        for (NSString *fileName in [fm contentsOfDirectoryAtPath:documentsDirectory error:&error])
        {
            BOOL success = [fm removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:fileName] error:&error];
            
            if (!success && error)
            {
                LogError(@"Error while deleting cached file : %@", fileName);
            }
        }
    }
}

- (BOOL)cacheExistsForKey:(NSString *)key
{
    if (self.storageType == kMemory)
        return ([self.keys objectForKey:key] != 0);
    else
        return [[NSFileManager defaultManager] fileExistsAtPath:[self pathForFileName:key]];
}

- (NSString *)pathForFileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    return writableDBPath;
}

@end