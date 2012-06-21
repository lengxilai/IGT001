//
//  IGB01ViewController1.h
//  IGT001Local
//
//  Created by wang chong on 12-4-30.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TypeMaster.h"
#import "IGCoreDataUtil.h"
#import "IGPlanUtil.h"
#import "IGCommonDefine.h"
#import "IGCheckBox.h"
#import "IGBusinessUtil.h"
#import "UIUtil.h"
#import "IGA02ViewController.h"
#import "TemplateMaster.h"

#import "IGB01TableViewCell.h"

typedef enum{
    B01ActionTypeNone=0,
    B01ActionTypeAddItem=11,B01ActionTypeDelItem=12,
    B01ActionTypeAddType=21,B01ActionTypeDelType=22,
}B01ActionType;

@interface IGB01ViewController : UIViewController<UITableViewDelegate,NSFetchedResultsControllerDelegate,UITextFieldDelegate,UITableViewDataSource>{
   @private NSMutableArray *modelList;
    NSFetchedResultsController *fetchedResultsController;
    
    UIButton *templateButton;
    UIButton *gobackButton;
    
    Plan *plan;
    UIViewController *preViewController;
    TemplateMaster *templateMaster;
    
    // liepng
    NSMutableDictionary *sectionDictionary;
    UITableView *IGTableView;
    IGLabel *titleCountLabel;
    IGCheckBox *allHiddenButton;
    UIButton *titleButton;
    
    B01ActionType actionType;
    
    UIView *editView;
    UIButton *deleteButton;
    NSIndexPath *indexPathForDelete;
    IGB01TableViewCell *sectionForDelete;
    UITextField *currentTextField;
    // 为了解决性能问题，使用一个选中item一览，最后点返回时反应到前画面，以TypeMaster为Key
    NSMutableDictionary *selectedItemDictionary;
    // 记录前画面的选中项目
    NSMutableSet *checkedItem;
}

- (id) initWithTemplateID:(NSString *)templateID;
-(UIView*)getItemView:(NSIndexPath *)indexPath;
-(UIView*)getTypeView;
-(void)addItem2PlanItem;
-(void)saveItem:(id)sender;
// 选择模板的回调方法
-(void)callbackSelectTemplate:(TemplateMaster*)templateMaster;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSMutableArray *modelList;
@property (nonatomic, retain) Plan * plan;
@property (nonatomic, retain) TemplateMaster *templateMaster;
@property(nonatomic, retain) UIViewController *preViewController;

// lipeng
@property (nonatomic,retain) NSDictionary *sectionDictionary;
@property (nonatomic,retain) UIView *editView;
@property (nonatomic,retain) UIButton *deleteButton;
@property (nonatomic,retain) NSIndexPath *indexPathForDelete;
@property (nonatomic,retain) IGB01TableViewCell *sectionForDelete;

@end
