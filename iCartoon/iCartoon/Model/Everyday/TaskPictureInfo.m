//
//  TaskPictureInfo.m
//  iCartoon
//
//  Created by 许成雄 on 16/5/16.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "TaskPictureInfo.h"

@implementation TaskPictureInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @ {
        @"url" : @"url",
    };
}

+ (NSValueTransformer *)urlJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSURL class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}


@end
