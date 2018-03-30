//
//  UserAPIRequest.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/11.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iCartoonAPI.h"

@interface UserAPIRequest : NSObject

+ (instancetype)sharedInstance;

#pragma mark - Public Method
//检查账户是否已经存在
- (void)checkAccountExist:(NSString *)account success:(void(^)(AccountExistInfo *))successHandler failure:(void(^)(NSError *))failureHandler;
//获取短信验证码
- (void)sendSMSCodeWithMobile:(NSString *)phoneNumber success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler;

//用户注册
- (void)userRegister:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler;

//用户登录
- (void)userLogin:(NSDictionary *)params success:(void(^)(LoginResultInfo *))successHandler failure:(void(^)(NSError *))failureHandler;

//第三方登录
- (void)thirdLogin:(NSDictionary *)params success:(void(^)(LoginResultInfo *))successHandler failure:(void(^)(NSError *))failureHandler;

//找回密码
- (void)findPassword:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler;

//提交反馈意见
- (void)submitFeedback:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler;

//用户退出登录
- (void)userLogout:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler;

//用户信息
- (void)getUserInfo:(NSDictionary *)params success:(void(^)(UserInfo *))successHandler failure:(void(^)(NSError *))failureHandler;

//更新用户信息
- (void)updateUserInfo:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler;

//修改密码
- (void)modifyPassword:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler;

//关注主题
- (void)followThemes:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler;

#pragma mark - 用户相关的


@end
