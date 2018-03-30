//
//  IncubatorAPIRequest.m
//  iCartoon
//
//  Created by 寻梦者 on 16/3/29.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "IncubatorAPIRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "APIConfig.h"
#import "BaseAPIRequest.h"
#import "Context.h"

@interface IncubatorAPIRequest()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;

//获取热门帖子
- (void)getHotPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取最新热门帖子
- (void)refreshHotPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取脑洞帖子
- (void)getNewPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取最新脑洞帖子
- (void)refreshNewPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取关注【设计师】帖子列表
- (void)getConcernedThemes:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取最新(最新脑洞/全部)帖子
- (void)refreshConcernedThemes:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取关注的作者
- (void)getConcernedAuthors:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取最新的关注的作者
- (void)refreshConcernedAuthors:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取作者相关的帖子
- (void)getPersonalPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取最新的作者相关的帖子
- (void)refreshPersonalPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取搜索相关的帖子
- (void)getSearchPosts:(NSDictionary *)params success:(void(^)(SearchResultInfo *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取最新的搜索相关的帖子
- (void)refreshSearchPosts:(NSDictionary *)params success:(void(^)(SearchResultInfo *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取搜索相关的帖子
- (void)getIndexPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

//获取最新的搜索相关的帖子
- (void)refreshIndexPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler;

@end

@implementation IncubatorAPIRequest

//单例方法
+ (instancetype)sharedInstance {
    static IncubatorAPIRequest *instance = nil;
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
//获取主题帖子
- (void)getIncubatorPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *type = (NSString *)[params objectForKey:@"type"];
    NSString *actionType = (NSString *)[params objectForKey:@"actionType"];
    if([type isEqualToString:@"1"]) {
        //最新脑洞
        if([actionType isEqualToString:ACTION_TYPE_REFRESH]) {
            //刷新(获取最新)
            NSString *postId = [params objectForKey:@"postId"];
            NSString *refreshTime = [params objectForKey:@"refreshTime"];
            if([postId isEqualToString:@""] && [refreshTime isEqualToString:@""]) {
                [self getNewPosts:params success:^(NSArray *postArray) {
                    
                    successHandler(postArray);
                } failure:^(NSError *error) {
                    failureHandler(error);
                }];
            } else {
                [self refreshNewPosts:params success:^(NSArray *postArray) {
                    successHandler(postArray);
                } failure:^(NSError *error) {
                    failureHandler(error);
                }];
            }
        } else {
            //加载更多
            [self getNewPosts:params success:^(NSArray *postArray) {
                successHandler(postArray);
            } failure:^(NSError *error) {
                failureHandler(error);
            }];
        }
        
     } else if([type isEqualToString:@"2"]) {
        //热门围观
        if([actionType isEqualToString:ACTION_TYPE_REFRESH]) {
            //刷新(获取最新)
            [self refreshHotPosts:params success:^(NSArray *postArray) {
                successHandler(postArray);
            } failure:^(NSError *error) {
                failureHandler(error);
            }];
        } else {
            successHandler(nil);
            return;
        }
    } else if([type isEqualToString:@"3"]) {
        //关注的熊窝
        if([actionType isEqualToString:ACTION_TYPE_REFRESH]) {
            //刷新(全部帖子)
            [self refreshConcernedThemes:params success:^(NSArray *postArray) {
                successHandler(postArray);
            } failure:^(NSError *error) {
                failureHandler(error);
            }];
        } else {
            //加载更多
            [self getConcernedThemes:params success:^(NSArray *postArray) {
                successHandler(postArray);
            } failure:^(NSError *error) {
                failureHandler(error);
            }];
        }
        
    } else if([type isEqualToString:@"4"]) {
        //关注的作者
        if([actionType isEqualToString:ACTION_TYPE_REFRESH]) {
            //刷新(获取最新)
            NSString *postId = [params objectForKey:@"postId"];
            NSString *refreshTime = [params objectForKey:@"refreshTime"];
            if([postId isEqualToString:@""] && [refreshTime isEqualToString:@""]) {
                [self getConcernedAuthors:params success:^(NSArray *postArray) {
                    successHandler(postArray);
                } failure:^(NSError *error) {
                    failureHandler(error);
                }];
            } else {
                [self refreshConcernedAuthors:params success:^(NSArray *postArray) {
                    successHandler(postArray);
                } failure:^(NSError *error) {
                    failureHandler(error);
                }];
            }
        } else {
            //加载更多
            [self getConcernedAuthors:params success:^(NSArray *postArray) {
                successHandler(postArray);
            } failure:^(NSError *error) {
                failureHandler(error);
            }];
        }
        
    } else {
        //TOOD -- 其他类型
    }
}
//获取作者相关的帖子
- (void)getAuthorPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *actionType = (NSString *)[params objectForKey:@"actionType"];
    if([actionType isEqualToString:ACTION_TYPE_REFRESH]) {
        //刷新(全部帖子)
//        NSString *authorId = [params objectForKey:@"authorId"];
        NSString *refreshTime = [params objectForKey:@"refreshTime"];
        if([refreshTime isEqualToString:@""]) {
            [self getPersonalPosts:params success:^(NSArray *postArray) {
                successHandler(postArray);
            } failure:^(NSError *error) {
                failureHandler(error);
            }];
        } else {
            [self refreshPersonalPosts:params success:^(NSArray *postArray) {
                successHandler(postArray);
            } failure:^(NSError *error) {
                failureHandler(error);
            }];
        }
    } else {
        //加载更多
        [self getPersonalPosts:params success:^(NSArray *postArray) {
            successHandler(postArray);
        } failure:^(NSError *error) {
            failureHandler(error);
        }];
    }

}

//搜索帖子
- (void)searchPosts:(NSDictionary *)params success:(void(^)(SearchResultInfo *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *actionType = (NSString *)[params objectForKey:@"actionType"];
    if([actionType isEqualToString:ACTION_TYPE_REFRESH]) {
        //刷新(全部帖子)
        NSString *keyword = [params objectForKey:@"keyword"];
        if(!keyword) {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"查询关键字为空"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
            return;
        }
        NSString *refreshTime = [params objectForKey:@"refreshTime"];
        if(!refreshTime || [refreshTime isEqualToString:@""]) {
            [self getSearchPosts:params success:^(SearchResultInfo *resultInfo) {
                successHandler(resultInfo);
            } failure:^(NSError *error) {
                failureHandler(error);
            }];
        } else {
            [self refreshSearchPosts:params success:^(SearchResultInfo *resultInfo) {
                successHandler(resultInfo);
            } failure:^(NSError *error) {
                failureHandler(error);
            }];
        }
    } else {
        //加载更多
        [self getSearchPosts:params success:^(SearchResultInfo *resultInfo) {
            successHandler(resultInfo);
        } failure:^(NSError *error) {
            failureHandler(error);
        }];
    }
}

//主页帖子
- (void)homeIndexPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *actionType = (NSString *)[params objectForKey:@"actionType"];
    if([actionType isEqualToString:ACTION_TYPE_REFRESH]) {
        //刷新(全部帖子)
        NSString *postId = [params objectForKey:@"postId"];
        NSString *refreshTime = [params objectForKey:@"refreshTime"];
        if([postId isEqualToString:@""] && [refreshTime isEqualToString:@""]) {
            [self getIndexPosts:params success:^(NSArray *postArray) {
                
                successHandler(postArray);
            } failure:^(NSError *error) {
                failureHandler(error);
            }];
        } else {
            [self refreshIndexPosts:params success:^(NSArray *postArray) {
                successHandler(postArray);
            } failure:^(NSError *error) {
                failureHandler(error);
            }];
        }
    } else {
        //加载更多
        [self getIndexPosts:params success:^(NSArray *postArray) {
            successHandler(postArray);
        } failure:^(NSError *error) {
            failureHandler(error);
        }];
    }
}

//获取作者详情
- (void)getAuthorInfo:(NSDictionary *)params success:(void(^)(AuthorDetailInfo *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig authorInfoURL];
    NSString *authorId = nil;
    if(params) {
        authorId = [params objectForKey:@"authorId"];
    }
    if(!authorId) {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"作者ID为空"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@", baseURL, authorId];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
   // //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:path parameters:parameters success:^(id responseObject) {
        AuthorDetailInfo *authorInfo = [MTLJSONAdapter modelOfClass:[AuthorDetailInfo class] fromJSONDictionary:responseObject[@"result"] error:nil];
        if(authorInfo) {
            successHandler(authorInfo);
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"解析数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failureHandler(error);
        }
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

#pragma mark - Private Method
//获取热门帖子
- (void)getHotPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig hotPostsURL];
//    NSString *type = @"2";
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@", baseURL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *beforeTopicId = nil;
    NSString *beforeDateTime = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
        beforeTopicId = [params objectForKey:@"postId"];
        beforeDateTime = [params objectForKey:@"refreshTime"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"50";
    beforeTopicId = beforeTopicId != nil ? beforeTopicId : @"";
    beforeDateTime = beforeDateTime != nil ? beforeDateTime : @"";
    [path appendFormat:@"/%@", pageSize];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
  
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:beforeTopicId forKey:@"beforeTopicId"];
    [parameters setObject:beforeDateTime forKey:@"beforeDateTime"];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
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

//获取最新热门帖子
- (void)refreshHotPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig refreshHotPostsURL];
//    NSString *type = @"2";
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@", baseURL];
    
//   NSLog(@"URLpath --> %@", path);
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *beforeTopicId = nil;
    NSString *beforeDateTime = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
        beforeTopicId = [params objectForKey:@"postId"];
        beforeDateTime = [params objectForKey:@"refreshTime"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"50";
    pageSize = @"50";
    beforeTopicId = beforeTopicId != nil ? beforeTopicId : @"";
    beforeDateTime = beforeDateTime != nil ? beforeDateTime : @"";
    [path appendFormat:@"/%@", pageSize];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
//    [parameters setObject:beforeTopicId forKey:@"beforeTopicId"];
//    [parameters setObject:beforeDateTime forKey:@"beforeDateTime"];
//       NSLog(@"URLpath --> %@", path);
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

//获取脑洞帖子
- (void)getNewPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig newPostsURL];
    NSString *type = @"1";
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@", baseURL, type];
    
    ////NSLog(@"URL --> %@", path);
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *beforeTopicId = nil;
    NSString *beforeDateTime = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
        beforeTopicId = [params objectForKey:@"postId"];
        beforeDateTime = [params objectForKey:@"refreshTime"];
    }
    pageIndex = pageIndex != nil ? pageIndex :@"1" ;
    pageSize = pageSize != nil ? pageSize : @"10";
    beforeTopicId = beforeTopicId != nil ? beforeTopicId : @"";
    beforeDateTime = beforeDateTime != nil ? beforeDateTime : @"";
    [path appendFormat:@"/%@", pageSize];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [parameters setObject:beforeTopicId forKey:@"beforeTopicId"];
    [parameters setObject:beforeDateTime forKey:@"beforeDateTime"];
    
[parameters setObject:pageIndex forKey:@"pageIndex"];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
//        NSLog(@"responseObject ======= %@",responseObject);
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

//获取最新脑洞帖子
- (void)refreshNewPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig refreshNewPostsURL];
    NSString *type = @"1";
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@", baseURL];
    
//    NSLog(@"URL --> %@", path);
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *beforeTopicId = nil;
    NSString *beforeDateTime = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
        beforeTopicId = [params objectForKey:@"postId"];
        beforeDateTime = [params objectForKey:@"refreshTime"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"15";
    beforeTopicId = beforeTopicId != nil ? beforeTopicId : @"";
    beforeDateTime = beforeDateTime != nil ? beforeDateTime : @"";
    [path appendFormat:@"/%@", beforeDateTime];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:beforeTopicId forKey:@"beforeTopicId"];
    [parameters setObject:beforeDateTime forKey:@"beforeDateTime"];
    
    NSString *urlPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"urlPath ========= %@",urlPath);
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:urlPath parameters:parameters success:^(id responseObject) {
        
        NSArray *postList = [MTLJSONAdapter modelsOfClass:[PostInfo class] fromJSONArray:responseObject[@"response"][@"result"] error:nil];
//        NSLog(@"postList ================ %@",postList);
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

//获取关注的熊窝
- (void)getConcernedThemes:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig designerPostsURL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"10";
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/1/%@/%@", baseURL, pageIndex, pageSize];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
   // //NSLog(@"URL --> %@", path);
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

//获取最新的关注的熊窝
- (void)refreshConcernedThemes:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig designerPostsURL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"10";
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/1/%@/%@", baseURL, pageIndex, pageSize];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
    NSLog(@"%@",path);
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

//获取关注的作者
- (void)getConcernedAuthors:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig concernedAuthorsURL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *beforeTopicId = nil;
    NSString *beforeDateTime = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
        beforeTopicId = [params objectForKey:@"postId"];
        beforeDateTime = [params objectForKey:@"refreshTime"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"15";
    beforeTopicId = beforeTopicId != nil ? beforeTopicId : @"";
    beforeDateTime = beforeDateTime != nil ? beforeDateTime : @"";
    
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@", baseURL, pageSize];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
   // //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:pageSize forKey:@"pageSize"];
    [parameters setObject:beforeTopicId forKey:@"beforeTopicId"];
    [parameters setObject:beforeDateTime forKey:@"beforeDateTime"];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
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

//获取最新的关注的作者
- (void)refreshConcernedAuthors:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig refreshConcernedAuthorsURL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *beforeTopicId = nil;
    NSString *beforeDateTime = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
        beforeTopicId = [params objectForKey:@"postId"];
        beforeDateTime = [params objectForKey:@"refreshTime"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"15";
    beforeTopicId = beforeTopicId != nil ? beforeTopicId : @"";
    beforeDateTime = beforeDateTime != nil ? beforeDateTime : @"";
    if([beforeDateTime isEqualToString:@""]) {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"refreshDateTime为空"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@", baseURL, beforeDateTime];
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

//获取作者相关的帖子
- (void)getPersonalPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig authorPostsURL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *postId = nil;
    NSString *authorId = nil;
    NSString *refreshTime = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
        postId = [params objectForKey:@"postId"];
        authorId = [params objectForKey:@"authorId"];
        refreshTime = [params objectForKey:@"refreshTime"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"15";
    postId = postId != nil ? postId : @"";
    refreshTime = refreshTime != nil ? refreshTime : @"";
    if(!authorId) {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"作者ID为空"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@", baseURL, authorId, pageSize];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
//   NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:postId forKey:@"beforeTopicId"];
    [parameters setObject:refreshTime forKey:@"beforeDateTime"];
//    [parameters setObject:authorId forKey:@"authorId"];
//    [parameters setObject:pageSize forKey:@"pageSize"];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
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

//获取最新的作者相关的帖子
- (void)refreshPersonalPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig refreshAuthorPostsURL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *postId = nil;
    NSString *authorId = nil;
    NSString *refreshTime = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
        postId = [params objectForKey:@"postId"];
        authorId = [params objectForKey:@"authorId"];
        refreshTime = [params objectForKey:@"refreshTime"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"15";
    postId = postId != nil ? postId : @"";
    if(!authorId) {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"作者ID为空"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    if(!refreshTime) {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"refreshTime为空"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@", baseURL, authorId, refreshTime];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
   // //NSLog(@"URL --> %@", path);
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

//获取搜索相关的帖子
- (void)getSearchPosts:(NSDictionary *)params success:(void(^)(SearchResultInfo *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig searchPostsURL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *postId = nil;
    NSString *keyword = nil;
    NSString *refreshTime = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
        postId = [params objectForKey:@"postId"];
        keyword = [params objectForKey:@"keyword"];
        refreshTime = [params objectForKey:@"refreshTime"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"15";
    postId = postId != nil ? postId : @"";
    refreshTime = refreshTime != nil ? refreshTime : @"";
    if(!keyword) {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"搜索关键字为空"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@", baseURL, keyword, pageSize];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
    NSString *pathStr = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   // //NSLog(@"URL --> %@", path);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:postId forKey:@"beforeTopicId"];
    [parameters setObject:refreshTime forKey:@"beforeDateTime"];
    //    [parameters setObject:authorId forKey:@"authorId"];
    //    [parameters setObject:pageSize forKey:@"pageSize"];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:pathStr parameters:parameters success:^(id responseObject) {
        SearchResultInfo *resultInfo = [MTLJSONAdapter modelOfClass:[SearchResultInfo class] fromJSONDictionary:responseObject[@"result"] error:nil];
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

//获取最新的搜索相关的帖子
- (void)refreshSearchPosts:(NSDictionary *)params success:(void(^)(SearchResultInfo *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig refreshSearchPostsURL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *postId = nil;
    NSString *keyword = nil;
    NSString *refreshTime = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
        postId = [params objectForKey:@"postId"];
        keyword = [params objectForKey:@"keyword"];
        refreshTime = [params objectForKey:@"refreshTime"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"15";
    postId = postId != nil ? postId : @"";
    if(!keyword) {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"搜索关键字为空"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    if(!refreshTime) {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"refreshTime为空"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@/%@", baseURL, keyword, refreshTime];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
    ////NSLog(@"URL --> %@", path);
    NSString *pathStr = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:pathStr parameters:parameters success:^(id responseObject) {
        SearchResultInfo *resultInfo = [MTLJSONAdapter modelOfClass:[SearchResultInfo class] fromJSONDictionary:responseObject[@"result"] error:nil];
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

//获取主页推荐帖子
- (void)getIndexPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig homePostsV2URL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *beforeTopicId = nil;
    NSString *beforeDateTime = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
        beforeTopicId = [params objectForKey:@"postId"];
        beforeDateTime = [params objectForKey:@"freshTime"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"15";
    beforeTopicId = beforeTopicId != nil ? beforeTopicId : @"";
    beforeDateTime = beforeDateTime != nil ? beforeDateTime : @"";
    
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@", baseURL, pageSize];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:pageSize forKey:@"pageSize"];
    [parameters setObject:beforeTopicId forKey:@"beforeTopicId"];
    [parameters setObject:beforeDateTime forKey:@"beforeDateTime"];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
//    NSLog(@"%@",path);
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"POST" URLPath:path parameters:parameters success:^(id responseObject) {
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

//获取最新的首页帖子
- (void)refreshIndexPosts:(NSDictionary *)params success:(void(^)(NSArray *))successHandler failure:(void(^)(NSError*))failureHandler {
    NSString *baseURL = [APIConfig refreshHomePostsV2URL];
    NSString *pageIndex = nil;
    NSString *pageSize = nil;
    NSString *beforeTopicId = nil;
    NSString *beforeDateTime = nil;
    if(params) {
        pageIndex = [params objectForKey:@"pageNo"];
        pageSize = [params objectForKey:@"pageSize"];
        beforeTopicId = [params objectForKey:@"postId"];
        beforeDateTime = [params objectForKey:@"refreshTime"];
    }
    pageIndex = pageIndex != nil ? pageIndex : @"1";
    pageSize = pageSize != nil ? pageSize : @"15";
    beforeTopicId = beforeTopicId != nil ? beforeTopicId : @"";
    beforeDateTime = beforeDateTime != nil ? beforeDateTime : @"";
    if([beforeDateTime isEqualToString:@""]) {
        NSDictionary *msg = @{NSLocalizedDescriptionKey: @"refreshDateTime为空"};
        NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
        failureHandler(error);
        return;
    }
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@", baseURL, beforeDateTime];
    NSString *token = [Context sharedInstance].token;
    if(token) {
        [path appendFormat:@"/%@", token];
    }
   ////NSLog(@"URL --> %@", path);
    NSString *pathStr = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [[BaseAPIRequest sharedInstance] requestWithMethod:@"GET" URLPath:pathStr parameters:parameters success:^(id responseObject) {
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

@end
