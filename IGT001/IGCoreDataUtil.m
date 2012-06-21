//
//  IGCoreDataUtil.m
//  IGT001
//
//  Created by Ming Liu on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGCoreDataUtil.h"

@implementation IGCoreDataUtil

static NSManagedObjectContext *staticManagedObjectContext;

+(void)setStaticManagedObjectContext:(NSManagedObjectContext*) managedObjectContext
{
    staticManagedObjectContext = managedObjectContext;
}

+(NSManagedObjectContext*)getStaticManagedObjectContext
{
    return staticManagedObjectContext;
}

// 查询对象表，返回结果NSFetchedResultsController
+(NSFetchedResultsController*)queryForFetchedResult:(NSString *)entityName queryCondition:(NSString *)queryCondition sortDescriptors:(NSArray*) sortDescriptors
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // 查询对象设置
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName 
                                              inManagedObjectContext:staticManagedObjectContext];
    [request setEntity:entity];
    
    // 查询条件设置
    if(queryCondition != nil){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:queryCondition];
        [request setPredicate:predicate];
    }
    
    // 排序设置
    if(sortDescriptors != nil){
        [request setSortDescriptors:sortDescriptors];
    }
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:staticManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return fetchedResultsController;
}

// 查询对象表，返回结果NSFetchedResultsController
+(NSFetchedResultsController*)queryForFetchedResult:(NSString *)entityName queryCondition:(NSString *)queryCondition sortDescriptors:(NSArray*) sortDescriptors sectionNameKeyPath:(NSString*)sectionKey
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // 查询对象设置
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName 
                                              inManagedObjectContext:staticManagedObjectContext];
    [request setEntity:entity];
    
    // 查询条件设置
    if(queryCondition != nil){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:queryCondition];
        [request setPredicate:predicate];
    }
    
    // 排序设置
    if(sortDescriptors != nil){
        [request setSortDescriptors:sortDescriptors];
    }
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:staticManagedObjectContext sectionNameKeyPath:sectionKey cacheName:nil];
    
    return fetchedResultsController;
}

+(Config*)getConfigInfoForKey:(NSString*)key
{
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Config" inManagedObjectContext:staticManagedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"key = %@", key];
	[request setPredicate:predicate];
	
	NSError *error = nil;
	NSArray *array = [staticManagedObjectContext executeFetchRequest:request error:&error];
	if (array != nil && [array count] > 0)
	{
		Config *config = [array objectAtIndex:0];
		return config;
	}else {
		return nil;
	}
}
@end
