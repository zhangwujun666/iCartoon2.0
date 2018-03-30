//
//  PictureCollectionViewCell.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/28.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSString *imageUrl;

@property (assign, nonatomic) BOOL hasSelected;

@end
