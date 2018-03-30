//
//  HCDBHelper.h
//  HCPatient
//
//  Created by  寻梦者 on 15/3/19.
//  Copyright (c) 2015年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DB_NAME @"iCartoon.db"

@interface ICartoonDBHelper : NSObject

+ (LKDBHelper *)getUsingLKDBHelper;
- (void)initDatabase;
- (void)clearDatabase;

@end
