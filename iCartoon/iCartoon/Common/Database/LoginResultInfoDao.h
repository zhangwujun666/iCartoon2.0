//
//  LoginResultInfoDao.h
//  iCartoon
//
//  Created by 寻梦者 on 16/2/2.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginResultInfo.h"
#import "ICartoonDBHelper.h"

@interface LoginResultInfoDao : ICartoonDBHelper

+ (LoginResultInfoDao *)sharedInstance;

- (BOOL)insertLoginResultInfo:(LoginResultInfo *)loginResultInfo;
- (LoginResultInfo *)getLoginResultInfo;
- (void)deleteLoginResultInfo;

@end
