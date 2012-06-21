//
//  IGCheckBox.h
//  IGT001
//
//  Created by Ming Liu on 12-5-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGCheckBox : UIButton
{
    NSString *imageName;
    BOOL isChecked;
    id checkItem;
}

@property BOOL isChecked;
@property(nonatomic,retain) NSString *imageName;
@property(nonatomic,retain) id checkItem;

- (id)initWithFrame:(CGRect)frame withImageName:(NSString*)inputImageName isChecked:(BOOL)inputIsChecked target:(id)target selector:(SEL)inSelector;

-(void)changeState;
-(void)check;
-(void)unCheck;
@end
