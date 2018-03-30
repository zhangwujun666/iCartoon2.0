//
//  TaskTableViewCell.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskInfo.h"

@protocol TaskTableViewCellDelegate <NSObject>

@optional
- (void)collectTaskForItem:(TaskInfo *)taskItem atIndexPath:(NSIndexPath *)indexPath;

@end

@interface TaskTableViewCell : UITableViewCell

@property (assign, nonatomic) id<TaskTableViewCellDelegate> delegate;
@property (strong, nonatomic) TaskInfo *taskItem;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end
