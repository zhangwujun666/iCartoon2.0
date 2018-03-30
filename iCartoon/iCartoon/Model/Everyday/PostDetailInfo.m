//
//  PostDetailInfo.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/16.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "PostDetailInfo.h"
#import "NSString+Utils.h"

@implementation PostDetailInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"pid" : @"id",
             @"title" : @"title",
             @"content" : @"content",
             @"isToped" : @"stick",
             @"createTime" : @"createdDate",
             @"collectCount" : @"collectedCount",
             @"favorCount" : @"praiseCount",
             @"disfavorCount" : @"badCount",
             @"collectStatus" : @"hasCollected",
             @"favorStatus" : @"hasActed",
             @"author" : @"user",
             @"images" : @"images",
             @"favorers" : @"praiseUsers",
             @"disfavorers" : @"badUsers",
             @"theme" : @"theme",
             @"commentCount": @"commentCount"
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

+ (NSValueTransformer *)collectCountJSONTransformer {
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

+ (NSValueTransformer *)disfavorCountJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)collectStatusJSONTransformer {
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

+ (NSValueTransformer *)favorersJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        NSArray *imageArray = [MTLJSONAdapter modelsOfClass:[AuthorInfo class] fromJSONArray:value error:nil];
        if(imageArray) {
            return [NSMutableArray arrayWithArray:imageArray];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)disfavorersJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        NSArray *imageArray = [MTLJSONAdapter modelsOfClass:[AuthorInfo class] fromJSONArray:value error:nil];
        if(imageArray) {
            return [NSMutableArray arrayWithArray:imageArray];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)themeJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        ThemeInfo *theme = [MTLJSONAdapter modelOfClass:[ThemeInfo class] fromJSONDictionary:value error:nil];
        if(theme) {
            return theme;
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

+ (NSValueTransformer *)commentCountJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}


@end
