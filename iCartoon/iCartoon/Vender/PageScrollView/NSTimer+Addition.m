//
//  NSTimer+Addition.m
//  PagedScrollView
//
//  Created by 陈政 on 14-1-24.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "NSTimer+Addition.h"

@implementation NSTimer (Addition)

//返回未来的某个时间
-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}

//返回当前时间
-(void)resumeTimer
{
    if (![self isValid]) {
        return ;
    }
//    设置fireData，其实暂停、开始会用到
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
