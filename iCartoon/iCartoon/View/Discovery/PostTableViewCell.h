//
//  DiscoveryTableViewCell.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostInfo.h"
@protocol PostTableViewCellDelegate <NSObject>

@optional
- (void)clickAuthorAtItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath;
- (void)clickThemeAtItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath;
- (void)commentPostForItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath;
- (void)favorPostForItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath;
- (void)clickCheckboxAtItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath tag:(NSInteger )tag;//管理时checkbox点击调用
- (void)unclickCheckboxAtItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath tag:(NSInteger )tag;//管理时checkboxq取消点击调用
@end


@interface PostTableViewCell : UITableViewCell

+ (CGFloat)heightForCell:(NSIndexPath *)indexPath withCommentInfo:(PostInfo *)postInfo;

@property (weak, nonatomic) id<PostTableViewCellDelegate> delegate;
@property (strong, nonatomic) PostInfo *postItem;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UIButton *checkBox;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (nonatomic, assign) BOOL mSelected;
@property (nonatomic,strong) NSString *isfreeze;
@property (nonatomic,strong) NSString *thaw_date;
@property (nonatomic,strong) NSString *thaw_time;
@property (nonatomic,strong)NSString * isshow;
- (void)changeState;
- (void)backState;
@end
