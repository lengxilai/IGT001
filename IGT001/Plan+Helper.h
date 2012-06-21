//
//  Plan+Helper.h
//  IGT001
//
//  Created by DATA NTT on 12/05/09.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Plan.h"

@interface Plan (Helper)
- (void)addPlanitemsObject:(PlanItem *)value;
- (void)removePlanitemsObject:(PlanItem *)value;
- (void)addPlanitems:(NSSet *)values;
- (void)removePlanitems:(NSSet *)values;
@end
