//
//  IndexAPIRequest.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/18.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "IndexAPIRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "APIConfig.h"
#import "BaseAPIRequest.h"
#import "Context.h"

@interface IndexAPIRequest()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;

@end

@implementation IndexAPIRequest

//单例方法
+ (instancetype)sharedInstance {
    static IndexAPIRequest *instance = nil;
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
//获取顶部滚动条列表
- (void)getIndexBanners:(void *)param success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig homeBannersURL];
    NSString *type = @"1";     //1首页轮播图，2引导页图片
    NSString *path = [NSString stringWithFormat:@"%@/%@", baseURL, type];
   // //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        NSArray *bannerList = [MTLJSONAdapter modelsOfClass:[HomeBannerInfo class] fromJSONArray:responseObject[@"result"] error:nil];
        if(bannerList) {
            successHandler(bannerList);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//获取主页任务列表
- (void)getIndexTasks:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig homeTasksURL];
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
//      NSLog(@"path =================== --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        //NSLog(@"responseObject = %@",responseObject);
        NSArray *taskList = [MTLJSONAdapter modelsOfClass:[TaskInfo class] fromJSONArray:responseObject[@"result"] error:nil];
        if(taskList) {
            if(taskList.count >= 3) {
                successHandler([taskList subarrayWithRange:NSMakeRange(0, 3)]);
            } else {
                successHandler(taskList);
            }
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//获取主页帖子主题列表
- (void)getIndexThemes:(void *)param success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig homeThemesURL];
    NSString *path = [NSString stringWithFormat:@"%@", baseURL];
  // NSLog(@"URL --> %@", path);
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


//获取主页帖子列表
- (void)getIndexPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig homePostsURL];
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
    ////NSLog(@"URL --> %@", path);
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


//获取任务列表
- (void)getTasks:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig taskListURL];
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
//    NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
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

//获取我的任务列表
- (void)getUserTasks:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig myTasksURL];
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
//   NSLog(@"URL --> %@\n", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
//        NSLog(@"\nresponseObject === %@",responseObject);
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

//获取任务信息
- (void)getTaskInfo:(NSDictionary *)params success:(void(^)(TaskDetailInfo *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig taskInfoURL];
    NSString *taskId = nil;
    if(params) {
        taskId = [params objectForKey:@"taskId"];
    }
    if(!taskId) {
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@", baseURL, taskId];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
   // //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        TaskDetailInfo *taskInfo = [MTLJSONAdapter modelOfClass:[TaskDetailInfo class] fromJSONDictionary:responseObject[@"result"] error:nil];
        if(taskInfo) {
            successHandler(taskInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}


//为任务投票(完成任务)
- (void)voteForTask:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig voteForTaskURL];
    NSString *taskId = nil;
    if(params) {
        taskId = [params objectForKey:@"taskId"];
    }
    if(!taskId) {
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@", baseURL, taskId];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
    ////NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        CommonInfo *commonInfo = [MTLJSONAdapter modelOfClass:[CommonInfo class] fromJSONDictionary:responseObject[@"result"] error:nil];
        if(commonInfo) {
            successHandler(commonInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//收藏任务
- (void)collectTask:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig collectTaskURL];
    NSString *taskId = nil;
    NSString *type = nil;
    if(params) {
        taskId = [params objectForKey:@"taskId"];
        type = [params objectForKey:@"type"];
    }
    if(!taskId) {
        return;
    }
    if(!type) {
        type = @"1";
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@", baseURL, taskId, type];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
    ////NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        CommonInfo *commonInfo = [MTLJSONAdapter modelOfClass:[CommonInfo class] fromJSONDictionary:responseObject error:nil];
        if(commonInfo) {
            successHandler(commonInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//获取侧边栏主题列表
- (void)getAllThemes:(void *)param success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig themeListURL];
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@", baseURL];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
//    NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        NSArray *themeList = [MTLJSONAdapter modelsOfClass:[ThemeGroupInfo class] fromJSONArray:responseObject[@"result"] error:nil];
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

//获取侧边栏我关注的主题列表
- (void)getMyThemes:(void *)param success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig myConcernedThemes2URL];
    NSString *token = [Context sharedInstance].token;
    NSString *path = [NSString stringWithFormat:@"%@/%@", baseURL, token];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        NSArray *themeList = [MTLJSONAdapter modelsOfClass:[ThemeGroupInfo class] fromJSONArray:responseObject[@"result"] error:nil];
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

//查询侧边栏主题列表
- (void)searchThemes:(NSDictionary *)param success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig searchThemes2URL];
    NSString *type = [param objectForKey:@"type"];
    NSString *keyword = [param objectForKey:@"keyword"];
    if(!type || [type isEqualToString:@""]) {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"type为空"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@", baseURL, type];
    NSString *token = [Context sharedInstance].token;
    if(token != nil && ![token isEqualToString:@""]) {
        [path appendFormat:@"/%@", token];
    }
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:type forKey:@"type"];
    if(keyword != nil) {
        [parameters setObject:keyword forKey:@"keyword"];
    }
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

//获取主题详情
- (void)getThemeInfo:(NSDictionary *)params success:(void(^)(ThemeDetailInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig themeInfoURL];
    NSString *themeId = nil;
    if(params) {
        themeId = [params objectForKey:@"themeId"];
    }
    if(!themeId) {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"主题ID为空"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@", baseURL, themeId];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        ThemeDetailInfo *detailInfo = [MTLJSONAdapter modelOfClass:[ThemeDetailInfo class] fromJSONDictionary:responseObject[@"result"] error:nil];
        if(detailInfo) {
            successHandler(detailInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//关注或者取消关注主题
- (void)followTheme:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig concernThemeURL];
    NSArray *themeIds = nil;
    NSString *type = nil;
    if(params) {
        themeIds = [params objectForKey:@"themeIds"];
        type = [params objectForKey:@"type"];
    }
    if(!themeIds || !type) {
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
    //NSLog(@"URL ＊＊＊＊＊＊＊＊＊＊＊＊＊ %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:themeIds forKey:@"themeIds"];
    [parameters setObject:type forKey:@"type"];
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

//获取侧边栏主题相关的帖子
- (void)getThemePosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig themePostsURL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *themeId = nil;
    if(params) {
        themeId = [params objectForKey:@"themeId"];
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"10";
    if(!themeId) {
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@/%@", baseURL, themeId, pageIndex, pageSize];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
    //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
//        NSLog(@"responseObject === %@",responseObject[@"result"]);
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

//获取侧边栏搜索列表
- (void)getSearchResults:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig searchURL];
    NSString *keyword = nil;
    if(params) {
        keyword = [params objectForKey:@"keyword"];
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@", baseURL];
    if(keyword) {
        [path appendFormat:@"/%@", keyword];
    }
    NSString *pageIndex = (NSString *)[params objectForKey:@"pageNo"];
    NSString *pageSize = (NSString *)[params objectForKey:@"pageSize"];
    [path appendFormat:@"/%@/%@", pageIndex, pageSize];
    //NSLog(@"URL --> %@", path);
    NSString *mPath = [[path stringByAppendingString:@""] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:mPath parameters:parameters success:^(id responseObject) {
        NSArray *resultList = [MTLJSONAdapter modelsOfClass:[SearchResultInfo class] fromJSONArray:responseObject[@"result"] error:nil];
        if(resultList) {
            successHandler(resultList);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

//用户投稿
- (void)userContribute:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig userContributeURL];
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@", baseURL];
    NSString *token = [Context sharedInstance].token;
    if(!token) {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"用户未登录"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    } else {
        [path appendFormat:@"/%@", token];
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    //添加参数
    if(params) {
        NSString *title = (NSString *)[params objectForKey:@"title"];
        [parameters setObject:title forKey:@"title"];
        NSString *content = (NSString *)[params objectForKey:@"content"];
        if(content) {
            [parameters setObject:content forKey:@"content"];
        }
        NSString *taskId = (NSString *)[params objectForKey:@"taskId"];
//        NSLog(@"taskId ======= %@",taskId);
        [parameters setObject:taskId forKey:@"voteId"];
        NSString *imageStr = (NSString *)[params objectForKey:@"image"];
        if(imageStr) {
            [parameters setObject:imageStr forKey:@"image"];
        }
         NSString *nameStr = (NSString *)[params objectForKey:@"name"];
        [parameters setObject:nameStr forKey:@"name"];
        
        NSString *phone = (NSString *)[params objectForKey:@"phone"];
        [parameters setObject:phone forKey:@"phone"];
    }
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
//        NSLog(@"params -------- %@",params);
        CommonInfo *resultInfo = [MTLJSONAdapter modelOfClass:[CommonInfo class] fromJSONDictionary:responseObject error:nil];
        if([resultInfo isSuccess]) {
            successHandler(resultInfo);
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

//评论或回复任务
- (void)commentTask:(NSDictionary *)params success:(void(^)(CommonInfo *))successHandler failure:(void(^)(NSError *))failureHandler {
    NSString *baseURL = [APIConfig taskCommentURL];
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
    //添加参数
    if(params) {
        NSString *taskId = (NSString *)[params objectForKey:@"taskId"];
        [parameters setObject:taskId forKey:@"voteId"];
        NSString *content = (NSString *)[params objectForKey:@"content"];
        [parameters setObject:content forKey:@"content"];
        
        NSString *authorId = (NSString *)[params objectForKey:@"authorId"];
        if(authorId) {
            [parameters setObject:authorId forKey:@"replyUserId"];
        } else {
            [parameters setObject:@"0" forKey:@"replyUserId"];
        }
        NSString *commentId = (NSString *)[params objectForKey:@"commentId"];
        if(commentId) {
            [parameters setObject:commentId forKey:@"replyCommentId"];
        } else {
            [parameters setObject:@"0" forKey:@"replyCommentId"];
        }
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
