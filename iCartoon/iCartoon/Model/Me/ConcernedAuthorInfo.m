//
//  ConcernedAuthor.m
//  iCartoon
//
//  Created by 许成雄 on 16/4/1.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "ConcernedAuthorInfo.h"

@implementation ConcernedAuthorInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"authorId" : @"id",
             @"account" : @"account",
             @"nickname" : @"nickName",
             @"avatarUrl" : @"avatar",
             @"signature" : @"signature"
             };
}

+ (NSValueTransformer *)authorIdJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}


@end
