//
//  PostPictureInfo.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/16.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "PostPictureInfo.h"

@implementation PostPictureInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"pid" : @"id",
             @"imageUrl" : @"path",
             @"thumbnailUrl" : @"thumbnailPath"
             };
}

+ (NSValueTransformer *)pidJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}


@end
