//
//  SearchThemeTableViewCell.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeInfo.h"

@class SearchThemeTableViewCell;

@protocol SearchThemeTableViewCellDelegate <NSObject>

@optional
- (void)cancelConcernAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface SearchThemeTableViewCell : UITableViewCell

@property (weak, nonatomic) id<SearchThemeTableViewCellDelegate> delegate;
@property (strong, nonatomic) ThemeInfo *themeInfo;
@property (strong, nonatomic) UILabel *titleLabel;


@end
