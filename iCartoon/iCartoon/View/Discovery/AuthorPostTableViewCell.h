//
//  AuthorPostTableViewCell.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostInfo.h"

@protocol AuthorPostTableViewCellDelegate <NSObject>

@optional
- (void)clickAuthorAtItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath;
- (void)clickThemeAtItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath;
- (void)commentPostForItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath;
- (void)favorPostForItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath;

@end


@interface AuthorPostTableViewCell : UITableViewCell

+ (CGFloat)heightForCell:(NSIndexPath *)indexPath withCommentInfo:(PostInfo *)postInfo;

@property (weak, nonatomic) id<AuthorPostTableViewCellDelegate> delegate;
@property (strong, nonatomic) PostInfo *postItem;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end
