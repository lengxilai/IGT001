//
//  IGDataLoader.h
//  IGT001
//
//  Created by Ming Liu on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGBusinessUtil.h"
#import "Plan.h"
#import "PlanItem.h"
#import "TemplateMaster.h"
#import "ItemMaster.h"
#import "TypeMaster.h"
#import "IGCoreDataUtil.h"
#import "IGCommonDefine.h"

@interface IGDataLoader : NSObject

+(void)lodeDefaultData;
@end
