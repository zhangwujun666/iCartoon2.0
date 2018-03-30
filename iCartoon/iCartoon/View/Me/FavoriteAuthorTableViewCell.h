//
//  FavoriteAuthorTableViewCell.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConcernedAuthorInfo.h"

@class FavoriteAuthorTableViewCell;

@protocol FavoriteAuthorTableViewCellDelegate <NSObject>

@optional
- (void)cancelConcernAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface FavoriteAuthorTableViewCell : UITableViewCell

@property (weak, nonatomic) id<FavoriteAuthorTableViewCellDelegate> delegate;
@property (strong, nonatomic) ConcernedAuthorInfo *authorInfo;
@property (strong, nonatomic) NSIndexPath *indexPath;


@end
