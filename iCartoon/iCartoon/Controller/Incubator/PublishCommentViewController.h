//
//  PublishCommentViewController.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostDetailInfo.h"
#import "PostCommentInfo.h"
#import "DraftCommentInfo.h"

typedef void(^ShowAlertBlock)();
//typedef void(^ShowAlertBlock2)();


typedef NS_ENUM(NSInteger, CommentSourceType) {
    CommentSourceTypeNew = 0,
    CommentSourceTypeDraft
};

@interface PublishCommentViewController : UIViewController

@property (assign, nonatomic) CommentSourceType type;                //评论来源类型
@property (strong, nonatomic) PostDetailInfo *postDetailInfo;
@property (strong, nonatomic) PostCommentInfo *replyCommentInfo;     
@property (strong, nonatomic) DraftCommentInfo *draftCommentInfo;    //评论草稿
@property (copy,nonatomic) ShowAlertBlock block;
//@property (copy,nonatomic) ShowAlertBlock2 block2;
@property (nonatomic,assign)BOOL isComment;
@property (nonatomic,assign)BOOL isEdit;
@property (nonatomic,strong)NSString * isDifference;


@property (nonatomic,copy)NSString  *  strTag;

@end
