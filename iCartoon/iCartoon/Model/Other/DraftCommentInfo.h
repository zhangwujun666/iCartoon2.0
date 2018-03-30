//
//  DraftCommentInfo.h
//  iCartoon
//
//  Created by 许成雄 on 16/4/17.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DraftCommentInfo : NSObject

@property (strong, nonatomic) NSString *commentId;         //
@property (strong, nonatomic) NSString *comment;           //
@property (strong, nonatomic) NSString *createTime;        //
@property (strong, nonatomic) NSString *postId;            //
@property (strong, nonatomic) NSString *postTitle;         //
@property (strong, nonatomic) NSString *postContent;       //
@property (strong, nonatomic) NSString *postImageUrl;      //如若有图片,取第一张图片，没有图片则是nil
@property (strong, nonatomic) NSString *authorId;          //帖子作者ID
@property (strong, nonatomic) NSString *authorName;        //帖子作者
@property (strong, nonatomic) NSString *replierId;         //回复的人的ID
@property (strong, nonatomic) NSString *replierName;       //回复的人

@property (assign, nonatomic) BOOL isSelected;             //是否被选中

@end
