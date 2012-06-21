//
//  IGB02ViewController1.h
//  IGT001Local
//
//  Created by wu jiabin on 12-4-30.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGB01ViewController.h"
#import "IGCommonDefine.h"
#import "IGCommonInclude.h"
#import "IGA02ViewController.h"

@interface IGB02ViewController : UIViewController<UITableViewDelegate,NSFetchedResultsControllerDelegate,UITableViewDataSource> {
    // 取得模板结果集
    @private
    NSFetchedResultsController *fetchedResultsController;
    
    // 前画面的ViewController
    UIViewController *preViewController;
    // 添加模板文本框
    IGTextField *addTextField;
    UITableView *IGTableView;
    NSString *fromFlag;
    UITextField * currentTextField;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, retain) UIViewController *preViewController;
@property(nonatomic, retain) NSString *fromFlag;

@end
