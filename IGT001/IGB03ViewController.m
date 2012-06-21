//
//  IGB03ViewController.m
//  IGT001
//
//  Created by wu jiabin on 12-5-25.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "IGB03ViewController.h"

@implementation IGB03ViewController

- (id)init
{
    self = [super init];
    if (self) {
        UIView *infoPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 220)];
        infoPanel.backgroundColor = [UIColor setAlarmBackgroundImageColor];

        // 读取普通plist文件
        NSString *plistPath = [ [NSBundle mainBundle] pathForResource:@"setAlertTime"ofType:@"plist"];
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//        [ dict setObject:@"Yes" forKey:@"alertTime" ];
//        [ dict writeToFile:@"/info.plist" atomically:YES ];

        // 取得提前提醒时间
        NSString* alertTime = [ dict objectForKey:@"alertTime" ];
        alertTime = alertTime==nil?@"30": alertTime;
        IGLabel *label1 = [[IGLabel alloc] initWithFrame:CGRectMake(45, 15, 300, 30)];
        label1.text = NSLocalizedString(@"闹钟将在行程前", @"闹钟将在行程前");
        IGLabel *label2 = [[IGLabel alloc] initWithFrame:CGRectMake(165, 15, 300, 30)];
        label2.text = [alertTime stringByAppendingString:@"(min)"];
        IGLabel *label3 = [[IGLabel alloc] initWithFrame:CGRectMake(222, 15, 300, 30)];
        label3.text = NSLocalizedString(@"提醒", @"提醒");

        // 修改闹钟时间
        IGLabel *label4 = [[IGLabel alloc] initWithFrame:CGRectMake(20, 60, 120, 30)];
        label4.text = NSLocalizedString(@"变更提醒时间:", @"变更提醒时间:");
        alertTimeText = [[IGTextField alloc] initWithFrame:CGRectMake(130, 65, 55, 20)];

        // 下划线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(130, 86, 55, 2)];
        lineView.backgroundColor = [UIColor setAlertTimeBackgroundImageColor];
        IGLabel *label5 = [[IGLabel alloc] initWithFrame:CGRectMake(185, 59, 50, 30)];
        label5.text = NSLocalizedString(@"(min)", @"(min)");
        
        UIButton *saveButton = [UIUtil buttonWithImage:@"finish.png" target:self selector:@selector(saveAlertTime) frame:CGRectMake(250, 60, 30, 30)];

        
        [infoPanel addSubview:label1];
        [infoPanel addSubview:label2];
        [infoPanel addSubview:label3];
        [infoPanel addSubview:label4];
        [infoPanel addSubview:label5];
        [infoPanel addSubview:alertTimeText];
        [infoPanel addSubview:lineView];
        [infoPanel addSubview:saveButton];
        [self.view addSubview:infoPanel];

        
        // 导航栏左边返回按钮
        UIButton *gobackButton = [UIUtil buttonWithImage:@"goback.png" target:self selector:@selector(goBack:) frame:CGRectMake(BarButtonLeftX, BarButtonLeftY, BarButtonLeftW, BarButtonLeftH)];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:gobackButton];
        self.title = NSLocalizedString(@"设置", @"设置");

    }
    return self;
}

-(void)saveAlertTime {
    
}

//按下Done按钮，键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// 点击返回按钮
- (void)goBack:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
