//
//  CommentInfo.m
//  GaoZhi
//
//  Created by 寻梦者 on 15/11/7.
//  Copyright © 2015年 GlenN. All rights reserved.
//

#import "CommentInfo.h"

@implementation CommentInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"commentId" : @"commentID",
             @"comment" : @"cc_content",
             @"senderId" : @"cc_send_userid",
             @"senderName" : @"cc_send_username",
             @"senderAvatar" : @"send_user_logo",
             @"time" : @"cc_send_time",
             @"status" : @"cc_send_status",
             @"advertisementId" : @"cc_advid",
             @"favorNum" : @"cc_yes_num",
             @"favorStatus": @"has_yes"
             };
}

+ (NSValueTransformer *)commentIdJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [((NSNumber *)value) stringValue];
        }
        return (NSString *)value;
    }];
}

+ (NSValueTransformer *)senderIdJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [((NSNumber *)value) stringValue];
        }
        return (NSString *)value;
    }];
}

+ (NSValueTransformer *)timeJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        if([value isKindOfClass:[NSNumber class]]) {
            NSString *result = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[((NSNumber *)value) longLongValue]]];
            return result;
        } else {
            NSString *result = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[((NSString *)value) longLongValue]]];
            return result;
        }
    }];
}

+ (NSValueTransformer *)statusJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [((NSNumber *)value) stringValue];
        }
        return (NSString *)value;
    }];
}
+ (NSValueTransformer *)advertisementIdJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [((NSNumber *)value) stringValue];
        }
        return (NSString *)value;
    }];
}

+ (NSValueTransformer *)favorNumJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [((NSNumber *)value) stringValue];
        }
        return (NSString *)value;
    }];
}

+ (NSValueTransformer *)favorStatusJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [((NSNumber *)value) stringValue];
        }
        return (NSString *)value;
    }];
}

@end
