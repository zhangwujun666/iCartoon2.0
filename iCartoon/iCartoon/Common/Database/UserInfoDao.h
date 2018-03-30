//
//  UserInfoDao.h
//  HCPatient
//
//  Created by  寻梦者 on 15/3/19.
//  Copyright (c) 2015年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "ICartoonDBHelper.h"

@interface UserInfoDao : ICartoonDBHelper

+ (UserInfoDao *)sharedInstance;

- (BOOL)insertUserInfo:(UserInfo *)userInfo;
- (UserInfo *)getUserInfo;
- (void)deleteUserInfo;

@end
