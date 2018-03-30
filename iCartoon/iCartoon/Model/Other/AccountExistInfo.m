//
//  AccountExistInfo.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/11.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "AccountExistInfo.h"

@implementation AccountExistInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"message": @"message",
             @"isExist": @"isExist",
             @"isLogin": @"isLogin"
             };
}

+ (NSValueTransformer *)isExistJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            BOOL result = [value boolValue];
            if(result) {
                return @"true";
            } else {
                return @"false";
            }
        } else {
            return value;
        }
    }];
}

+ (NSValueTransformer *)isLoginJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            BOOL result = [value boolValue];
            if(result) {
                return @"true";
            } else {
                return @"false";
            }
        } else {
            return value;
        }
    }];
}


@end
