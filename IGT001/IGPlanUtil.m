//
//  IGPlanUtil.m
//  IGT001
//
//  Created by Ming Liu on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGPlanUtil.h"

@implementation IGPlanUtil

static NSManagedObjectContext *staticMoc;

+(void)setStaticMoc:(NSManagedObjectContext*) moc
{
    staticMoc = moc;
}

+(NSManagedObjectContext*)getStaticMoc
{
    return staticMoc;
}

// 根据行程ID取得行程
+(Plan*)getPlanForID:(NSInteger)planID
{
    Plan *plan = [self createPlanForID:planID forDesAdr:@"北京"];
    return plan;
}

// 根据模板ID返回模板
+(TemplateMaster*)getTemplateForID:(NSInteger)templateID
{
//    TemplateMaster *template = [self createTemplateForID:templateID forName:@"行程模板"];
//    return template;
    return nil;
}

// 取得全部模板
+(NSMutableArray *)getTemplate{
    NSMutableArray *reult = [[NSMutableArray alloc] initWithObjects:@"旅游", @"出差", @"探亲", @"徒步", nil];
    return reult;
}

// 以下为测试数据创建用的临时代码
+(Plan*)createPlanForID:(NSInteger)planID forDesAdr:(NSString*)desAdr
{
    Plan *plan = [NSEntityDescription insertNewObjectForEntityForName:@"Plan" inManagedObjectContext:staticMoc];
    plan.planid = [NSNumber numberWithInt:1];
    plan.desadr = desAdr;
    plan.travltype = [NSNumber numberWithInt:1];
    plan.travldetail = @"Z81";
    plan.starttime = [NSDate date];
    plan.hotelname = @"三元桥宜必思商务酒店";
    plan.memo = @"联系人侯老师";
    plan.isalarm = [NSNumber numberWithInt:0];
    
    plan.template = [self createTemplateForID:1 forName:@"行程模板" forTemplate:plan.template];
    
    plan.planitems = [[NSOrderedSet alloc] initWithObjects:
                      [self createPlanItemForPlan:plan                        forItem:[self createItemForID:1 forName:@"行程检查项1"] forCheck:NO], 
                      [self createPlanItemForPlan:plan                        forItem:[self createItemForID:2 forName:@"行程检查项2"] forCheck:NO], 
                      [self createPlanItemForPlan:plan                        forItem:[self createItemForID:3 forName:@"行程检查项3"] forCheck:NO], 
                      [self createPlanItemForPlan:plan                        forItem:[self createItemForID:4 forName:@"行程检查项4"] forCheck:NO], 
                      [self createPlanItemForPlan:plan                        forItem:[self createItemForID:5 forName:@"行程检查项5"] forCheck:NO], 
                      nil];    return plan;
}

+(ItemMaster*)createItemForID:(NSInteger)itemID forName:(NSString*)itemName
{
    ItemMaster *item = [[ItemMaster alloc] initWithEntity:[NSEntityDescription entityForName:@"ItemMaster" inManagedObjectContext:staticMoc] insertIntoManagedObjectContext:staticMoc];
    item.itemname = itemName;  
    
    return item;
}

+(ItemMaster*)createItemForType:(TypeMaster*)itemType forID:(NSInteger)itemID forName:(NSString*)itemName
{
    ItemMaster *item = [[ItemMaster alloc] initWithEntity:[NSEntityDescription entityForName:@"ItemMaster" inManagedObjectContext:staticMoc] insertIntoManagedObjectContext:staticMoc];
    item.itemname = itemName;
    
    return item;
}

+(TypeMaster*)createItemTypeForID:(NSInteger)typeID forName:(NSString*)typeName forItemType:(TypeMaster*)itemType
{
    itemType.typename = typeName;
    
    [itemType addItemsObject:[self createItemForType:itemType forID:11 forName:@"分类项目1"]];
    [itemType addItemsObject:[self createItemForType:itemType forID:12 forName:@"分类项目2"]];
    [itemType addItemsObject:[self createItemForType:itemType forID:13 forName:@"分类项目3"]];
    [itemType addItemsObject:[self createItemForType:itemType forID:14 forName:@"分类项目4"]];
    [itemType addItemsObject:[self createItemForType:itemType forID:15 forName:@"分类项目5"]];
    
    return itemType;
}

+(void)createTemplateForName:(NSString*)name
{
    TemplateMaster *template = [[TemplateMaster alloc] initWithEntity:[NSEntityDescription entityForName:@"TemplateMaster" inManagedObjectContext:staticMoc] insertIntoManagedObjectContext:staticMoc];
    
    template.templatename = name;
    
    [template addItemsObject:[self createItemForID:1 forName:[NSString stringWithFormat:@"%@%@",name, @"模板检查项目1"]]];
    [template addItemsObject:[self createItemForID:2 forName:[NSString stringWithFormat:@"%@%@",name, @"模板检查项目2"]]];
    [template addItemsObject:[self createItemForID:3 forName:[NSString stringWithFormat:@"%@%@",name, @"模板检查项目3"]]];
    [template addItemsObject:[self createItemForID:4 forName:[NSString stringWithFormat:@"%@%@",name, @"模板检查项目4"]]];
    [template addItemsObject:[self createItemForID:5 forName:[NSString stringWithFormat:@"%@%@",name, @"模板检查项目5"]]];
    
    NSError *error = nil;

    if (![[IGPlanUtil getStaticMoc] save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}

+(void)saveTemplateForName:(NSString*)name forItemMasterArray:(NSMutableArray*)itemMasterArray  forPlan:(Plan*)plan
{
    TemplateMaster *template = [[TemplateMaster alloc] initWithEntity:[NSEntityDescription entityForName:@"TemplateMaster" inManagedObjectContext:staticMoc] insertIntoManagedObjectContext:staticMoc];
    
    template.templatename = name;
    for (ItemMaster *itemMaster in itemMasterArray) {
        [template addItemsObject:itemMaster];
    }
    plan.template = template;

    NSError *error = nil;
    
    if (![[IGPlanUtil getStaticMoc] save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}


+(TemplateMaster*)createTemplateForID:(NSInteger)templateID forName:(NSString*)templateName forTemplate:(TemplateMaster*)template
{
    template.templatename = templateName;
    
    [template addItemsObject:[self createItemForID:1 forName:@"模板检查项目1"]];
    [template addItemsObject:[self createItemForID:2 forName:@"模板检查项目2"]];
    [template addItemsObject:[self createItemForID:3 forName:@"模板检查项目3"]];
    [template addItemsObject:[self createItemForID:4 forName:@"模板检查项目4"]];
    [template addItemsObject:[self createItemForID:5 forName:@"模板检查项目5"]];
 
    
    return template;
}

+(void)createTypeMaster
{
    TypeMaster *type = [[TypeMaster alloc] initWithEntity:[NSEntityDescription entityForName:@"TypeMaster" inManagedObjectContext:staticMoc] insertIntoManagedObjectContext:staticMoc];
    type.typename = @"日常用品";
    NSError *error = nil;
    if (![[IGPlanUtil getStaticMoc] save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}
+(void)saveMasterDate{
    [self getPlanForID:1];
    NSError *error = nil;
	if (![[IGPlanUtil getStaticMoc] save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}

// 根据模板名称创建新模板
+(TemplateMaster*)createTemplateByName:(NSString *)templateName
{
    TemplateMaster *template = [[TemplateMaster alloc] initWithEntity:[NSEntityDescription entityForName:@"TemplateMaster" inManagedObjectContext:staticMoc] insertIntoManagedObjectContext:staticMoc];
    template.templatename = templateName;
    template.addtime = [NSDate date];
    NSError *error = nil;
	if (![[IGPlanUtil getStaticMoc] save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    return template;
}

@end
