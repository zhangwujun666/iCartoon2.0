//
//  PublishTaskViewController.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeInfo.h"
#import "DraftPostInfo.h"

typedef NS_ENUM(NSInteger, PostTaskSourceType) {
    PostTaskSourceTypeNew = 0,
    PostTaskSourceTypeDraft
};

@interface PublishTaskViewController : UIViewController

@property (assign, nonatomic) PostTaskSourceType type;             //帖子来源类型
@property (strong, nonatomic) NSString *taskId;                    //任务ID
@property (strong, nonatomic) DraftPostInfo *draftInfo;            //草稿

@end
