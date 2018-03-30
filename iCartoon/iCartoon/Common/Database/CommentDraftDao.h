//
//  CommentDraftDao.h
//  iCartoon
//
//  Created by 许成雄 on 16/4/17.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DraftCommentInfo.h"
#import "ICartoonDBHelper.h"

@interface CommentDraftDao : ICartoonDBHelper

+ (CommentDraftDao *)sharedInstance;

- (BOOL)insertCommentDraftInfo:(DraftCommentInfo *)draftInfo;

- (NSArray *)getCommentDraftList;

- (DraftCommentInfo *)getCommentDraftInfo:(NSString *)draftInfoId;

- (BOOL)deleteCommentDraftInfo:(DraftCommentInfo *)draftInfo;

- (void)deleteAll;

@end
