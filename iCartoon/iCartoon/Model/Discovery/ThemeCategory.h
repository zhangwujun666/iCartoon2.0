//
//  ThemeCategory.h
//  iCartoon
//
//  Created by 寻梦者 on 16/3/27.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface ThemeCategory : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *categoryName;

@end
