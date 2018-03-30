//
//  BaseAPIRequest.h
//  GaoZhi
//
//  Created by 寻梦者 on 15/10/29.
//  Copyright © 2015年 GlenN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseAPIRequest : NSObject

+ (instancetype)sharedInstance;

- (void)requestWithMethod:(NSString *)method URLPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

- (void)uploadImagesWithURLPath:(NSString *)path images:(NSMutableArray *)imageArray parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
