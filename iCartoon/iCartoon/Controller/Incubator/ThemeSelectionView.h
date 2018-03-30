//
//  ThemeSelectionView.h
//  iCartoon
//
//  Created by 许成雄 on 16/4/2.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeInfo.h"

@protocol ThemeSelectionViewDelegate <NSObject>

@required
- (void)didSelectAtItem:(ThemeInfo *)themeInfo;

@end

@interface ThemeSelectionView : UIView

@property (assign, nonatomic) id<ThemeSelectionViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withSelectTheme:(ThemeInfo *)themeInfo;

- (void)show;

- (void)hide;

@end
