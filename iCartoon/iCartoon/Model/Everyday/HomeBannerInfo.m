//
//  HomeBannerInfo.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/17.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "HomeBannerInfo.h"

@implementation HomeBannerInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title" : @"title",
             @"imageUrl" : @"image",
             @"relatedType" : @"relatedType",
             @"relatedId" : @"relatedId",
             @"link" : @"link"
             };
}

+ (NSValueTransformer *)relatedIdJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)relatedTypeJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}



@end
