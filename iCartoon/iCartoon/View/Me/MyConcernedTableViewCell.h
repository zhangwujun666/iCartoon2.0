//
//  MyConcernedTableViewCell.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeInfo.h"

@class MyConcernedTableViewCell;

@protocol MyConcernedTableViewCellDelegate <NSObject>

@optional
- (void)cancelConcernAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MyConcernedTableViewCell : UITableViewCell

@property (weak, nonatomic) id<MyConcernedTableViewCellDelegate> delegate;
@property (strong, nonatomic) ThemeInfo *concernedItem;
@property (strong, nonatomic) NSIndexPath *indexPath;


@end
