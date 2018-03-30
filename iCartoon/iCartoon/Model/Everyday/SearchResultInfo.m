//
//  SearchResultInfo.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "SearchResultInfo.h"

@implementation SearchResultInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"postList" : @"topics",
             @"themeList" : @"themes",
             @"userList" : @"users",
             @"refreshTime" : @"refreshDateTime"
             };
}

+ (NSValueTransformer *)postListJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        NSArray *imageArray = [MTLJSONAdapter modelsOfClass:[PostInfo class] fromJSONArray:value error:nil];
        if(imageArray) {
            return [NSMutableArray arrayWithArray:imageArray];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)themeListJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        NSArray *imageArray = [MTLJSONAdapter modelsOfClass:[ThemeInfo class] fromJSONArray:value error:nil];
        if(imageArray) {
            return [NSMutableArray arrayWithArray:imageArray];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)userListJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        NSArray *imageArray = [MTLJSONAdapter modelsOfClass:[AuthorInfo class] fromJSONArray:value error:nil];
        if(imageArray) {
            return [NSMutableArray arrayWithArray:imageArray];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)refreshTimeJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}


@end
