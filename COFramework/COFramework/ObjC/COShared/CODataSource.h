//
//  CODataSource.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 8/2/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CODataSourceDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol CODataSourceDelegate <NSObject>

@required

/**
 returns number of record from datasource
 
 @return int
 */
- (int)numberOfRecords;

/**
 returns objectAtIndex at index
 
 @param index dictionary to pull from index
 @return NSDictionary
 */
- (NSDictionary *)objectAtIndex:(int)index;

/**
 returns all data
 
 @return NSArray
 */
- (NSArray *)dataList;

@optional

@end

@interface CODataSource : NSObject <CODataSourceDelegate>

/**
 Initialized CODataSource with given file name
 
 @param file filename to load JSON configuration
 @see COUIFlowEventModel
 */
- (id)initWithJSONFile:(NSString *)file;

@end
