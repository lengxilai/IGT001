//
//  Plan.h
//  IGT001
//
//  Created by DATA NTT on 12/05/09.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlanItem, TemplateMaster;

@interface Plan : NSManagedObject

@property (nonatomic, retain) NSDate * addtime;
@property (nonatomic, retain) NSString * desadr;
@property (nonatomic, retain) NSString * hotelname;
@property (nonatomic, retain) NSNumber * isalarm;
@property (nonatomic, retain) NSNumber * isover;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) NSNumber * planid;
@property (nonatomic, retain) NSDate * starttime;
@property (nonatomic, retain) NSString * travldetail;
@property (nonatomic, retain) NSNumber * travltype;
@property (nonatomic, retain) NSOrderedSet *planitems;
@property (nonatomic, retain) TemplateMaster *template;
@end

@interface Plan (CoreDataGeneratedAccessors)

- (void)insertObject:(PlanItem *)value inPlanitemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPlanitemsAtIndex:(NSUInteger)idx;
- (void)insertPlanitems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePlanitemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPlanitemsAtIndex:(NSUInteger)idx withObject:(PlanItem *)value;
- (void)replacePlanitemsAtIndexes:(NSIndexSet *)indexes withPlanitems:(NSArray *)values;
- (void)addPlanitemsObject:(PlanItem *)value;
- (void)removePlanitemsObject:(PlanItem *)value;
- (void)addPlanitems:(NSOrderedSet *)values;
- (void)removePlanitems:(NSOrderedSet *)values;
@end
