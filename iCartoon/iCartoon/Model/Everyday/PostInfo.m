//
//  PostInfo.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/16.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "PostInfo.h"
#import "NSString+Utils.h"

@implementation PostInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"pid" : @"id",
             @"title" : @"title",
             @"content" : @"content",
             @"isToped" : @"stick",
             @"createTime" : @"createdDate",
             @"commentCount" : @"commentCount",
             @"favorCount" : @"praiseCount",
             @"sharedCount" : @"sharedCount",
             @"favorStatus" : @"hasActed",
             @"author" : @"user",
             @"images" : @"images",
             @"theme" : @"theme"
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

+ (NSValueTransformer *)isTopedJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)tidJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)createTimeJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)commentCountJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)favorCountJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)sharedCountJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)favorStatusJSONTransformer {
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

+ (NSValueTransformer *)imagesJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        NSArray *imageArray = [MTLJSONAdapter modelsOfClass:[PostPictureInfo class] fromJSONArray:value error:nil];
        if(imageArray) {
            return [NSMutableArray arrayWithArray:imageArray];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)themeJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        ThemeInfo *themeInfo = [MTLJSONAdapter modelOfClass:[ThemeInfo class] fromJSONDictionary:value error:nil];
        if(themeInfo) {
            return themeInfo;
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)contentJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            NSString *resultStr = [value stringValue];
            resultStr = [NSString flattenHTML:resultStr trimWhiteSpace:YES];
            return resultStr;
        } else {
            NSString *resultStr = (NSString *)value;
            resultStr = [NSString flattenHTML:resultStr trimWhiteSpace:YES];
            return resultStr;
        }
    }];
}


@end
