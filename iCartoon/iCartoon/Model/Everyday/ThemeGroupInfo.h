//
//  ThemeGroupInfo.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/21.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface ThemeGroupInfo : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *tag;
@property (strong, nonatomic) NSMutableArray *list;

@end
