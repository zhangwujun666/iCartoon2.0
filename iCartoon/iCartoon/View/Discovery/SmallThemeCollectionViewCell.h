//
//  SmallThemeCollectionViewCell.h
//  iHealth
//
//  Created by 寻梦者 on 15/9/5.
//  Copyright (c) 2015年 xuchengxiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeInfo.h"

@protocol SmallThemeCollectionViewCellDelegate <NSObject>

@optional
- (void)collectionCellClickedAtItem:(ThemeInfo *)themeInfo;

@end

@interface SmallThemeCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)NSString * type;
@property (strong, nonatomic) ThemeInfo *themeInfo;
@property (assign, nonatomic) id<SmallThemeCollectionViewCellDelegate> delegate;

@end
