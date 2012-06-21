//
//  IGB01ViewController.m
//  IGT001Local
//
//  Created by wang chong on 12-4-30.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "IGB01ViewController_test.h"
@class IGPlanUtil;


@implementation IGB01ViewController_test
@synthesize fetchedResultsController;
@synthesize managedObjectContext = managedObjectContext;
@synthesize plan;
@synthesize preViewController;
@synthesize modelList;


static NSString *masterType =@"1";//大分类
static NSString *subMasterType = @"0";//子分类
static NSString *type= @"type";//分类key
static NSString *checkON = @"checkON";//选中
static NSString *checkOFF = @"checkOFF";//选中取消
static NSString *checkStat = @"checkStat";//选择状态
static NSString *selected = @"true";//用户选中
static NSString *selectedStat = @"selectedStat";//是否选择



- (id) init{
    self = [super init];
    
    [self fetchedResultsController];
    [self getTypeList];
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[IGPlanUtil createTemplateForName:@"出差"]; 
    self.title = NSLocalizedString(@"item选择", @"item选择");
    
    // 导航栏左边返回按钮
    gobackButton = [UIUtil buttonWithImage:@"goback.png" target:self selector:@selector(goBack:) frame:CGRectMake(BarButtonLeftX, BarButtonLeftY, BarButtonLeftW, BarButtonLeftH)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:gobackButton];
    // lipeng
    sectionDictionary = [[NSMutableDictionary alloc] init];
}

//返回section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //    NSInteger count = [[[fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    //    return count + 1;
    
    NSInteger count = [[fetchedResultsController sections] count];
	if (count == 0) {
		count = 1;
	}
    return [[[fetchedResultsController sections] objectAtIndex:0] numberOfObjects]+1;
    
}


// 返回每个Sections的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    NSInteger numberOfRows = 0;
    //    NSInteger sectionsCount = [[[fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    //    if (sectionsCount > 0 && sectionsCount != section) {
    //        TypeMaster *type = 
    //        [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0]];
    //        numberOfRows = [type.items count];
    //    }
    //    
    //    
    //    return numberOfRows +1;
    
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
    
    NSString *key = [[NSString alloc] initWithFormat:@"%d",indexPath.section];
    if ([sectionDictionary objectForKey:key] == @"NO") {
        return  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell = nil;
    if ([[fetchedResultsController sections] count] == 0 ||
        indexPath.section == [[[fetchedResultsController sections] objectAtIndex:0] numberOfObjects]) {
        cell = [[IGB01TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier:CellTypeInput];
        [cell updateInputCell:cell];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
    TypeMaster *type = [[sectionInfo objects] objectAtIndex:indexPath.section];
    
    // Configure the cell...
    NSLog(@"%d",indexPath.row);
    NSLog(@"%d",[type.items count]);
    if(indexPath.row >= [type.items count]){
        cell = [[IGB01TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier:CellTypeInput];
        [cell updateInputCell:cell];
    }else {
        cell = [[IGB01TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier:CellTypeRow];
        ItemMaster *item = [type.items objectAtIndex:indexPath.row];
        [cell updateItemCell:cell :item];
        
        [cell.imageBtn addTarget:self action:@selector(clickCheckListCheckBox:) forControlEvents:UIControlEventTouchUpInside];
        
        if([self.preViewController isKindOfClass:[IGA02ViewController class]]){
            //由创建行程画面来得时候
            for (PlanItem *planItem in plan.planitems) {
                if([planItem.item.itemname isEqual:item.itemname]){
                    //如果planitem中有，则设置为选中
                    UIImage *newImage = [UIImage imageNamed:@"star_on.png"];
                    [cell.imageBtn setBackgroundImage:newImage forState:UIControlStateNormal];
                }
            }
        }else{
            //由模板list画面来得时候
            for (ItemMaster *templateItem in templateMaster.items) {
                if([templateItem.itemname isEqual:item.itemname]){
                    UIImage *newImage = [UIImage imageNamed:@"star_on.png"];
                    [cell.imageBtn setBackgroundImage:newImage forState:UIControlStateNormal];
                }
            }
        }
        
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.editingAccessoryType = UITableViewCellAccessoryNone;
    return cell;
    
    //lipeng
    
    //    static NSString *CellIdentifier = @"MyCell";
    //    
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //    }
    //  
    //    UIView *cellView = [cell.contentView viewWithTag:UIView_Tag];
    //    if (cellView != nil) {
    //        [cellView removeFromSuperview];
    //    }
    //    
    //    UIView *itemView = [self getItemView:indexPath];
    //    [cell.contentView addSubview:itemView];
    //    
    //    
    //
    //    return cell;
}
//小分类单元格

//lipeng
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60;
//}
//lipeng
// 列表详细选择
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    TypeMaster *type = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
//    NSOrderedSet *items = type.items;
//    ItemMaster *item = [items objectAtIndex:indexPath.row];
//    
//    tableView.reloadData;
//}
//删除item
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSError *error;
        NSInteger *row = indexPath.row;
        TypeMaster *typeMaster = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
        NSSet *items = typeMaster.items;//items list
        ItemMaster *itemMaster = [[items allObjects] objectAtIndex:row];
        [[IGCoreDataUtil getStaticManagedObjectContext] deleteObject:itemMaster];
        
        if (![[IGCoreDataUtil getStaticManagedObjectContext]save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }  
    [tableView reloadData];
}

//实现UITextFieldDｅｌｅｇａｔｅ的若干方法进行相关设置

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{;
    
}

//按下Done按钮，键盘消失

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [textField resignFirstResponder];
    
    return YES;
    
}
//保存type操作
- (void)save:(UIButton*)button {
    NSError *error = nil;
    //取得对应得view
    UIView *sectionView =[button superview];
    //取得输入框中内容
    UITextField *itemTextField = [sectionView viewWithTag:InputText_Tag];
    NSString *itemText = itemTextField.text;
    NSLog(@"%@" ,itemText);
    //取得类型
    //类型为type时 保存type
    TypeMaster *typeMaster = [[TypeMaster alloc] initWithEntity:[NSEntityDescription entityForName:@"TypeMaster" inManagedObjectContext:[IGCoreDataUtil getStaticManagedObjectContext]] insertIntoManagedObjectContext:[IGCoreDataUtil getStaticManagedObjectContext]];
    typeMaster.typename = itemText;
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
    UITableViewCell *cellView =[[[sender superview] superview]superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cellView];
    
    //取得输入框中内容
    UIView *cell = [cellView.contentView viewWithTag:UIView_Tag];
    UITextField *itemTextField = [cell viewWithTag:InputText_Tag];
    NSString *itemText = itemTextField.text;
    ItemMaster *itemMaster = [[ItemMaster alloc] initWithEntity:[NSEntityDescription entityForName:@"ItemMaster" inManagedObjectContext:[IGCoreDataUtil getStaticManagedObjectContext]] insertIntoManagedObjectContext:[IGCoreDataUtil getStaticManagedObjectContext]];;
    itemMaster.itemname = itemText;
    itemMaster.addtime = [NSDate date];
    
    //取得类型
    //类型为type时 保存type
    TypeMaster *typeMaster =  [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
    [typeMaster addItemsObject:itemMaster];
    if (![[IGCoreDataUtil getStaticManagedObjectContext]save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
}
//取得typeList
-(void)getTypeList{
    NSLog(@"%d", [[[fetchedResultsController sections] objectAtIndex:0] numberOfObjects]);
    // NSLog(@"%d", [[fetchedResultsController sections] count]);
    
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




// 列表编辑
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = self.tableView;
    
	switch(type) {
		case NSFetchedResultsChangeInsert:
            if ([anObject isKindOfClass:[TypeMaster class]]) {
                [tableView insertSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }            
			break;
			
		case NSFetchedResultsChangeDelete:
            
			break;
        case NSFetchedResultsChangeUpdate:
            if ([anObject isKindOfClass:[TypeMaster class]]) {
                NSIndexPath *addIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:addIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
            
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSLog(@"didChangeSection type %d",type);
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
            
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
    [self.tableView reloadData];
}
//显示大分类
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //lipeng
    static NSString *CellIdentifier = @"sectionCell";
    IGB01TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[IGB01TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier:CellTypeSection];
    }
    
    if ([[fetchedResultsController sections] count] == 0 ||
        section == [[[fetchedResultsController sections] objectAtIndex:0] numberOfObjects]){
        cell.nameLabel.text = @"这里添加一级级别目录";
		return cell;
    }
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
    TypeMaster *typeMaster = [[sectionInfo objects] objectAtIndex:section];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setCellForSectionHidden:)];
    
    [cell.imageCheckBox addTarget:self action:@selector(setCellForSectionHidden:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addGestureRecognizer:singleTap];
    [cell.nameLabel addGestureRecognizer:singleTap];
    
//    [cell.imageBtn addTarget:self action:@selector(selectTrvalTypeImage:)  forControlEvents:UIControlEventTouchUpInside];
//    cell.tag = section;
    NSString *key = [[NSString alloc] initWithFormat:@"%d",section];
    
    if(![sectionDictionary valueForKey:key]){
        [sectionDictionary setValue:@"YES" forKey:key];   
    }
    
    [cell updateSectinCell:cell :typeMaster:[sectionDictionary valueForKey:key]];
    return cell;
    //lipeng
    
    //int number = [[[fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    //    NSInteger sectionsCount = [[[fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    //    
    //    if(sectionsCount != section){
    //        TypeMaster *type = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0]];
    //        CGRect sectionHeaderLabelViewFrame = CGRectMake(B01TypeX, B01TypeY, B01TypeW, B01TypeH);
    //        UILabel *sectionHeaderLabel = [[UILabel alloc] initWithFrame:sectionHeaderLabelViewFrame] ;
    //        sectionHeaderLabel.backgroundColor = [UIColor clearColor];
    //        sectionHeaderLabel.textColor = [UIColor colorWithRed:0.298 green:0.337 blue:0.424 alpha:1.0];
    //        sectionHeaderLabel.shadowColor  = [UIColor whiteColor];
    //            sectionHeaderLabel.shadowOffset = CGSizeMake(0, 1);
    //        sectionHeaderLabel.font = [UIFont boldSystemFontOfSize:17];
    //        sectionHeaderLabel.text = type.typename;
    //        return sectionHeaderLabel;
    //
    //    }else{
    //        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(B01TypeLabelX, B01TypeLabelY, B01TypeLabelW, B01TypeLabelH)];
    //        textField.borderStyle = UITextBorderStyleRoundedRect;//设置文本框边框风格
    //        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //        [textField setBackgroundColor:[UIColor whiteColor]];
    //        textField.delegate = self;//设置delegate
    //        textField.tag = InputText_Tag;
    //        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //        saveButton.frame = CGRectMake(B01ButtonW, B01ButtonY, B01ButtonW, B01ButtonH);
    //        
    //        [saveButton addTarget:self action:@selector(save:)  forControlEvents:UIControlEventTouchUpInside];
    //        [saveButton setTitle:@"保存" forState:UIControlStateNormal];//按钮title
    //        [saveButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //        
    //        
    //        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(B01TypeX, B01TypeY, B01TypeW, B01TypeH)];
    //        [sectionView addSubview:textField];
    //        [sectionView addSubview:saveButton];
    //        return sectionView;
    //    }
}

// lipeng
//取得item view
//-(UIView*)getItemView:(NSIndexPath *)indexPath {
//    UIView *checkItemView = [[UIView alloc] initWithFrame:CGRectMake(B01ItemX, B01ItemY, B01ItemW, 480)];
//    checkItemView.tag = UIView_Tag;
//    
//    NSInteger sectionsCount = [[[fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
//    if(sectionsCount != indexPath.section){
//        TypeMaster *type = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
//        NSOrderedSet *items = type.items;
//        if(items.count != 0 && items.count != indexPath.row){
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(B01ItemLabelX, B01ItemLabelY, B01ItemLabelW, B01ItemLabelH)];
//            ItemMaster *item = [items objectAtIndex:indexPath.row];
//            
//            label.text = item.itemname;//小分类名称显示
//            label.tag = B01itemLabelTag;
//            IGCheckBox *checkBox = [[IGCheckBox alloc] initWithFrame:
//                                    CGRectMake(B01CheckListCheckBoxX, B01CheckListCheckBoxY, B01CheckListCheckBoxW, B01CheckListCheckBoxH) withImageName:@"star" isChecked:NO target:self selector:@selector(clickCheckListCheckBox:)];
//            
//            
//            if([self.preViewController isKindOfClass:[IGA02ViewController class]]){
//                //由创建行程画面来得时候
//                for (PlanItem *planItem in plan.planitems) {
//                    if([planItem.item.itemname isEqual:item.itemname]){
//                        //如果planitem中有，则设置为选中
//                        [checkBox changeState];
//                    }
//                }
//            }else{
//                //由模板list画面来得时候
//                for (ItemMaster *templateItem in templateMaster.items) {
//                    if([templateItem.itemname isEqual:item.itemname]){
//                        //如果planitem中有，则设置为选中
//                        [checkBox changeState];
//                    }
//                }
//            }
//            [checkItemView addSubview:label];
//            [checkItemView addSubview:checkBox];
//        }else {
//            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(B01ItemInputX, B01ItemInputY, B01ItemInputW, B01ItemInputH)];
//            textField.borderStyle = UITextBorderStyleRoundedRect;//设置文本框边框风格
//            textField.autocorrectionType = UITextAutocorrectionTypeYes;//启用自动提示更正功能
//            //textField.returnKeyType = UIReturnKeyDone;//设置键盘完成按钮，相应的还有“Return”"Gｏ""Google"等
//            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//            [textField setBackgroundColor:[UIColor whiteColor]];
//            textField.delegate = self;//设置delegate
//            textField.tag = InputText_Tag;
//            UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            saveButton.frame = CGRectMake(B01ButtonX, B01ButtonY, B01ButtonW, B01ButtonH);
//            
//            [saveButton addTarget:self action:@selector(saveItem:)  forControlEvents:UIControlEventTouchUpInside];
//            [saveButton setTitle:@"保存" forState:UIControlStateNormal];//按钮title
//            [saveButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//            [checkItemView addSubview:textField];
//            [checkItemView addSubview:saveButton];
//        }
//    }
//    return checkItemView;
//}
//点击checkbox
-(void)clickCheckListCheckBox:(UIButton*)button{
    IGCheckBox *checkBox = (IGCheckBox *)button;
    UITableViewCell *cellView =(UITableViewCell *)[[[button superview] superview]superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cellView];
    TypeMaster *typeMaster =  [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
    ItemMaster *item = [typeMaster.items objectAtIndex:indexPath.row];
    
    [checkBox changeState];
    
    if([checkBox isChecked]){
        
        if([self.preViewController isKindOfClass:[IGA02ViewController class]]){
            //planitems中添加
            [self addItem2PlanItem:item];
        }else{
            //template item 添加
            [self addItem2TemplateItem:item];
        }
    }else{
        if([self.preViewController isKindOfClass:[IGA02ViewController class]]){
            //planitems中删除
            [self deleteItem2PlanItem:item];
        }else{
            //template item 删除    
            [self deleteItem2TemplateItem:item];
        }
    }
}
//在plan中添加item
-(void)addItem2PlanItem:(ItemMaster *)item{
    
    // 创建一个新的检查项目
    PlanItem *planItem = [IGBusinessUtil createPlanItemForItem:item forCheck:NO];
    // 添加新的检查项目
    [plan addPlanitemsObject:planItem];
    
}
//在plan中删除item
-(void)deleteItem2PlanItem:(ItemMaster *)item{
    
    for(PlanItem *planItem in plan.planitems){
        if([planItem.item.itemname isEqual:item.itemname]){
            // 删除item
            [plan removePlanitemsObject:planItem];
        }
    } 
}
//在plan中添加item
-(void)addItem2TemplateItem:(ItemMaster *)item{
    [templateMaster addItemsObject:item];
    
}
//在plan中删除item
-(void)deleteItem2TemplateItem:(ItemMaster *)item{
    
    for(ItemMaster *templateItem in templateMaster.items){
        if([templateItem.itemname isEqual:item.itemname]){
            // 删除item
            [templateMaster removeItemsObject:item];
        }
    } 
}
// 点击返回按钮
-(void)goBack:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


// lipeng
- (void)setCellForSectionHidden:(UIGestureRecognizer *)gestureRecognizer 
{
    NSLog(@"%@",gestureRecognizer.view);
    IGB01TableViewCell *cell= gestureRecognizer.view;
    NSString *key = [[NSString alloc] initWithFormat:@"%d",cell.tag]; 
    if([sectionDictionary objectForKey:key] == @"YES"){
        
        [sectionDictionary setValue:@"NO" forKey:key];
    }else {
        
        [sectionDictionary setValue:@"YES" forKey:key];
    }
    self.tableView.reloadData;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *key = [[NSString alloc] initWithFormat:@"%d",indexPath.section];
    // 查询字典，当结果为no的时候返回高度0
    if([sectionDictionary objectForKey:key] == @"NO"){
        return 0;
    }else {
        return 44;
    }
}
// lipeng
@end
