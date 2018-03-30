//
//  AuthorInfo.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/16.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "AuthorInfo.h"

@implementation AuthorInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"uid" : @"id",
             @"nickname" : @"nickName",
             @"avatar" : @"avatar"
             };
}

+ (NSValueTransformer *)uidJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}


@end
