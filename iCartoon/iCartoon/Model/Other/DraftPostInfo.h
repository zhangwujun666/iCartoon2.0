//
//  DraftInfo.h
//  iCartoon
//
//  Created by cxl on 16/3/30.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DraftThemeInfo;

@interface DraftPostInfo : NSObject
@property (strong, nonatomic) NSString *taskId;
@property (strong, nonatomic) NSString *phoneNum;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) DraftThemeInfo *themeInfo;
@property (assign, nonatomic) BOOL isSelected;//是否被选中
@property (nonatomic,assign)int type;
@end
