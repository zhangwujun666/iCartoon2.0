//
//  TaskInfo.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface TaskInfo : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *tid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;
@property (strong, nonatomic) NSString *progress;
@property (strong, nonatomic) NSString *participants;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *collectStatus;
@property (assign, nonatomic)int draftStatus;
@property (assign, nonatomic)int type;
@property (strong, nonatomic)NSString *draftEndDate;
@property (strong, nonatomic)NSString *draftStartDate;
@property (strong, nonatomic)NSString *draftPercent;
@property (strong, nonatomic)NSString *draftPersonCount;

@end
