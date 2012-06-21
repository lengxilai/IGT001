//
//  IGViewController.m
//  IGT001Local
//
//  Created by 鹏 李 on 12-4-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGMainViewController.h"

@implementation IGMainViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Custom initialization
        self.navigationBar.barStyle = UIBarStyleBlackOpaque;
        [self.navigationBar setBackgroundColor:[UIColor clearColor]];
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbarbak.png"] forBarMetrics:UIBarMetricsDefault];
        self.view.backgroundColor = [UIColor viewBackgroundImageColor];
        
        // 广告页追加 收费版去除广告
        //[self.view addSubview:[IGAdBannerViewController shareIadView]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
