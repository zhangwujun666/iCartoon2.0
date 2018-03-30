//
//  MyCommentTableViewCell.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/20.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMessageInfo.h"
@protocol MyCommentTableViewCellDelegate <NSObject>

@optional
- (void)clickCheckboxAtItem:(MyMessageInfo *)postInfo indexPath:(NSIndexPath *)indexPath tag:(NSInteger )tag;//管理时checkbox点击调用
- (void)unclickCheckboxAtItem:(MyMessageInfo *)postInfo indexPath:(NSIndexPath *)indexPath tag:(NSInteger )tag;//管理时checkboxq取消点击调用
@end

@interface MyCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) id<MyCommentTableViewCellDelegate> delegate;
@property (strong, nonatomic) UIButton *checkBox;
@property (nonatomic, assign) BOOL mSelected;
@property (strong, nonatomic) MyMessageInfo *messageInfo;
@property (strong, nonatomic) NSIndexPath *indexPath;
- (void)changeState;
- (void)backState;
- (void)changPictureBack;
- (void)changPicture;
@end
