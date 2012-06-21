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

// lipeng
#import "IGB01TableViewCell.h"


@interface IGB01ViewController_test : UITableViewController <NSFetchedResultsControllerDelegate>{
@private NSMutableArray *modelList;
    NSFetchedResultsController *fetchedResultsController;
    
    UIButton *templateButton;
    UIButton *gobackButton;
    
    Plan *plan;
    UIViewController *preViewController;
    TemplateMaster *templateMaster;
    
    // liepng
    NSMutableDictionary *sectionDictionary;
    
}

- (id) initWithTemplateID:(NSString *)templateID;
- (void)save;
-(void)getTypeList;
-(UIView*)getItemView:(NSIndexPath *)indexPath;
-(UIView*)getTypeView;
-(void)addItem2PlanItem;
-(void)deleteItem2PlanItem;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSMutableArray *modelList;
@property (nonatomic, retain) Plan * plan;
@property (nonatomic, retain) TemplateMaster *templateMaster;
@property(nonatomic, retain) UIViewController *preViewController;

// lipeng
@property (nonatomic,retain) NSDictionary *sectionDictionary;


@end
