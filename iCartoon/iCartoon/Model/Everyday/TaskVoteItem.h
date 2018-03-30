//
//  TaskVoteItem.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/16.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface TaskVoteItem : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *vid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *participants;
@property (strong, nonatomic) NSString *progress;

@end
