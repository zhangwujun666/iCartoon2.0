//
//  MoreThemeTableViewCell.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeInfo.h"

@class MoreThemeTableViewCell;

@protocol MoreThemeTableViewCellDelegate <NSObject>

@optional
- (void)concernAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MoreThemeTableViewCell : UITableViewCell

@property (weak, nonatomic) id<MoreThemeTableViewCellDelegate> delegate;
@property (strong, nonatomic) ThemeInfo *concernedItem;
@property (strong, nonatomic) NSIndexPath *indexPath;


@end
