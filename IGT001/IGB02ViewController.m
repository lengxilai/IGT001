//
//  IGB02ViewController.m
//  IGT001Local
//
//  Created by wu jiabin on 12-4-30.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "IGB01ViewController.h"
#import "IGB02ViewController.h"
#import "IGPlanUtil.h"
#import "IGCoreDataUtil.h"

@implementation IGB02ViewController

@synthesize fetchedResultsController = fetchedResultsController;
@synthesize preViewController;
@synthesize fromFlag;

#pragma mark -
#pragma mark view初始化

- (id) init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor]; 
        // 头部背景区域设置
        UIImageView *headerBak = [[UIImageView alloc] initWithFrame:CGRectMake(A01TableViewHeaderX, A01TableViewHeaderY, A01TableViewHeaderW, A01TableViewHeaderH) ];
        headerBak.image = [UIImage imageNamed:@"planlistheadbak.png"];
        [self.view addSubview: headerBak];

        // 底部背景区域设置
        UIImageView *footerBak = [[UIImageView alloc] initWithFrame:CGRectMake(A01TableViewFooterX, A01TableViewFooterY, A01TableViewFooterW, A01TableViewFooterH)];
        footerBak.image = [UIImage imageNamed:@"planlistfootbak.png"];
        [self.view addSubview: footerBak];

        IGTableView = [[UITableView alloc] initWithFrame:CGRectMake(B02TableViewX, B02TableViewY, B02TableViewW, B02TableViewH) style:UITableViewStylePlain];
        IGTableView.rowHeight = B02CellHeight;
        IGTableView.backgroundColor = [UIColor templatelistBackgroundImageColor];
        IGTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [IGTableView setDelegate:self];
        [IGTableView setDataSource:self];
        
        [self.view addSubview:IGTableView];
        
        // 导航栏左边返回按钮
        UIButton *gobackButton = [UIUtil buttonWithImage:@"goback.png" target:self selector:@selector(goBack:) frame:CGRectMake(BarButtonLeftX, BarButtonLeftY, BarButtonLeftW, BarButtonLeftH)];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:gobackButton];
        self.title = NSLocalizedString(@"模板", @"模板");
    }
    
    // 键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    return self;
}

#pragma mark - 全局函数
- (void)viewWillAppear:(BOOL)animated{
    
    [IGTableView reloadData];
}

-(void)keyboardWillShow:(NSNotification *)notification
{   
	NSDictionary *userInfo = [notification userInfo];  
	NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];  
	CGRect keyboardRect = [aValue CGRectValue]; 
	
    CGRect frame = IGTableView.frame;
    CGFloat height = frame.size.height - keyboardRect.size.height + B02TableViewOffset;
    if (height > 0) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             IGTableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
                         } 
                         completion:^(BOOL finished){
                             if (currentTextField != nil) {
                                 
                                 UITableViewCell *cell = (UITableViewCell *)[[[currentTextField superview] superview] superview];
                                 NSIndexPath *indexPath = [IGTableView indexPathForCell:cell];
                                 [IGTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                             }
                         }];
    }
}
-(void)keyboardWillHide:(NSNotification *)notification
{
    CGRect frame = IGTableView.frame;
	[UIView animateWithDuration:0.3
					 animations:^{
						 IGTableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, B02TableViewHeight);
					 } 
					 completion:^(BOOL finished){
					 }];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // 取得模板结果集
    NSError *error = nil;
    if (![[self getTemplate] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

}

#pragma mark -
#pragma mark tableview操作相关

// 取得section数目
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// 取得待显示行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getRow] + 1;
}

// cell中要显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // Liuming 上面的大括号原来在最后，挪到这里了，如果在最后的话，只有在cell为nil时才更新内容，所以会错乱
    
    // Liuming 把cell的文本设定为空
    cell.textLabel.text = @"";
    // Liuming 用TableViewCellTag取得之前的view
    UIView *cellView = [cell.contentView viewWithTag:TableViewCellTag];
    // Liuming 如果能取得到，则删除之前的view
    if (cellView != nil) {
        [cellView removeFromSuperview];
    }

    // Liuming 下面的代码整体向左缩进，以前在if (cell == nil) {里面，所以会错乱
    // 最后一行添加模板
    if (indexPath.row < [self getRow]) {            

        UIView *templateContentView = [self getTemplateView:indexPath];
        [cell.contentView addSubview:templateContentView];
        
    } else {
        // 从行程画面过来不显示[添加模板]按钮
        if (![preViewController isKindOfClass:[IGA02ViewController class]] && ![[self fromFlag] isEqualToString:@"noAddTemplate"]) {
            
            UIView *addTemplateView = [self getAddTemplateView];
            
            // Liuming以前是[cell addSubView，应该是[cell.contentView addSubView
            [cell.contentView addSubview:addTemplateView];
        }
    }
    return cell;
}

// 点击cell事件的响应规则
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取得选择的模板
    TemplateMaster *template;
    if (indexPath.row == [self getRow]) {
        template = nil;
    } else {
        template = (TemplateMaster *)[fetchedResultsController objectAtIndexPath:indexPath];
    }

    // 从行程编辑过来时
    if ([preViewController isKindOfClass:[IGA02ViewController class]]) {
        
        if (template != nil) {
            // 回调函数
            IGA02ViewController *a02ViewController = (IGA02ViewController*)preViewController;
            [a02ViewController callbackSelectTemplate:template];
        }
        
        // 返回行程编辑画面
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    // 从项目列表过来
    if ([preViewController isKindOfClass:[IGB01ViewController class]]) {
        
        if (template != nil) {
            IGB01ViewController *b01ViewController = (IGB01ViewController*)preViewController ;
            [b01ViewController callbackSelectTemplate:template];
            
        }
        // 返回项目列表
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    // 去检查项编辑页面
    if (indexPath.row < [self getRow]) {
        IGB01ViewController *b01ViewController = [[IGB01ViewController alloc] init];
        b01ViewController.preViewController = self;
        [b01ViewController setTemplateMaster:template];
        [self.navigationController pushViewController:b01ViewController animated:YES];
    }
    
}

// 对cell编辑(删除，添加)
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
        [context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
            
        NSError *error = nil;
        if (![context save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

// 判断tableview中的cell是否可以删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self getRow]) {
        return YES;
    } else {
        // 添加模板cell不可滑动删除
        return NO;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTextField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{;
    currentTextField = nil;
}

//按下Done按钮，键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    currentTextField = nil;
    return YES;
}

#pragma mark -
#pragma mark NSFetchedResultsController操作

// 列表编辑
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[IGTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = IGTableView;
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
            
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[IGTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[IGTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[IGTableView endUpdates];
}

#pragma mark -
#pragma mark 数据库中检索模板相关

// 取得全部模板
- (NSFetchedResultsController *) getTemplate {
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    // 排序规则 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"addtime" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    NSFetchedResultsController *b02FetchResultsController = [IGCoreDataUtil queryForFetchedResult:@"TemplateMaster" queryCondition:nil sortDescriptors:sortDescriptors];
    b02FetchResultsController.delegate = self;
    fetchedResultsController = b02FetchResultsController;
    
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
    }
    
    return fetchedResultsController;
}

// 取得检索到的模板个数
- (NSInteger) getRow {
    NSInteger row = 0;
    if ([[fetchedResultsController sections] count] > 0) {
        row = [[[fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    }
    return row;
}

// 去item详细画面(添加完模板先不去详细画面了)
- (void) gotob01 {
    if (addTextField.text == nil || [addTextField.text isEqualToString:@""]) {
        
        UIAlertView* warnAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"请输入模板名称", @"请输入模板名称 模板画面模板名为空的提示")
                                                                message:@""   
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"确认", @"确认") 
                                                      otherButtonTitles:nil];
        [warnAlert show];
    } else {
        TemplateMaster *template = [IGPlanUtil createTemplateByName:addTextField.text];
        addTextField.text = @"";
        IGB01ViewController *b01ViewController = [[IGB01ViewController alloc] init];
        b01ViewController.preViewController = self;
        [b01ViewController setTemplateMaster:template];
        [IGTableView reloadData];
    }

}

// 取得添加模板文本框视图
- (UIView *) getTemplateView:(NSIndexPath *)indexPath{
    TemplateMaster *template = (TemplateMaster *)[fetchedResultsController objectAtIndexPath:indexPath];
    // 模板名View
    UIView *templateContentView = [[UIView alloc] initWithFrame:CGRectMake(B02TemplateX, B02TemplateY, B02TemplateW, B02TemplateH)];
    // 模板名Lab
    IGLabel *temlateNameLab = [[IGLabel alloc] initWithFrame:CGRectMake(B02TemplateNameX, B02TemplateNameY, B02TemplateNameW, B02TemplateNameH)];
    // 取得件数Lab
    IGLabel *itemsCountLab = [[IGLabel alloc] initWithFrame:CGRectMake(B02ItemsCountX, B02ItemsCountY, B02ItemsCountW, B02ItemsCountH)];
    [itemsCountLab setTextAlignment:UITextAlignmentRight];
//    // item详细画面button
//    UIButton *nextButton = [UIUtil buttonWithImage:@"next.png" target:self selector:nil frame:CGRectMake(B02NextButtonX, B02NextButtonY, B02NextButtonW, B02NextButtonH)];
    temlateNameLab.text = template.templatename;
    itemsCountLab.text = [NSString stringWithFormat:@"%d件", [self getItemsCount:template]];
    itemsCountLab.textColor = [UIColor grayColor];
    [templateContentView addSubview:temlateNameLab];
    [templateContentView addSubview:itemsCountLab];
//    [templateContentView addSubview:nextButton];
    templateContentView.tag = TableViewCellTag;
    return templateContentView;
}

// 取得添加模板文本框视图
- (UIView *) getAddTemplateView {
    // 设置文本框
    addTextField = [[IGTextField alloc] initWithFrame:CGRectMake(B02AddTemplateX, B02AddTemplateY, B02AddTemplateW, B02AddTemplateH)];
    addTextField.delegate = self;//设置delegate
    [addTextField setPlaceholder:NSLocalizedString(@"请输入新模板名....", @"请输入新模板名....")];
    UIButton *editButton = [UIUtil buttonWithImage:@"finish.png" target:self selector:@selector(gotob01) frame:CGRectMake(B02AddTemplateButtonX, B02AddTemplateButtonY, B02AddTemplateButtonW, B02AddTemplateButtonH)];
    
    UIView *addTemplateView = [[UIView alloc] initWithFrame:CGRectMake(B02AddTemplateViewX, B02AddTemplateViewY, B02AddTemplateViewW, B02AddTemplateViewH)];
    // Liuming 给addTemplateView设定Tag为TableViewCellTag
    addTemplateView.tag = TableViewCellTag;
    [addTemplateView addSubview:addTextField];
    [addTemplateView addSubview:editButton];
    
    return addTemplateView;
}

// 取得模板中有多少Item
- (NSInteger) getItemsCount:(TemplateMaster *) template {
    NSInteger count = 0;
    for (ItemMaster *item in template.items) {
        count ++;
    }
    return count;
}
// 点击返回按钮
- (void)goBack:(UIButton*)button
{
    NSError *error = nil;
    if (![[IGPlanUtil getStaticMoc] save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
