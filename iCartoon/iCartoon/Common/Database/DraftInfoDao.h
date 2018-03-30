//
//  DraftInfoDao.h
//  iCartoon
//
//  Created by cxl on 16/3/30.
//  Copyright © 2016年 wonders. All rights reserved.
//
//草稿箱数据处理

#import <Foundation/Foundation.h>
#import "ICartoonDBHelper.h"

@class DraftPostInfo;
@interface DraftInfoDao : ICartoonDBHelper

+ (DraftInfoDao *)sharedInstance;

/**
 *  草稿箱信息-删除相关表数据
 */
- (void)clearTableData;
/**
 *  草稿箱信息-消息添加
 */
- (BOOL)insertMsgWithDraftInfo:(DraftPostInfo *)info;
/**
 *  草稿箱信息-消息删除
 */
- (BOOL)deleteMsgWithDraftInfo:(DraftPostInfo *)info;
/**
 *  草稿箱信息-消息更新
 */
- (BOOL)updateMsgWithDraftInfo:(DraftPostInfo *)info;
/**
 *  草稿箱信息-数据库数据获取
 */
- (NSMutableArray *)getMsgDraftInfos;


@end
