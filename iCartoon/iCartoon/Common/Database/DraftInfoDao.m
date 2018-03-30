//
//  DraftInfoDao.m
//  iCartoon
//
//  Created by cxl on 16/3/30.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "DraftInfoDao.h"
#import "DraftPostInfo.h"
#import "DraftThemeInfo.h"

@implementation DraftInfoDao

+ (DraftInfoDao *)sharedInstance {
    static dispatch_once_t pred;
    static DraftInfoDao *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[DraftInfoDao alloc] init];
    });
    return shared;
}

- (void)clearTableData {
    [LKDBHelper clearTableData:[DraftPostInfo class]];
    [LKDBHelper clearTableData:[DraftThemeInfo class]];
}

- (BOOL)insertMsgWithDraftInfo:(DraftPostInfo *)info {
    BOOL isEstTable = [[ICartoonDBHelper getUsingLKDBHelper] getTableCreatedWithClass:[DraftPostInfo class]];
    if (isEstTable) {
        BOOL isEstObj = [[ICartoonDBHelper getUsingLKDBHelper] isExistsModel:info];
        if (isEstObj) {
            [[ICartoonDBHelper getUsingLKDBHelper] deleteToDB:info];
        }
    }
    return [[ICartoonDBHelper getUsingLKDBHelper] insertToDB:info];
}

- (BOOL)deleteMsgWithDraftInfo:(DraftPostInfo *)info {
    BOOL isEstTable = [[ICartoonDBHelper getUsingLKDBHelper] getTableCreatedWithClass:[DraftPostInfo class]];
    if (isEstTable) {
        BOOL isEstObj = [[ICartoonDBHelper getUsingLKDBHelper] isExistsModel:info];
        if (isEstObj) {
            BOOL isDeleteInfo = [[ICartoonDBHelper getUsingLKDBHelper] deleteToDB:info];
            BOOL isDeleteTheme = [[ICartoonDBHelper getUsingLKDBHelper] deleteToDB:info.themeInfo];
            return isDeleteTheme && isDeleteInfo;
        }
    }
    return NO;
}

- (BOOL)updateMsgWithDraftInfo:(DraftPostInfo *)info {
    BOOL isEstTable = [[ICartoonDBHelper getUsingLKDBHelper] getTableCreatedWithClass:[DraftPostInfo class]];
    if (isEstTable) {
        BOOL isEstObj = [[ICartoonDBHelper getUsingLKDBHelper] isExistsModel:info];
        if (isEstObj) {
            return [[ICartoonDBHelper getUsingLKDBHelper] updateToDB:info where:[NSString stringWithFormat:@"createTime = \"%@\"",info.createTime]];
        }
    }
    return NO;
}

- (NSMutableArray *)getMsgDraftInfos {
    return [[ICartoonDBHelper getUsingLKDBHelper] searchWithSQL:@"select * from @t " toClass:[DraftPostInfo class]];
}



@end
