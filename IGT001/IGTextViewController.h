//
//  IGTextViewController.h
//  IGT001  自动换行的UITextView
//
//  Created by DATA NTT on 12/05/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGCommonDefine.h"

typedef enum{
    // 初始化时顶部缩进
    TextViewPaddingY=7,
    // TextView本身上下的缩进和
    TextViewOverY=16,
}TextViewDef;

@protocol IGTextViewDelegate

@optional
- (void)textViewDidChangeHeight:(UITextView*)textView forHeight:(CGFloat)height;
@end

@interface IGTextViewController : UIViewController<UITextViewDelegate>
{
    UITextView *textView;
    CGFloat minHeight;
    id delegate;
    UIToolbar *topView;
}

@property(nonatomic, retain)UITextView *textView;
@property(nonatomic, retain)id delegate;

-(id)initWithFrame:(CGRect)frame withText:(NSString*)text withFont:(UIFont*)font;

@end
