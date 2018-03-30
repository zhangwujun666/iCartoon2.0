//
//  ErrorInfo.h
//  Patient
//
//  Created by oo_life on 14/12/9.
//  Copyright (c) 2014年 W3. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface CommonInfo : MTLModel <MTLJSONSerializing>

@property(nonatomic, strong)  NSString *status;
@property(nonatomic, strong)  NSString *message;
@property (nonatomic, strong) NSString *isLogin;

- (BOOL)isSuccess;

- (BOOL)isTokenInValid;

@end
