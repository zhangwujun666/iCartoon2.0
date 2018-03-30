//
//  TaskContributeDraftDao.h
//  iCartoon
//
//  Created by 许成雄 on 16/4/17.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DraftTaskContributeInfo.h"
#import "ICartoonDBHelper.h"

@interface TaskContributeDraftDao : ICartoonDBHelper

+ (TaskContributeDraftDao *)sharedInstance;

- (BOOL)insertCommentDraftInfo:(DraftTaskContributeInfo *)draftInfo;

- (NSArray *)getCommentDraftList;

- (DraftTaskContributeInfo *)getCommentDraftInfo:(NSString *)draftInfoId;

- (BOOL)deleteCommentDraftInfo:(DraftTaskContributeInfo *)draftInfo;

- (void)deleteAll;

@end
