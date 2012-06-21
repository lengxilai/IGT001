//
//  IGTextViewController.m
//  IGT001
//
//  Created by DATA NTT on 12/05/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGTextViewController.h"

@implementation IGTextViewController

@synthesize textView;
@synthesize delegate;

-(id)initWithFrame:(CGRect)frame withText:(NSString*)text withFont:(UIFont*)font{
    self = [super init];
    if (self) {
        textView = [[UITextView alloc] initWithFrame:frame];
        textView.delegate = self;
        textView.backgroundColor = [UIColor clearColor];
        textView.text = text;
        textView.font = font;
        textView.scrollEnabled = NO;
        // 设定一个最小高度
        minHeight = frame.size.height;
        
        CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(textView.contentSize.width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        // 根据文字大小重新设定一下TextView的大小
        [textView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height+TextViewOverY<minHeight?minHeight+TextViewPaddingY:size.height+TextViewOverY)];
        
        // 完成按钮
        topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, UITextViewInputViewW, UITextViewInputViewH)];
        [topView setBarStyle:UIBarStyleBlack];    
        UIBarButtonItem*btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self  action:nil];
        
        UIBarButtonItem*doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self  action:@selector(dismissKeyBoard:)];
        NSArray*buttonsArry = [NSArray arrayWithObjects:btnSpace, doneButton, nil];

        [topView setItems:buttonsArry];
//        [textView setInputAccessoryView:topView];
    }
    return self;
}

- (void)dismissKeyBoard:(id)sender
{
    [textView resignFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.textView setInputAccessoryView:topView];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.textView setInputAccessoryView:nil];
}

- (void)textViewDidChange:(UITextView *)sender
{   
    // 如果内容的高度减去缩进值之后不等于文本域的高度
    if (textView.contentSize.height != textView.frame.size.height) {
        
        // 如果小于最小高度则设定为最小高度
        CGFloat height = textView.contentSize.height;
        if (height < minHeight) {
            height = minHeight;
        }
        
        // 重新设定文本域的高度：设定为内容高度减去缩进值
        [textView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, height)];
        
        // 通知委托类调整高度
        if ([self.delegate respondsToSelector:@selector(textViewDidChangeHeight:forHeight:)]) {
            [self.delegate textViewDidChangeHeight:textView forHeight:height];
        }
    }
}

- (void)loadView
{
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
