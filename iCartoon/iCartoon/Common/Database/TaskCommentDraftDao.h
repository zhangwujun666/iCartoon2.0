//
//  TaskCommentDraftDao.h
//  iCartoon
//
//  Created by 许成雄 on 16/4/17.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DraftTaskCommentInfo.h"
#import "ICartoonDBHelper.h"

@interface TaskCommentDraftDao : ICartoonDBHelper

+ (TaskCommentDraftDao *)sharedInstance;

- (BOOL)insertCommentDraftInfo:(DraftTaskCommentInfo *)draftInfo;

- (NSArray *)getCommentDraftList;

- (DraftTaskCommentInfo *)getCommentDraftInfo:(NSString *)draftInfoId;

- (BOOL)deleteCommentDraftInfo:(DraftTaskCommentInfo *)draftInfo;

- (void)deleteAll;

@end
