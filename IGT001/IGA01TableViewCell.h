//
//  IGA01TableViewCell.h
//  IGT001
//
//  Created by 鹏 李 on 12-4-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Plan.h"
#import "PlanItem.h"
#import "IGBusinessUtil.h"
#import "UIColor+IGColor.h"
#import "IGLabel.h"
#import "IGCommonDefine.h"
#import "IGCheckBox.h"

@interface IGA01TableViewCell : UITableViewCell {

    // 交通方式
    IGLabel *travlTpyeiImageView;
    // 出发时间
    UILabel *startTimeLabel;
    // 目的地
    UILabel *desadrLabel;
    // 完成度
    UILabel *overLabel;
    // 提醒图标
    IGCheckBox *clockImageView;
    // 交通详细
    UILabel *travlDetailLabel;
    // 住宿信息
    UILabel *hotelLabel;
    
}
@property (nonatomic, retain) IGLabel *travlTpyeiImageView;
@property (nonatomic, retain) UILabel *startTimeLabel;
@property (nonatomic, retain) UILabel *desadrLabel;
@property (nonatomic, retain) UILabel *overLabel;
@property (nonatomic, retain) UILabel *travlDetailLabel;
@property (nonatomic, retain) UILabel *hotelLabel;
@property (nonatomic, retain) IGCheckBox *clockImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)updateCell:(IGA01TableViewCell*) cell :(Plan*) newPlan;
- (CGRect)_travlTpyeiImageViewFrame;
- (CGRect)_startTimeLabelFrame;
- (CGRect)_desadrLabelFrame;
- (CGRect)_overLabelFrame;
- (CGRect)_clockImageViewFrame;

@end
