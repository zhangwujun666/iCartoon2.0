//
//  SearchHistoryDao.m
//  iCartoon
//
//  Created by 许成雄 on 16/4/3.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "SearchHistoryDao.h"

@implementation SearchHistoryDao

+ (SearchHistoryDao *)sharedInstance {
    static dispatch_once_t pred;
    static SearchHistoryDao *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SearchHistoryDao alloc] init];
    });
    return shared;
}

- (void)clear {
    [LKDBHelper clearTableData:[SearchHistoryInfo class]];
}

- (BOOL)insertWithSearchHistoryInfo:(SearchHistoryInfo *)history {
    BOOL isEstTable = [[ICartoonDBHelper getUsingLKDBHelper] getTableCreatedWithClass:[SearchHistoryInfo class]];
    if (isEstTable) {
        BOOL isEstObj = [[ICartoonDBHelper getUsingLKDBHelper] isExistsModel:history];
        if (isEstObj) {
            [[ICartoonDBHelper getUsingLKDBHelper] deleteToDB:history];
        }
    }
    return [[ICartoonDBHelper getUsingLKDBHelper] insertToDB:history];
}

- (NSMutableArray *)getSearchHistroyList {
    return [[ICartoonDBHelper getUsingLKDBHelper] searchWithSQL:@"select * from @t order by time desc" toClass:[SearchHistoryInfo class]];
}

- (BOOL)deleteSearchHistoryInfo:(SearchHistoryInfo *)info {
    BOOL isEstTable = [[ICartoonDBHelper getUsingLKDBHelper] getTableCreatedWithClass:[SearchHistoryInfo class]];
    if (isEstTable) {
        BOOL isEstObj = [[ICartoonDBHelper getUsingLKDBHelper] isExistsModel:info];
        if (isEstObj) {
            BOOL isDeleteInfo = [[ICartoonDBHelper getUsingLKDBHelper] deleteToDB:info];
            return isDeleteInfo;
        }
    }
    return NO;
}


@end
