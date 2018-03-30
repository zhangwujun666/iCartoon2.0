//
//  LoginResultInfo.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/11.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "LoginResultInfo.h"

@implementation LoginResultInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"uid" : @"id",
             @"token" : @"token",
             @"nickname" : @"nickName",
             @"gender" : @"gender",
             @"avatar" : @"avatar"
             };
}

+ (NSValueTransformer *)uidJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return value;
        }
    }];
}

+ (NSValueTransformer *)genderJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return value;
        }
    }];
}


@end
