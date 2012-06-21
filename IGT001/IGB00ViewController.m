//
//  IGB00ViewController.m
//  IGT001
//
//  Created by wu jiabin on 12-5-23.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "IGB00ViewController.h"

@implementation IGB00ViewController

@synthesize b02ViewController;
@synthesize b03ViewController;
- (id)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor]; 
        // 头部背景区域设置
        UIImageView *headerBak = [[UIImageView alloc] initWithFrame:CGRectMake(B00TableViewBackX, B00TableViewBackY, B00TableViewBackW, B00TableViewBackH) ];
        headerBak.image = [UIImage imageNamed:@"b00background.png"];
        [self.view addSubview: headerBak];
        
        // 数据显示区域
        IGTableView = [[UITableView alloc] initWithFrame:CGRectMake(B00TableViewX, B00TableViewY, B00TableViewW, B00TableViewH) style:UITableViewStylePlain];
        IGTableView.backgroundColor = [UIColor clearColor];
        //IGTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [IGTableView setDelegate:self];
        [IGTableView setDataSource:self];
        [self.view addSubview:IGTableView];
        
        
        // 导航栏左边返回按钮
        UIButton *gobackButton = [UIUtil buttonWithImage:@"goback.png" target:self selector:@selector(goBack:) frame:CGRectMake(BarButtonLeftX, BarButtonLeftY, BarButtonLeftW, BarButtonLeftH)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:gobackButton];
        self.title = NSLocalizedString(@"设置", @"设置");
    }

    return self;
}

// 取得section数目
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// 取得待显示行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

// cell中要显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }

    UIView *contentView = [cell viewWithTag:TableViewCellTag];
    if (contentView == nil) {
        [self setContentWithIndexPath:cell.contentView :indexPath];
    }

    [self editListCellView:cell.contentView forIndex:indexPath];
    return cell;
}

#pragma mark 创建各个View
-(void)setContentWithIndexPath:(UIView*) contentView:(NSIndexPath *)indexPath
{
    // cell的内容生成
    contentView.tag = TableViewCellTag;
    
    // 前5行的显示内容生成
    if(indexPath.row < 4){
        
        // 联系我们和评价我们行，图片使用表情文字
        if(indexPath.row == 3 || indexPath.row == 4){
            IGLabel *startLabel = [[IGLabel alloc] initWithFrame:CGRectMake(B00CellStartLabelX, B00CellStartLabelY, B00CellStartLabelW, B00CellStartLabelH)];
            startLabel.tag = BOOCellStartLabelTag;
            startLabel.font = [UIFont fontWithName:@"AppleColorEmoji" size:30];
            [contentView addSubview:startLabel];
        }else{
        // 其他行使用图片显示，都使用表情文字时候可以删去
            UIImageView *startImage = [[UIImageView alloc] initWithFrame:CGRectMake(B00CellStartImageX, B00CellStartImageY, B00CellStartImageW, B00CellStartImageH)];
            startImage.tag = BOOCellStartImageTag;
            [contentView addSubview:startImage];
        }
        
        // 说明文字显示区域
        IGLabel *titleLabel = [[IGLabel alloc] initWithFrame:CGRectMake(B00CellTitleX, B00CellTitleY, B00CellTitleW, B00CellTitleH)];
        titleLabel.tag = BOOCellTitleTag;
        [contentView addSubview:titleLabel];
        
        // 最后的标示图片显示区域，要不要需要检讨
        UIImageView *endImage = [[UIImageView alloc] initWithFrame:CGRectMake(B00CellEndImageX, B00CellEndImageY, B00CellEndImageW, B00CellEndImageH)];
        endImage.tag = BOOCellEndImageTag;
        [contentView addSubview:endImage];
    }
    
    // 其他应用行生成
    if(indexPath.row == 4){
        //bakView.image = [UIImage imageNamed:@"classlistforcellbck.png"];
        
        IGLabel *startLabel = [[IGLabel alloc] initWithFrame:CGRectMake(B00CellStartLabelX, B00CellStartLabelY, B00CellStartLabelW, B00CellStartLabelH)];
        startLabel.tag = BOOCellStartLabelTag;
        startLabel.font = [UIFont systemFontOfSize:20];
        startLabel.textColor = [UIColor grayColor];
        [contentView addSubview:startLabel];
    }
    
    // 应用介绍行的生成
    if(indexPath.row > 4){
        //bakView.image = [UIImage imageNamed:@"classlistforcellbck.png"];
        //bakView.frame = CGRectMake(5,39,280, 35);
        
        // 图片显示区域生成
        UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(B00CellAppImageX, B00CellAppImageY, B00CellAppImageW, B00CellAppImageH)];
        imageView.tag = BOOCellStartImageTag;
        [contentView addSubview:imageView]; 
        
        // 应用名字显示区域
        IGLabel *label = [[IGLabel alloc] initWithFrame:CGRectMake(B00CellAppNameX, B00CellAppNameY, B00CellAppNameW, B00CellAppNameH)];
        label.tag = BOOCellTitleTag;
        label.font = [UIFont systemFontOfSize:20];
        [contentView addSubview:label];
        
        // 应用介绍区域
        UITextView *textView=[[UITextView alloc] initWithFrame:CGRectMake(B00CellAppMemoX, B00CellAppMemoY, B00CellAppMemoW, B00CellAppMemoH)];
        textView.tag = BOOCellMemoTextFieldTag;
        textView.editable = NO;
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [UIColor grayColor];
        textView.textAlignment = UITextAlignmentLeft;
        textView.font = [UIFont systemFontOfSize:13];
        [contentView addSubview:textView];
    }
    
}

-(void)editListCellView:(UIView*)view forIndex:(NSIndexPath *)indexPath
{
    // 说明文字
    IGLabel *titleLabel = (IGLabel *)[view viewWithTag:BOOCellTitleTag];
    // 表情文字显示区域
    IGLabel *startLabel = (IGLabel *)[view viewWithTag:BOOCellStartLabelTag];
    // 行开始图标
    UIImageView *startImage = (UIImageView *)[view viewWithTag:BOOCellStartImageTag];
    // 行结束图标
    UIImageView *endImage = (UIImageView *)[view viewWithTag:BOOCellEndImageTag];
    // 应用说明文字
    UITextView *appMemo =  (UITextView *)[view viewWithTag:BOOCellMemoTextFieldTag];
    switch (indexPath.row) {
        case 0:
            startImage.image = [UIImage imageNamed:@"add.png"];
            endImage.image = [UIImage imageNamed:@"next.png"];
            titleLabel.text = NSLocalizedString(@"设置模板", @"设置模板");
            break;
        case 1:
            startImage.image = [UIImage imageNamed:@"alert_on.png"];
            endImage.image = [UIImage imageNamed:@"next.png"];
            //titleLabel.text = NSLocalizedString(@"设置闹钟", @"设置闹钟");
            titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"当前提醒时间为出发前%@", @"当前提醒时间为出发前%@"),[IGBusinessUtil changeAlertTimeTravelFormat]];
            break;
        case 2:
            startImage.image = [UIImage imageNamed:@"pens.png"];
            endImage.image = [UIImage imageNamed:@"next.png"];
            titleLabel.text = NSLocalizedString(@"现在评价", @"现在评价");
            break;
        case 3:
            endImage.image = [UIImage imageNamed:@"next.png"];
            startLabel.text = [IGBusinessUtil getMailImageName];
            titleLabel.text = NSLocalizedString(@"联系我们", @"联系我们");
            break;
//        case 4:
//            endImage.image = [UIImage imageNamed:@"next.png"];
//            startLabel.text = [IGBusinessUtil getFollowImageName];
//            titleLabel.text = NSLocalizedString(@"关注我们", @"关注我们");
//            break;
        case 4:
            startLabel.text = NSLocalizedString(@"其他应用", @"其他应用");
            break;;
        case 5:
            titleLabel.text = NSLocalizedString(@"十年日记", @"十年日记");
            appMemo.text = NSLocalizedString(@"将十年中的每一天写在同一页，每一页纪录了十年中的同一天.", @"十年日记介绍");
            startImage.image = [UIImage imageNamed:@"tenyeardiaryicon.png"];
            break;
        default:
            break;
    }
}

// 点击cell事件的响应规则
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row]) {
        case 0:
            [self go2B02];
            break;
        case 1:
            //[self go2B03];
            [self selectAlertTimeTravel];
            break;
        case 2:
            // 评价应用
            [IGBusinessUtil go2CommentApp:AppID_TripChecker];
            break;
        case 3:
            // 发送邮件给我们
            [self sendMail];
            break;
//        case 4:
//            [IGBusinessUtil go2OurWebSite];
//            break;
        case 5:
            // 下载十年应用
            [IGBusinessUtil go2DownLoadApp:AppID_TenYearsDiary];
            break;
        default:
            break;
    }
    
}

// 新规追加按钮 go2B02
- (void)go2B02
{
    self.b02ViewController = [[IGB02ViewController alloc] init];
    [self.navigationController pushViewController:self.b02ViewController animated:YES];
}

// 去闹钟设置页面
- (void)go2B03 {
    self.b03ViewController = [[IGB03ViewController alloc] init];
    [self.navigationController pushViewController:self.b03ViewController animated:YES];
}

// 点击返回按钮
- (void)goBack:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row==5?B00AppCellHeight:B00CellHeight;
}

#pragma mark - send mail
// 点击发送邮件按钮
-(void)sendMail
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		if ([mailClass canSendMail])
		{
			MFMailComposeViewController *mailView = [IGBusinessUtil sendMailToOur];
            mailView.mailComposeDelegate = self;
            [self presentModalViewController:mailView animated:YES];
		}
		else
		{
			[IGBusinessUtil launchMailAppOnDeviceToOur];
		}
	}
	else
	{
		[IGBusinessUtil launchMailAppOnDeviceToOur];
	}
}
// 发送邮件的后处理
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	// 邮件发送提示信息
    NSString *message = nil;
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			message = NSLocalizedString(@"邮件保存成功",@"邮件保存成功");
			break;
		case MFMailComposeResultSent:
			message = NSLocalizedString(@"邮件发送成功",@"邮件发送成功");
			break;
		case MFMailComposeResultFailed:
			message = NSLocalizedString(@"邮件发送失败",@"邮件发送失败");
			break;
		default:
			message = NSLocalizedString(@"邮件发送失败",@"邮件发送失败");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
    if(message != nil){
        UIAlertView* alertMessage = [[UIAlertView alloc] 
                                     initWithTitle:NSLocalizedString(@"邮件提示",@"邮件提示")
                                     message:message   
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"完成", @"")
                                     otherButtonTitles:nil];
        [alertMessage show]; 
    }
}
#pragma mark - 选择提醒时间
// 选择时间
-(void)selectAlertTimeTravel{   
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
    actionSheet.frame = CGRectMake(DateSelectViewX, DateSelectViewY, DateSelectViewW, DateSelectViewH);
    UIDatePicker *datePicker=[[UIDatePicker alloc] init];
    datePicker.date=[NSDate date];
    datePicker.tag = DateSelectViewTag;
    datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    // 设定初始时间
    [datePicker setCountDownDuration:[IGBusinessUtil getAlertTimeTravel]];
    [actionSheet addSubview:datePicker];
    [actionSheet showInView:[self.view superview]];
}
// 日期选择OK之后
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 保存到配置文件里
//    UIDatePicker *datePicker = (UIDatePicker*)[actionSheet viewWithTag:DateSelectViewTag];
//    NSString *plistPath = [ [NSBundle mainBundle] pathForResource:@"setAlertTime"ofType:@"plist"];
//    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//    [dict setObject:[NSString stringWithFormat:@"%d",(int)[datePicker countDownDuration]] forKey:@"alertTime" ];
//    
//    [dict writeToFile:plistPath atomically:YES];
    
    // 保存到DB
    UIDatePicker *datePicker = (UIDatePicker*)[actionSheet viewWithTag:DateSelectViewTag];
    [self updateConfigTBL:[NSString stringWithFormat:@"%d",(int)[datePicker countDownDuration]]];
    
    // 更改页面
    IGLabel *titleLabel = (IGLabel *)[[IGTableView cellForRowAtIndexPath:[IGTableView indexPathForSelectedRow]] viewWithTag:BOOCellTitleTag];
    titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"当前提醒时间为出发前%@", @"当前提醒时间为出发前%@"),[IGBusinessUtil changeAlertTimeTravelFormat]];
    
    // 更改全部进行中计划的提醒时间 未完成
    NSFetchRequest *request=[[NSFetchRequest alloc] init]; 
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Plan" inManagedObjectContext:[IGPlanUtil getStaticMoc]]; 
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *results=[[[IGCoreDataUtil getStaticManagedObjectContext] executeFetchRequest:request error:&error] copy];
    
    for (Plan *plan in results){
        // 如果已经完成或者为设置提醒则处理下一条
        if([IGBusinessUtil isOver:plan] || ![plan.isalarm boolValue]){
            continue;
        }
        [IGBusinessUtil addPlanAlert:plan];        
    }
}

-(void)updateConfigTBL:(NSString *)alarmtime{
    
    Config *config = [IGCoreDataUtil getConfigInfoForKey:@"alarmTime"];
    
    // 如果没有配置信
    if (config != nil) {
        config.value = alarmtime;
    }else{
        Config *newConfig = [NSEntityDescription insertNewObjectForEntityForName:@"Config" inManagedObjectContext:[IGCoreDataUtil getStaticManagedObjectContext]];
        newConfig.key = @"alarmTime";
        newConfig.value = alarmtime;
    }
    NSError *error = nil;
    if (![[IGCoreDataUtil getStaticManagedObjectContext]save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}
@end
