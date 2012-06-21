//
//  IGBusinessUtil.h
//  IGT001
//
//  Created by Ming Liu on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Plan.h"
#import "PlanItem.h"
#import "IGCoreDataUtil.h"
#import "NSDate+Helper.h"
#import "IGLabel.h"
#import "IGCommonDefine.h"
#import "UIUtil.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

// 交通方式分类
typedef enum{
    TrvalTypeWalking=1,TrvalTypeDriving=2,TrvalTypeBus=3,TrvalTypeTrain=4,TrvalTypeAir=5,
}TrvalType;

@interface IGBusinessUtil : NSObject

+(void)printSubviews:(UIView*)view;
//返回该程序的档案目录，用来简单使用
+ (NSString *)applicationDocumentsDirectory;
// 根据交通方式分类返回图片名
+(NSString*)getTrvalTypeImageNameForType:(TrvalType)trvalType;
// 根据交通方式分类返回相应图片
+(IGLabel*)getTrvalTypeImageForType:(TrvalType)trvalType;
// 返回所有交通方式图片
+(NSArray*)getAllTrvalTypeImage;
// 计算计划的完成度
+(NSString *)getCheckedRate:(Plan*) plan;
// 创建一个行程检查项目
+(PlanItem*)createPlanItemForItem:(ItemMaster*)item forCheck:(NSInteger)isCheck;
// 添加闹钟提醒
+(void)addPlanAlert:(Plan*)plan;
// 取消闹钟提醒
+(void)removePlanAlert:(Plan*)plan;
// 判断计划是否完了
+(BOOL)isOver:(Plan*)plan;
// 返回发邮件的表情符号
+(NSString*)getMailImageName;
// 返回关注的表情符号
+(NSString*)getFollowImageName;
// 创建邮件内容
+(MFMailComposeViewController*)createMailForPlan:(Plan*)plan;
// 直接调用系统邮件发送
+(void)launchMailAppOnDevice:(Plan*)plan;
// 去评论页面
+(void)go2CommentApp:(NSInteger *) appId;
// 下载应用
+(void)go2DownLoadApp:(NSInteger *) appId;
// 去我们的网站
+(void)go2OurWebSite;
// 发邮件给我们
+(MFMailComposeViewController *)sendMailToOur;
+(void)launchMailAppOnDeviceToOur;
// 取得提醒时间
+(NSInteger)getAlertTimeTravel;
// 取得提醒message内容
+(NSString*)getAlertMessage;
// 变换时间显示格式
+(NSString*)changeAlertTimeTravelFormat;
@end
