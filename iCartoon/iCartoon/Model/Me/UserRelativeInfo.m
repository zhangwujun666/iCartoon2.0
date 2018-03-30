//
//  UserRelativeInfo.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/13.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "UserRelativeInfo.h"

@implementation UserRelativeInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"messageCount" : @"newsCount",
             @"commentCount" : @"commentCount",
             @"collectionCount" : @"collectionCount"
             };
}

+ (NSValueTransformer *)messageCountJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)commentCountJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)collectionCountJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}


@end
