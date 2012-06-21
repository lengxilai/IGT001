//
//  IGDataLoader.m
//  IGT001
//
//  Created by Ming Liu on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGDataLoader.h"

@implementation IGDataLoader

// 初始化数据，注意：CURRENT_VERSION是自己定义的，如果要更新数据请修改CURRENT_VERSION的值
+(void)lodeDefaultData
{
    // 如果已经导过数据则略过
    Config *config = [IGCoreDataUtil getConfigInfoForKey:@"DataVersion"];
    NSString *dataFileName = @"init.data";
    
    // 如果没有配置信息则使用init.data并且新建配置信息，如果已经有配置信息，则使用更新文件
    if (config != nil) {
        float dataVersion = [config.value floatValue];
        if (dataVersion < CURRENT_VERSION) {
            dataFileName = [NSString stringWithFormat:@"update%.2f.data", CURRENT_VERSION];
        }else {
            return;
        }
    }else{
        Config *newConfig = (Config*)[[Config alloc] initWithEntity:[NSEntityDescription entityForName:@"Config" inManagedObjectContext:[IGCoreDataUtil getStaticManagedObjectContext]] insertIntoManagedObjectContext:[IGCoreDataUtil getStaticManagedObjectContext]];
        newConfig.key = @"DataVersion";
        newConfig.value = [NSString stringWithFormat:@"%.2f",CURRENT_VERSION];
    }
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    // 数据文件路径
    NSString *dataPath =  [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.lproj",currentLanguage]] stringByAppendingPathComponent:dataFileName];
    
    // 如果文件不存在则退出
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath isDirectory:NO]){
        return;
    }
    
    NSString *data = [NSString stringWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *dataArray = [data componentsSeparatedByString:@"\n"];
    
    TypeMaster *typeMaster = nil;
    // addtime延迟值
    NSInteger timeInterval = 0;
    
    for (NSString *name in dataArray) {
        // type
        if ([name hasPrefix:@"-"]) {
            //
            typeMaster = [[TypeMaster alloc] initWithEntity:[NSEntityDescription entityForName:@"TypeMaster" inManagedObjectContext:[IGCoreDataUtil getStaticManagedObjectContext]] insertIntoManagedObjectContext:[IGCoreDataUtil getStaticManagedObjectContext]];
            typeMaster.typename = [name substringFromIndex:1];
            // 大分类之间的addtime设置延迟值，否则会出现几个大分类addtime相同，在B01页面用addtime做tag，点击一个section收缩展开的时候会出现几个section同时收缩展开的现象
            typeMaster.addtime = [NSDate dateWithTimeIntervalSinceNow:timeInterval++];
        // item
        }else if([name hasPrefix:@"*"]){
            ItemMaster *itemMaster = [[ItemMaster alloc] initWithEntity:[NSEntityDescription entityForName:@"ItemMaster" inManagedObjectContext:[IGCoreDataUtil getStaticManagedObjectContext]] insertIntoManagedObjectContext:[IGCoreDataUtil getStaticManagedObjectContext]];;
            itemMaster.itemname = [name substringFromIndex:1];
            itemMaster.addtime = [NSDate dateWithTimeIntervalSinceNow:timeInterval++];
            [typeMaster addItemsObject:itemMaster];
        }
    }
    NSError *error = nil;
    if (![[IGCoreDataUtil getStaticManagedObjectContext]save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}
@end
