//
//  WZMyHTTPRequest.m
//  iCartoon
//
//  Created by wangzheng on 16/5/30.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "WZMyHTTPRequest.h"

@implementation WZMyHTTPRequest
-(id)initWithRequestString:(NSString *)requestString delegate:(id)delegate
{
    if (self = [super init]) {
        
        self.delegate = delegate;
        
        NSURL *url  = [NSURL URLWithString: requestString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
        if (connection) {
            NSLog(@"连接成功");
        }else{
            NSLog(@"连接失败");
        }
    }
    return self;
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (error) {
        NSLog(@"请求失败----%@",error.localizedDescription);
    }
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //拼接数据
    [self.sucData appendData:data];
}
//多次发送请求的时候,可能会产生垃圾 所以需要清理一下缓存self.sucData.length = 0;
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"服务反馈");
    if (self.sucData  == nil) {
        self.sucData = [NSMutableData data];
    }else{
        //清理缓存
        self.sucData.length = 0;
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"请求完成");
    //增加代码的安全性
    if ([self.delegate respondsToSelector:@selector(requestFinshed:)]) {
        [self.delegate requestFinshed:self];
    }
}

@end
