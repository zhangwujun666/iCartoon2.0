//
//  TaskContributeDraftDao.m
//  iCartoon
//
//  Created by 许成雄 on 16/4/17.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "TaskContributeDraftDao.h"

@implementation TaskContributeDraftDao

+ (TaskContributeDraftDao *)sharedInstance {
    static dispatch_once_t pred;
    static TaskContributeDraftDao *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[TaskContributeDraftDao alloc] init];
    });
    return shared;
}


- (BOOL)insertCommentDraftInfo:(DraftTaskContributeInfo *)draftInfo {
    BOOL result = [[ICartoonDBHelper getUsingLKDBHelper] insertWhenNotExists:draftInfo];
    return result;
}

- (NSArray *)getCommentDraftList {
    NSMutableArray *draftList = [[ICartoonDBHelper getUsingLKDBHelper] search:[DraftTaskContributeInfo class] where:nil orderBy:nil offset:0 count:999];
    return draftList;
}

- (DraftTaskContributeInfo *)getCommentDraftInfo:(NSString *)draftInfoId {
    DraftTaskContributeInfo *draftInfo = (DraftTaskContributeInfo *)[[ICartoonDBHelper getUsingLKDBHelper] searchSingle:[DraftTaskContributeInfo class] where:[NSString stringWithFormat:@"taskId=%@", draftInfoId] orderBy:nil];
    return draftInfo;
}

- (BOOL)deleteCommentDraftInfo:(DraftTaskContributeInfo *)draftInfo {
    BOOL isEstObj = [[ICartoonDBHelper getUsingLKDBHelper] isExistsModel:draftInfo];
    BOOL result = NO;
    if (isEstObj) {
        result = [[ICartoonDBHelper getUsingLKDBHelper] deleteToDB:draftInfo];
    }
    return result;
}

- (void)deleteAll {
    [[ICartoonDBHelper getUsingLKDBHelper] deleteWithClass:[DraftTaskContributeInfo class] where:@"1=1"];
}

@end
