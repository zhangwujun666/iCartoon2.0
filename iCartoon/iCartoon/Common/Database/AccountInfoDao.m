//
//  AccountInfoDao.m
//  iCartoon
//
//  Created by 寻梦者 on 16/2/2.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "AccountInfoDao.h"

@implementation AccountInfoDao

+(AccountInfoDao *)sharedInstance {
    static dispatch_once_t pred;
    static AccountInfoDao *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[AccountInfoDao alloc] init];
    });
    return shared;
}

-(BOOL)insertAccountInfo:(AccountInfo *)accountInfo {
    [[ICartoonDBHelper getUsingLKDBHelper] deleteWithClass:[AccountInfo class] where:@"1=1"];
    return [[ICartoonDBHelper getUsingLKDBHelper] insertToDB:accountInfo];
}

- (AccountInfo *)getAccountInfo {
    AccountInfo *accountInfo =[[ICartoonDBHelper getUsingLKDBHelper] searchSingle:[AccountInfo class] where:nil orderBy:nil];
    return accountInfo;
}

- (void)deleteAccountInfo {
    [[ICartoonDBHelper getUsingLKDBHelper] deleteWithClass:[AccountInfo class] where:@"1=1"];
}


@end
