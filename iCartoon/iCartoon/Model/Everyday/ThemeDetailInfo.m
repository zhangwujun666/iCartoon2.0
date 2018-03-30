//
//  ThemeDetailInfo.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "ThemeDetailInfo.h"

@implementation ThemeDetailInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"tid" : @"id",
             @"title" : @"title",
             @"avatarUrl" : @"image",
             @"backgroundUrl" : @"banner",
             @"desc" : @"description",
             @"postNum" : @"topicCount",
             @"followNum" : @"followCount",
             @"followStatus" : @"hasFollowed"
             };
}

+ (NSValueTransformer *)tidJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)postNumJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)followNumJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)followStatusJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

@end
