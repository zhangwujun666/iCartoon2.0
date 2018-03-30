//
//  MyMessageNewTableViewCell.h
//  iCartoon
//
//  Created by cxl on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInfo.h"

#define kCellIdentifier_MyMessageNewTableViewCell @"MyMessageNewTableViewCell"

@interface MyMessageNewTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL mSelected;
@property (nonatomic, strong) MessageInfo *messageInfo;

@end
