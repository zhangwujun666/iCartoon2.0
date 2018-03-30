//
//  LoginSucCollectionViewCell.h
//  iCartoon
//
//  Created by cxl on 16/3/26.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeInfo.h"

#define kCellIdentifier_LoginSucCollectionViewCell @"LoginSucCollectionViewCell"

@interface LoginSucCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) ThemeInfo *themeInfo;

- (void)selectedCollectCell;
- (void)deselectCollectCell;

@end
