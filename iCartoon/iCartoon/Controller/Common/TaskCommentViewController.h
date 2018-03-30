//
//  TaskCommentViewController.h
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

typedef NS_ENUM(NSInteger, TaskCommentSourceType) {
    TaskCommentSourceTypeNew = 0,
    TaskCommentSourceTypeDraft
};

@interface TaskCommentViewController : UIViewController

@property (assign, nonatomic) TaskCommentSourceType type;                //评论来源类型
@property (strong, nonatomic) NSString *taskId;                          //任务ID
@property (strong, nonatomic) NSString *authorId;                        //作者ID
@property (strong, nonatomic) NSString *commentId;                       //评论ID
@property (strong, nonatomic) DraftCommentInfo *draftCommentInfo;        //评论草稿
@property (copy,nonatomic) ShowAlertBlock block;
//@property (copy,nonatomic) ShowAlertBlock2 block2;
@property (nonatomic,assign) BOOL isComment;
@end
