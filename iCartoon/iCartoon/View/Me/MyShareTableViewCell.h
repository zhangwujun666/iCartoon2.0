//
//  MyShareTableViewCell.h
//  iCartoon
//
//  Created by cxl on 16/3/27.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellIdentifier_MyShareTableViewCell @"MyShareTableViewCell"

@interface MyShareTableViewCell : UITableViewCell

- (void)setImgName:(NSString *)imgName title:(NSString *)titleName status:(NSString *)statusType;

@end
