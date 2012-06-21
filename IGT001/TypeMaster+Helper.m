//
//  TypeMaster+Helper.m
//  IGT001
//
//  Created by DATA NTT on 12/05/09.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TypeMaster+Helper.h"

@implementation TypeMaster (Helper)
- (void)addItemsObject:(ItemMaster*)value{
    [self willChangeValueForKey:@"items"];
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.items];
    [tempSet addObject: value];
    self.items = tempSet;
    [self didChangeValueForKey:@"items"];
}

- (void)removeItemsObject:(ItemMaster *)value
{
    [self willChangeValueForKey:@"items"];
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.items];
    [tempSet removeObject: value];
    self.items = tempSet;
    [self didChangeValueForKey:@"items"];
}

- (void)addItems:(NSOrderedSet *)values
{
    [self willChangeValueForKey:@"items"];
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.items];
    [tempSet addObjectsFromArray:[values array]];
    self.items = tempSet;
    [self didChangeValueForKey:@"items"];
}

- (void)removeItems:(NSOrderedSet *)values
{    
    [self willChangeValueForKey:@"items"];
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.items];
    [tempSet removeObjectsInArray:[values array]];
    self.items = tempSet;
    [self didChangeValueForKey:@"items"];
    
}
@end
