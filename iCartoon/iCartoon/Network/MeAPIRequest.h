//
//  MeAPIRequest.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/16.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iCartoonAPI.h"

@interface MeAPIRequest : NSObject

+ (instancetype)sharedInstance;

#pragma mark - 日常相关
//获取用户互动信息
- (void)getUserInteractionInfo:(void *)param success:(void(^)(UserInteractionInfo *))successHandler failure:(void(^)(NSError *))failureHandler;

//获取用户相关的信息
- (void)getUserRelativeInfo:(void *)param success:(void(^)(UserRelativeInfo *))successHandler failure:(void(^)(NSError *))failureHandler;

//获取用户关注的主题
- (void)getUserConcernedThemes:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler;

//获取用户关注的帖子
- (void)getUserConcernedPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler;

//获取用户收藏的任务列表
- (void)getUserCollectedTasks:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取用户收藏的帖子列表
- (void)getUserCollectedPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取用户发布的帖子
- (void)getUserPublishedPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取回复与评论
- (void)getReplyAndComments:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取用户消息
- (void)getUserMessages:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取我的评论
- (void)getMyComments:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取用户关注的作者
- (void)getUserFollowedAuthors:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler;

//关注/取消关注作者
- (void)followAuthor:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler;

//获取用户的粉丝
- (void)getMyFuns:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler;

#pragma mark - 消息中心
//获取消息中心
- (void)getMessageList:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//删除帖子
- (void)deletePost:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError*))failureHandler;

//设置消息为已读
- (void)setMessageAsRead:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError*))failureHandler;

//删除消息
- (void)deleteMessage:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError*))failureHandler;

@end
