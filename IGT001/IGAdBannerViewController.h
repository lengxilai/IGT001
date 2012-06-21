//
//  IGAdBannerViewController.h
//  IGT001
//
//  Created by 鹏 李 on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface IGAdBannerViewController : UIView<ADBannerViewDelegate>{
    ADBannerView *bannerView;
}

+(id)shareIadView;
@end
