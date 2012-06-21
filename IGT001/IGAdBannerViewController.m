//
//  IGAdBannerViewController.m
//  IGT001
//
//  Created by 鹏 李 on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGAdBannerViewController.h"

@interface IGAdBannerViewController ()

@end

@implementation IGAdBannerViewController


// 获得广告页
+(id)shareIadView{
    
    IGAdBannerViewController *iadView = [[self alloc] init];
    iadView.frame = CGRectMake(0, 430, 320, 50.0);
    return iadView;
}
//自定义的函式 Banner初始化（以画面直立）  
- (id)init {  
    
    self = [super init];
    if(self){
        //以画面直立的方式设定Banner于画面底部  
        bannerView = [[ADBannerView alloc]initWithFrame:CGRectMake(0, 50, 320.0, 50.0)];  
        
        //此Banner所能支援的类型  
        bannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];  
        
        //目前的Banner 类型  
        bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;  
        
        //设定代理  
        bannerView.delegate = self;  
        
        //无法按下触发广告  
        //bannerView.userInteractionEnabled = YES;  
        
        [self addSubview:bannerView];
    }
    return self;
}  

// 广告读取过程中出现错误
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError * )error{
    // 切换ADBannerView表示状态，显示→隐藏
    bannerView.frame = CGRectMake(0, 50, 320, 50.0);
    NSLog(@"%@",error);
}

// 成功读取广告
- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    // 切换ADBannerView表示状态，隐藏→显示
    bannerView.frame = CGRectMake(0, 0, 320, 50.0);
}

// 用户点击广告是响应，返回值BOOL指定广告是否打开
// 参数willLeaveApplication是指是否用其他的程序打开该广告
// 一般在该函数内让当前View停止，以及准备全画面表示广告
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    return YES;
}

// 全画面的广告表示完了后，调用该接口
// 该接口被调用之后，当前程序一般会作为后台程序运行
// 该接口中需要回复之前被中断的处理（如果有的话）
- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
}
@end
