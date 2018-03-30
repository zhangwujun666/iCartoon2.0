//
//  DraftTaskContributeInfo.h
//  iCartoon
//
//  Created by 许成雄 on 16/5/12.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DraftTaskContributeInfo : NSObject

@property (strong, nonatomic) NSString *taskId;            //任务ID
@property (strong, nonatomic) NSString *taskTitle;         //任务标题
@property (strong, nonatomic) NSString *tilte;             //标题
@property (strong, nonatomic) NSString *content;           //内容
@property (strong, nonatomic) NSString *imageStr;          //图片
@property (strong, nonatomic) NSString *createTime;        //创建时间

@property (assign, nonatomic) BOOL isSelected;             //是否被选中

@end
