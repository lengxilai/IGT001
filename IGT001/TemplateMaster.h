//
//  TemplateMaster.h
//  IGT001
//
//  Created by DATA NTT on 12/05/09.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ItemMaster, Plan;

@interface TemplateMaster : NSManagedObject

@property (nonatomic, retain) NSDate * addtime;
@property (nonatomic, retain) NSString * templatename;
@property (nonatomic, retain) NSOrderedSet *items;
@property (nonatomic, retain) NSSet *plan;
@end

@interface TemplateMaster (CoreDataGeneratedAccessors)

- (void)insertObject:(ItemMaster *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(ItemMaster *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)values;
- (void)addItemsObject:(ItemMaster *)value;
- (void)removeItemsObject:(ItemMaster *)value;
- (void)addItems:(NSOrderedSet *)values;
- (void)removeItems:(NSOrderedSet *)values;
- (void)addPlanObject:(Plan *)value;
- (void)removePlanObject:(Plan *)value;
- (void)addPlan:(NSSet *)values;
- (void)removePlan:(NSSet *)values;

@end
