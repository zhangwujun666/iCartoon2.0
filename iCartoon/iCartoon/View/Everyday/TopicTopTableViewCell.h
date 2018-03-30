//
//  TopicTableViewCell.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeDetailInfo.h"

@class TopicTopTableViewCell;

@protocol TopicTopTableViewCellDelegate <NSObject>

@optional
- (void)followActionForTheme:(ThemeDetailInfo *)themeInfo;

@end

@interface TopicTopTableViewCell : UITableViewCell

@property (strong, nonatomic) ThemeDetailInfo *themeInfo;

@property (assign, nonatomic) id<TopicTopTableViewCellDelegate> delegate;

@end
