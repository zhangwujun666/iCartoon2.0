//
//  UserInfo.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/11.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"uid" :  @"id",
             @"account" :  @"account",
             @"avatar" :  @"avatar",
             @"nickname" :  @"nickName",
             @"gender" :  @"gender",
             @"bloodType" :  @"bloodType",
             @"birthday" :  @"birthday",
             @"signature" :  @"signature",
             @"deviceId" :  @"deviceID"
             };
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

+ (NSValueTransformer *)birthdayJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            NSString *strValue = [value stringValue];
            if([value stringValue].length >= 10) {
                strValue = [[value stringValue] substringWithRange:NSMakeRange(0, 10)];
            }
            return strValue;
        } else {
            NSString *strValue = (NSString *)value;
            if(((NSString *)value).length >= 10) {
                strValue = [((NSString *)value) substringWithRange:NSMakeRange(0, 10)];
            }
            return strValue;
        }
    }];
}

@end
