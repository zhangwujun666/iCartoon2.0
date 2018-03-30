//
//  SearchResultInfo.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "PostInfo.h"
#import "ThemeInfo.h"
#import "AuthorInfo.h"

@interface SearchResultInfo : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSMutableArray *postList;
@property (strong, nonatomic) NSMutableArray *themeList;
@property (strong, nonatomic) NSMutableArray *userList;
@property (strong, nonatomic) NSString *refreshTime;

@end
