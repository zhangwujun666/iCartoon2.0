//
//  DraftBoxTableViewCell.h
//  iCartoon
//
//  Created by cxl on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//
#define kCellIdentifier_DraftBoxTableViewCell @"DraftBoxTableViewCell"
#import <UIKit/UIKit.h>
@class DraftInfo;
@interface DraftBoxTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL mSelected;
@property (nonatomic, strong) DraftInfo *myDraftInfo;
@end
