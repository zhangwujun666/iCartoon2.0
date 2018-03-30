//
//  ErrorInfo.m
//  Patient
//
//  Created by oo_life on 14/12/9.
//  Copyright (c) 2014年 W3. All rights reserved.
//

#import "CommonInfo.h"
@implementation CommonInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"status" : @"success",
             @"message" : @"message",
             @"isLogin" : @"isLogin"
            };
}

+ (NSValueTransformer *)statusJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            BOOL result = [value boolValue];
            if(result) {
                return @"true";
            } else {
                return @"false";
            }
        } else {
            return (NSString *)value;
        }
    }];
}

+ (NSValueTransformer *)isLoginJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            return (NSString *)value;
        }
    }];
}



- (BOOL)isSuccess {
    return [self.status isEqualToString:@"true"];
}

- (BOOL)isTokenInValid {
    return [self.status isEqualToString:@"false"] && [self.isLogin isEqualToString:@"0"];
}
@end
