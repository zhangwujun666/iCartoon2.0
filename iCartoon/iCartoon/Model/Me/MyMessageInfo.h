//
//  MyMessageInfo.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/21.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "AuthorInfo.h"
#import "PostInfo.h"
#import "ThemeInfo.h"

@interface MyMessageInfo : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *mid;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) AuthorInfo *user;
@property (strong, nonatomic) AuthorInfo *replyer;
@property (strong, nonatomic) PostInfo *postInfo;
@property (strong, nonatomic) ThemeInfo *themeInfo;

@end
