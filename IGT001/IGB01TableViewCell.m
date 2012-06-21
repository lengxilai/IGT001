//
//  IGB01TableViewCell.m
//  IGT001
//
//  Created by 鹏 李 on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGB01TableViewCell.h"

@implementation IGB01TableViewCell

@synthesize nameLabel;
@synthesize countLabel;
@synthesize imageBtn;
@synthesize textField;
@synthesize imageCheckBox;
@synthesize planItem;
@synthesize templateItem;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier : (CellType)cellType{
    
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        type = cellType;
        
        // cell的背景颜色设定
        if(cellType == CellTypeSection){
            self.contentView.backgroundColor  = [UIColor classlistForSectionBackgroundImageColor];
        }else if(cellType == CellTypeRow){
            self.contentView.backgroundColor  = [UIColor classlistForCellBackgroundImageColor];
        }else if(cellType == CellTypeInput){
            self.contentView.backgroundColor  = [UIColor classlistForInputBackgroundImageColor];
        }else{
            self.contentView.backgroundColor  = [UIColor clearColor];
        }
        
        // 图片checkbox
        imageCheckBox = [[IGCheckBox alloc] initWithFrame:CGRectZero withImageName:@"star" isChecked:NO target:nil selector:nil];
        imageCheckBox.tag = CheckBox_Tag;
        [self.contentView addSubview:imageCheckBox];
        
        // 图片按钮
        imageBtn = [[UIButton alloc] init];
        imageBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        imageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        imageBtn.adjustsImageWhenDisabled = YES;
        imageBtn.adjustsImageWhenHighlighted = YES;
        [imageBtn setBackgroundColor:[UIColor clearColor]]; 
        [self.contentView addSubview:imageBtn];
        
        // 大分类和小分类名字显示lael        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        if(cellType == CellTypeSection){
            [nameLabel setTextColor:[UIColor blackColor]];
        }else if(cellType == CellTypeRow){
            [nameLabel setTextColor:[UIColor textRedBlackColor]];
        }
        [nameLabel setHighlightedTextColor:[UIColor whiteColor]];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:nameLabel];
        
        // 选择件数显示        
        countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        if(cellType == CellTypeSection){
            [countLabel setTextColor:[UIColor grayColor]];
            countLabel.font = [UIFont systemFontOfSize:15];
        }
        countLabel.textAlignment = UITextAlignmentRight;
        [countLabel setHighlightedTextColor:[UIColor whiteColor]];
        [countLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:countLabel];
        
        // 大分类和小分类添加入力框
        textField = [[UITextField alloc] init];
        textField.returnKeyType = UIReturnKeyDone;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.borderStyle = UITextBorderStyleNone;
        textField.autocorrectionType = UITextAutocorrectionTypeYes;
        [textField setTextColor:[UIColor grayColor]];
//        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = NSLocalizedString(@"输入新项目...", @"输入新项目...");
//        [textField setClearsOnBeginEditing:YES];
        [self.contentView addSubview:textField];
    }
    return self;
}

//- (void)willTransitionToState:(UITableViewCellStateMask)state {
//
//[super willTransitionToState:state];
//
//if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
//    
//    for (UIView *subview in self.subviews) {
//        
//        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {             
//            
//            subview.hidden = YES;
//            subview.alpha = 0.0;
//        }
//    }
//}
//}
//
//- (void)didTransitionToState:(UITableViewCellStateMask)state {
//
//[super didTransitionToState:state];
//
//if (state == UITableViewCellStateShowingDeleteConfirmationMask || state == UITableViewCellStateDefaultMask) {
//    for (UIView *subview in self.subviews) {
//        
//        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
//            
//            UIView *deleteButtonView = (UIView *)[subview.subviews objectAtIndex:0];
//            CGRect f = deleteButtonView.frame;
//            f.origin.x -= 20;
//            f.size.height -= 10;
//            deleteButtonView.frame = CGRectMake(0, 0, 80, 25); //这里可以改变delete button的大小
//            
//            subview.hidden = NO;
//            
//            [UIView beginAnimations:@"anim" context:nil];
//            subview.alpha = 1.0;
//            [UIView commitAnimations];
//        }
//    }
//}
//}

// 更新sectioncell
-(void)updateSectinCell:(IGB01TableViewCell*) cell :(NSString*) typeMasterName{
    
    cell.nameLabel.text = typeMasterName;
    self.contentView.backgroundColor  = [UIColor classlistForSectionBackgroundImageColor];
    [cell.imageCheckBox unCheck];
    
    // 不显示完成按钮、输入框、小星星
    cell.imageBtn.hidden = YES;
    cell.textField.hidden = YES;
    cell.imageCheckBox.hidden = YES;
}

-(void)updateInputCell:(IGB01TableViewCell*) cell{
    UIImage *newImage = [UIImage imageNamed:@"finish.png"];
    [cell.imageBtn setBackgroundImage:newImage forState:UIControlStateNormal];
    cell.contentView.backgroundColor = [UIColor classlistForInputBackgroundImageColor];
    
    // 显示完成按钮、输入框
    cell.imageBtn.hidden = NO;
    self.textField.hidden = NO;
    self.textField.text = @"";
    // 不显示名称、小星星
    cell.nameLabel.hidden = YES;
    cell.imageCheckBox.hidden = YES;
}

-(void)updateItemCell:(IGB01TableViewCell*) cell :(ItemMaster*) itemMaster{
    
    UIImage *newImage = [UIImage imageNamed:@"star_off.png"];
    [cell.imageBtn setBackgroundImage:newImage forState:UIControlStateNormal];
    cell.nameLabel.text = itemMaster.itemname;
    cell.contentView.backgroundColor = [UIColor classlistForCellBackgroundImageColor];
    
    // 不显示完成按钮、输入框
    cell.imageBtn.hidden = YES;
    cell.textField.hidden = YES;
    // 显示名称、小星星
    cell.nameLabel.hidden = NO;
    cell.imageCheckBox.hidden = NO;
    [cell.imageCheckBox unCheck];
}
#pragma mark -
#pragma mark Laying out subviews

/*
 To save space, the prep time label disappears during editing.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
	
    [nameLabel setFrame:[self _nameLabelFrame]];
    [imageBtn setFrame:[self _imageBtnFrame]];
    [textField setFrame:[self _textFieldFrame]];
    [countLabel setFrame:[self _countLabelFrame]];
    [imageCheckBox setFrame:[self _imageCheckBoxFrame]];
    if (self.editing) {
        imageBtn.alpha = 0.0;
        imageCheckBox.alpha = 0.0;
    } else {
        imageBtn.alpha = 1.0;
        imageCheckBox.alpha = 1.0;
    }
}

#define ZERO                 0.0
#define IMAGE_SIZE           30.0
#define CONTENT_LEFT_MARGIN  10.0
#define CONTENT_RIGHT_MARGIN 5.0
#define CONTENT_TOP_MARGIN   2.5
#define TEXTFIELD_TOP_MARGIN 10.0
#define COUNT_LABEL_WIDTH    100.0
#define INPUT_FIELD_WIDTH    180.0
/*
 Return the frame of the various subviews -- these are dependent on the editing state of the cell.
 */
- (CGRect)_nameLabelFrame {
    switch (type) {
        case CellTypeSection:
            return CGRectMake(ZERO, ZERO, self.contentView.bounds.size.width-CONTENT_RIGHT_MARGIN-IMAGE_SIZE - COUNT_LABEL_WIDTH, self.bounds.size.height);
        case CellTypeRow:
            return CGRectMake(CONTENT_LEFT_MARGIN*2, ZERO, self.contentView.bounds.size.width-CONTENT_LEFT_MARGIN*2-CONTENT_RIGHT_MARGIN-IMAGE_SIZE, self.bounds.size.height);
        default:
            return CGRectMake(ZERO, ZERO, ZERO, ZERO);
    }
}

- (CGRect)_imageBtnFrame {
    return CGRectMake(CONTENT_LEFT_MARGIN*2+INPUT_FIELD_WIDTH, CONTENT_TOP_MARGIN, IMAGE_SIZE, IMAGE_SIZE);
}

- (CGRect)_textFieldFrame {
    return CGRectMake(CONTENT_LEFT_MARGIN*2, TEXTFIELD_TOP_MARGIN, INPUT_FIELD_WIDTH, self.bounds.size.height);
}

- (CGRect)_countLabelFrame {
    switch (type) {
        case CellTypeSection:
            return CGRectMake(self.contentView.bounds.size.width-CONTENT_RIGHT_MARGIN-IMAGE_SIZE - COUNT_LABEL_WIDTH, ZERO, COUNT_LABEL_WIDTH, self.bounds.size.height);
        default:
            return CGRectMake(ZERO, ZERO, ZERO, ZERO);
    }
}

- (CGRect)_imageCheckBoxFrame {
    
    switch (type) {
        case CellTypeSection:
            return CGRectMake(self.bounds.size.width-CONTENT_RIGHT_MARGIN-IMAGE_SIZE,CONTENT_TOP_MARGIN, IMAGE_SIZE, IMAGE_SIZE);
        case CellTypeRow:
            return CGRectMake(self.bounds.size.width-CONTENT_RIGHT_MARGIN-IMAGE_SIZE, CONTENT_TOP_MARGIN, IMAGE_SIZE, IMAGE_SIZE);
        default:
            return CGRectMake(ZERO, ZERO, ZERO, ZERO);
    }
}
@end
