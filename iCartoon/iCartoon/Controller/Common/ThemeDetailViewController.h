//
//  TopicDetailViewController.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/30.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeInfo.h"

@interface ThemeDetailViewController : UIViewController
@property (nonatomic,assign)int fromWhere;
@property (strong, nonatomic) ThemeInfo *themeInfo;
@property (strong, nonatomic) NSString *themeId;
@end
