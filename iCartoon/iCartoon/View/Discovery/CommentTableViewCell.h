//
//  CommentTableViewCell.h
//  GaoZhi
//
//  Created by 寻梦者 on 15/10/27.
//  Copyright © 2015年 GlenN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostCommentInfo.h"
#import "PPLabel.h"
@class CommentTableViewCell;

@protocol CommentTableViewCellDelegate <NSObject>

@optional

- (void)replyCommentAtIndexPath:(NSIndexPath *)indexPath;
- (void)clickAuthorAtIndexPath:(NSIndexPath *)indexPath;
- (void)clickAtAuthorAtIndexPath:(NSIndexPath *)indexPath;


@end

@interface CommentTableViewCell : UITableViewCell<PPLabelDelegate>

@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nicknameLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) PPLabel *commentLabel;

@property (strong, nonatomic) PostCommentInfo *commentInfo;
@property (strong, nonatomic) NSIndexPath *selectIndexPath;

@property (strong, nonatomic) id<CommentTableViewCellDelegate> delegate;

+ (CGFloat)heightForCell:(NSIndexPath *)indexPath withCommentInfo:(PostCommentInfo *)commentInfo;

@end
