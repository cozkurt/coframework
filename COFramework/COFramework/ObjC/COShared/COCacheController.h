//
//  COCacheController.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 8/20/13.
//  Copyright (c) 2013 Cenker Ozkurt. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kMemory = 0,
    kDocumentFolder
} StorageType;

@interface COCacheController : NSObject

@property (strong, nonatomic) NSCache *cache;
@property (assign, nonatomic) StorageType storageType;

+(COCacheController *)sharedInstance;

- (void)saveObject:(id)obj forKey:(NSString *)key;
- (id)cachedObject:(id)obj forKey:(NSString *)key;
- (id)cachedObjectForKey:(NSString *)key;
- (void)deleteCache;

- (BOOL)cacheExistsForKey:(NSString *)key;

@end
