//
//  UserAPIRequest.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/11.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "UserAPIRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "APIConfig.h"
#import "BaseAPIRequest.h"
#import "Context.h"

@interface UserAPIRequest()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;

@end

@implementation UserAPIRequest

//BaseAPIRequest单例方法
+ (instancetype)sharedInstance {
    
    static UserAPIRequest *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if(self = [super init]) {
        self.requestManager = [AFHTTPRequestOperationManager manager];
    }
    return self;
}

#pragma mark - Public Method
//检查账户是否已经存在
- (void)checkAccountExist:(NSString *)account success:(void(^)(AccountExistInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig checkAccountExistURL];
    NSString *path = [NSString stringWithFormat:@"%@/%@", baseURL, account];
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        AccountExistInfo *existInfo = [MTLJSONAdapter modelOfClass:[AccountExistInfo class] fromJSONDictionary:responseObject error:nil];
        if(existInfo) {
            successHandler(existInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//获取短信验证码
- (void)sendSMSCodeWithMobile:(NSString *)phoneNumber success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig sendSMSCodeURL];
    NSString *path = [NSString stringWithFormat:@"%@/%@", baseURL, phoneNumber];
//    NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        CommonInfo *resultInfo = [MTLJSONAdapter modelOfClass:[CommonInfo class] fromJSONDictionary:responseObject error:nil];
        if(resultInfo) {
            successHandler(resultInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//用户注册
- (void)userRegister:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig userRegisterURL];
    NSString *path = [NSString stringWithFormat:@"%@", baseURL];
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    if(params.count > 0) {
        [parameters addEntriesFromDictionary:params];
    }
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
        CommonInfo *resultInfo = [MTLJSONAdapter modelOfClass:[CommonInfo class] fromJSONDictionary:responseObject error:nil];
        if(resultInfo) {
            successHandler(resultInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//用户登录
- (void)userLogin:(NSDictionary *)params success:(void(^)(LoginResultInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig userLoginURL];
    NSString *path = [NSString stringWithFormat:@"%@", baseURL];
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    if(params.count > 0) {
        [parameters addEntriesFromDictionary:params];
    }
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
//        NSLog(@"responseObject ============ %@",responseObject);
        LoginResultInfo *resultInfo = [MTLJSONAdapter modelOfClass:[LoginResultInfo class] fromJSONDictionary:responseObject[@"result"] error:nil];
        if(resultInfo) {
            successHandler(resultInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//第三方登录
- (void)thirdLogin:(NSDictionary *)params success:(void(^)(LoginResultInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig thirdLoginURL];
    NSString *path = [NSString stringWithFormat:@"%@", baseURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    if(params.count > 0) {
        [parameters addEntriesFromDictionary:params];
    }
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
       
        LoginResultInfo *resultInfo = [MTLJSONAdapter modelOfClass:[LoginResultInfo class] fromJSONDictionary:responseObject[@"result"] error:nil];
//         NSLog(@"responseObject ==== %@",responseObject);
//        NSLog(@"resultInfo ========= %@",resultInfo);
        if(resultInfo) {
            successHandler(resultInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
//        NSLog(@"error ====== %@",error);
        failureHandler(error);
    }];
}

//找回密码
- (void)findPassword:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig findPasswordURL];
    NSString *path = [NSString stringWithFormat:@"%@", baseURL];
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    if(params.count > 0) {
        [parameters addEntriesFromDictionary:params];
    }
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"PUT" URLPath:path parameters:parameters success:^(id responseObject) {
        CommonInfo *resultInfo = [MTLJSONAdapter modelOfClass:[CommonInfo class] fromJSONDictionary:responseObject error:nil];
        if(resultInfo) {
            successHandler(resultInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//提交反馈意见
- (void)submitFeedback:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig submitFeedbackURL];
    if(![Context sharedInstance].token) {
        return;
    }
    NSString *token = [Context sharedInstance].token;
    NSString *path = [NSString stringWithFormat:@"%@/%@", baseURL, token];
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    if(params.count > 0) {
        [parameters addEntriesFromDictionary:params];
    }
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
        CommonInfo *resultInfo = [MTLJSONAdapter modelOfClass:[CommonInfo class] fromJSONDictionary:responseObject error:nil];
        if(resultInfo) {
            successHandler(resultInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//用户退出登录
- (void)userLogout:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig userLogoutURL];
    if(![Context sharedInstance].token) {
        return;
    }
    NSString *token = [Context sharedInstance].token;
    NSString *path = [NSString stringWithFormat:@"%@/%@", baseURL, token];
//    NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    if(params.count > 0) {
        [parameters addEntriesFromDictionary:params];
    }
//    NSLog(@"===============%@",parameters);
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
        CommonInfo *resultInfo = [MTLJSONAdapter modelOfClass:[CommonInfo class] fromJSONDictionary:responseObject error:nil];
        if(resultInfo) {
            successHandler(resultInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//用户信息
- (void)getUserInfo:(NSDictionary *)params success:(void(^)(UserInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig userInfoURL];
    NSString *token = [Context sharedInstance].token;
    NSString *path = [NSString stringWithFormat:@"%@/%@", baseURL, token];
//    NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    if(params.count > 0) {
        [parameters addEntriesFromDictionary:params];
    }
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
//        NSLog(@"responseObject ========= %@",responseObject);
        UserInfo *userInfo = [MTLJSONAdapter modelOfClass:[UserInfo class] fromJSONDictionary:responseObject[@"result"] error:nil];
        if(userInfo) {
            successHandler(userInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//更新用户信息
- (void)updateUserInfo:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig updateUserInfoURL];
    if(![Context sharedInstance].token) {
        return;
    }
    NSString *token = [Context sharedInstance].token;
    NSString *path = [NSString stringWithFormat:@"%@/%@", baseURL, token];
//    NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    if(params.count > 0) {
        [parameters addEntriesFromDictionary:params];
    }
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
    
        if(!responseObject) {
            successHandler(nil);
            return;
        }
        CommonInfo *userInfo = [MTLJSONAdapter modelOfClass:[CommonInfo class] fromJSONDictionary:responseObject error:nil];
        if(userInfo) {
//            NSLog(@"userInfo ======= %@",userInfo.message);
            successHandler(userInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//修改密码
- (void)modifyPassword:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig modifyPasswordURL];
    if(![Context sharedInstance].token) {
        return;
    }
    NSString *token = [Context sharedInstance].token;
    NSString *path = [NSString stringWithFormat:@"%@/%@", baseURL, token];
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    if(params.count > 0) {
        [parameters addEntriesFromDictionary:params];
    }
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"PUT" URLPath:path parameters:parameters success:^(id responseObject) {
        CommonInfo *resultInfo = [MTLJSONAdapter modelOfClass:[CommonInfo class] fromJSONDictionary:responseObject error:nil];
        if(resultInfo) {
            successHandler(resultInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//关注(取消关注)主题(批量)
- (void)followThemes:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig followThemesURL];
    if(![Context sharedInstance].token) {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"用户未登录"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    NSString *token = [Context sharedInstance].token;
    NSString *path = [NSString stringWithFormat:@"%@/%@", baseURL, token];
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    if(params.count > 0) {
        [parameters addEntriesFromDictionary:params];
    }
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
        CommonInfo *resultInfo = [MTLJSONAdapter modelOfClass:[CommonInfo class] fromJSONDictionary:responseObject error:nil];
        if(resultInfo) {
            successHandler(resultInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}


@end
