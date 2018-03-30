//
//  PostCommentInfo.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/16.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "PostCommentInfo.h"

@implementation PostCommentInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {

    return @{
             @"cid" : @"id",
             @"content" : @"content",
             @"createTime" : @"createdDate",
             @"commentCount" : @"commentCount",
             @"author" : @"user",
             @"replier" : @"replyUser"
             };
}

+ (NSValueTransformer *)cidJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)authorJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        AuthorInfo *authorInfo = [MTLJSONAdapter modelOfClass:[AuthorInfo class] fromJSONDictionary:value error:nil];
        if(authorInfo) {
            return authorInfo;
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)replierJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        AuthorInfo *authorInfo = [MTLJSONAdapter modelOfClass:[AuthorInfo class] fromJSONDictionary:value error:nil];
        if(authorInfo) {
            return authorInfo;
        } else {
            return (NSString *)value;
        }
    }];
}



@end
