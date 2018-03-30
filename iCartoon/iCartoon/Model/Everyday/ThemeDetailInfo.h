//
//  ThemeDetailInfo.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface ThemeDetailInfo : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *tid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *avatarUrl;
@property (strong, nonatomic) NSString *backgroundUrl;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *postNum;
@property (strong, nonatomic) NSString *followNum;
@property (strong, nonatomic) NSString *followStatus;

@end
