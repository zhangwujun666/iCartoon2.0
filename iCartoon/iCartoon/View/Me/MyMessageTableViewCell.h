//
//  MyMessageNewTableViewCell.h
//  iCartoon
//
//  Created by cxl on 16/3/27.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_MyMessageTableViewCell @"MyMessageTableViewCell"

@interface MyMessageTableViewCell : UITableViewCell

@property(nonatomic,copy) void (^headBtnTapAction)(BOOL isShow);

- (void)setTitle:(NSString *)titleName content:(NSString *)contentStr isShow:(BOOL)isShow;

@end
