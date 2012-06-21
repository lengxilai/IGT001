//
//  ItemMaster.h
//  IGT001
//
//  Created by DATA NTT on 12/05/09.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlanItem, TemplateMaster, TypeMaster;

@interface ItemMaster : NSManagedObject

@property (nonatomic, retain) NSDate * addtime;
@property (nonatomic, retain) NSString * itemname;
@property (nonatomic, retain) TypeMaster *itemtype;
@property (nonatomic, retain) NSSet *templates;
@property (nonatomic, retain) NSSet *planitems;
@end

@interface ItemMaster (CoreDataGeneratedAccessors)

- (void)addTemplatesObject:(TemplateMaster *)value;
- (void)removeTemplatesObject:(TemplateMaster *)value;
- (void)addTemplates:(NSSet *)values;
- (void)removeTemplates:(NSSet *)values;

- (void)addPlanitemsObject:(PlanItem *)value;
- (void)removePlanitemsObject:(PlanItem *)value;
- (void)addPlanitems:(NSSet *)values;
- (void)removePlanitems:(NSSet *)values;

@end
