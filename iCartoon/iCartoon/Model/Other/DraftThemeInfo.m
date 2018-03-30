//
//  DraftThemeInfo.m
//  iCartoon
//
//  Created by cxl on 16/3/30.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "DraftThemeInfo.h"
#import "ICartoonDBHelper.h"

@implementation DraftThemeInfo
+ (LKDBHelper *)getUsingLKDBHelper {
    return [ICartoonDBHelper getUsingLKDBHelper];
}

+ (NSString *)getTableName {
    return @"DraftThemeInfoTable";
}

+ (NSString *)getPrimaryKey {
    return @"createTime";
}

@end
