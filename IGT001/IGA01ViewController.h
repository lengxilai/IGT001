//
//  IGA01ViewController.h
//  IGT001Local
//
//  Created by 鹏 李 on 12-4-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGCommonInclude.h"
#import <CoreData/CoreData.h>
#import "IGA01TableViewCell.h"
#import "IGB00ViewController.h"
#import "IGA02ViewController.h"
#import "IGA01TableViewCell.h"
#import "Plan.h"
#import "IGUISegmentedControl.h"

@interface IGA01ViewController : UIViewController<UITableViewDelegate,NSFetchedResultsControllerDelegate> {
    @private
    NSFetchedResultsController *fetchedResultsController;
    IGUISegmentedControl *segmentedView;
    UITableView *IGTableView;
}

@property (strong, nonatomic) IGA02ViewController *a02ViewController;
@property (strong, nonatomic) IGUISegmentedControl *segmentedView;
@property (strong, nonatomic) IGB00ViewController *b00ViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UITableView *IGTableView;


// 自定义初始化函数
-(id)init;
// 新规追加页面
- (void)go2A02:(id)sender;
// 设定页面
- (void)go2B00:(id)sender;

@end
