//
//  AccountInfoDao.h
//  iCartoon
//
//  Created by 寻梦者 on 16/2/2.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountInfo.h"
#import "ICartoonDBHelper.h"

@interface AccountInfoDao : ICartoonDBHelper

+ (AccountInfoDao *)sharedInstance;

- (BOOL)insertAccountInfo:(AccountInfo *)accountInfo;
- (AccountInfo *)getAccountInfo;
- (void)deleteAccountInfo;

@end
