//
//  ShopCollectionViewCell.h
//  iCartoon
//
//  Created by cxl on 16/3/27.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellIdentifier_ShopCollectionViewCell @"ShopCollectionViewCell"
@class BShop;
@interface ShopCollectionViewCell : UICollectionViewCell
- (void)setCollectionView;
@property(nonatomic, strong) BShop * shop;
@end
