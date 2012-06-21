//
//  IGB01ViewController.m
//  IGT001Local
//
//  Created by wang chong on 12-4-30.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "IGB01ViewController.h"
@class IGPlanUtil;

@interface IGB01ViewController ()

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation IGB01ViewController
@synthesize fetchedResultsController;
@synthesize managedObjectContext = managedObjectContext;
@synthesize plan;
@synthesize preViewController;
@synthesize modelList;
@synthesize templateMaster;
@synthesize editView;
@synthesize deleteButton;
@synthesize indexPathForDelete;
@synthesize sectionForDelete;

- (id) init{
    self = [super init];
    
    // 背景区域设置
    UIImageView *backGround = [[UIImageView alloc] initWithFrame:CGRectMake(B01BackGroundX, B01BackGroundY, B01BackGroundW, B01BackGroundH) ];
    backGround.image = [UIImage imageNamed:@"classlistbck.png"];
    
    [self.view addSubview: backGround];
    
    // 头部内容生成
    titleCountLabel = [[IGLabel alloc] initWithFrame:CGRectMake(B01CountLableX, B01CountLableY, B01CountLableW, B01CountLableH)];
    [titleCountLabel setTextColor:[UIColor grayColor]];
    titleCountLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:titleCountLabel];

    // 数据显示区域初始化
    IGTableView = [[UITableView alloc] initWithFrame:CGRectMake(B01DataViewX, B01DataViewY, B01DataViewW, B01DataViewH) style:UITableViewStylePlain];
    IGTableView.backgroundColor = [UIColor clearColor];
    IGTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [IGTableView setDelegate:self];
    [IGTableView setDataSource:self];
    
    [self.view addSubview:IGTableView];

    // 收缩用字典初始化
    sectionDictionary = [[NSMutableDictionary alloc] init];
    
    // 设置编辑视图
    editView = [[UIView alloc] initWithFrame:CGRectMake(B01EditViewX, B01EditViewY, B01EditViewW,B01EditViewH)];
    editView.backgroundColor = [UIColor clearColor];
    editView.alpha = 0.0;
    editView.hidden = YES;
    deleteButton = [UIUtil buttonWithTitle:NSLocalizedString(@"删除",@"删除") target:nil selector:nil frame:CGRectZero image:@"button_bag.png"];
    [editView addSubview:deleteButton];
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteRowAndSection:)];
    [deleteButton addGestureRecognizer:singleTap2];
    [self.view addSubview:editView];
    
    // 取数据
    [self fetchedResultsController];
    
    // 收缩所有分类
    for (int sectionNum = 0; sectionNum < [[[fetchedResultsController sections] objectAtIndex:0] numberOfObjects]; sectionNum++) {
        NSString *key = [self getSectionKeyForSectionNum:sectionNum];
        [sectionDictionary setObject:@"NO" forKey:key];
    }
    // 全收缩、隐藏按钮生成
    allHiddenButton = [[IGCheckBox alloc] initWithFrame:CGRectMake(B01AllCheckBtnX, B01AllCheckBtnY, B01AllCheckBtnW, B01AllCheckBtnH) withImageName:@"hidden" isChecked:YES target:self selector:@selector(allItemHidden:)];
    // 设定按钮为全收缩状态
    [allHiddenButton check];
    
    [self.view addSubview: allHiddenButton];
    
    // 键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    return self;
}

#pragma mark - 全局函数
- (void)viewWillAppear:(BOOL)animated{
    
    NSString *templatename;
    //从行程编辑画面过来
    if ([preViewController isKindOfClass:[IGA02ViewController class]]) {
        templatename = plan.template.templatename;
    }
    //从模板编辑画面过来
    if ([preViewController isKindOfClass:[IGB02ViewController class]]) {
        templatename = templateMaster.templatename;
    }
    if (templatename == nil) {
        templatename = NSLocalizedString(@"没有模板", @"没有模板");
    }

    //从行程编辑画面过来
    if ([preViewController isKindOfClass:[IGA02ViewController class]]) {
    titleButton = [UIUtil buttonWithTitle:templatename target:self selector:@selector(toTemplateList) frame:CGRectMake(B01TitleBtnX, B01TitleBtnY, B01TitleBtnW, B01TitleBtnH) image:@"button_bag.png"];
    } else {
        self.title = templatename;
    }
    
    self.navigationItem.titleView = titleButton;
    
    // 如果没有已选中item一览，则创建
    if (selectedItemDictionary == nil) {
        selectedItemDictionary = [[NSMutableDictionary alloc] initWithCapacity:5];
        if([self.preViewController isKindOfClass:[IGA02ViewController class]]){
            for (PlanItem *planItem in plan.planitems) {
                [self addToSelectedList:planItem.item];
                [self addToCheckedList:planItem];
            }
        }else{
            //由模板list画面来得时候  SI0015修正
            for (ItemMaster *templateItem in templateMaster.items) {
                [self addToSelectedList:templateItem];
            }
        }
    }
    
    // 更新头部选择件数
    [self updateTitleCountLabel];
    [IGTableView reloadData];
}

-(void)keyboardWillShow:(NSNotification *)notification
{   
	NSDictionary *userInfo = [notification userInfo];  
	NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];  
	CGRect keyboardRect = [aValue CGRectValue]; 
	
    CGRect frame = IGTableView.frame;
    CGFloat height = frame.size.height - keyboardRect.size.height;
    if (height > 0) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             IGTableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
                         } 
                         completion:^(BOOL finished){
                             if (currentTextField != nil) {
                                 
                                 IGB01TableViewCell *cell = (IGB01TableViewCell *)[[currentTextField superview] superview];
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
						 IGTableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, B01DataViewH);
					 } 
					 completion:^(BOOL finished){
					 }];
}

// 手指点击时触发
 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (editView.hidden == NO) {
        // 隐藏删除按钮
        [self endDelete];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 导航栏左边返回按钮
    gobackButton = [UIUtil buttonWithImage:@"goback.png" target:self selector:@selector(goBack:) frame:CGRectMake(BarButtonLeftX, BarButtonLeftY, BarButtonLeftW, BarButtonLeftH)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:gobackButton];
}

#pragma mark - 返回与回调函数
// 选择模板的回调方法
-(void)callbackSelectTemplate:(TemplateMaster*)template
{
    self.plan.template = template;
    
    // 将行程的检查项替换为模板的检查项
    // 首先删除当前所有检查项目
    [plan removePlanitems:plan.planitems];
    
    // 清空所有已选择项
    [selectedItemDictionary removeAllObjects];
    for (ItemMaster *item in template.items) {
        [self addToSelectedList:item];
    }
}

// 点击返回按钮
-(void)goBack:(UIButton*)button
{
    // 行程画面
    if([self.preViewController isKindOfClass:[IGA02ViewController class]]){
        [plan removePlanitems:plan.planitems];
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
        for (TypeMaster *type in [sectionInfo objects]) {
            NSOrderedSet *itemSet = [selectedItemDictionary objectForKey:type.addtime];
            if (itemSet != nil) {
                for (ItemMaster *item in itemSet) {
                    //planitems中添加
                    PlanItem *newPlanItem = [self addItem2PlanItem:item];
                    // 如果前画面已经选中，则再次选中
                    if ([checkedItem containsObject:item]) {
                        newPlanItem.ischecked = [NSNumber numberWithBool:YES];
                    }
                }
            }
        }
        // 模板画面
    }else{
        [templateMaster removeItems:templateMaster.items];
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
        for (TypeMaster *type in [sectionInfo objects]) {
            NSOrderedSet *itemSet = [selectedItemDictionary objectForKey:type.addtime];
            if (itemSet != nil) {
                for (ItemMaster *item in itemSet) {
                    //planitems中添加
                    [self addItem2TemplateItem:item];
                }
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView的数据显示
//返回section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // lipeng 修正，为添加大分类追加一个sections
    NSInteger count = [[fetchedResultsController sections] count];
	if (count == 0) {
		count = 1;
	}
    return [[[fetchedResultsController sections] objectAtIndex:0] numberOfObjects]+1;
}


// 返回每个Sections的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 如果收缩则不显示行，解决性能问题
    if([[sectionDictionary objectForKey:[self getSectionKeyForSectionNum:section]] isEqualToString:@"NO"]){
        return 0;
    }
    
    // lipeng 修正
    NSInteger numberOfRows = 0;
    if ([[fetchedResultsController sections] count] > 0 &&
        section != [[[fetchedResultsController sections] objectAtIndex:0] numberOfObjects]) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
        TypeMaster *type = [[sectionInfo objects] objectAtIndex:section];
        if(type.items.count){
            numberOfRows = type.items.count;
        }
    }
    
    return numberOfRows+1;
}

// 显示小分类
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // lipeng
    static NSString *CellIdentifier = @"Cell";
    IGB01TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[IGB01TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier:CellTypeRow];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
    }
    
    // 如果没有数据，或者为最后一个section，则只显示一个添加分类
    if ([[fetchedResultsController sections] count] == 0 ||
        indexPath.section == [[[fetchedResultsController sections] objectAtIndex:0] numberOfObjects]) {
        
        [cell updateInputCell:cell];
        
        cell.textField.delegate = self;
        
        [cell.imageBtn removeTarget:self action:@selector(saveItem:)  forControlEvents:UIControlEventTouchUpInside];
        [cell.imageBtn addTarget:self action:@selector(save:)  forControlEvents:UIControlEventTouchUpInside];
        
        // 不设定这个，因为重用，不知道哪一行就被隐藏了
        cell.contentView.hidden = NO;
        
        return cell;
    }
    
    // 查询字典，当结果为no的时候为收缩，收缩时隐藏内容
    if([[sectionDictionary objectForKey:[self getSectionKeyForSectionNum:indexPath.section]] isEqualToString:@"NO"]){
        cell.contentView.hidden = YES;
    }else {
        cell.contentView.hidden = NO;
    }
    
    // 取得当前分类
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
    TypeMaster *type = [[sectionInfo objects] objectAtIndex:indexPath.section];
    
    // 最后一行为添加项目行
    if(indexPath.row == [type.items count]){
        [cell updateInputCell:cell];
        cell.textField.delegate = self;
        
        [cell.imageBtn removeTarget:self action:@selector(save:)  forControlEvents:UIControlEventTouchUpInside];
        [cell.imageBtn addTarget:cell.textField.delegate action:@selector(saveItem:)  forControlEvents:UIControlEventTouchUpInside];
       
    // 检查项的行
    }else {
        ItemMaster *item = [type.items objectAtIndex:indexPath.row];
        
        [cell updateItemCell:cell :item];
        [cell.imageCheckBox unCheck];
        
        cell.nameLabel.tag = B01itemLabelTag;
        
        [cell.imageCheckBox addTarget:self action:@selector(clickCheckListCheckBox:) forControlEvents:UIControlEventTouchUpInside];
        // 如果已经在选中item一览中，则选中
        NSMutableOrderedSet *selectedItemOrder = [selectedItemDictionary objectForKey:item.itemtype.addtime];
        if ([selectedItemOrder containsObject:item]) {
            [cell.imageCheckBox check];
        }
    }
    
    return cell;
}

//显示大分类
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //lipeng
    static NSString *CellIdentifier = @"sectionCell";
    IGB01TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[IGB01TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier:CellTypeSection];
        
        // 给section加收缩事件
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setCellForSectionHidden:)];
        [cell addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *singleTapBtu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allSectionItemCheck:)];
        [cell.imageCheckBox addGestureRecognizer:singleTapBtu];
        
        // 给ection加滑动删除事件
        UISwipeGestureRecognizer  *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sectionSwipe:)];
        [cell addGestureRecognizer:swipe];
    }
    
    // 没有数据 或者 为最后一个section时
    if ([[fetchedResultsController sections] count] == 0 || section == [[[fetchedResultsController sections] objectAtIndex:0] numberOfObjects]){
        
        [cell updateSectinCell:cell :NSLocalizedString(@"添加新分类", @"添加新分类")];
        
        return cell;
    }
    
    // 取得当前分类
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
    TypeMaster *typeMaster = [[sectionInfo objects] objectAtIndex:section];
    
    [cell updateSectinCell:cell :typeMaster.typename];
    cell.imageCheckBox.hidden = NO;
    
    // 用于收缩和隐藏
    cell.tag = section;
    
    // 初始化时在缩进字典中标记为展开
    NSString *key = [self getSectionKeyForSectionNum:section];
    if([sectionDictionary valueForKey:key]==nil){
        [sectionDictionary setObject:@"YES" forKey:key];
    }
    
    // section选择件数更新
    NSInteger coutNum = 0;
    NSOrderedSet *typeSet = [selectedItemDictionary objectForKey:typeMaster.addtime];
    if(typeSet != nil){
        coutNum = [typeSet count];
    }
    
    if(coutNum != 0 && coutNum == [typeMaster.items count]){
        [cell.imageCheckBox check];
    }
    
    cell.countLabel.text = [NSString stringWithFormat:NSLocalizedString(@"选择%d件", @"选择%d件 IGB01section显示"), coutNum];

    return cell;
}

//删除item
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSError *error;
        NSInteger row = indexPath.row;
        TypeMaster *typeMaster = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
        NSOrderedSet *items = typeMaster.items;//items list
        ItemMaster *itemMaster = [[items array] objectAtIndex:row];
        
        // 从选中列表中删除
        [self removeFromSelectedList:itemMaster];
        
        [[IGCoreDataUtil getStaticManagedObjectContext] deleteObject:itemMaster];
        
        // 保存前设定操作类型，保存后删除
        actionType = B01ActionTypeDelItem;
        if (![[IGCoreDataUtil getStaticManagedObjectContext]save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        actionType = B01ActionTypeNone;
    }  
   [IGTableView reloadData];
}

#pragma mark - 实现UITextFieldDｅｌｅｇａｔｅ的若干方法进行相关设置
//实现UITextFieldDｅｌｅｇａｔｅ的若干方法进行相关设置

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

#pragma mark - 保存

//保存type操作
- (void)save:(id)sender {
    NSError *error = nil;
    //取得对应得view
    IGB01TableViewCell *cell = (IGB01TableViewCell *)[[sender superview] superview];
    //取得输入框中内容
    //UITextField *itemTextField = [sectionView viewWithTag:InputText_Tag];
    NSString *TypeText = cell.textField.text;
    
    // 不允许输入空
    if (TypeText == nil || [TypeText isEqualToString:@""]) {
        return;
    }
    
    //取得类型
    //类型为type时 保存type
    TypeMaster *typeMaster = [[TypeMaster alloc] initWithEntity:[NSEntityDescription entityForName:@"TypeMaster" inManagedObjectContext:[IGCoreDataUtil getStaticManagedObjectContext]] insertIntoManagedObjectContext:[IGCoreDataUtil getStaticManagedObjectContext]];
    typeMaster.typename = TypeText;
    typeMaster.addtime = [NSDate date];
    if (![[IGCoreDataUtil getStaticManagedObjectContext]save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}

//保存item操作
- (void)saveItem:(id)sender {
    NSError *error = nil;
    //取得对应得view
    IGB01TableViewCell *cell = (IGB01TableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [IGTableView indexPathForCell:cell];
    //取得输入框中内容
    NSString *itemText = cell.textField.text;
    
    // 不允许输入空
    if (itemText == nil || [itemText isEqualToString:@""]) {
        return;
    }
    
    ItemMaster *itemMaster = [[ItemMaster alloc] initWithEntity:[NSEntityDescription entityForName:@"ItemMaster" inManagedObjectContext:[IGCoreDataUtil getStaticManagedObjectContext]] insertIntoManagedObjectContext:[IGCoreDataUtil getStaticManagedObjectContext]];;
    itemMaster.itemname = itemText;
    itemMaster.addtime = [NSDate date];
    
    //取得类型
    //类型为type时 保存type
    TypeMaster *typeMaster =  [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
    [typeMaster addItemsObject:itemMaster];
    
    // 保存前先设定操作类型，保存之后再清除
    actionType = B01ActionTypeAddItem;
    if (![[IGCoreDataUtil getStaticManagedObjectContext]save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    actionType = B01ActionTypeNone;
    
    // 添加到选中列表
    [self addToSelectedList:itemMaster];
    
    [self updateTitleCountLabel];
    
}

//  生成列表的datasourse
- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController != nil) {
        return self.fetchedResultsController;
    }
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc] initWithKey:@"addtime" ascending:YES], nil];
    NSFetchedResultsController *aFetchedResultsController = 
    [IGCoreDataUtil queryForFetchedResult:@"TypeMaster" queryCondition:nil sortDescriptors:sortDescriptors];
    aFetchedResultsController.delegate = self;
    fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    return fetchedResultsController;
} 

#pragma mark - CoreData相关类

// 列表编辑
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[IGTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = IGTableView;
    
	switch(type) {
		case NSFetchedResultsChangeInsert:
            if ([anObject isKindOfClass:[TypeMaster class]]) {
                int count = [[[controller sections] objectAtIndex:0] numberOfObjects];
                [tableView insertSections:[[NSIndexSet alloc] initWithIndex:count-1] withRowAnimation:UITableViewRowAnimationFade];
            }
			break;
			
		case NSFetchedResultsChangeDelete:
            if ([anObject isKindOfClass:[TypeMaster class]]) {
            [IGTableView deleteSections:[[NSIndexSet alloc] initWithIndex:sectionForDelete.tag] withRowAnimation:UITableViewScrollPositionNone];
            }
			break;
        case NSFetchedResultsChangeUpdate:
            if (actionType == B01ActionTypeAddItem) {
                NSIndexPath *addIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:addIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            }
            if (actionType == B01ActionTypeDelItem) {
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:indexPath.row], nil] withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[IGTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
            
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[IGTableView endUpdates];
    [IGTableView reloadData];
    [self updateTitleCountLabel];
}

#pragma mark - checkbox点击操作

// 分类下全项目选择
-(void)allSectionItemCheck:(UIGestureRecognizer *)gestureRecognizer{
    
    // 改变星星状态
    IGCheckBox *checkBox = (IGCheckBox *)gestureRecognizer.view;
    [checkBox changeState];
    
    // 取得当前位置
    IGB01TableViewCell *sectionCell =(IGB01TableViewCell *)[[checkBox superview] superview];
    NSInteger section = sectionCell.tag;
    
    // 取得当前分类
    TypeMaster *typeMaster = [[[[fetchedResultsController sections] objectAtIndex:0] objects] objectAtIndex:section];
    
    // 循环当前分类的所有行
    for (int r = 0; r < [typeMaster.items count]; r++) {
        
        // 取得当前检查项目，由于行的索引和CoreData的索引是一样的，所以这里取出来的也是TableView的当前行的检查项目
        ItemMaster *item = [typeMaster.items objectAtIndex:r];
        
        // 更新前画面检查项
        [self updateItemCellForItem:item forCell:nil forChecked:checkBox.isChecked];
    }
    
    [self updateTitleCountLabel];
    [IGTableView reloadData];
}


// 点击某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 定位目标行
    IGB01TableViewCell *cell =(IGB01TableViewCell *)[IGTableView cellForRowAtIndexPath:indexPath];
 
    // 没有星星的行不进行任何操作
    if(cell.imageCheckBox.hidden){
        return;
    }
    
    // 取得目标行的分类
    TypeMaster *typeMaster =  [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
    ItemMaster *item = [typeMaster.items objectAtIndex:indexPath.row];
    
    IGCheckBox *checkBox = (IGCheckBox*)[cell.contentView viewWithTag:CheckBox_Tag];
    // 改变星星状态
    [checkBox changeState];
    
    // 更新前画面检查项
    [self updateItemCellForItem:item forCell:cell forChecked:checkBox.isChecked];
    // 更新选择件数
    [self updateTitleCountLabel];
    // 更新全选星星的状态
    //    [self updateAllItemCheckState];
    [IGTableView reloadData];
}

//点击项目的小星星
-(void)clickCheckListCheckBox:(UIButton*)button{
    IGCheckBox *checkBox = (IGCheckBox *)button;
    
    // 定位目标行
    IGB01TableViewCell *cell =(IGB01TableViewCell *)[[button superview] superview];
    NSIndexPath *indexPath = [IGTableView indexPathForCell:cell];
    
    // 取得目标行的分类
    TypeMaster *typeMaster =  [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
    ItemMaster *item = [typeMaster.items objectAtIndex:indexPath.row];
    
    // 改变星星状态
    [checkBox changeState];
    
    // 更新前画面检查项
    [self updateItemCellForItem:item forCell:cell forChecked:checkBox.isChecked];
    // 更新选择件数
    [self updateTitleCountLabel];
    // 更新全选星星的状态
//    [self updateAllItemCheckState];
    [IGTableView reloadData];
}

// 根据检查项和单元格更新，如果非选中，则从前画面的检查项中删除，如果选中则向前画面检查项中追加
-(void)updateItemCellForItem:(ItemMaster*)item forCell:(IGB01TableViewCell*)cell forChecked:(BOOL)isChecked
{
    // 添加
    if(isChecked){
        [self addToSelectedList:item];
    // 删除
    }else{
        [self removeFromSelectedList:item];
    }
}

// 点击分类section收缩事件
- (void)setCellForSectionHidden:(UIGestureRecognizer *)gestureRecognizer 
{
    
    IGB01TableViewCell *cell= (IGB01TableViewCell *)gestureRecognizer.view;
    
    // 新建行不响应收缩事件
    if(cell.imageCheckBox.isHidden){
        return;
    }
    
    NSString *key = [self getSectionKeyForSectionNum:cell.tag];
    
    // YES为展开
    if([[sectionDictionary valueForKey:key] isEqualToString:@"YES"]){
        [sectionDictionary setValue:@"NO" forKey:key];
    }else {
        [sectionDictionary setValue:@"YES" forKey:key];
    }
    
    // 更新字典后重新刷新表格 
    [IGTableView reloadData];
    if([[sectionDictionary valueForKey:key] isEqualToString:@"YES"]){
    [IGTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:cell.tag] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    // 用动画效果会莫名其妙地出现白线
    //[IGTableView reloadSections:[NSIndexSet indexSetWithIndex:cell.tag] withRowAnimation:UITableViewRowAnimationFade];
}

//在行程中添加item
-(PlanItem *)addItem2PlanItem:(ItemMaster *)item{
    // 创建一个新的检查项目
    PlanItem *planItem = [IGBusinessUtil createPlanItemForItem:item forCheck:NO];
    // 添加新的检查项目
    [plan addPlanitemsObject:planItem];
    return planItem;
}

// 在模板中添加item
-(void)addItem2TemplateItem:(ItemMaster *)item{
    [templateMaster addItemsObject:item];
}

#pragma mark - TableView的行高

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

#pragma mark - 其他计算方法

-(NSString*)getSectionKeyForSectionNum:(NSInteger)sectionNum
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
    
    // 超过行数（最后一行始终展开）
    if (sectionNum >= [sectionInfo numberOfObjects] ) {
        return @"YES";
    }
    TypeMaster *typeMaster = [[sectionInfo objects] objectAtIndex:sectionNum];
    return [NSDate stringFromDate:typeMaster.addtime 
                withFormat: @"yyyyMMddHHmmssSSS"];  
}

// 从选中列表中删除
-(void)removeFromSelectedList:(ItemMaster*)itemMaster
{
    NSMutableOrderedSet *selectedItemOrder = [selectedItemDictionary objectForKey:itemMaster.itemtype.addtime];
    if (selectedItemOrder != nil) {
        if ([selectedItemOrder containsObject:itemMaster]) {
            [selectedItemOrder removeObject:itemMaster];
        }
    }
}
// 添加到选中列表
-(void)addToSelectedList:(ItemMaster*)itemMaster
{
    NSMutableOrderedSet *selectedItemOrder = [selectedItemDictionary objectForKey:itemMaster.itemtype.addtime];
    if (selectedItemOrder == nil) {
        selectedItemOrder = [[NSMutableOrderedSet alloc] initWithCapacity:1];
        [selectedItemDictionary setObject:selectedItemOrder forKey:itemMaster.itemtype.addtime];
        [selectedItemOrder addObject:itemMaster];
    }else {
        if (![selectedItemOrder containsObject:itemMaster]) {
            [selectedItemOrder addObject:itemMaster];
        }
    }
}
// 添加到前画面选中list
-(void)addToCheckedList:(PlanItem*)planItem
{
    if (checkedItem == nil) {
        checkedItem = [[NSMutableSet alloc] initWithCapacity:5];
    }
    // 如果前画面选中，则添加到checkedList中
    if ([planItem.ischecked boolValue]) {
        [checkedItem addObject:planItem.item];
    }
}

// 更新头部件数
-(void)updateTitleCountLabel{
    // 选择件数更新
    NSInteger count = 0;
    for (NSOrderedSet *typeSet in [selectedItemDictionary allValues]) {
        count += [typeSet count];
    }
    //由创建行程画面来得时候
    titleCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"已选择%d件", @"选择%d件 IGB01头部显示"), count];
}
//跳转到模板画面
-(void)toTemplateList{
    IGB02ViewController *b02ViewController = [[IGB02ViewController alloc] init];
    b02ViewController.preViewController = self;
    // 不显示添加模板框
    b02ViewController.fromFlag = @"noAddTemplate";
    [self.navigationController pushViewController:b02ViewController animated:YES];
}


#pragma mark - section删除相关方法

// 禁止section删除添加行
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    IGB01TableViewCell *cell = (IGB01TableViewCell *)[IGTableView cellForRowAtIndexPath:indexPath];
    if(cell.textField.isHidden){
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

// section的滑动事件
- (void)sectionSwipe:(UIGestureRecognizer *)gestureRecognizer 
{
    IGB01TableViewCell *cell = (IGB01TableViewCell*) gestureRecognizer.view;
    
    // 新建行不响应删除事件
    if(cell.imageCheckBox.isHidden){
        return;
    }
    sectionForDelete = cell;
    [self setDeleteState:cell];
}

// 设定删除状态
- (void)setDeleteState:(IGB01TableViewCell *)cell 
{
    deleteButton.frame = CGRectMake(B01DeleteBtnX, cell.frame.origin.y+B01DeleteBtnY - IGTableView.contentOffset.y, B01DeleteBtnW, B01DeleteBtnH);
    [UIView beginAnimations:@"delsection" context:nil];
        editView.hidden = NO;
        editView.alpha = 1.0;
    [UIView commitAnimations];
}

// 点击分类section收缩事件
- (void)endDelete
{
    
    [UIView beginAnimations:@"delsection" context:nil];
        editView.alpha = 0.0;
        editView.hidden = YES;
    [UIView commitAnimations];
    indexPathForDelete = nil;
}

-(void)deleteTypeAlert{
    // 生成提示消息
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:
                          NSLocalizedString(@"确认",@"确认") 
                                                    message:NSLocalizedString(@"确认要删除该分类下所有项目吗？",@"确认删除大分类提示消息") 
                                                   delegate:self 
                                          cancelButtonTitle:NSLocalizedString(@"取消",@"取消") 
                                          otherButtonTitles:NSLocalizedString(@"删除",@"删除"), nil];
    [alert show];
    
}

// 删除按钮提示对话框
-(void)deleteRowAndSection:(id)sender{
    [self deleteTypeAlert];
}

//  alert上的按钮触发事件的响应(取消按钮:buttonIndex=0  删除按钮:buttonIndex=1)
- (void) alertView:(UIAlertView *)alertview clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([[NSNumber numberWithInt:buttonIndex] boolValue]){
        [self deleteTypeMaster];
    }
    
}
// 删除大分类
-(void)deleteTypeMaster{
    if(sectionForDelete != nil){
        // 删除大分类
        NSInteger section = sectionForDelete.tag;
        
        // 取得当前分类
        TypeMaster *typeMaster = [[[[fetchedResultsController sections] objectAtIndex:0] objects] objectAtIndex:section];
        
        // 从选中列表中删除所有项目
        for (ItemMaster *item in typeMaster.items) {
            [self removeFromSelectedList:item];
        }
        
        [[IGCoreDataUtil getStaticManagedObjectContext] deleteObject:typeMaster];
        // 保存
        NSError *error = nil;
        if (![[IGCoreDataUtil getStaticManagedObjectContext]save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    editView.alpha = 0.0;
    sectionForDelete = nil;
}

// 全项目收缩、展开
-(void)allItemHidden:(id)sender{
    // allHiddenButton.isChecked YES为全收缩 NO为全展开
    // sectionDictionary NO为收缩 YES为展开
    [allHiddenButton changeState];
    // 收缩所有分类
    for (int sectionNum = 0; sectionNum < [[[fetchedResultsController sections] objectAtIndex:0] numberOfObjects]; sectionNum++) {
        [sectionDictionary setObject:allHiddenButton.isChecked?@"NO":@"YES" forKey:[self getSectionKeyForSectionNum:sectionNum]];
    }
    [IGTableView reloadData];
}
@end
