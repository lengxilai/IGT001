//
//  IGA01ViewController.m
//  IGT001Local
//
//  Created by 鹏 李 on 12-4-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGA01ViewController.h"

@implementation IGA01ViewController


@synthesize a02ViewController;
@synthesize b00ViewController;
@synthesize fetchedResultsController;
@synthesize segmentedView;
@synthesize IGTableView;
// 自定义初始化函数
- (id)init
{
    self = [super init];
    if (self) {
        
        // 头部背景区域设置
        UIImageView *headerBak = [[UIImageView alloc] initWithFrame:CGRectMake(A01TableViewHeaderX, A01TableViewHeaderY, A01TableViewHeaderW, A01TableViewHeaderH) ];
        headerBak.image = [UIImage imageNamed:@"planlistheadbak.png"];
        
        // 底部背景区域设置
        [self.view addSubview: headerBak];
        UIImageView *footerBak = [[UIImageView alloc] initWithFrame:CGRectMake(A01TableViewFooterX, A01TableViewFooterY, A01TableViewFooterW, A01TableViewFooterH)];
        footerBak.image = [UIImage imageNamed:@"planlistfootbak.png"];
        [self.view addSubview: footerBak];
        
        // 数据显示区域初始化
        IGTableView = [[UITableView alloc] initWithFrame:CGRectMake(A01TableViewX, A01TableViewY, A01TableViewW, A01TableViewH) style:UITableViewStylePlain];
        IGTableView.rowHeight = A01CellHeight;
        IGTableView.backgroundColor = [UIColor planlistBackgroundImageColor];
        IGTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [IGTableView setDelegate:self];
        [IGTableView setDataSource:self];
        
        [self.view addSubview:IGTableView];
        
        // 标题设置
        self.title = NSLocalizedString(@"首页", @"首页");
        
        // 左边设定按钮显示
        UIButton *button = [UIUtil buttonWithImage:@"setup.png" target:self selector:@selector(go2B00:) frame:CGRectMake(BarButtonRightX, BarButtonRightY, BarButtonRightW, BarButtonRightH)];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = leftBarButton;
        
        
        // 右边追加按钮显示
        
        UIButton *rightButton = [UIUtil buttonWithImage:@"add.png" target:self selector:@selector(go2A02:) frame:CGRectMake(BarButtonLeftX, BarButtonLeftY, BarButtonLeftW, BarButtonLeftH)];
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        
        self.navigationItem.rightBarButtonItem =rightBarButton;
        
        // 中间的选项切换生成
        NSArray *segmentTextContent = [NSArray arrayWithObjects: 
                                       NSLocalizedString(@"进行中", @"进行中")
                                       , NSLocalizedString(@"全部", @"全部")
                                       , nil];
        segmentedView = [[IGUISegmentedControl alloc] initWithRectAndItems:CGRectMake(A01SegmentedX, A01SegmentedY, A01SegmentedW, A01SegmentedH) :segmentTextContent];
        [[segmentedView leftButton] addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
        [[segmentedView rightButton] addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
        //selectedSegmentIndexValue = 0;
        self.navigationItem.titleView = segmentedView.view;
        
        [IGDataLoader lodeDefaultData];
    }
    return self;
}

// 选项卡选择切换事件
- (void)segmentAction:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    // 节省资源，如果连续点击同一个按钮，不进行任何响应
    if(segmentedView.selectedIndex == button.tag){
        return;
    }
    //segmentedView.selectedIndex = button.tag;
    [segmentedView changeState];
    //selectedSegmentIndexValue = button.tag;
    [IGTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // tabelview的datasourse初始化
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    IGTableView.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [IGTableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.fetchedResultsController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// 返回Sections个数
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [[fetchedResultsController sections] count];
	if (count == 0) {
		count = 1;
	}
    return count;
}

// 返回每个Sections的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if ([[fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    return numberOfRows;
}

// 生成行内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    IGA01TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || ![cell isKindOfClass:[IGA01TableViewCell class]]) {
        // 自定行样式
        cell = [[IGA01TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Plan *plan = (Plan *)[fetchedResultsController objectAtIndexPath:indexPath];
    
    if([IGBusinessUtil isOver:plan] && segmentedView.selectedIndex == 0){
        cell.contentView.hidden = YES;
    }else {
        cell.contentView.hidden = NO;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    // 给闹钟添加提醒事件
    [cell.clockImageView addTarget:self action:@selector(clickAlert:) forControlEvents:UIControlEventTouchUpInside];
	return cell;
}

// cell更新函数
- (void)configureCell:(IGA01TableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
	Plan *plan = (Plan *)[fetchedResultsController objectAtIndexPath:indexPath];
    [cell updateCell:cell :plan];
}

//  生成列表的datasourse
- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    // 排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"starttime" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSFetchedResultsController *aFetchedResultsController;
    aFetchedResultsController = 
        [IGCoreDataUtil queryForFetchedResult:@"Plan" queryCondition:nil sortDescriptors:sortDescriptors];
    aFetchedResultsController.delegate = self;
    fetchedResultsController = aFetchedResultsController;
    
    return fetchedResultsController;
}  

// 新规追加按钮 go2B00
- (void)go2B00:(id)sender
{
    self.b00ViewController = [[IGB00ViewController alloc] init];
    [self.navigationController pushViewController:self.b00ViewController animated:YES];
}

// 新规追加按钮 go2A02
- (void)go2A02:(id)sender
{
    self.a02ViewController = [[IGA02ViewController alloc] initWithEditing:YES];
	Plan *newPlan = [NSEntityDescription insertNewObjectForEntityForName:@"Plan" inManagedObjectContext:[IGCoreDataUtil getStaticManagedObjectContext]];
    a02ViewController.plan = newPlan;
    [self.navigationController pushViewController:self.a02ViewController animated:YES];
}
// 列表详细选择 go2A02
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.a02ViewController = [[IGA02ViewController alloc] initWithEditing:NO];
    Plan *plan = (Plan *)[fetchedResultsController objectAtIndexPath:indexPath];
    a02ViewController.plan = plan;
    [self.navigationController pushViewController:self.a02ViewController animated:YES];
}

// 列表删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
        
        // 删除提醒
        Plan *plan = (Plan *)[fetchedResultsController objectAtIndexPath:indexPath];
        if ([plan.isalarm boolValue]) {
            [IGBusinessUtil removePlanAlert:plan];
        }
        
        [context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

// 自定义删除按钮的内容
- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return NSLocalizedString(@"删除", @"删除");
}

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
		case NSFetchedResultsChangeUpdate:
			[self configureCell:(IGA01TableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            default:
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
    [IGTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Plan *plan = (Plan *)[fetchedResultsController objectAtIndexPath:indexPath];
    // 隐藏列返回高度0
    if([IGBusinessUtil isOver:plan] && segmentedView.selectedIndex == 0){
        return 0;
    }else {
        return A01CellHeight;
    }
}

// 点击闹钟按钮
-(void)clickAlert:(IGCheckBox*)checkbox
{
    [checkbox changeState];
    
    // 更新数据库
    NSIndexPath *indexpath = [IGTableView indexPathForCell:(IGA01TableViewCell *)checkbox.superview.superview];
    Plan *plan = (Plan *)[fetchedResultsController objectAtIndexPath:indexpath];
    plan.isalarm = [NSNumber numberWithBool:checkbox.isChecked];
    
    NSError *error = nil;
    if (![[IGPlanUtil getStaticMoc] save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    // 追加提醒
    if ([plan.isalarm boolValue]) {
        [IGBusinessUtil addPlanAlert:plan];
        [self showAlertMessage];
    }else {
        [IGBusinessUtil removePlanAlert:plan];
    }
}

// 显示设定闹钟的信息
-(void)showAlertMessage
{
    
    UIAlertView* alertMessage = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"闹钟设定",@"闹钟设定")
                                                           message:[IGBusinessUtil getAlertMessage]   
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"完成", @"")
                                                 otherButtonTitles:nil];
    [alertMessage show];
}
@end
