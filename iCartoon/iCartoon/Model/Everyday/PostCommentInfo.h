//
//  PostCommentInfo.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/16.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "AuthorInfo.h"

@interface PostCommentInfo : MTLModel <MTLJSONSerializing>
@property (assign, nonatomic) int imageHeight;
@property (assign, nonatomic) int imageWidth;
@property (strong, nonatomic) NSString *cid;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *commentCount;
@property (strong, nonatomic) AuthorInfo *author;
@property (strong, nonatomic) AuthorInfo *replier;

@end
