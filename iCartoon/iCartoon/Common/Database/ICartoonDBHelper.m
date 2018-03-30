//
//  HCDBHelper.m
//  HCPatient
//
//  Created by  寻梦者 on 15/3/19.
//  Copyright (c) 2015年 wonders. All rights reserved.
//

#import "ICartoonDBHelper.h"
#import "UserInfo.h"
#import "ACcountInfo.h"
#import "LoginResultInfo.h"
#import "DraftPostInfo.h"
#import "DraftThemeInfo.h"

@implementation ICartoonDBHelper

+ (LKDBHelper *)getUsingLKDBHelper {
    static LKDBHelper *dbHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        dbHelper = [[LKDBHelper alloc] initWithDBPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:DB_NAME]];
    });
    return dbHelper;
}

- (void)initDatabase {
    LKDBHelper *globalHelper = [ICartoonDBHelper getUsingLKDBHelper];
    //创建表
    BOOL result;
    result = [globalHelper getTableCreatedWithClass:[UserInfo class]];
    result = [globalHelper getTableCreatedWithClass:[AccountInfo class]];
    result = [globalHelper getTableCreatedWithClass:[LoginResultInfo class]];
    result = [globalHelper getTableCreatedWithClass:[DraftThemeInfo class]];
    result = [globalHelper getTableCreatedWithClass:[DraftPostInfo class]];
    
}

- (void)clearDatabase {
    LKDBHelper *globalHelper = [ICartoonDBHelper getUsingLKDBHelper];
    //删除表
    [globalHelper deleteWithClass:[UserInfo class] where:nil];
    [globalHelper deleteWithClass:[AccountInfo class] where:nil];
    [globalHelper deleteWithClass:[LoginResultInfo class] where:nil];
    [globalHelper deleteWithClass:[DraftPostInfo class] where:nil];
    [globalHelper deleteWithClass:[DraftThemeInfo class] where:nil];
}

@end
