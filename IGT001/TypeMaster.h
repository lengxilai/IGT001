//
//  TypeMaster.h
//  IGT001
//
//  Created by DATA NTT on 12/05/09.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ItemMaster;

@interface TypeMaster : NSManagedObject

@property (nonatomic, retain) NSDate * addtime;
@property (nonatomic, retain) NSString * typename;
@property (nonatomic, retain) NSOrderedSet *items;
@end

@interface TypeMaster (CoreDataGeneratedAccessors)

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
@end
