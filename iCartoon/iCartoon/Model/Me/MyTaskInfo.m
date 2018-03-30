//
//  MyTaskItem.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "MyTaskInfo.h"

@implementation MyTaskInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"tid" : @"id",
             @"title" : @"title",
             @"time" : @"voteDate"
             };
}

+ (NSValueTransformer *)tidJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return value;
        }
    }];
}

+ (NSValueTransformer *)timeJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return value;
        }
    }];
}

@end
