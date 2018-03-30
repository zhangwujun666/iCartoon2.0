//
//  ThemeGroupInfo.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/21.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "ThemeGroupInfo.h"
#import "ThemeInfo.h"

@implementation ThemeGroupInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"tag" : @"tag",
             @"list" : @"themes"
             };
}

+ (NSValueTransformer *)listJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSArray class]]) {
            NSArray *themes = [MTLJSONAdapter modelsOfClass:[ThemeInfo class] fromJSONArray:value error:nil];
            NSMutableArray *themeLists = [NSMutableArray arrayWithCapacity:0];
            if(themes) {
                [themeLists addObjectsFromArray:themes];
            }
            return themeLists;
        } else {
            return (NSString *)value;
        }
    }];
}

@end
