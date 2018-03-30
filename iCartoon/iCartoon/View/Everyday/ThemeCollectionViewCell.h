//
//  ThemeCollectionViewCell.h
//  iHealth
//
//  Created by 寻梦者 on 15/9/5.
//  Copyright (c) 2015年 xuchengxiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeInfo.h"

@protocol ThemeCollectionViewCellDelegate <NSObject>

@optional
- (void)collectionCellClickedAtItem:(ThemeInfo *)themeInfo;

@end

@interface ThemeCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) ThemeInfo *themeInfo;
@property (assign, nonatomic) id<ThemeCollectionViewCellDelegate> delegate;

@end
