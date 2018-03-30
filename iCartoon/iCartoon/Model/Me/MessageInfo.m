//
//  MessageInfo.m
//  iCartoon
//
//  Created by 许成雄 on 16/4/3.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "MessageInfo.h"

@implementation MessageInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mid" : @"id",
             @"userId" : @"userId",
             @"title" : @"title",
             @"sendTime" : @"sendDate",
             @"content" : @"content",
             @"status" : @"state"   //状态1:已读 0:未读
             };
}

+ (NSValueTransformer *)midJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)sendTimeJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)statusJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}


@end
