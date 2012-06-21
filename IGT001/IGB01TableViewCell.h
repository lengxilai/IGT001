//
//  IGA01TableViewCell.h
//  IGT001
//
//  Created by 鹏 李 on 12-4-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TypeMaster.h"
#import "ItemMaster.h"
#import "IGBusinessUtil.h"
#import "UIUtil.h"
#import "IGCheckBox.h"
#import "PlanItem.h"
#import "IGCommonDefine.h"

// cell类型
typedef enum{
    CellTypeSection=1,
    CellTypeRow=2,
    CellTypeInput =3,
}CellType;

@interface IGB01TableViewCell : UITableViewCell {
    
    // 分类名称
    UILabel *nameLabel;
    // 选择件数
    UILabel *countLabel;
    // 图片button
    UIButton *imageBtn;
    // 图片checkbox
    IGCheckBox *imageCheckBox;
    // 添加输入
    UITextField *textField;
    // cell类型
    CellType type;
    // 行程中的项目
    PlanItem *planItem;
    // 模板中的项目
    ItemMaster *templateItem;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UIButton *imageBtn;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UILabel *countLabel;
@property (nonatomic, retain) IGCheckBox *imageCheckBox;

@property (nonatomic, retain) PlanItem *planItem;
@property (nonatomic, retain) ItemMaster *templateItem;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier:(CellType)cellType;
-(void)updateSectinCell:(IGB01TableViewCell*) cell :(NSString*) typeMasterName;
-(void)updateInputCell:(IGB01TableViewCell*) cell;
-(void)updateItemCell:(IGB01TableViewCell*) cell :(ItemMaster*) itemMaster;
@end
