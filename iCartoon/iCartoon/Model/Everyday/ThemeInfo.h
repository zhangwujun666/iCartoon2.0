//
//  ThemeInfo.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/13.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface ThemeInfo : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *tid;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *hasFollowed;

@end
