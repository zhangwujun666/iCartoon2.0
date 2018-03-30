//
//  DraftInfo.m
//  iCartoon
//
//  Created by cxl on 16/3/30.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "DraftPostInfo.h"
#import "ICartoonDBHelper.h"
#import "DraftThemeInfo.h"

@implementation DraftPostInfo
+ (LKDBHelper *)getUsingLKDBHelper {
    return [ICartoonDBHelper getUsingLKDBHelper];
}

+ (NSString *)getTableName {
    return @"DraftInfoTable";
}

+ (NSString *)getPrimaryKey {
    return @"createTime";
}

+ (void)initialize
{
    //单个要不显示时
    [self removePropertyWithColumnName:@"isSelected"];
}

@end
