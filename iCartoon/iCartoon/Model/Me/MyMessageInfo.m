//
//  MyMessageInfo.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/21.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "MyMessageInfo.h"

@implementation MyMessageInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mid" : @"id",
             @"content" : @"content",
             @"createTime" : @"createDate",
             @"user" : @"user",
             @"replyer" : @"replyUser",
             @"postInfo" : @"topic",
             @"themeInfo" : @"theme"
             };
}

+ (NSValueTransformer *)midJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [((NSNumber *)value) stringValue];
        }
        return (NSString *)value;
    }];
}

+ (NSValueTransformer *)createTimeJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [((NSNumber *)value) stringValue];
        }
        return (NSString *)value;
    }];
}


+ (NSValueTransformer *)userJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSDictionary class]]) {
            AuthorInfo *userInfo = [MTLJSONAdapter modelOfClass:[AuthorInfo class] fromJSONDictionary:value error:nil];
            return userInfo;
        }
        return (NSString *)value;
    }];
}


+ (NSValueTransformer *)replyerJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSDictionary class]]) {
            AuthorInfo *userInfo = [MTLJSONAdapter modelOfClass:[AuthorInfo class] fromJSONDictionary:value error:nil];
            return userInfo;
        }
        return (NSString *)value;
    }];
}


+ (NSValueTransformer *)postInfoJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSDictionary class]]) {
            PostInfo *postInfo = [MTLJSONAdapter modelOfClass:[PostInfo class] fromJSONDictionary:value error:nil];
            return postInfo;
        }
        return (NSString *)value;
    }];
}

+ (NSValueTransformer *)themeInfoJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSDictionary class]]) {
            ThemeInfo *themeInfo = [MTLJSONAdapter modelOfClass:[ThemeInfo class] fromJSONDictionary:value error:nil];
            return themeInfo;
        }
        return (NSString *)value;
    }];
}


@end
