//
//  IGMailComposeViewController.h
//  IGT001
//
//  Created by 鹏 李 on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "IGCommonInclude.h"

@interface IGMailComposeViewController : UIViewController <MFMailComposeViewControllerDelegate>{
    // 前画面的ViewController
    UIViewController *preViewController;
}
@property(nonatomic, retain) UIViewController *preViewController;

-(id)init;
-(void)showPicker;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;

@end
