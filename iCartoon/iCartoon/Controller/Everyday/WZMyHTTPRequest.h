//
//  WZMyHTTPRequest.h
//  iCartoon
//
//  Created by wangzheng on 16/5/30.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WZMyHTTPRequest;

@protocol WZMyHTTPRequestDelegate <NSObject>

-(void)requestFinshed:(WZMyHTTPRequest *)request;

@end

@interface WZMyHTTPRequest : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@property (nonatomic,weak)id<WZMyHTTPRequestDelegate>delegate;

@property (nonatomic,strong)NSMutableData *sucData;

-(id)initWithRequestString:(NSString *)requestString delegate:(id)delegate;
@end
