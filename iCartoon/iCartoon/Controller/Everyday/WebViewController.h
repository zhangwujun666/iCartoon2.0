//
//  WebViewController.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeBannerInfo.h"
@interface WebViewController : UIViewController

@property (strong, nonatomic) NSString *urlStr;
@property (nonatomic,strong)HomeBannerInfo *bannerInfo;
@end
