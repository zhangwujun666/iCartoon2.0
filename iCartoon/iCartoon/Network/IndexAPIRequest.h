//
//  IndexAPIRequest.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/18.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iCartoonAPI.h"

@interface IndexAPIRequest : NSObject

+ (instancetype)sharedInstance;

#pragma mark - Public Method
//获取顶部滚动条列表
- (void)getIndexBanners:(void *)param success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler;

//获取主页帖子主题列表
- (void)getIndexThemes:(void *)param success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler;

//获取主页帖子列表
- (void)getIndexPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取主页任务列表
- (void)getIndexTasks:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取任务列表
- (void)getTasks:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取我的任务列表
- (void)getUserTasks:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取任务信息
- (void)getTaskInfo:(NSDictionary *)params success:(void(^)(TaskDetailInfo *))successHandler failure:(void(^)(NSError*))failureHandler;

//为任务投票(完成任务)
- (void)voteForTask:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError*))failureHandler;

//收藏任务
- (void)collectTask:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取侧边栏主题列表
- (void)getAllThemes:(void *)param success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler;

//获取侧边栏我关注的主题列表
- (void)getMyThemes:(void *)param success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler;

//查询侧边栏主题列表
- (void)searchThemes:(NSDictionary *)param success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler;

//获取主题详情
- (void)getThemeInfo:(NSDictionary *)params success:(void(^)(ThemeDetailInfo *))successHandler failure:(void(^)(NSError *))failureHandler;

//关注或者取消关注主题
- (void)followTheme:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler;

//获取侧边栏主题相关的帖子
- (void)getThemePosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler;

//获取侧边栏搜索列表
- (void)getSearchResults:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler;

//用户投稿
- (void)userContribute:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler;

//评论或回复任务
- (void)commentTask:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler;

@end
