//
//  IGCoreDataUtil.h
//  IGT001
//
//  Created by Ming Liu on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

@class IGAppDelegate;

@interface IGCoreDataUtil : NSObject;

+(void)setStaticManagedObjectContext:(NSManagedObjectContext*) managedObjectContext;
+(NSManagedObjectContext*)getStaticManagedObjectContext;
// 查询
+(NSFetchedResultsController*)queryForFetchedResult:(NSString *)entityName queryCondition:(NSString *)queryCondition sortDescriptors:(NSArray*) sortDescriptors;
+(NSFetchedResultsController*)queryForFetchedResult:(NSString *)entityName queryCondition:(NSString *)queryCondition sortDescriptors:(NSArray*) sortDescriptors sectionNameKeyPath:(NSString*)sectionKey;
+(Config*)getConfigInfoForKey:(NSString*)key;
@end
