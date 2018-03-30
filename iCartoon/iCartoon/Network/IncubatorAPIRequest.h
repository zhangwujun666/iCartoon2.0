//
//  IncubatorAPIRequest.h
//  iCartoon
//
//  Created by 寻梦者 on 16/3/29.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iCartoonAPI.h"

@interface IncubatorAPIRequest : NSObject

+ (instancetype)sharedInstance;

#pragma mark - Public Method
//获取主题帖子
- (void)getIncubatorPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取作者相关的帖子
- (void)getAuthorPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取用户信息
- (void)getAuthorInfo:(NSDictionary *)params success:(void(^)(AuthorDetailInfo *))successHandler failure:(void(^)(NSError*))failureHandler;

//搜索的帖子
- (void)searchPosts:(NSDictionary *)params success:(void(^)(SearchResultInfo *))successHandler failure:(void(^)(NSError*))failureHandler;

//搜索的帖子
- (void)homeIndexPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

@end
