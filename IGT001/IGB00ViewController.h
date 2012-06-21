//
//  IGB00ViewController.h
//  IGT001
//
//  Created by wu jiabin on 12-5-23.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGCommonDefine.h"
#import "IGCommonInclude.h"
#import "IGB02ViewController.h"
#import "IGB03ViewController.h"
#import "IGBusinessUtil.h"

@interface IGB00ViewController : UIViewController
{
    UITableView *IGTableView;
}
@property (strong, nonatomic) IGB02ViewController *b02ViewController;
@property (strong, nonatomic) IGB03ViewController *b03ViewController;

@end
