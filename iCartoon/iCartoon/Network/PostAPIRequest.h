//
//  PostAPIRequest.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/18.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iCartoonAPI.h"

@interface PostAPIRequest : NSObject

+ (instancetype)sharedInstance;

#pragma mark - Public Method
//搜索主题
- (void)searchThemes:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//发表帖子
- (void)publishPost:(NSDictionary *)params success:(void(^)(NSString *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取主题帖子
- (void)getThemePosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取发现帖子详情
- (void)getPostInfo:(NSDictionary *)params success:(void(^)(PostDetailInfo *))successHandler failure:(void(^)(NSError*))failureHandler;

//对帖子进行点赞或者踩
- (void)favorPost:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError*))failureHandler;

//收藏帖子
- (void)collectPost:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取帖子评论列表
- (void)getPostComments:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//评论帖子
- (void)commentPost:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError*))failureHandler;

//删除帖子
- (void)deletePosts:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError*))failureHandler;
- (void)PostReport:(NSDictionary *)params success:(void(^)(PostDetailInfo *))successHandler failure:(void(^)(NSError*))failureHandler;
@end
