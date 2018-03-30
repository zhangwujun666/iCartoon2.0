//
//  ThemeTableViewCell.h
//  iCartoon
//
//  Created by 寻梦者 on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeInfo.h"

@protocol ThemeTableViewCellDelegate <NSObject>

@optional
- (void)themeButtonClickedAtItem:(ThemeInfo *)themeInfo;

@end

@interface ThemeTableViewCell : UITableViewCell

@property (assign, nonatomic) id<ThemeTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSArray *themeArray;

@end
