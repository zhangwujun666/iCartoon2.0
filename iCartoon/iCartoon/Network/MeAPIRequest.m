//
//  MeAPIRequest.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/16.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "MeAPIRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "APIConfig.h"
#import "BaseAPIRequest.h"
#import "Context.h"

@interface MeAPIRequest()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;

@end

@implementation MeAPIRequest

//BaseAPIRequest单例方法
+ (instancetype)sharedInstance {
    
    static MeAPIRequest *instance = nil;
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

#pragma mark - 用户相关
//获取用户互动信息
- (void)getUserInteractionInfo:(void *)param success:(void(^)(UserInteractionInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig myInteractionInfoURL];
    NSString *token = [Context sharedInstance].token;
    NSString *path = [NSString stringWithFormat:@"%@/%@", baseURL, token];
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        UserInteractionInfo *interactionInfo = [MTLJSONAdapter modelOfClass:[UserInteractionInfo class] fromJSONDictionary:responseObject[@"result"] error:nil];
        if(interactionInfo) {
            successHandler(interactionInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
    
}

//获取用户相关的信息
- (void)getUserRelativeInfo:(void *)param success:(void(^)(UserRelativeInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig myMessageCountURL];
    NSString *token = [Context sharedInstance].token;
    NSString *path = [NSString stringWithFormat:@"%@/%@", baseURL, token];
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        UserRelativeInfo *relativeInfo = [MTLJSONAdapter modelOfClass:[UserRelativeInfo class] fromJSONDictionary:responseObject[@"result"] error:nil];
        if(relativeInfo) {
            successHandler(relativeInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
    
}

//获取用户关注的主题
- (void)getUserConcernedThemes:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig myConcernedThemesURL];
    NSString *token = [Context sharedInstance].token;
    NSString *pageIndex = [params objectForKey:@"pageNo"];
    if(!pageIndex) {
        pageIndex = @"1";
    }
    NSString *pageSize = [params objectForKey:@"pageSzie"];
    if(!pageSize) {
        pageSize = @"10";
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@/%@", baseURL, pageIndex, pageSize, token];
//    NSString *path = [NSString stringWithFormat:@"%@/%@", baseURL, token];
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
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

//获取用户关注的帖子

- (void)getUserConcernedPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig myConcernedPostsURL];
    NSString *token = [Context sharedInstance].token;
    NSString *pageIndex = [params objectForKey:@"pageNo"];
    if(!pageIndex) {
        pageIndex = @"1";
    }
    NSString *pageSize = [params objectForKey:@"pageSzie"];
    if(!pageSize) {
        pageSize = @"10";
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@/%@", baseURL, pageIndex, pageSize, token];
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
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

//获取用户发布帖子
- (void)getUserPublishedPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig myReleasedPostsURL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *type = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
        type = [params objectForKey:@"type"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"10";
    if(!type) {
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@/%@", baseURL, type, pageIndex, pageSize];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
    //NSLog(@"URL --> %@", path);
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

//获取用户收藏的任务列表
- (void)getUserCollectedTasks:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig myCollectedTasksURL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"10";
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@", baseURL, pageIndex, pageSize];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        if(!responseObject[@"result"]) {
            successHandler([NSArray array]);
            return;
        }
        NSArray *taskList = [MTLJSONAdapter modelsOfClass:[TaskInfo class] fromJSONArray:responseObject[@"result"] error:nil];
        if(taskList) {
            successHandler(taskList);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//获取用户收藏的帖子列表
- (void)getUserCollectedPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig myCollectedPostsURL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"10";
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@", baseURL, pageIndex, pageSize];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        if(!responseObject[@"result"]) {
            successHandler([NSArray array]);
            return;
        }
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

//获取回复与评论
- (void)getReplyAndComments:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig myReplyAndCommentURL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *type = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
        type = [params objectForKey:@"type"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"10";
    if(!type) {
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@/%@", baseURL, type, pageIndex, pageSize];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        NSArray *postList = [MTLJSONAdapter modelsOfClass:[MyMessageInfo class] fromJSONArray:responseObject[@"result"] error:nil];
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

//获取我的评论
- (void)getMyComments:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig myCommentsURL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *type = nil;
    if(params) {
        type = [params objectForKey:@"type"];
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"10";
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@", baseURL, pageIndex, pageSize];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        NSArray *postList = [MTLJSONAdapter modelsOfClass:[MyMessageInfo class] fromJSONArray:responseObject[@"result"] error:nil];
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

//获取用户消息
- (void)getUserMessages:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig myMessageURL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *type = nil;
    if(params) {
        type = [params objectForKey:@"type"];
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
    }
    type = @"1";
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"10";
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@/%@", baseURL, type, pageIndex, pageSize];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        NSArray *postList = [MTLJSONAdapter modelsOfClass:[MyMessageInfo class] fromJSONArray:responseObject[@"result"] error:nil];
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

//获取用户关注的作者
- (void)getUserFollowedAuthors:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig myFollowedAuthorsURL];
    NSString *pageIndex = [params objectForKey:@"pageNo"];
    if(!pageIndex) {
        pageIndex = @"1";
    }
    NSString *pageSize = [params objectForKey:@"pageSzie"];
    if(!pageSize) {
        pageSize = @"10";
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@", baseURL, pageIndex, pageSize];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    } else {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"用户未登录"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        NSArray *authorList = [MTLJSONAdapter modelsOfClass:[ConcernedAuthorInfo class] fromJSONArray:responseObject[@"result"] error:nil];
        if(authorList) {
            successHandler(authorList);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//关注/取消关注作者
- (void)followAuthor:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig followAuthorURL];
    NSString *followUserId = [params objectForKey:@"authorId"];
    if(!followUserId) {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"作者ID为空"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    NSString *type = [params objectForKey:@"type"];
    //type 1:关注 2:取消关注
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@", baseURL, followUserId, type];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    } else {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"用户未登录"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }

    //NSLog(@"URL --> %@", path);
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

//获取用户的粉丝
- (void)getMyFuns:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig myFunsURL];
    NSString *pageIndex = [params objectForKey:@"pageNo"];
    if(!pageIndex) {
        pageIndex = @"1";
    }
    NSString *pageSize = [params objectForKey:@"pageSize"];
    if(!pageSize) {
        pageSize = @"10";
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@", baseURL, pageIndex, pageSize];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    } else {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"用户未登录"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        NSArray *authorList = [MTLJSONAdapter modelsOfClass:[ConcernedAuthorInfo class] fromJSONArray:responseObject[@"result"] error:nil];
        if(authorList) {
            successHandler(authorList);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

#pragma mark - 新添加的
//获取消息中心
- (void)getMessageList:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    
    NSString *baseURL = [APIConfig messageURL];
   // NSLog(@"baseURL = %@",baseURL);
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"10";
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@", baseURL];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@/%@/%@",pageIndex, pageSize,token];
    } else {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"用户未登录"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
//    NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        //NSLog(@"URL --> %@", path);
//        NSLog(@"%@",responseObject);
        NSArray *messageList = [MTLJSONAdapter modelsOfClass:[MessageInfo class] fromJSONArray:responseObject[@"result"] error:nil];
        if(messageList) {
            successHandler(messageList);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
//        NSLog(@"%@",error.localizedDescription);

    }];
}

//删除帖子
- (void)deletePost:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig deletePostURL];
    NSString *postId = nil;
    if(params) {
        postId = [params objectForKey:@"postId"];
    }
    if(!postId) {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"帖子ID为空"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@", baseURL];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    } else {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"用户未登录"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:postId forKey:@"topiceIds"];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
        CommonInfo *result = [MTLJSONAdapter modelOfClass:[CommonInfo class] fromJSONDictionary:responseObject error:nil];
        if(result) {
            successHandler(result);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//设置消息为已读
- (void)setMessageAsRead:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig setMessageReadURL];
    NSString *messageId = nil;
    if(params) {
        messageId = [params objectForKey:@"messageId"];
    }
    if(!messageId) {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"消息ID为空"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@", baseURL];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    } else {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"用户未登录"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:messageId forKey:@"messageId"];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
        CommonInfo *result = [MTLJSONAdapter modelOfClass:[CommonInfo class] fromJSONDictionary:responseObject error:nil];
        if(result) {
            successHandler(result);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//删除消息
- (void)deleteMessage:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig deleteMessageURL];
    NSString *messageIds = nil;
    if(params) {
        messageIds = [params objectForKey:@"messageIds"];
    }
    if(!messageIds) {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"消息ID为空"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@", baseURL];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    } else {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"用户未登录"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:messageIds forKey:@"messageIds"];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
        CommonInfo *result = [MTLJSONAdapter modelOfClass:[CommonInfo class] fromJSONDictionary:responseObject error:nil];
        if(result) {
            successHandler(result);
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
