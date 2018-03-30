//
//  LoginResultInfoDao.m
//  iCartoon
//
//  Created by 寻梦者 on 16/2/2.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "LoginResultInfoDao.h"

@implementation LoginResultInfoDao

+(LoginResultInfoDao *)sharedInstance {
    static dispatch_once_t pred;
    static LoginResultInfoDao *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[LoginResultInfoDao alloc] init];
    });
    return shared;
}

-(BOOL)insertLoginResultInfo:(LoginResultInfo *)loginResultInfo {
    [[ICartoonDBHelper getUsingLKDBHelper] deleteWithClass:[LoginResultInfo class] where:@"1=1"];
    return [[ICartoonDBHelper getUsingLKDBHelper] insertToDB:loginResultInfo];
}

-(LoginResultInfo *)getLoginResultInfo {
    LoginResultInfo *resultInfo =[[ICartoonDBHelper getUsingLKDBHelper] searchSingle:[LoginResultInfo class] where:nil orderBy:nil];
    return resultInfo;
}

-(void)deleteLoginResultInfo {
    [[ICartoonDBHelper getUsingLKDBHelper] deleteWithClass:[LoginResultInfo class] where:@"1=1"];
}


@end
