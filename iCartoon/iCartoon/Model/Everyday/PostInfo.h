//
//  PostInfo.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/16.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "AuthorInfo.h"
#import "PostPictureInfo.h"
#import "ThemeInfo.h"

@interface PostInfo : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *pid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *isToped;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *commentCount;
@property (strong, nonatomic) NSString *favorCount;
@property (strong, nonatomic) NSString *sharedCount;
@property (strong, nonatomic) NSString *favorStatus;
@property (strong, nonatomic) AuthorInfo *author;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) ThemeInfo *theme;

@end