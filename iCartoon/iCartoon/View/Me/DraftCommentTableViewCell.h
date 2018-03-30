//
//  DraftCommentTableViewCell.h
//  iCartoon
//
//  Created by cxl on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraftCommentInfo.h"

#define kCellIdentifier_DraftCommentTableViewCell @"DraftCommentTableViewCell"

@interface DraftCommentTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL mSelected;
@property (nonatomic, strong) DraftCommentInfo *commentDraftInfo;
@property (nonatomic, assign)int type;
@end
