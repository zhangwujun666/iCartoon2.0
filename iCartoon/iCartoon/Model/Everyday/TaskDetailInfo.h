//
//  TaskDetailInfo.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/16.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#include "TaskVoteItem.h"

@interface TaskDetailInfo : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *tid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;
@property (strong, nonatomic) NSString *progress;
@property (strong, nonatomic) NSString *participants;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSMutableArray *voteItems;
@property (strong, nonatomic) NSString *isVoted;

@end
