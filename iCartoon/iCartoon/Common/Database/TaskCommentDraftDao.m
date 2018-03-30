//
//  TaskCommentDraftDao.m
//  iCartoon
//
//  Created by 许成雄 on 16/4/17.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "TaskCommentDraftDao.h"

@implementation TaskCommentDraftDao

+ (TaskCommentDraftDao *)sharedInstance {
    static dispatch_once_t pred;
    static TaskCommentDraftDao *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[TaskCommentDraftDao alloc] init];
    });
    return shared;
}


- (BOOL)insertCommentDraftInfo:(DraftTaskCommentInfo *)draftInfo {
    BOOL result = [[ICartoonDBHelper getUsingLKDBHelper] insertWhenNotExists:draftInfo];
    return result;
}

- (NSArray *)getCommentDraftList {
    NSMutableArray *draftList = [[ICartoonDBHelper getUsingLKDBHelper] search:[DraftTaskCommentInfo class] where:nil orderBy:nil offset:0 count:999];
    return draftList;
}

- (DraftTaskCommentInfo *)getCommentDraftInfo:(NSString *)draftInfoId {
    DraftTaskCommentInfo *draftInfo = (DraftTaskCommentInfo *)[[ICartoonDBHelper getUsingLKDBHelper] searchSingle:[DraftTaskCommentInfo class] where:[NSString stringWithFormat:@"commentId=%@", draftInfoId] orderBy:nil];
    return draftInfo;
}

- (BOOL)deleteCommentDraftInfo:(DraftTaskCommentInfo *)draftInfo {
    BOOL isEstObj = [[ICartoonDBHelper getUsingLKDBHelper] isExistsModel:draftInfo];
    BOOL result = NO;
    if (isEstObj) {
        result = [[ICartoonDBHelper getUsingLKDBHelper] deleteToDB:draftInfo];
    }
    return result;
}

- (void)deleteAll {
    [[ICartoonDBHelper getUsingLKDBHelper] deleteWithClass:[DraftTaskCommentInfo class] where:@"1=1"];
}

@end
