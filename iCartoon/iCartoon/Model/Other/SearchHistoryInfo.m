//
//  SearchHistoryInfo.m
//  iCartoon
//
//  Created by 许成雄 on 16/4/3.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "SearchHistoryInfo.h"
#import "ICartoonDBHelper.h"

@implementation SearchHistoryInfo
+ (LKDBHelper *)getUsingLKDBHelper {
    return [ICartoonDBHelper getUsingLKDBHelper];
}
@end
