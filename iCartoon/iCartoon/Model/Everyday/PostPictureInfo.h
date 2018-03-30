//
//  PostPictureInfo.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/16.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface PostPictureInfo : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *pid;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *thumbnailUrl;

@end
