//
//  MyTabBar.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/27.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTabBar;

@protocol MyTabBarDelegate <UITabBarDelegate>

@optional
- (void)tabBar:(MyTabBar *)tabbar didClickCenterButton:(UIButton *)centerButton;

@end

@interface MyTabBar : UITabBar

@property (weak, nonatomic) id<MyTabBarDelegate> tabBarDelegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end
