//
//  IGCheckBox.m
//  IGT001
//
//  Created by Ming Liu on 12-5-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGCheckBox.h"
#import "UIUtil.h"

@implementation IGCheckBox

@synthesize isChecked;
@synthesize imageName;
@synthesize checkItem;

- (id)initWithFrame:(CGRect)frame withImageName:(NSString*)inputImageName isChecked:(BOOL)inputIsChecked target:(id)target selector:(SEL)inSelector
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        if (inputImageName != nil) {
            UIImage *newImage = [UIImage imageNamed:inputIsChecked?[NSString stringWithFormat:@"%@_on.png",inputImageName]:[NSString stringWithFormat:@"%@_off.png",inputImageName]];
            [self setBackgroundImage:newImage forState:UIControlStateNormal];
        }
        [self addTarget:target action:inSelector forControlEvents:UIControlEventTouchUpInside];
        self.adjustsImageWhenDisabled = YES;
        self.adjustsImageWhenHighlighted = YES;
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.imageName = inputImageName;
        self.isChecked = inputIsChecked;
    }
    return self;
}

-(void)changeState
{
    if (isChecked) {
        [self unCheck];
    }else {
        [self check];
    }
}

-(void)check
{
    self.isChecked = YES;
    UIImage *newImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_on.png",imageName]];
    [self setBackgroundImage:newImage forState:UIControlStateNormal];
}

-(void)unCheck
{
    self.isChecked = NO;
    UIImage *newImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_off.png",imageName]];
    [self setBackgroundImage:newImage forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
