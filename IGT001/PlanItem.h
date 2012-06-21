//
//  PlanItem.h
//  IGT001
//
//  Created by DATA NTT on 12/05/09.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ItemMaster, Plan;

@interface PlanItem : NSManagedObject

@property (nonatomic, retain) NSDate * addtime;
@property (nonatomic, retain) NSNumber * ischecked;
@property (nonatomic, retain) ItemMaster *item;
@property (nonatomic, retain) Plan *plan;

@end
