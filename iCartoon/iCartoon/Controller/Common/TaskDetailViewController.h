//
//  TaskDetailViewController.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/23.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskInfo.h"
@interface TaskDetailViewController : UIViewController
@property (assign, nonatomic) int draftStatus;
@property (strong, nonatomic) NSString *taskId;
@property (strong, nonatomic) TaskInfo *taskInfo;

@property (nonatomic,strong)NSString *imageUrl;
@property (nonatomic,strong)NSString *titleStr;
@end

