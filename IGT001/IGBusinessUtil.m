//
//  IGBusinessUtil.m
//  IGT001
//
//  Created by Ming Liu on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGBusinessUtil.h"

@implementation IGBusinessUtil

+(void)printSubviews:(UIView*)view
{
    if ([[view subviews] count]>0) {
        for (UIView *subView in [view subviews]) {
            [self printSubviews:subView];
        }
    }else {
        NSLog(@"view is %@. super view is: %@.", [view class], [[view superview] class]);
        if ([view isKindOfClass:[UILabel class]]) {
            NSLog(@"UILabel text is :%@.", ((UILabel*)view).text);
        }
    }
}

//返回该程序的档案目录，用来简单使用
+ (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

// 根据交通方式分类返回图片名
+(NSString*)getTrvalTypeImageNameForType:(TrvalType)trvalType
{
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 5) {
        
        switch (trvalType) {
            case TrvalTypeWalking:
                return @"\U0001F3C3";
                break;
            case TrvalTypeDriving:
                return @"\U0001F697";
                break;
            case TrvalTypeBus:
                return @"\U0001F68C";
                break;
            case TrvalTypeTrain:
                return @"\U0001F685";
                break;
            case TrvalTypeAir:
                return @"\u2708";
                break;
            default:
                return @"\U0001F3C3";
                break;
        }
    }else {
        
        switch (trvalType) {
            case TrvalTypeWalking:
                return @"\uE115";
                break;
            case TrvalTypeDriving:
                return @"\uE01B";
                break;
            case TrvalTypeBus:
                return @"\uE159";
                break;
            case TrvalTypeTrain:
                return @"\uE01F";
                break;
            case TrvalTypeAir:
                return @"\uE01D";
                break;
            default:
                return @"\uE115";
                break;
        }
    }

}

// 返回发邮件的表情文字
+(NSString*)getMailImageName{
    return @"\U0001F4E9";
}

// 返回关注我们的表情文字
+(NSString*)getFollowImageName{
    return @"\U0001F440";
}

// 根据交通方式分类返回相应图片
+(IGLabel*)getTrvalTypeImageForType:(TrvalType)trvalType
{
//    UIImageView *imageView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self getTrvalTypeImageNameForType:trvalType]]];
    IGLabel *label = [[IGLabel alloc] init];
    label.text = [self getTrvalTypeImageNameForType:trvalType];
    label.tag = trvalType;
    label.font = [UIFont fontWithName:@"AppleColorEmoji" size:42];
    label.textAlignment = UITextAlignmentCenter;
    return label;
}

// 返回所有交通方式图片
+(NSArray*)getAllTrvalTypeImage
{
    return [NSArray arrayWithObjects:[self getTrvalTypeImageForType:TrvalTypeWalking],
            [self getTrvalTypeImageForType:TrvalTypeDriving],
            [self getTrvalTypeImageForType:TrvalTypeBus],
            [self getTrvalTypeImageForType:TrvalTypeTrain],
            [self getTrvalTypeImageForType:TrvalTypeAir],
            nil];
}

// 计算计划的完成度
+(NSString *)getCheckedRate:(Plan*) plan
{
    // 没有ckeck时候返回100％
    if([plan.planitems count] == 0){
        return [[NSString alloc] initWithFormat:@"%d％",100];
    }
    
    NSOrderedSet *planItems = plan.planitems;
    NSInteger checkedCount = 0;
    for (PlanItem *planItem in planItems) {
        if ([planItem.ischecked boolValue]){
            checkedCount++;
        }
    }
    // check项目为0的时候直接返回0％
    if(checkedCount == 0 || checkedCount < [plan.planitems count]/10.0){
        return [[NSString alloc] initWithFormat:@"%d％",0];
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:0];
    [formatter setRoundingMode:NSNumberFormatterRoundDown];
    [formatter setNumberStyle:1];
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:(((float)checkedCount/(float)[plan.planitems count]))*10]];
    return [[NSString alloc] initWithFormat:@"%@0％",numberString];
}

// 创建一个行程检查项目
+(PlanItem*)createPlanItemForItem:(ItemMaster*)item forCheck:(NSInteger)isCheck
{
    PlanItem *planItem = [[PlanItem alloc] initWithEntity:[NSEntityDescription entityForName:@"PlanItem" inManagedObjectContext:[IGCoreDataUtil getStaticManagedObjectContext]] insertIntoManagedObjectContext:[IGCoreDataUtil getStaticManagedObjectContext]];
    planItem.item = item;
    planItem.ischecked = [NSNumber numberWithInt:isCheck];
    
    return planItem;
}

// 添加闹钟提醒
+(void)addPlanAlert:(Plan*)plan
{
    // 行程的添加时间
    NSString *planAddTime = [NSDate stringFromDate:plan.addtime withFormat:@"yyyyMMddHHmmssSSS"];
//    NSLog(@"plan add time is :%@", planAddTime);
    
	// 取消先前的通知
	NSArray *myArray=[[UIApplication sharedApplication] scheduledLocalNotifications];
	for (int i=0; i<[myArray count]; i++) {
		UILocalNotification	*myUILocalNotification=[myArray objectAtIndex:i];
		if ([[[myUILocalNotification userInfo] objectForKey:@"planchecklist"] isEqualToString:planAddTime]) {
//            NSLog(@"remove alert");
			[[UIApplication sharedApplication] cancelLocalNotification:myUILocalNotification];
		}
	}
	
	// 创建本地通知
	UILocalNotification *notification=[[UILocalNotification alloc] init]; 
	notification.timeZone=[NSTimeZone defaultTimeZone]; 
	// 不重复提示
	notification.repeatInterval=0;
	notification.alertAction = NSLocalizedString(@"行程", @"闹钟提醒时，iOS4系统显示的对话框按钮名称，iOS5系统不显示");

    // 出发半小时前提醒
	notification.fireDate = [[NSDate alloc] initWithTimeInterval:-[self getAlertTimeTravel] sinceDate:plan.starttime];
//    NSLog(@"alert time %@",[NSDate stringFromDate:[[NSDate alloc] initWithTimeInterval:-60*30 sinceDate:plan.starttime] withFormat:@"yyyyMMdd HH:mm"]);
	notification.alertBody= [NSString stringWithFormat:
                             NSLocalizedString(@"%@，出发时间：%@", @"%@，出发时间：%@ 闹钟提醒信息，行程名，时间"),
                             plan.desadr, [NSDate stringFromDate:plan.starttime withFormat:@"HH:mm"]];
	
	[notification setSoundName:UILocalNotificationDefaultSoundName];
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:planAddTime, @"planchecklist", nil];
	[notification setUserInfo:dict];
	[[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

// 取消闹钟提醒
+(void)removePlanAlert:(Plan*)plan
{
    // 行程的添加时间
    NSString *planAddTime = [NSDate stringFromDate:plan.addtime 
                                        withFormat: @"yyyyMMddHHmmssSSS"];
//    NSLog(@"plan add time is :%@", planAddTime);
    
	// 取消先前的通知
	NSArray *myArray=[[UIApplication sharedApplication] scheduledLocalNotifications];
	for (int i=0; i<[myArray count]; i++) {
		UILocalNotification	*myUILocalNotification=[myArray objectAtIndex:i];
		if ([[[myUILocalNotification userInfo] objectForKey:@"planchecklist"] isEqualToString:planAddTime]) {
			[[UIApplication sharedApplication] cancelLocalNotification:myUILocalNotification];
		}
	}
}

/* 进行中的判断逻辑
 1 出发时间在当前时间之后的
 2 check项目没有达到100％的
 YES 完了  NO 进行中
 */
+(BOOL)isOver:(Plan *) plan{
    BOOL isAllChecked = YES;
    NSOrderedSet *planItems = plan.planitems;
    for (PlanItem *planItem in planItems) {
        if (![planItem.ischecked boolValue]){
            isAllChecked = NO;
            break;
        }
    }
    if([plan.starttime timeIntervalSinceDate:[NSDate date]] > 0|| !isAllChecked){
        return NO;
    }else {
        return YES;
    }
}


// 创建邮件
+(MFMailComposeViewController*)createMailForPlan:(Plan*)plan
{
    MFMailComposeViewController *mailView = [self createMailFrom];
    // 设置邮件主题
    NSString *titileName = NSLocalizedString(@"CheckList", @"CheckList");  
    [mailView setSubject:titileName];
    
    // 设置邮件正文
	[mailView setMessageBody:[self getEmailBodyForPlan:plan] isHTML:NO];
    return mailView;
}

+(NSMutableString *)getEmailBodyForPlan:(Plan*)plan{
    
    // 邮件正文
	NSMutableString *emailBody = [[NSMutableString alloc] initWithString:@""];
    [emailBody appendFormat:@"%@:%@\n",NSLocalizedString(@"目的地", @"目的地"),plan.desadr==nil?@"":plan.desadr];
    [emailBody appendFormat:@"%@:%@ %@\n",NSLocalizedString(@"交通方式", @"交通方式"),[IGBusinessUtil getTrvalTypeImageNameForType:[plan.travltype intValue]],plan.travldetail==nil?@"":plan.travldetail];
    [emailBody appendFormat:@"%@:%@\n",NSLocalizedString(@"出发时间", @"出发时间"),plan.starttime==nil?@"":[NSDate stringFromDate:plan.starttime withFormat: NSLocalizedString(@"yyyy年MM月dd日 HH:mm", @"yyyy年MM月dd日 HH:mm 日期格式")]];
    [emailBody appendFormat:@"%@:%@\n",NSLocalizedString(@"住宿", @"住宿"),plan.hotelname==nil?@"":plan.hotelname];
    [emailBody appendFormat:@"%@:%@\n",NSLocalizedString(@"备注", @"备注"),plan.memo==nil?@"":plan.memo];
    [emailBody appendFormat:@"\%@\n------------------------------------------------\n",NSLocalizedString(@"CheckList", @"CheckList")];
    for (PlanItem *planitem in plan.planitems) {
        [emailBody appendFormat:@"%@%@\n",[planitem.ischecked boolValue]?@"■":@"□",planitem.item.itemname];
    }
    [emailBody appendString:@"------------------------------------------------\n"];
    [emailBody appendString:@"create by iguor(www.iguor.com)"];
    return emailBody;
}

// 如果不支持MFmail的情况下直接调用系统邮件
+(void)launchMailAppOnDevice:(Plan*)plan
{
	NSString *recipients = [NSString stringWithFormat:@"mailto:?subject=%@",NSLocalizedString(@"CheckList", @"CheckList")];
	NSString *body = [NSString stringWithFormat:@"&body=%@",[self getEmailBodyForPlan:plan]];
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

// 去评论页面
+(void)go2CommentApp:(NSInteger *) appId{
    NSString *str = [NSString stringWithFormat: 
                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d", appId];  
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

// 下载应用
+(void)go2DownLoadApp:(NSInteger *) appId {
    NSString *str = [NSString stringWithFormat: 
                     @"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%d", 
                     appId];  
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

// 去我们的网站
+(void)go2OurWebSite{
    NSString *str = NSLocalizedString(@"http://www.iguor.com", @"我们网站的地址");  
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

// 发邮件给我们
+(MFMailComposeViewController *)sendMailToOur{
    MFMailComposeViewController *mailView = [self createMailFrom];
    NSString *titileName = NSLocalizedString(@"意见", @"意见");  
    NSArray *toRecipients = [NSArray arrayWithObject: NSLocalizedString(@"iguorhelp@163.com", @"我们的客服邮箱")];    
    [mailView setToRecipients: toRecipients]; 
    [mailView setSubject:titileName];
    return mailView;
}

// 如果不支持MFmail的情况下直接调用系统邮件
+(void)launchMailAppOnDeviceToOur
{	
    NSString *recipients = [NSString stringWithFormat:@"mailto:%@?subject=%@",NSLocalizedString(@"igurhelp@163.com", @"我们的客服邮箱"),NSLocalizedString(@"意见", @"意见")];
	NSString *body = [NSString stringWithFormat:@"&body=%@",@""];
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

// 创建邮件发送窗口
+(MFMailComposeViewController *)createMailFrom{
    
    MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
    [mailView.navigationBar setBackgroundColor:[UIColor clearColor]];
    [mailView.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbarbak.png"] forBarMetrics:UIBarMetricsDefault];

    // 导航栏左边返回按钮
    UIButton *leftButton = [UIUtil buttonWithImage:@"goback.png" target:mailView.navigationBar.topItem.leftBarButtonItem.target  selector:mailView.navigationBar.topItem.leftBarButtonItem.action frame:CGRectMake(BarButtonLeftX, BarButtonLeftY, BarButtonLeftW, BarButtonLeftH)];
    mailView.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    // 导航右边的发送按钮(不能保留事件，原因待解决)
    //    UIButton *rightButton = [UIUtil buttonWithImage:@"finish.png" target:mailView.navigationBar.topItem.rightBarButtonItem.target selector:mailView.navigationBar.topItem.rightBarButtonItem.action frame:CGRectMake(BarButtonRightX, BarButtonRightY, BarButtonRightW, BarButtonRightH)];
    //    mailView.navigationBar.topItem.rightBarButtonItem.customView = rightButton;
    mailView.navigationBar.topItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    mailView.navigationBar.topItem.rightBarButtonItem.title = [IGBusinessUtil getMailImageName];
    return mailView;
}

// 取得提醒时间
+(NSInteger)getAlertTimeTravel{
    // 取得提醒时间
//    NSString *plistPath = [ [NSBundle mainBundle] pathForResource:@"setAlertTime"ofType:@"plist"];
//    NSMutableDictionary* alertdict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//    NSString* alertTime = [alertdict objectForKey:@"alertTime" ];
    Config *config = [IGCoreDataUtil getConfigInfoForKey:@"alarmTime"];
    if (config != nil) {
        NSLog(@"%d",[config.value integerValue]);
        return [config.value integerValue];
    }
    return 1800;
}

// 取得提醒message内容
+(NSString*)getAlertMessage{
    return [NSString stringWithFormat:NSLocalizedString(@"闹钟设定完成，将在出发前%@提醒。",@"闹钟设定完成，将在出发前30分钟提醒。"),[self changeAlertTimeTravelFormat]];
}

// 变换时间显示格式
+(NSString*)changeAlertTimeTravelFormat{
    return [NSString stringWithFormat:NSLocalizedString(@"%d小时%d分钟",@"%d小时%d分钟"),([self getAlertTimeTravel]%86400)/3600,([self getAlertTimeTravel]%3600)/60];
}
@end
