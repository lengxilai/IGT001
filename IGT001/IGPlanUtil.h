//
//  IGPlanUtil.h
//  IGT001
//
//  Created by Ming Liu on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Plan.h"
#import "PlanItem.h"
#import "TemplateMaster.h"
#import "ItemMaster.h"
#import "TypeMaster.h"

@class IGAppDelegate;
@interface IGPlanUtil : NSObject

+(void)setStaticMoc:(NSManagedObjectContext*) moc;
+(NSManagedObjectContext*)getStaticMoc;

+(Plan*)getPlanForID:(NSInteger)planID;
+(NSMutableArray *)getTemplate;
+(Plan*)createPlanForID:(NSInteger)planID forDesAdr:(NSString*)desAdr;
+(TemplateMaster*)createTemplateForID:(NSInteger)templateID forName:(NSString*)templateName forTemplate:(TemplateMaster*)template;
+(PlanItem*)createPlanItemForPlan:(Plan*)plan forItem:(ItemMaster*)item forCheck:(NSInteger)isCheck;
+(TypeMaster*)createItemTypeForID:(NSInteger)typeID forName:(NSString*)typeName forItemType:(TypeMaster*)itemType;
+(ItemMaster*)createItemForID:(NSInteger)itemID forName:(NSString*)itemName;
+(void)saveMasterDate;
+(void)createTypeMaster;
+(void)createTemplateForName:(NSString*)name;
+(void)saveTemplateForName:(NSString*)name forItemMasterArray:(NSMutableArray*)itemMaster forPlan:(Plan*)plan;
+(TemplateMaster*)createTemplateByName:(NSString *)templateName;
@end
