//
//  ThemeInfo.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/13.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "ThemeInfo.h"

@implementation ThemeInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"tid": @"id",
             @"imageUrl" : @"image",
             @"title" : @"title",
             @"hasFollowed" : @"hasFollowed"
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

+ (NSValueTransformer *)hasFollowedJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}


@end
