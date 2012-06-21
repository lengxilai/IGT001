//
//  IGCommonDefine.h
//  IGT001
//
//  Created by Ming Liu on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CURRENT_VERSION 1.00f

typedef enum{
    AppID_TenYearsDiary = 508014699,
    AppID_TripChecker = 529403333,
}AppID;

typedef enum{
    TableViewCellTag=90,CheckBox_Tag=91,DateSelectViewTag=92,
    // 输入框tag
    InputText_Tag = 93,
    // UIView tag
    UIView_Tag=94,
}CommonViewTag;

typedef enum{
    // 导航栏右边按钮
    BarButtonRightX=0,BarButtonRightY=0,BarButtonRightW=40,BarButtonRightH=40,
    // 导航栏左边按钮
    BarButtonLeftX=0,BarButtonLeftY=0,BarButtonLeftW=40,BarButtonLeftH=40,
    // 日期选择View
    DateSelectViewX=0,DateSelectViewY=190,DateSelectViewW=320,DateSelectViewH=230,
    // TableView默认高度
    TableViewHeight=415,B01TableViewHeight=380,B01TableViewOffset=15,B02TableViewHeight=390,B02TableViewOffset=15,
    UITextViewInputViewW=320,UITextViewInputViewH=30,
} IGCommonRectDef;

typedef enum{
    // 整个TopPanel的定义
    A02TopPanelX=13,A02TopPanelY=2,A02TopPanelW=320,A02TopPanelH=145,
    // 目的地的标题和数据的定义
    A02DesAdrTitleLabelX=3,A02DesAdrTitleLabelY=10,A02DesAdrTitleLabelW=60,A02DesAdrTitleLabelH=25,
    A02DesAdrLabelX=70,A02DesAdrLabelY=11,A02DesAdrLabelW=200,A02DesAdrLabelH=25,
    // 发送邮件按钮定义
    A02SendMailButtonX=263,A02SendMailButtonY=8,A02SendMailButtonW=30,A02SendMailButtonH=30,
    // 交通方式的标题和数据的定义
    A02TrvalTitleLabelX=3,A02TrvalTitleLabelY=36,A02TrvalTitleLabelW=70,A02TrvalTitleLabelH=25,
    A02TrvalTypeX=73,A02TrvalTypeY=37,A02TrvalTypeW=25,A02TrvalTypeH=25,
    A02TrvalLabelX=100,A02TrvalLabelY=38,A02TrvalLabelW=188,A02TrvalLabelH=25,
    // 出发时间的标题和数据的定义
    A02StartTitleLabelX=3,A02StartTitleLabelY=61,A02StartTitleLabelW=80,A02StartTitleLabelH=25,
    A02StartLabelX=85,A02StartLabelY=63,A02StartLabelW=190,A02StartLabelH=25,
    A02AlertCheckboxX=265,A02AlertCheckboxY=57,A02AlertCheckboxW=30,A02AlertCheckboxH=30,
    // 住宿的标题和数据的定义
    A02HotelTitleLabelX=3,A02HotelTitleLabelY=86,A02HotelTitleLabelW=50,A02HotelTitleLabelH=25,
    A02HotelLabelX=55,A02HotelLabelY=88,A02HotelLabelW=210,A02HotelLabelH=25,
    // 备注的标题和数据的定义
    A02MemoTitleLabelX=3,A02MemoTitleLabelY=109,A02MemoTitleLabelW=50,A02MemoTitleLabelH=25,
    A02MemoLabelX=55,A02MemoLabelY=107,A02MemoLabelW=225,A02MemoLabelH=28,
    
    // CheckListHeaderView的定义
    A02CheckListHeaderViewX=0,A02CheckListHeaderViewY=0,A02CheckListHeaderViewW=320,A02CheckListHeaderViewH=35,
    A02CheckListTitleLabelX=15,A02CheckListTitleLabelY=9,A02CheckListTitleLabelW=100,A02CheckListTitleLabelH=25,
    A02CheckListFooterX=0,A02CheckListFooterY=0,A02CheckListFooterW=320,A02CheckListFooterH=15,
    // 选项卡
    A02SegmentedX = 105,A02SegmentedY = 2,A02SegmentedW = 130,A02SegmentedH = 30,
    // 模板按钮
    A02TemplateButtonX=15,A02TemplateButtonY=2,A02TemplateButtonW=110,A02TemplateButtonH=30,
    
    // 保存模板按钮
    A02SaveTemplateButtonX=130,A02SaveTemplateButtonY=2,A02SaveTemplateButtonW=110,A02SaveTemplateButtonH=30,
    
    // CheckList编辑按钮
    A02CheckListEditButtonX=270,A02CheckListEditButtonY=2,A02CheckListEditButtonW=30,A02CheckListEditButtonH=30,
    // CheckList行的件数Label
    A02CheckListCountLabelX=235,A02CheckListCountLabelY=7,A02CheckListCountLabelW=70,A02CheckListCountLabelH=25,
    
    // CheckList行高度
    A02CheckListLineHeight=30,
    A02CheckListCheckBoxX=18,A02CheckListCheckBoxY=2,A02CheckListCheckBoxW=25,A02CheckListCheckBoxH=25,
    
    // CheckBox行
    A02CheckItemLabelX = 55,A02CheckItemLabelY=2,A02CheckItemLabelW=200,A02CheckItemLabelH=25,
    A02CheckItemViewX=5,A02CheckItemViewY=0,A02CheckItemViewW=320,A02CheckItemViewH=25,
}A02RectDef;

typedef enum{
    // TableView的行高
    A01CellHeight = 78,A01SegmentedWidth = 80,
    // 选项卡
    A01SegmentedX = 0,A01SegmentedY = 0,A01SegmentedW = 160,A01SegmentedH = 40,
    // tableview头部位置
    A01TableViewHeaderX = 0,A01TableViewHeaderY = 0,A01TableViewHeaderW = 320,A01TableViewHeaderH = 10,
    // tableview位置
    A01TableViewX = 9,A01TableViewY = 10,A01TableViewW = 301,A01TableViewH = 390,
    // tableview底部位置
    A01TableViewFooterX = 0,A01TableViewFooterY = 400,A01TableViewFooterW = 320,A01TableViewFooterH = 10,
    // tableview的cell中交通方式显示位置
    A01CellTravlTypeX = 15,A01CellTravlTypeY = 10,A01CellTravlTypeW = 40,A01CellTravlTypeH = 55,
    // tableview的cell中目的地显示位置
    A01CellDesadrX = 70,A01CellDesadrY = 5,A01CellDesadrW = 170,A01CellDesadrH = 30,
    // tableview的cell中完成度显示位置
    A01CellOverX = 245,A01CellOverY = 40,A01CellOverW = 50,A01CellOverH = 25,
    // tableview的cell中出发时间显示位置
    A01CellStartTimeX = 70,A01CellStartTimeY = 30,A01CellStartTimeW = 170,A01CellStartTimeH = 25,
    // tableview的cell中提醒图标显示位置
    A01CellClockImageX = 253,A01CellClockImageY = 10,A01CellClockImageW = 30,A01CellClockImageH = 30,
    // tableview的住宿显示位置
    A01CellHotelX = 70,A01CellHotelY = 50,A01CellHotelW = 190,A01CellHotelH = 25,
    // tableview的交通详细显示位置
    A01CellTravldetailX = 5,A01CellTravldetailY = 50,A01CellTravldetailW = 60,A01CellTravldetailH = 25,
    
}A01RectDef;

typedef enum {
    BOOCellStartImageTag = 49,BOOCellEndImageTag = 48,BOOCellTitleTag = 47,BOOCellStartLabelTag = 46,BOOCellMemoTextFieldTag = 46,
    // B02模板画面cell高度
    B00CellHeight=40,B00AppCellHeight = 74,
    // tableview头部位置
    B00TableViewBackX = 10,B00TableViewBackY = 0,B00TableViewBackW = 300,B00TableViewBackH = 410,    
    // tableview位置
    B00TableViewX = 15,B00TableViewY = 10,B00TableViewW = 290,B00TableViewH = 390,
    // cell中开始图片的位置
    B00CellStartImageX = 5,B00CellStartImageY = 5,B00CellStartImageW = 30,B00CellStartImageH = 30,
    // cell中开始文字显示区域的位置
    B00CellStartLabelX = 5,B00CellStartLabelY = 5,B00CellStartLabelW = 150,B00CellStartLabelH = 35,
    // cell中标题的位置
    B00CellTitleX = 40,B00CellTitleY = 5,B00CellTitleW = 200,B00CellTitleH = 30,
    // cell中结束图片的位置
    B00CellEndImageX = 250,B00CellEndImageY = 5,B00CellEndImageW = 30,B00CellEndImageH = 30,
    // cell中app的icon,名字，介绍的位置
    B00CellAppImageX=5,B00CellAppImageY=5,B00CellAppImageW=64,B00CellAppImageH=64,
    B00CellAppNameX=80,B00CellAppNameY=3,B00CellAppNameW=150,B00CellAppNameH=32,
    B00CellAppMemoX=72,B00CellAppMemoY=25,B00CellAppMemoW=210,B00CellAppMemoH=45,

}B00RectDef;

typedef enum {
    // B02模板画面cell高度
    B02CellHeight=35,
    // tableview位置
    B02TableViewX = 9,B02TableViewY = 10,B02TableViewW = 301,B02TableViewH = 390,
    // 模板view的显示位置
    B02TemplateX=10,B02TemplateY=0,B02TemplateW=320,B02TemplateH=30,
    // 添加模板文本框的显示位置
    B02AddTemplateX=0,B02AddTemplateY=10,B02AddTemplateW=220,B02AddTemplateH=30,
    // 添加模板按钮的显示位置
    B02AddTemplateButtonX=230,B02AddTemplateButtonY=2,B02AddTemplateButtonW=30,B02AddTemplateButtonH=30,
    // 添加模板view的显示位置
    B02AddTemplateViewX=10,B02AddTemplateViewY=0,B02AddTemplateViewW=320,B02AddTemplateViewH=30,
    // 模板名字lab显示位置
    B02TemplateNameX=0,B02TemplateNameY=0,B02TemplateNameW=200,B02TemplateNameH=30,
    // 模板取得件数lab显示位置
    B02ItemsCountX=220,B02ItemsCountY=0,B02ItemsCountW=60,B02ItemsCountH=30,
    // item详细画面button显示位置
    B02NextButtonX=245,B02NextButtonY=3,B02NextButtonW=30,B02NextButtonH=30,
}B02RectDef;

typedef enum{
    // item显示位置
    B01ItemX=20,B01ItemY=0,B01ItemW=320,B01ItemH=40,
    // type显示位置
    B01TypeX=0,B01TypeY=0,B01TypeW=320,B01TypeH=40,
    // item 输入框的位置
    B01ItemInputX=20,B01ItemInputY=0,B01ItemInputW=200,B01ItemInputH=40,
    // type 输入框的位置
    B01TypeInputX=20,B01ItemTypeY=0,B01ItemTypeW=320,B01ItemTypeH=40,
    // item label 显示位置
    B01ItemLabelX=20,B01ItemLabelY=0,B01ItemLabelW=200,B01ItemLabelH=40,
    // save button 显示位置
    B01ButtonX= 240,B01ButtonY=2,B01ButtonW=40,B01ButtonH=30,
    // type label 显示位置
    B01TypeLabelX=20,B01TypeLabelY=0,B01TypeLabelW=200,B01TypeLabelH=40,
    // list 中的 checkbox 显示位置
    B01CheckListCheckBoxX=240,B01CheckListCheckBoxY=2,B01CheckListCheckBoxW=25,B01CheckListCheckBoxH=25,
    // item label显示用tag
    B01itemLabelTag=60,
    // 背景图片位置
    B01BackGroundX=0,B01BackGroundY=-5,B01BackGroundW=320,B01BackGroundH=420,
    // 数据显示区域位置
    B01DataViewX=15,B01DataViewY=32,B01DataViewW=291,B01DataViewH=370,
    // 头部件数显示位置
    B01CountLableX=15,B01CountLableY=5,B01CountLableW=100,B01CountLableH=25,
    // 头部全选择按钮显示位置
    B01AllCheckBtnX=240,B01AllCheckBtnY=1,B01AllCheckBtnW=60,B01AllCheckBtnH=30,
    // 标题view位置
    B01TitleViewX=0,B01TitleViewY=0,B01TitleViewW=200,B01TitleViewH=20,
    // 标题中间按钮位置
    B01TitleBtnX=0,B01TitleBtnY=0,B01TitleBtnW=150,B01TitleBtnH=35,
    // 编辑视图位置
    B01EditViewX=0,B01EditViewY=0,B01EditViewW=320,B01EditViewH=420,
    // 删除按钮位置
    B01DeleteBtnX=250,B01DeleteBtnY=33,B01DeleteBtnW=50,B01DeleteBtnH=32,
    
}B01RectDef;

@interface IGCommonDefine : NSObject

@end
