//
//  BaseAPIRequest.m
//  GaoZhi
//
//  Created by 寻梦者 on 15/10/29.
//  Copyright © 2015年 GlenN. All rights reserved.
//

#import "BaseAPIRequest.h"
#import <AFNetworking/AFNetworking.h>
#import <Mantle/Mantle.h>
#import "CommonInfo.h"
#import "Context.h"
//#import "UserPictureInfo.h"

@interface BaseAPIRequest ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;

@end

@implementation BaseAPIRequest

//BaseAPIRequest单例方法
+ (instancetype)sharedInstance {
    
    static BaseAPIRequest *instance = nil;
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
- (void)requestWithMethod:(NSString *)method URLPath:(NSString *)path parameters:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    NSAssert(([method isEqualToString:@"POST"] || [method isEqualToString:@"GET"] || [method isEqualToString:@"DELETE"] || [method isEqualToString:@"PUT"]), @"method must be POST or GET or DELETE!");
   
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    if(params.count > 0) {
        //        NSString *jsonStr = [self objectToJson:params];
        //        [parameters setObject:jsonStr forKey:@"request"];
        [parameters setObject:params forKey:@"request"];
    }
//    NSLog(@"parameters === %@",parameters);
    if ([method isEqualToString:@"GET"]) {
//        [self GETWithURLPath:path parameters:parameters success:^(id responseObject) {
//            success(responseObject);
//        } failure:^(NSError *error) {
//            failure(error);
//        }];
        [self requestWithURLPath:path method:@"GET" parameters:parameters success:^(id responseObject) {
           
            success(responseObject);
        } failure:^(NSError *error) {
//            NSLog(@"=================%@",error.localizedDescription);
            failure(error);
        }];
    } else if ([method isEqualToString:@"POST"]) {
//        [self POSTWithURLPath:path parameters:parameters success:^(id responseObject) {
//            success(responseObject);
//        } failure:^(NSError *error) {
//            failure(error);
//        }];
//         NSLog(@"\nparams +++++ %@",parameters);
//        NSLog(@"\npath ========== %@",path);
        [self requestWithURLPath:path method:@"POST" parameters:parameters success:^(id responseObject) {
//           NSLog(@"responseObject =========== %@",responseObject);
            success(responseObject);
        } failure:^(NSError *error) {
         
            failure(error);
        }];
    } else if ([method isEqualToString:@"DELETE"]) {
//        [self DELETEWithURLPath:path parameters:parameters success:^(id responseObject) {
//            success(responseObject);
//        } failure:^(NSError *error) {
//            failure(error);
//        }];
        [self requestWithURLPath:path method:@"DELETE" parameters:parameters success:^(id responseObject) {
            success(responseObject);
        } failure:^(NSError *error) {
            failure(error);
        }];
    } else if([method isEqualToString:@"PUT"]) {
//        [self PUTWithURLPath:path parameters:parameters success:^(id responseObject) {
//            success(responseObject);
//        } failure:^(NSError *error) {
//            failure(error);
//        }];
        [self requestWithURLPath:path method:@"PUT" parameters:parameters success:^(id responseObject) {
            success(responseObject);
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

- (NSString*)objectToJson:(id)object {
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        ////NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *s = [NSMutableString stringWithString:jsonString];
    //[s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    //[s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    return [NSString stringWithString:s];
}

#pragma mark - Private Methods
- (void)requestWithURLPath:(NSString *)path method:(NSString *)method parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
//    NSLog(@"\npath === %@\nparameters ===%@",path,parameters);
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableString *body = [[NSMutableString alloc] init];
    NSString *jsonStr = [self objectToJson:parameters];
    if([jsonStr isEqualToString:@"{}"] || [jsonStr isEqualToString:@""]) {
        jsonStr = nil;
    }
    if(jsonStr) {
        [body appendString:jsonStr];
    }
    NSMutableData *requestData = [NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [requestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    //设置HTTPHeader
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"keep-alive" forHTTPHeaderField:@"connection"];
    [request setValue:@"UTF-8" forHTTPHeaderField:@"Charsert"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:requestData];
    //http method
    [request setHTTPMethod:method];
    
    //NSLog(@"%@",request.allHTTPHeaderFields);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil]; // 设置content-Type为text/html
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        id responseData = responseObject[@"response"];
        CommonInfo *returnData = [MTLJSONAdapter modelOfClass:CommonInfo.class fromJSONDictionary:responseData error:nil];
//        NSLog(@"-------------%@",responseObject);
        if ([returnData isSuccess]) {
            success(responseData);
        } else {
            if([returnData isTokenInValid]) {
                //用户失效
                [[Context sharedInstance] tokenExpired];
            }
            if (responseData) {
                CommonInfo *mError = [MTLJSONAdapter modelOfClass:CommonInfo.class fromJSONDictionary:responseData error:nil];
                NSDictionary *msg = @{NSLocalizedDescriptionKey: mError.message};
                NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
                failure(error);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"caught a error: %@", error);
//        NSDictionary *userInfo = [error userInfo];
//        NSString *descript = [[NSString alloc] initWithData:userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", descript);
        failure(error);
    }];
    [operation start];
}

- (void)GETWithURLPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    //设置网络请求时间
    self.requestManager.requestSerializer.timeoutInterval = 30;
    self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil]; // 设置content-Type为text/html
    
    //NSLog(@"%@\n", path);
    [self.requestManager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [self.requestManager GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@\n", responseObject);
        id responseData = responseObject[@"response"];
        if(responseData) {
            CommonInfo *returnData = [MTLJSONAdapter modelOfClass:CommonInfo.class fromJSONDictionary:responseData error:nil];
            if([returnData isSuccess]) {
                success(responseData);
            } else {
                CommonInfo *mError = [MTLJSONAdapter modelOfClass:CommonInfo.class fromJSONDictionary:responseData error:nil];
                NSDictionary *msg = @{NSLocalizedDescriptionKey: mError.message};
                NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
                failure(error);
            }
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"获取数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failure(error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"caught a error: %@", error.localizedDescription);
        failure(error);
    }];
}

- (void)POSTWithURLPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    //设置网络请求时间
    self.requestManager.requestSerializer.timeoutInterval = 30;
    
    self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];

    //NSLog(@"请求url: %@\n", path);
    //NSLog(@"参数: %@\n", parameters);
    [self.requestManager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [self.requestManager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"返回结果: %@\n", responseObject);
        id responseData = responseObject[@"response"];
        if(responseData) {
            CommonInfo *returnData = [MTLJSONAdapter modelOfClass:CommonInfo.class fromJSONDictionary:responseData error:nil];
            if([returnData isSuccess]) {
                success(responseData);
            } else {
                CommonInfo *mError = [MTLJSONAdapter modelOfClass:CommonInfo.class fromJSONDictionary:responseData error:nil];
                NSDictionary *msg = @{NSLocalizedDescriptionKey: mError.message};
                NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
                failure(error);
            }
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"获取数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failure(error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"caught a error: %@", error.localizedDescription);
        failure(error);
    }];
}

- (void)DELETEWithURLPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError * error))failure {
    //设置网络请求时间
    self.requestManager.requestSerializer.timeoutInterval = 30;
    self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil]; // 设置content-Type为text/html
    
    //NSLog(@"%@\n", path);
    [self.requestManager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [self.requestManager DELETE:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@\n", responseObject);
        id responseData = responseObject[@"response"];
        if(responseData) {
            CommonInfo *returnData = [MTLJSONAdapter modelOfClass:CommonInfo.class fromJSONDictionary:responseData error:nil];
            if([returnData isSuccess]) {
                success(responseData);
            } else {
                CommonInfo *mError = [MTLJSONAdapter modelOfClass:CommonInfo.class fromJSONDictionary:responseData error:nil];
                NSDictionary *msg = @{NSLocalizedDescriptionKey: mError.message};
                NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
                failure(error);
            }
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"获取数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failure(error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"caught a error: %@", error.localizedDescription);
        failure(error);
    }];
}

- (void)PUTWithURLPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError * error))failure {
    //设置网络请求时间
    self.requestManager.requestSerializer.timeoutInterval = 30;
    self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil]; // 设置content-Type为text/html
    
    //NSLog(@"%@\n", path);
    [self.requestManager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [self.requestManager PUT:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@\n", responseObject);
        id responseData = responseObject[@"response"];
        if(responseData) {
            CommonInfo *returnData = [MTLJSONAdapter modelOfClass:CommonInfo.class fromJSONDictionary:responseData error:nil];
            if([returnData isSuccess]) {
                success(responseData);
            } else {
                CommonInfo *mError = [MTLJSONAdapter modelOfClass:CommonInfo.class fromJSONDictionary:responseData error:nil];
                NSDictionary *msg = @{NSLocalizedDescriptionKey: mError.message};
                NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
                failure(error);
            }
        } else {
            NSDictionary *msg = @{NSLocalizedDescriptionKey: @"获取数据失败"};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failure(error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"caught a error: %@", error.localizedDescription);
        failure(error);
    }];
}

//上传图片
- (void)uploadImagesWithURLPath:(NSString *)path images:(NSMutableArray *)imageArray parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@", TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--", MPboundary];
    //http body的字符串
    NSMutableString *body = [[NSMutableString alloc] init];
    //参数的集合的所有key的集合
    NSArray *keys= [parameters allKeys];
    //遍历keys
    for(int i = 0;i < [keys count]; i++) {
        //添加分界线，换行
        [body appendFormat:@"%@\r\n", MPboundary];
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[parameters objectForKey:key]];
        //NSLog(@"添加字段的值==%@", [parameters objectForKey:key]);
    }
    
    NSMutableData *requestData = [NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [requestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //声明结束符：--AaB03x--
    NSString *end = [[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
    //加入结束符--AaB03x--
    [requestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //[request setValue:@"keep-alive" forHTTPHeaderField:@"connection"];
    //[request setValue:@"UTF-8" forHTTPHeaderField:@"Charsert"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:requestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //NSLog(@"%@",request.allHTTPHeaderFields);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"]; // 设置content-Type为text/html
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@\n", responseObject);
        CommonInfo *returnData = [MTLJSONAdapter modelOfClass:CommonInfo.class fromJSONDictionary:responseObject error:nil];
        if ([returnData isSuccess]) {
            success(responseObject);
        } else {
            CommonInfo *mError = [MTLJSONAdapter modelOfClass:CommonInfo.class fromJSONDictionary:responseObject error:nil];
            NSDictionary *msg = @{NSLocalizedDescriptionKey: mError.message};
            NSError *error = [NSError errorWithDomain:iCartoonErrorDomain code:(-1) userInfo:msg];
            failure(error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"caught a error: %@", error.localizedDescription);
//        NSDictionary *userInfo = [error userInfo];
//        NSString *descript = [[NSString alloc] initWithData:userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", descript);
        failure(error);
    }];
    [operation start];
}

@end
