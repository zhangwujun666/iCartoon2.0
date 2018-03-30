//
//  UserInteractionInfo.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/13.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "UserInteractionInfo.h"

@implementation UserInteractionInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"favorNum" : @"praiseCount",
             @"postNum" : @"TopicsCount",
             @"concernedNum" : @"followThemeCount"
             };
}

+ (NSValueTransformer *)favorNumJSONTransformer {
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

+ (NSValueTransformer *)concernedNumJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

@end
