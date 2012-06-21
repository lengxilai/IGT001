//
//  IGA02ViewController.m
//  IGT001Local
//
//  Created by 鹏 李 on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGA02ViewController.h"

@implementation IGA02ViewController

static NSString *kCellIdentifier = @"MyIdentifier";
static NSString *kDepartureTimeKey = @"departuretime";
static NSString *kDestinationKey = @"destination";
static NSString *kFinishedKey = @"finished";
static NSString *kVehicleKey = @"vehicle";
static NSString *kViewControllerKey = @"viewController";

@synthesize rowDataSoures;
@synthesize plan;
@synthesize editing;

// 浏览进来设定为NO，新建进来设定为YES
- (id)initWithEditing:(BOOL)isEditing
{
    self = [super initWithStyle:UITableViewStylePlain];
    self.editing = isEditing;
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;   
        
        // 设定一个topPanel的初始高度
        memoTextViewHeight = A02MemoLabelH;
        
        // 键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark - 全局函数
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[IGPlanUtil createTemplateForName:@"旅游"]; 
    self.title = NSLocalizedString(@"行程", @"行程");
    if (editing && plan.addtime == nil) {
        self.title = NSLocalizedString(@"新建行程", @"新建行程");
    }
    
    // 导航右边的编辑按钮
    planEditButton = [UIUtil buttonWithImage:editing?@"finish.png":@"edit.png" target:self selector:@selector(editPlan:) frame:CGRectMake(BarButtonRightX, BarButtonRightY, BarButtonRightW, BarButtonRightH)];
    // 导航栏左边返回按钮
    gobackButton = [UIUtil buttonWithImage:@"goback.png" target:self selector:@selector(goBack:) frame:CGRectMake(BarButtonLeftX, BarButtonLeftY, BarButtonLeftW, BarButtonLeftH)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:gobackButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:planEditButton];
}    

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    // 每次开始时重新设定模板按钮的显示文字，否则在下一级模板画面删除模板之后这里仍然显示删除之前的模板名
    [templateButton setTitle:plan.template.templatename==nil?NSLocalizedString(@"没有模板", @"没有模板"):plan.template.templatename forState:UIControlStateNormal];
}

-(void)keyboardWillShow:(NSNotification *)notification
{   
	NSDictionary *userInfo = [notification userInfo];  
	NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];  
	CGRect keyboardRect = [aValue CGRectValue]; 
	
    CGRect frame = self.tableView.frame;
    CGFloat height = frame.size.height - keyboardRect.size.height;
    if (height > 0) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - keyboardRect.size.height);
                         } 
                         completion:^(BOOL finished){
                         }];
    }
}
-(void)keyboardWillHide:(NSNotification *)notification
{
    CGRect frame = self.tableView.frame;
	[UIView animateWithDuration:0.3
					 animations:^{
						 self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, TableViewHeight);
					 } 
					 completion:^(BOOL finished){
					 }];
}

#pragma mark - Make 其他计算用方法

-(CGFloat)getMemoTextViewHeight
{
    CGSize size = [plan.memo sizeWithFont:memoTextViewController.textView.font constrainedToSize:memoTextViewController.textView.contentSize lineBreakMode:UILineBreakModeWordWrap];
    return size.height;
}

// 计算有几个选中
-(NSInteger)getSelectedPlanItemCount
{
    NSOrderedSet *planItems = plan.planitems;
    
    NSInteger count = 0;
    for (PlanItem *planItem in planItems) {
        if ([planItem.ischecked boolValue]) {
            count++;
        }
    }
    return count;
}

#pragma mark - 创建表格各行的View

// 初始化TopPanel（行程基本信息）
-(UIView*)getTopPanelView
{
    // 不存在时才创建
    if (topPanelView != nil) {
        return topPanelView;
    }
    
    topPanelView = [[UIView alloc] initWithFrame:CGRectMake(A02TopPanelX, A02TopPanelY, A02TopPanelW, A02TopPanelH)];
    topPanelView.tag = TableViewCellTag;
    
    // 目的地
    IGLabel *desAdrTitleLabel = [[IGLabel alloc] initWithFrame:CGRectMake(A02DesAdrTitleLabelX, A02DesAdrTitleLabelY, A02DesAdrTitleLabelW, A02DesAdrTitleLabelH)];
    desAdrTitleLabel.textColor = [UIColor textPlanTopPanelColor];
    [topPanelView addSubview:desAdrTitleLabel];
    
    desAdrLabel = [[IGTextField alloc] initWithFrame:CGRectMake(A02DesAdrLabelX, A02DesAdrLabelY, A02DesAdrLabelW, A02DesAdrLabelH)];
    desAdrLabel.enabled = editing;
    desAdrLabel.delegate = self;
    desAdrLabel.font = [UIFont systemFontOfSize:20];
    desAdrLabel.textColor = [UIColor textPlanTopPanelColor];
    [topPanelView addSubview:desAdrLabel];
    
    // 发送邮件按钮
    NSString *mailImageName = [IGBusinessUtil getMailImageName];
    mailImage = [UIUtil buttonWithTitle:mailImageName target:self selector:@selector(sendMail:) frame:CGRectMake(265, A02DesAdrLabelY, 30, 30) image:nil];
    mailImage.titleLabel.font = [UIFont fontWithName:@"AppleColorEmoji" size:25];
    [topPanelView addSubview:mailImage];
    
    // 交通方式
    IGLabel *trvalTitleLabel = [[IGLabel alloc] initWithFrame:CGRectMake(A02TrvalTitleLabelX, A02TrvalTitleLabelY, A02TrvalTitleLabelW, A02TrvalTitleLabelH)];
    trvalTitleLabel.textColor = [UIColor textPlanTopPanelColor];
    [topPanelView addSubview:trvalTitleLabel];
    // 交通方式图片
    NSString *trvalTypeImageName = [IGBusinessUtil getTrvalTypeImageNameForType:[plan.travltype intValue]];
    trvalTypeImage = [UIUtil buttonWithTitle:trvalTypeImageName target:self selector:@selector(selectTrvalType:) frame:CGRectMake(A02TrvalTypeX, A02TrvalTypeY, A02TrvalTypeW, A02TrvalTypeH) image:nil];
    [topPanelView addSubview:trvalTypeImage];
    
    trvalLabel = [[IGTextField alloc] initWithFrame:CGRectMake(A02TrvalLabelX, A02TrvalLabelY, A02TrvalLabelW, A02TrvalLabelH)];
    trvalLabel.enabled = editing;
    trvalLabel.delegate = self;
    trvalLabel.textColor = [UIColor textPlanTopPanelColor];
    trvalLabel.font = [UIFont systemFontOfSize:20];
    [topPanelView addSubview:trvalLabel];
    
    // 出发时间
    IGLabel *startTitleLabel = [[IGLabel alloc] initWithFrame:CGRectMake(A02StartTitleLabelX, A02StartTitleLabelY, A02StartTitleLabelW, A02StartTitleLabelH)];
    startTitleLabel.textColor = [UIColor textPlanTopPanelColor];
    [topPanelView addSubview:startTitleLabel];
    
    startLabel = [[IGTextField alloc] initWithFrame:CGRectMake(A02StartLabelX, A02StartLabelY, A02StartLabelW, A02StartLabelH)];
    startLabel.enabled = editing;
    startLabel.textColor = [UIColor textPlanTopPanelColor];
    // 单击选择时间
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectStartDate:)];
    [startLabel addGestureRecognizer:singleTap];
    [topPanelView addSubview:startLabel];
    // 闹钟按钮
    alertCheckBox = [[IGCheckBox alloc] initWithFrame:CGRectMake(A02AlertCheckboxX, A02AlertCheckboxY, A02AlertCheckboxW, A02AlertCheckboxH) withImageName:@"alert" isChecked:[plan.isalarm boolValue] target:self selector:@selector(clickAlert:)];
    [topPanelView addSubview:alertCheckBox];
    
    // 住宿
    IGLabel *hotelTitleLabel = [[IGLabel alloc] initWithFrame:CGRectMake(A02HotelTitleLabelX, A02HotelTitleLabelY, A02HotelTitleLabelW, A02HotelTitleLabelH)];
    hotelTitleLabel.textColor = [UIColor textPlanTopPanelColor];
    [topPanelView addSubview:hotelTitleLabel];
    
    hotelLabel = [[IGTextField alloc] initWithFrame:CGRectMake(A02HotelLabelX, A02HotelLabelY, A02HotelLabelW, A02HotelLabelH)];
    hotelLabel.enabled = editing;
    hotelLabel.delegate = self;
    hotelLabel.textColor = [UIColor textPlanTopPanelColor];
    [topPanelView addSubview:hotelLabel];
    
    // 备注
    IGLabel *memoTitleLabel = [[IGLabel alloc] initWithFrame:CGRectMake(A02MemoTitleLabelX, A02MemoTitleLabelY, A02MemoTitleLabelW, A02MemoTitleLabelH)];
    memoTitleLabel.textColor = [UIColor textPlanTopPanelColor];
    [topPanelView addSubview:memoTitleLabel];
    
    memoTextViewController = [[IGTextViewController alloc] initWithFrame:CGRectMake(A02MemoLabelX, A02MemoLabelY, A02MemoLabelW, A02MemoLabelH) withText:plan.memo withFont:[UIFont systemFontOfSize:15]];
    memoTextViewController.textView.editable = editing;
    memoTextViewController.textView.textColor = [UIColor textPlanTopPanelColor];
    memoTextViewController.delegate = self;;
    [self.view addSubview:memoTextViewController.textView];
    
    desAdrTitleLabel.text = NSLocalizedString(@"目的地", @"目的地");
    trvalTitleLabel.text = NSLocalizedString(@"交通方式", @"交通方式");
    startTitleLabel.text = NSLocalizedString(@"出发时间", @"出发时间");
    hotelTitleLabel.text = NSLocalizedString(@"住宿", @"住宿");
    memoTitleLabel.text = NSLocalizedString(@"备注", @"备注");
    
    desAdrLabel.text = plan.desadr;
    trvalLabel.text = plan.travldetail;
    startLabel.text = [NSDate stringFromDate:plan.starttime 
                                  withFormat: NSLocalizedString(@"yyyy年MM月dd日 HH:mm", @"yyyy年MM月dd日 HH:mm 日期格式")];
    hotelLabel.text = plan.hotelname;
    
    return topPanelView;
}

// 取得checklist的标题行
-(UIView*)getCheckListHeaderView
{
    // 不存在时才创建
    if (checkListHeaderView != nil) {
        return checkListHeaderView;
    }
    checkListHeaderView = [[UIView alloc] initWithFrame:CGRectMake(A02CheckListHeaderViewX, A02CheckListHeaderViewY, A02CheckListHeaderViewW, A02CheckListHeaderViewH)];
    checkListHeaderView.tag = TableViewCellTag;
    
    // 编辑按钮
    checkListEditButton = [UIUtil buttonWithImage:@"edit.png" target:self selector:@selector(clickCheckListEditButton:) frame:CGRectMake(A02CheckListEditButtonX, A02CheckListEditButtonY, A02CheckListEditButtonW, A02CheckListEditButtonH)];
    [checkListHeaderView addSubview:checkListEditButton];
    checkListEditButton.hidden = (!editing);
    
    // 模板按钮
    templateButton = [UIUtil buttonWithTitle:plan.template.templatename target:self selector:@selector(clickTemplateButton:) frame:CGRectMake(A02TemplateButtonX, A02TemplateButtonY, A02TemplateButtonW, A02TemplateButtonH) image:@"button_bag.png"];
    [templateButton setTitleColor:[UIColor textWhiteColor] forState:UIControlStateNormal];
    [templateButton setTitle:plan.template.templatename==nil?NSLocalizedString(@"没有模板", @"没有模板"):plan.template.templatename forState:UIControlStateNormal];
    templateButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [checkListHeaderView addSubview:templateButton];
    templateButton.hidden = (!editing);
    
    // 保存模板按钮生成
    saveTemplateButton = [UIUtil buttonWithTitle:plan.template.templatename target:self selector:@selector(clickSaveTemplateButton:) frame:CGRectMake(A02SaveTemplateButtonX, A02SaveTemplateButtonY, A02SaveTemplateButtonW, A02SaveTemplateButtonH) image:@"button_bag.png"];
    [saveTemplateButton setTitleColor:[UIColor textWhiteColor] forState:UIControlStateNormal];
    [saveTemplateButton setTitle:NSLocalizedString(@"保存模板", @"保存模板") forState:UIControlStateNormal];
    saveTemplateButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [checkListHeaderView addSubview:saveTemplateButton];
    saveTemplateButton.hidden = (!editing);
    
    // 中间的选项切换生成
    NSArray *segmentTextContent = [NSArray arrayWithObjects: 
                                   NSLocalizedString(@"全部", @"全部")
                                   , NSLocalizedString(@"未选择", @"未选择")
                                   , nil];
    segmentedView = [[IGUISegmentedControl alloc] initWithRectAndItems:CGRectMake(A02SegmentedX, A02SegmentedY, A02SegmentedW, A02SegmentedH):segmentTextContent leftImage:@"switchblack_left" rightImage:@"switchblack_right" onColor:[UIColor whiteColor] offColor:[UIColor blackColor]];
    [[segmentedView leftButton] addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [[segmentedView rightButton] addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [segmentedView setFontSize:14];
    [checkListHeaderView addSubview:segmentedView.view];
    segmentedView.view.hidden = editing;
    
    // 标题
    checkListTitle = [[IGLabel alloc] initWithFrame:CGRectMake(A02CheckListTitleLabelX, A02CheckListTitleLabelY, A02CheckListTitleLabelW, A02CheckListTitleLabelH)];
    checkListTitle.text = NSLocalizedString(@"CheckList", @"CheckList");
    checkListTitle.font = [UIFont systemFontOfSize:19];
    checkListTitle.textColor = [UIColor textRedBlackColor];
    checkListTitle.hidden = editing;
    [checkListHeaderView addSubview:checkListTitle];
    
    // 选择件数的提示
    checkListCountLabel = [[IGLabel alloc] initWithFrame:CGRectMake(A02CheckListCountLabelX, A02CheckListCountLabelY, A02CheckListCountLabelW, A02CheckListCountLabelH)];
    checkListCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"(%d/%d件)", @"(%d/%d件) checklist的件数 a02页面"), [self getSelectedPlanItemCount], [plan.planitems count]];
    checkListCountLabel.hidden = editing;
    checkListCountLabel.textAlignment = UITextAlignmentRight;
    checkListCountLabel.textColor = [UIColor textGrayColor];
    // (19/100)以上显示不开修正
    checkListCountLabel.adjustsFontSizeToFitWidth = YES;
    
    [checkListHeaderView addSubview:checkListCountLabel];
    
    return checkListHeaderView;
}

// CheckList选择项的行
-(UIView*)getCheckItemViewForIndexPath:(NSIndexPath *)indexPath
{
    UIView *checkItemView = [[UIView alloc] initWithFrame:CGRectMake(A02CheckItemViewX, A02CheckItemViewY, A02CheckItemViewW, A02CheckItemViewH)];
    checkItemView.tag = TableViewCellTag;
    
    IGLabel *checkItemLabel = [[IGLabel alloc] initWithFrame:CGRectMake(A02CheckItemLabelX, A02CheckItemLabelY, A02CheckItemLabelW, A02CheckItemLabelH)];
    
    // 取得选项
    NSArray *planItemArray = [plan.planitems array];
    PlanItem *planItem = [planItemArray objectAtIndex:indexPath.row - 2];
    checkItemLabel.text = planItem.item.itemname;
    [checkItemView addSubview:checkItemLabel];
    
    IGCheckBox *checkBox = [[IGCheckBox alloc] initWithFrame:
                CGRectMake(A02CheckListCheckBoxX, A02CheckListCheckBoxY, A02CheckListCheckBoxW, A02CheckListCheckBoxH) withImageName:@"checkbox" isChecked:NO target:self selector:@selector(clickCheckListCheckBox:)];
    
    // 把行程的检查项设定给CheckBox，以便CheckBox点击时可以更新数据
    checkBox.checkItem = planItem;
    // 设定CheckBox的显示
    if ([planItem.ischecked boolValue]) {
        [checkBox check];
    }else {
        [checkBox unCheck];
    }
    
    checkBox.tag = CheckBox_Tag;
    [checkItemView addSubview:checkBox];
    
    return checkItemView;
}

#pragma mark - TextField代理 TextView代理
//按下Done按钮，键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// TextView高度变化时调用
- (void)textViewDidChangeHeight:(UITextView*)textView forHeight:(CGFloat)height
{
    memoTextViewHeight = height;
    
    UIView *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, A02TopPanelH - A02MemoLabelH + memoTextViewHeight)];
    // 刷新下一行，否则TextView会闪一下光标就没了
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0], nil] withRowAnimation:NO];
}

#pragma mark - 各个画面的回调函数
// 选择模板的回调方法
-(void)callbackSelectTemplate:(TemplateMaster*)templateMaster
{
    plan.template = templateMaster;
    // 设定模板名
    [templateButton setTitle:templateMaster.templatename forState:UIControlStateNormal];
    
    // 首先删除当前所有检查项目
    for (PlanItem *planItem in plan.planitems) {
        [plan removePlanitemsObject:planItem];
    }
    for (ItemMaster *item in templateMaster.items) {
        // 创建一个新的检查项目
        PlanItem *planItem = [IGBusinessUtil createPlanItemForItem:item forCheck:NO];
        // 添加新的检查项目
        [plan addPlanitemsObject:planItem];
    }
}

#pragma mark - 各个按钮点击动作
// 选项卡选择切换事件
- (void)segmentAction:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    // 节省资源，如果连续点击同一个按钮，不进行任何响应
    if(segmentedView.selectedIndex == button.tag){
        return;
    }
    [segmentedView changeState];
    [self.tableView reloadData];
}
// 点击闹钟按钮
-(void)clickAlert:(IGCheckBox*)checkbox
{
    // 只有编辑状态可以更改
    if (!editing) {
        return;
    }
    [checkbox changeState];
    plan.isalarm = [NSNumber numberWithBool:checkbox.isChecked];
}

// 选择交通方式
-(void)selectTrvalType:(id)sender
{   
    // 只有编辑状态可以更改
    if (!editing) {
        return;
    }
    NSArray *images = [IGBusinessUtil getAllTrvalTypeImage];
    NSString *title = NSLocalizedString(@"请选择交通方式", @"请选择交通方式");
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                       message:@"\n\n\n"
                                      delegate:self
                             cancelButtonTitle:NSLocalizedString(@"完成", @"")
                             otherButtonTitles: nil];
    
    UIView *frameView = [[UIView alloc] initWithFrame:CGRectMake(8, 43, 267, 72)];
    frameView.backgroundColor = [UIColor colorWithRed:0xF1	green:0xF1 blue:0xF1 alpha:0.6];
    frameView.layer.borderWidth = 2;
    frameView.layer.cornerRadius = 5;
    [alert addSubview:frameView];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(10+53*0, 47, 47, 63)];
    backgroundView.backgroundColor = [UIColor colorWithRed:0xF5	green:0xF4 blue:0xE7 alpha:0.9];
    backgroundView.layer.cornerRadius = 5;
    backgroundView.tag = 99;
    [alert addSubview:backgroundView];
    
    for (int i=0; i < [images count]; i++) {
        UIView *imageView = [images objectAtIndex:i];
        imageView.frame = CGRectMake(10+53*i, 60, 50, 60);
        imageView.userInteractionEnabled = YES;
        
        // 单击选择本项目
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTrvalTypeImage:)];
        [imageView addGestureRecognizer:singleTap];
        [alert addSubview:imageView];
    }
    [alert show];
}

// 选择交通方式图片之后
-(void)selectTrvalTypeImage:(UIGestureRecognizer *)gestureRecognizer 
{
    IGLabel *imageView = (IGLabel*)gestureRecognizer.view;
    
    // 设定交通方式的图片
    [trvalTypeImage setTitle:imageView.text forState:UIControlStateNormal];
    plan.travltype = [NSNumber numberWithInt:imageView.tag];

    // 对话框中的背景移动
    UIAlertView *alert = (UIAlertView*)[imageView superview];
    UIView *backView = [alert viewWithTag:99];
    [UIView animateWithDuration:0.2
                     animations:^{
                         backView.frame = CGRectMake(imageView.frame.origin.x, 47, 51, 63);
                     } 
                     completion:^(BOOL finished){
                     }];
}

// 选择时间
-(void)selectStartDate:(id)sender
{   
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
    actionSheet.frame = CGRectMake(DateSelectViewX, DateSelectViewY, DateSelectViewW, DateSelectViewH);
    UIDatePicker *datePicker=[[UIDatePicker alloc] init];
    datePicker.date=[NSDate date];
    datePicker.tag = DateSelectViewTag;
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    // 设定初始时间
    [datePicker setDate:plan.starttime == nil? [NSDate date] : plan.starttime];
    
    [actionSheet addSubview:datePicker];
    [actionSheet showInView:[self.view superview]];
}
// 日期选择OK之后
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIDatePicker *datePicker = (UIDatePicker*)[actionSheet viewWithTag:DateSelectViewTag];
    startLabel.text = [NSDate stringFromDate:datePicker.date 
                                  withFormat: NSLocalizedString(@"yyyy年MM月dd日 HH:mm", @"yyyy年MM月dd日 HH:mm 日期格式")];
}

// 点击模板按钮
-(void)clickTemplateButton:(UIButton*)button
{
    IGB02ViewController *b02ViewController = [[IGB02ViewController alloc] init];
    b02ViewController.preViewController = self;
    [self.navigationController pushViewController:b02ViewController animated:YES];
}

// 点击保存模板按钮
-(void)clickSaveTemplateButton:(UIButton*)button
{
    [self alertTemplateView];
}

// 点击CheckList编辑按钮
-(void)clickCheckListEditButton:(UIButton*)button
{
    // 去检查项编辑页面
    IGB01ViewController *b01ViewController = [[IGB01ViewController alloc] init];
    b01ViewController.preViewController = self;
    b01ViewController.plan = plan;
    [self.navigationController pushViewController:b01ViewController animated:YES];
    
}

// 点击CheckList的Checkbox
-(void)clickCheckListCheckBox:(UIButton*)button
{
    IGCheckBox *checkbox = (IGCheckBox *)button;
    [checkbox changeState];
    PlanItem *planItem = (PlanItem*)checkbox.checkItem;
    planItem.ischecked = [NSNumber numberWithBool:checkbox.isChecked];
    
    checkListCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"(%d/%d件)", @"(%d/%d件) checklist的件数 a02页面"), [self getSelectedPlanItemCount], [plan.planitems count]];
    
    NSError *error = nil;
    
    [self.tableView reloadData];
    
    // 编辑模式点击checkbox不保存，编辑模式只有在点击编辑完成按钮时保存
    if (editing) {
        return;
    }
    
    if (![[IGPlanUtil getStaticMoc] save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

// 点击返回按钮
-(void)goBack:(UIButton*)button
{
    // 如果新建并且没有保存过，则删除行程
    if (plan.addtime == nil) {
        [[IGPlanUtil getStaticMoc] deleteObject:plan];
        
        NSError *error = nil;
        if (![plan.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// 显示设定闹钟的信息
-(void)showAlertMessage
{
    
    UIAlertView* alertMessage = [[UIAlertView alloc] 
                                 initWithTitle:NSLocalizedString(@"闹钟设定",@"闹钟设定")
                                 message:[IGBusinessUtil getAlertMessage]  
                                 delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"完成", @"")
                                 otherButtonTitles:nil];
    [alertMessage show];
}

// 点击编辑按钮
-(void)editPlan:(UIButton*)button
{
    // 编辑完成，如果正在编辑，设定为不可编辑，把图片变为编辑按钮，并且保存
    if (editing) {
        self.title = NSLocalizedString(@"行程", @"行程");
        editing = NO;
        // CheckList编辑按钮隐藏
        checkListEditButton.hidden = YES;
        // 模板按钮
        templateButton.hidden = YES;
        // 保存模板按钮
        saveTemplateButton.hidden = YES;
        // CheckList件数显示
        checkListCountLabel.hidden = NO;
        // CheckList切换显示
        segmentedView.view.hidden = NO;
        // CheckList
        checkListTitle.hidden = NO;
        // 导航右边变为编辑按钮
        [planEditButton setBackgroundImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
        desAdrLabel.enabled = NO;
        trvalLabel.enabled = NO;
        startLabel.enabled = NO;
        hotelLabel.enabled = NO;
        memoTextViewController.textView.editable = NO;
        
        // 如果没有添加时间，则为新建
        if (plan.addtime == nil) {
            plan.addtime = [NSDate date];
        }
        
        plan.desadr = desAdrLabel.text;
        plan.travldetail = trvalLabel.text;
        plan.starttime = [NSDate dateFromString:startLabel.text withFormat:NSLocalizedString(@"yyyy年MM月dd日 HH:mm", @"yyyy年MM月dd日 HH:mm 日期格式")];
        plan.hotelname = hotelLabel.text;
        plan.memo = memoTextViewController.textView.text;
        
        // 刷新选择件数
        checkListCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"(%d/%d件)", @"(%d/%d件) checklist的件数 a02页面"), [self getSelectedPlanItemCount], [plan.planitems count]];
        // 如果设置了提醒，则重新设定提醒时间
        if ([plan.isalarm boolValue]) {
            [IGBusinessUtil addPlanAlert:plan];
            [self showAlertMessage];
        }else {
            [IGBusinessUtil removePlanAlert:plan];
        }
        
        NSError *error = nil;
        if (![[IGPlanUtil getStaticMoc] save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        // 刷新数据
        [self.tableView reloadData];
    }else {
        self.title = NSLocalizedString(@"编辑行程", @"编辑行程");
        // 开始编辑，如果不是正在编辑，设定为编辑状态，把图片变为完成按钮
        editing = YES;
        // CheckList编辑按钮显示
        checkListEditButton.hidden = NO;
        // 模板按钮
        templateButton.hidden = NO;
        // 保存模板按钮
        saveTemplateButton.hidden = NO;
        // CheckList件数隐藏
        checkListCountLabel.hidden = YES;
        // CheckList切换隐藏
        segmentedView.view.hidden = YES;
        // CheckList
        checkListTitle.hidden = YES;
        // 导航右边变为完成按钮
        [planEditButton setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
        
        desAdrLabel.enabled = YES;
        trvalLabel.enabled = YES;
        startLabel.enabled = YES;
        hotelLabel.enabled = YES;
        memoTextViewController.textView.editable = YES;
        
        // 切换到全部
        segmentedView.selectedIndex = 0;
        [segmentedView setState];
        // 刷新数据
        [self.tableView reloadData];
    }
}

#pragma mark - saveTemplate

// 确认是否保存模板
- (void) alertTemplateView {
    
    UIAlertView* templateAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"是否需要保存模板",@"是否需要保存模板")
                                                            message:@"\n\n\n"   
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"确认", @"确认") 
                                                  otherButtonTitles: NSLocalizedString(@"取消", @"取消"), nil];
    
    templateAlert.tag = 199;
    
    // 模板名称Lab
    IGLabel *templateSaveNameLab = [[IGLabel alloc] initWithFrame:CGRectMake(10, 56, 60, 20)];
    templateSaveNameLab.text = NSLocalizedString(@"模 板 名:", @"模板名称:");
    templateSaveNameLab.textColor = [UIColor whiteColor];
    templateSaveNameLab.adjustsFontSizeToFitWidth = YES;
    
    IGLabel *nameRequireMsg = [[IGLabel alloc] initWithFrame:CGRectMake(10, 76, 240, 23)];
    nameRequireMsg.text = NSLocalizedString(@"(模板名不能为空白)", @"(模板名不能为空白)");
    nameRequireMsg.textColor = [UIColor grayColor];
    nameRequireMsg.adjustsFontSizeToFitWidth = YES;
    
    // 模板名称TextField
    templateSaveNameTf = [[IGTextField alloc] initWithFrame:CGRectMake(68, 55, 160, 23)];
    templateSaveNameTf.tag = 198;
    
    templateSaveNameTf.text = plan.template.templatename==nil?@"":plan.template.templatename;
    templateSaveNameTf.textColor = [UIColor redColor];
    templateSaveNameTf.backgroundColor = [UIColor clearColor];
    
    // alert中add view
    [templateAlert addSubview:templateSaveNameLab];
    [templateAlert addSubview:nameRequireMsg];
    [templateAlert addSubview:templateSaveNameTf];
    
    [templateAlert show];
}

//  alert上的按钮触发事件的响应(确定按钮:buttonIndex=0  取消按钮:buttonIndex=1)
- (void) alertView:(UIAlertView *)alertview clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertview.tag == 199) {
        if (buttonIndex == 0) {
            // 模板名不能为空
            if (templateSaveNameTf.text == nil || [templateSaveNameTf.text isEqualToString:@""]) {
                [self alertTemplateView];
                return;
            }
            
            // 如果模板名有变更
            if ([self isTemplateNameChanged]) {
                // 模板名更改时新建一个模板
                [IGPlanUtil saveTemplateForName:templateSaveNameTf.text forItemMasterArray:[self getNewItemOfNewTemplate] forPlan:plan];
                // 更新模板按钮的文字
                [templateButton setTitle:templateSaveNameTf.text forState:UIControlStateNormal];
             } else {
                 // 模板名没改时更新模板的item
                 for (ItemMaster *itemMaster in plan.template.items) {
                     [plan.template removeItemsObject:itemMaster];
                 }
                 for (PlanItem *pl in plan.planitems) {
                     [plan.template addItemsObject: pl.item];
                 }
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
        }
        //[self.navigationController popViewControllerAnimated:YES];
    }
}

// 判断模板中的Item是否更改(更改:YES 没更改:NO)
- (BOOL) isItemsChanged {    
    
    // 变更前模板中的Item集合
    NSMutableArray *oldItemNameArray = [[NSMutableArray alloc] init];
    // 变更后模板中的Item集合
    NSMutableArray *newItemNameArray = [[NSMutableArray alloc] init];
    // 当前行程中选定模板的ItemMaster集合
    NSOrderedSet *oldItemSet = plan.template.items;
    // 当前行程中选定的PlanItem集合
    NSOrderedSet *newItemSet = plan.planitems;
    
    for (ItemMaster *itemMaster in oldItemSet) {
        [oldItemNameArray addObject:itemMaster.itemname];
    }
    for (PlanItem *pl in newItemSet) {
        [newItemNameArray addObject:pl.item.itemname];
    }
    
    return ![newItemNameArray isEqualToArray:oldItemNameArray];
}

// 判断是否已经存在模板(有:YES  无:NO)
- (BOOL) hadTemplateYet {
    return plan.template != nil;
}

// 保存模板时，判断模板名称是否发生变化(变化:YES  没变:NO)
- (BOOL) isTemplateNameChanged {
    return ![templateSaveNameTf.text isEqualToString:plan.template.templatename];
}

// 取得
- (NSMutableArray *)getNewItemOfNewTemplate {
    NSMutableArray *itemMasterArray = [[NSMutableArray alloc] init] ;
    for (PlanItem *pl in plan.planitems) {
        [itemMasterArray addObject:pl.item];
    }
    return itemMasterArray;

}
             
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3 + [plan.planitems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    UIView *cellView = [cell.contentView viewWithTag:TableViewCellTag];
    if (cellView != nil) {
        [cellView removeFromSuperview];
    }
    
    // 基本信息
    if (indexPath.row == 0) {
        UIView *topPanel = [self getTopPanelView];
        [cell.contentView addSubview:topPanel];
//        cell.contentView.backgroundColor = [UIColor topPanelBackgroundImageColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:editing?@"toppanelbak_edit.png":@"toppanelbak.png"] stretchableImageWithLeftCapWidth:100 topCapHeight:100]];
    }
    
    // CheckListHeader
    if (indexPath.row == 1) {
        UIView *checkListHeader = [self getCheckListHeaderView];
        [cell.contentView addSubview:checkListHeader];
        cell.contentView.backgroundColor = [UIColor checklistBackroundImageColor];
    }
    
    // CheckListItem
    if (indexPath.row > 1 && indexPath.row < 2 + [plan.planitems count]) {
        
        if (segmentedView.selectedIndex == 1) {
            NSArray *items = [plan.planitems array];
            if ([((PlanItem*)[items objectAtIndex:indexPath.row-2]).ischecked boolValue]) {
                return cell;
            }
        }
        
        UIView *checkItemView = [self getCheckItemViewForIndexPath:indexPath];
        [cell.contentView addSubview:checkItemView];
        cell.contentView.backgroundColor = [UIColor checklistLineBackgroundImageColor];
    }
    
    // Footer
    if (indexPath.row == 2 + [plan.planitems count]) {
        cell.contentView.backgroundColor = [UIColor checklistFooterBackgroundImageColor];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 编辑模式点击不进行checkbox选中
    if (editing) {
        return;
    }
    // CheckListItem
    if (indexPath.row > 1 && indexPath.row < 2 + [plan.planitems count]) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        IGCheckBox *checkbox = (IGCheckBox*)[[cell.contentView viewWithTag:TableViewCellTag] viewWithTag:CheckBox_Tag];
        // 正常不应该为nil
        if (checkbox == nil) {
            return;
        }
        [checkbox changeState];
        PlanItem *planItem = (PlanItem*)checkbox.checkItem;
        planItem.ischecked = [NSNumber numberWithBool:checkbox.isChecked];
        
        checkListCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"(%d/%d件)", @"(%d/%d件) checklist的件数 a02页面"), [self getSelectedPlanItemCount], [plan.planitems count]];
        
        NSError *error = nil;
        
        [self.tableView reloadData];
        
        if (![[IGPlanUtil getStaticMoc] save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        // 先创建TopPanelView，以便计算Memo高度，不能在init创建，因为init时没有plan
        [self getTopPanelView];
        return A02TopPanelH - A02MemoLabelH + memoTextViewController.textView.frame.size.height;
    }
    
    if (indexPath.row == 1) {
        return A02CheckListHeaderViewH;
    }
    
    if (indexPath.row == 2 + [plan.planitems count]) {
        return A02CheckListFooterH;
    }
    
    if (segmentedView.selectedIndex == 1) {
        NSArray *items = [plan.planitems array];
        if ([((PlanItem*)[items objectAtIndex:indexPath.row-2]).ischecked boolValue]) {
            return 0;
        }
    }
    return A02CheckListLineHeight;
}

#pragma mark - send mail
// 点击发送邮件按钮
-(void)sendMail:(UIButton*)button
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		if ([mailClass canSendMail])
		{
			MFMailComposeViewController *mailView = [IGBusinessUtil createMailForPlan:plan];
            mailView.mailComposeDelegate = self;
            [self presentModalViewController:mailView animated:YES];
		}
		else
		{
			[IGBusinessUtil launchMailAppOnDevice:plan];
		}
	}
	else
	{
		[IGBusinessUtil launchMailAppOnDevice:plan];
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
@end
