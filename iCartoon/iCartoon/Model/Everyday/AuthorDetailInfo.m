//
//  AuthorDetailInfo.m
//  iCartoon
//
//  Created by 许成雄 on 16/4/3.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "AuthorDetailInfo.h"

@implementation AuthorDetailInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @ {
        
             @"uid" : @"id",
             @"account" : @"account",
             @"nickname" : @"nickName",
             @"avatar" : @"avatar",
             @"signature" : @"signature",
             @"gender" : @"gender",
             @"birthday" : @"birthday",
             @"deviceId" : @"deviceId",
             @"isFollowed" : @"isFollow",
             @"bloodType" : @"bloodType"
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

+ (NSValueTransformer *)genderJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)isFollowedJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}


@end
