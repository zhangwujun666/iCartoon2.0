//
//  AttentionTableViewCell.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostInfo.h"

@class AttentionTableViewCell;

@protocol AttentionTableViewCellDelegate <NSObject>

@optional
- (void)moreClickedForCell:(PostInfo *)postInfo;

@end

@interface AttentionTableViewCell : UITableViewCell

@property (strong, nonatomic) PostInfo *postItem;

@property (assign, nonatomic) id<AttentionTableViewCellDelegate> delegate;

@end
