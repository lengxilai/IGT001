//
//  Plan+Helper.m
//  IGT001
//
//  Created by DATA NTT on 12/05/09.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Plan+Helper.h"

@implementation Plan (Helper)
- (void)addPlanitemsObject:(PlanItem *)value
{
    [self willChangeValueForKey:@"planitems"];
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.planitems];
    [tempSet addObject: value];
    self.planitems = tempSet;
    [self didChangeValueForKey:@"planitems"];
}
- (void)removePlanitemsObject:(PlanItem *)value
{
    [self willChangeValueForKey:@"planitems"];
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.planitems];
    [tempSet removeObject: value];
    self.planitems = tempSet;
    [self didChangeValueForKey:@"planitems"];
}
- (void)addPlanitems:(NSSet *)values
{
    [self willChangeValueForKey:@"planitems"];
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.planitems];
    [tempSet addObjectsFromArray:[values allObjects]];
    self.planitems = tempSet;
    [self didChangeValueForKey:@"planitems"];
}
- (void)removePlanitems:(NSSet *)values
{
    [self willChangeValueForKey:@"planitems"];
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.planitems];
    [tempSet removeObjectsInArray:[values allObjects]];
    self.planitems = tempSet;
    [self didChangeValueForKey:@"planitems"];
}
@end
