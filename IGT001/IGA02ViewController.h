//
//  IGA02ViewController.h
//  IGT001Local
//
//  Created by 鹏 李 on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IGCommonInclude.h"
#import "IGB02ViewController.h"
#import "IGB01ViewController.h"
#import "IGPlanUtil.h"
#import "IGUISegmentedControl.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface IGA02ViewController : UITableViewController<UIActionSheetDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITextFieldDelegate,IGTextViewDelegate>
{
    Plan *plan;
    IGLabel *checkListCountLabel;
    IGTextField *desAdrLabel;
    IGTextField *trvalLabel;
    IGTextField *startLabel;
    IGCheckBox *alertCheckBox;
    IGTextField *hotelLabel;
    //IGTextField *memoLabel;
    IGTextViewController *memoTextViewController;
    CGFloat memoTextViewHeight;
    IGTextField *templateSaveNameTf;
    UIButton *checkListEditButton;
    UIButton *templateButton;
    UIButton *planEditButton;
    UIButton *gobackButton;
    UIView *topPanelView;
    UIView *checkListHeaderView;
    UIButton *trvalTypeImage;
    IGUISegmentedControl *segmentedView;
    IGLabel *checkListTitle;
    BOOL editing;
    
    UIButton *saveTemplateButton;
    UIButton *mailImage;
}

// 信息
@property (nonatomic, retain) NSDictionary *rowDataSoures;
@property (nonatomic, retain) Plan *plan;
@property (nonatomic) BOOL editing;

// 初始参数为是否编辑模式
- (id)initWithEditing:(BOOL)isEditing;
// 取得行程选择项数目
-(NSInteger)getSelectedPlanItemCount;
// 点击编辑CheckList按钮
-(void)clickCheckListEditButton:(UIButton*)button;
// 点击CheckList的CheckBox
-(void)clickCheckListCheckBox:(UIButton*)button;
// 点击编辑按钮
-(void)editPlan:(UIButton*)button;
// 选择出发时间
-(void)selectStartDate:(id)sender;
// 测试方法
-(Plan*)showPlan;
// 选择模板的回调方法
-(void)callbackSelectTemplate:(TemplateMaster*)templateMaster;
// 文本于高度变化的代理方法
- (void)textViewDidChangeHeight:(CGFloat)height;
@end
