//
//  PostAPIRequest.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/18.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "PostAPIRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "APIConfig.h"
#import "BaseAPIRequest.h"
#import "Context.h"

@interface PostAPIRequest()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;

@end

@implementation PostAPIRequest

//单例方法
+ (instancetype)sharedInstance {
    static PostAPIRequest *instance = nil;
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

#pragma mark - 发帖子
//搜索主题
- (void)searchThemes:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig searchThemesURL];
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/2", baseURL];
    NSString *token = [Context sharedInstance].token;
    if(token && ![token isEqualToString:@""]) {
        [path appendFormat:@"/%@", token];
    }
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    if(params && [params objectForKey:@"keyword"]) {
        NSString *keyword = (NSString *)[params objectForKey:@"keyword"];
        [parameters setObject:keyword forKey:@"keyword"];
    }
    [parameters setObject:@"2" forKey:@"type"];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
        NSArray *themeList = [MTLJSONAdapter modelsOfClass:[ThemeInfo class] fromJSONArray:responseObject[@"result"] error:nil];
        if(themeList) {
            successHandler(themeList);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}


//发表帖子
- (void)publishPost:(NSDictionary *)params success:(void(^)(NSString *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig publishPostURL];
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@", baseURL];
    NSString *token = [Context sharedInstance].token;
    if(!token) {
        return;
    } else {
        [path appendFormat:@"/%@", token];
    }
    
//    NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    //添加参数
    if(params) {
        NSString *title = (NSString *)[params objectForKey:@"title"];
        [parameters setObject:title forKey:@"title"];
        NSString *content = (NSString *)[params objectForKey:@"content"];
        if(content) {
            [parameters setObject:content forKey:@"content"];
        }
        NSString *themeId = (NSString *)[params objectForKey:@"themeId"];
        [parameters setObject:themeId forKey:@"themeId"];
        NSDictionary *images = (NSDictionary *)[params objectForKey:@"images"];
        if(images) {
            [parameters setObject:images forKey:@"images"];
        }
    }
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
//        isLogin = 1;
//        message = "\U53d1\U5e16\U6210\U529f";
//        result =     {
//            topicId = 470;
//        };
//        success = 1;
        CommonInfo *resultInfo = [MTLJSONAdapter modelOfClass:[CommonInfo class] fromJSONDictionary:responseObject error:nil];
        if([resultInfo isSuccess]) {
            NSString *postId = [responseObject[@"result"][@"topicId"] stringValue];
            successHandler(postId);
        } else if(resultInfo != nil && ![resultInfo isSuccess]) {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: resultInfo.message};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}
- (void)PostReport:(NSDictionary *)params success:(void(^)(PostDetailInfo *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig reportPostURL];
    NSString *postId = nil;
    if(params) {
        postId = [params objectForKey:@"postId"];
    }
    if(!postId) {
        return;
    }
    NSString * deviceId = [params objectForKey:@"deviceId"];
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@", baseURL, postId,deviceId];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
        if(!responseObject[@"result"]) {
            successHandler(nil);
            return;
        }
        PostDetailInfo *postInfo = [MTLJSONAdapter modelOfClass:[PostDetailInfo class] fromJSONDictionary:responseObject[@"result"] error:nil];
        if(postInfo) {
            successHandler(postInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}
#pragma mark - 帖子相关
//获取帖子详情
- (void)getPostInfo:(NSDictionary *)params success:(void(^)(PostDetailInfo *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig postInfoURL];
    NSString *postId = nil;
    if(params) {
        postId = [params objectForKey:@"postId"];
    }
    if(!postId) {
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@", baseURL, postId];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
//    NSLog(@"pathURL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        if(!responseObject[@"result"]) {
            successHandler(nil);
            return;
        }
        NSDictionary * dic = responseObject[@"result"];
//        NSLog(@"%@",responseObject[@"result"]);
        NSString * str =  [dic[@"content"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary * dicc = [NSMutableDictionary dictionary];
        [dicc setObject:dic[@"badCount"] forKey:@"badCount"];
        [dicc setObject:dic[@"badUsers"] forKey:@"badUsers"];
        [dicc setObject:dic[@"commentCount"] forKey:@"commentCount"];
        [dicc setObject:str forKey:@"content"];
        [dicc setObject:dic[@"createdDate"] forKey:@"createdDate"];
        [dicc setObject:dic[@"hasActed"] forKey:@"hasActed"];
        [dicc setObject:dic[@"hasCollected"] forKey:@"hasCollected"];
        [dicc setObject:dic[@"id"] forKey:@"id"];
        [dicc setObject:dic[@"images"] forKey:@"images"];
        [dicc setObject:dic[@"praiseCount"] forKey:@"praiseCount"];
        [dicc setObject:dic[@"praiseUsers"] forKey:@"praiseUsers"];
        [dicc setObject:dic[@"theme"] forKey:@"theme"];
        [dicc setObject:dic[@"title"] forKey:@"title"];
        [dicc setObject:dic[@"user"] forKey:@"user"];
//        NSLog(@"dicc ====== %@",dicc);
        PostDetailInfo *postInfo = [MTLJSONAdapter modelOfClass:[PostDetailInfo class] fromJSONDictionary:dicc error:nil];
        if(postInfo) {
            successHandler(postInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}


//对帖子进行点赞或者踩
- (void)favorPost:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig favorPostURL];
    NSString *postId = nil;
    NSString *favorType = nil;
    if(params) {
        postId = [params objectForKey:@"postId"];
        favorType = [params objectForKey:@"favorType"];
        //1-赞 2-踩 3-取消赞踩
    }
    if(!postId || !favorType) {
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@", baseURL, postId, favorType];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    } else {
        return;
    }
//    NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        CommonInfo *postInfo = [MTLJSONAdapter modelOfClass:[CommonInfo class] fromJSONDictionary:responseObject error:nil];
        if(postInfo) {
            successHandler(postInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//收藏帖子
- (void)collectPost:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig collectPostURL];
    NSString *postId = nil;
    NSString *type = nil;
    if(params) {
        postId = [params objectForKey:@"postId"];
        type = [params objectForKey:@"type"];
    }
    if(!postId || !type) {
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@", baseURL, postId, type];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    } else {
        return;
    }
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        CommonInfo *postInfo = [MTLJSONAdapter modelOfClass:[CommonInfo class] fromJSONDictionary:responseObject error:nil];
        if(postInfo) {
            successHandler(postInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//获取帖子评论列表
- (void)getPostComments:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig commentsOfPostURL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *postId = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
        postId = [params objectForKey:@"postId"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"10";
    if(!postId) {
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@/%@", baseURL, postId, pageIndex, pageSize];
//    NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        if(!responseObject[@"result"]) {
            successHandler([NSArray array]);
            return;
        }
        NSArray *commentList = [MTLJSONAdapter modelsOfClass:[PostCommentInfo class] fromJSONArray:responseObject[@"result"] error:nil];
        if(commentList) {
            successHandler(commentList);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//评论帖子
- (void)commentPost:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig commentPostURL];
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@", baseURL];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    } else {
        return;
    }
//    NSLog(@"URL --> %@", path);
   
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    if(params) {
        [parameters addEntriesFromDictionary:params];
    }
//     NSLog(@"URL --> %@", parameters);
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
//        NSLog(@"--------------%@",error.localizedDescription);
        failureHandler(error);
    }];
}

//获取主题相关帖子
- (void)getThemePosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig themePostsURL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *themeTypeId = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
        themeTypeId = [params objectForKey:@"themeTypeId"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"10";
    if(!themeTypeId) {
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@/%@", baseURL, themeTypeId, pageIndex, pageSize];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
    NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        NSArray *postList = [MTLJSONAdapter modelsOfClass:[PostInfo class] fromJSONArray:responseObject[@"result"] error:nil];
        if(postList) {
            successHandler(postList);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//删除帖子
- (void)deletePosts:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig deletePostURL];
    NSString *postIds = nil;
    if(params) {
        postIds = [params objectForKey:@"postIds"];
    }
    if(!postIds) {
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@", baseURL];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
//    NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:postIds forKey:@"topiceIds"];
//    NSLog(@"%@ ============= %@",path,params);
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
