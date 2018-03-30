//
//  SearchTableViewCell.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchHistoryInfo.h"

@interface SearchTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *indexLabel;
@property (strong, nonatomic) SearchHistoryInfo *item;
@property(nonatomic,copy) dispatch_block_t deleteBtnTapAction;
@end
