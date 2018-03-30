//
//  MyFunsTableViewCell.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConcernedAuthorInfo.h"

@class MyFunsTableViewCell;

@protocol MyFunsTableViewCellDelegate <NSObject>

@optional
- (void)cancelConcernAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MyFunsTableViewCell : UITableViewCell

@property (weak, nonatomic) id<MyFunsTableViewCellDelegate> delegate;
@property (strong, nonatomic) ConcernedAuthorInfo *authorInfo;
@property (strong, nonatomic) NSIndexPath *indexPath;


@end
