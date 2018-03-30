//
//  SearchHistoryDao.h
//  iCartoon
//
//  Created by 许成雄 on 16/4/3.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICartoonDBHelper.h"
#import "SearchHistoryInfo.h"

@interface SearchHistoryDao : ICartoonDBHelper

+ (SearchHistoryDao *)sharedInstance;

//清除
- (void)clear;

//插入
- (BOOL)insertWithSearchHistoryInfo:(SearchHistoryInfo *)history;

//获取历史纪录
- (NSMutableArray *)getSearchHistroyList;

//删除历史记录
- (BOOL)deleteSearchHistoryInfo:(SearchHistoryInfo *)info;


@end
