//
//  UserInfoDao.m
//  HCPatient
//
//  Created by  寻梦者 on 15/3/19.
//  Copyright (c) 2015年 wonders. All rights reserved.
//

#import "UserInfoDao.h"

@implementation UserInfoDao

+(UserInfoDao *)sharedInstance {
    static dispatch_once_t pred;
    static UserInfoDao *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[UserInfoDao alloc] init];
    });
    return shared;
}

-(BOOL)insertUserInfo:(UserInfo *)userInfo {
    [[ICartoonDBHelper getUsingLKDBHelper] deleteWithClass:[UserInfo class] where:@"1=1"];
    return [[ICartoonDBHelper getUsingLKDBHelper] insertToDB:userInfo];
}

- (UserInfo *)getUserInfo {
    UserInfo *userInfo =[[ICartoonDBHelper getUsingLKDBHelper] searchSingle:[UserInfo class] where:nil orderBy:nil];
    return userInfo;
}

-(void)deleteUserInfo {
    [[ICartoonDBHelper getUsingLKDBHelper] deleteWithClass:[UserInfo class] where:@"1=1"];
}

@end
