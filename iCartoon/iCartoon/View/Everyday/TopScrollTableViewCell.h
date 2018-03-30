//
//  TopScrollTableViewCell.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/27.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLCycleScrollView.h"
#import "HomeBannerInfo.h"

@class TopScrollTableViewCell;

@protocol TopScrollTableViewCellDelegate <NSObject>

@optional
- (void)didClickTopBannerInfo:(HomeBannerInfo *)bannerInfo;

@end

@interface TopScrollTableViewCell : UITableViewCell

@property (nonatomic, strong) XLCycleScrollView *scrollView;

@property (strong, nonatomic, setter = setTopList:) NSArray *topList;

@property (weak, nonatomic) id<TopScrollTableViewCellDelegate> delegate;

@end
