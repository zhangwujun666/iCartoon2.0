//
//  DraftBoxTableViewCell.h
//  iCartoon
//
//  Created by cxl on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//
#define kCellIdentifier_DraftPostTableViewCell @"DraftPostTableViewCell"

#import <UIKit/UIKit.h>
#import "DraftPostInfo.h"

@interface DraftPostTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL mSelected;
@property (nonatomic, strong) DraftPostInfo *myDraftInfo;
@property (nonatomic, assign) int type;
@end
