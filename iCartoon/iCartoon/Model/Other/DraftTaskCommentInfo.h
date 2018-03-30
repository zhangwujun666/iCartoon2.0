//
//  DraftTaskCommentInfo.h
//  iCartoon
//
//  Created by 许成雄 on 16/5/12.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DraftTaskCommentInfo : NSObject

@property (strong, nonatomic) NSString *commentId;         //
@property (strong, nonatomic) NSString *comment;           //
@property (strong, nonatomic) NSString *taskId;            //
@property (strong, nonatomic) NSString *taskTitle;         //
@property (strong, nonatomic) NSString *authorId;          //帖子作者ID
@property (strong, nonatomic) NSString *createTime;        //创建时间

@property (assign, nonatomic) BOOL isSelected;             //是否被选中

@end
