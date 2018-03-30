//
//  CommentDraftDao.m
//  iCartoon
//
//  Created by 许成雄 on 16/4/17.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "CommentDraftDao.h"

@implementation CommentDraftDao

+ (CommentDraftDao *)sharedInstance {
    static dispatch_once_t pred;
    static CommentDraftDao *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[CommentDraftDao alloc] init];
    });
    return shared;
}


- (BOOL)insertCommentDraftInfo:(DraftCommentInfo *)draftInfo {
    BOOL result = [[ICartoonDBHelper getUsingLKDBHelper] insertWhenNotExists:draftInfo];
    return result;
}

- (NSArray *)getCommentDraftList {
    NSMutableArray *draftList = [[ICartoonDBHelper getUsingLKDBHelper] search:[DraftCommentInfo class] where:nil orderBy:nil offset:0 count:999];
    return draftList;
}

- (DraftCommentInfo *)getCommentDraftInfo:(NSString *)draftInfoId {
    DraftCommentInfo *draftInfo = (DraftCommentInfo *)[[ICartoonDBHelper getUsingLKDBHelper] searchSingle:[DraftCommentInfo class] where:[NSString stringWithFormat:@"commentId=%@", draftInfoId] orderBy:nil];
    return draftInfo;
}

- (BOOL)deleteCommentDraftInfo:(DraftCommentInfo *)draftInfo {
    BOOL isEstObj = [[ICartoonDBHelper getUsingLKDBHelper] isExistsModel:draftInfo];
    BOOL result = NO;
    if (isEstObj) {
        result = [[ICartoonDBHelper getUsingLKDBHelper] deleteToDB:draftInfo];
    }
    return result;
//    BOOL result = [[ICartoonDBHelper getUsingLKDBHelper] deleteWithClass:[DraftCommentInfo class] where:[NSString stringWithFormat:@"commentId=%@", draftInfo.commentId]];
//    return result;
}

- (void)deleteAll {
    [[ICartoonDBHelper getUsingLKDBHelper] deleteWithClass:[DraftCommentInfo class] where:@"1=1"];
}

@end
