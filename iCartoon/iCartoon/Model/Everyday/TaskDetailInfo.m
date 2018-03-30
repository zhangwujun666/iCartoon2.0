//
//  TaskDetailInfo.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/16.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "TaskDetailInfo.h"

@implementation TaskDetailInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"tid" : @"id",
             @"title" : @"title",
             @"imageUrl" : @"image",
             @"startTime" : @"startDate",
             @"endTime" : @"endDate",
             @"progress" : @"percent",
             @"participants" : @"personCount",
             @"status" : @"status",
             @"isVoted" : @"isVoted",
             @"voteItems" : @"items"
             };
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

+ (NSValueTransformer *)startTimeJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)endTimeJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)progressJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)participantsJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)statusJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)isVotedJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)voteItemsJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        NSArray *items = [MTLJSONAdapter modelsOfClass:[TaskVoteItem class] fromJSONArray:value error:nil];
        if(items) {
            return [NSMutableArray arrayWithArray:items];
        } else {
            return (NSString *)value;
        }
    }];
}



@end
