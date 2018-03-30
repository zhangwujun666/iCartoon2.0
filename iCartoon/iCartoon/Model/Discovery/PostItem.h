//
//  DiscoveryItem.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface PostItem : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *userAvatar;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *level;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *top;           //1--置顶, 0 --未置顶
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *theme;
@property (strong, nonatomic) NSString *commentNum;
@property (strong, nonatomic) NSString *favorNum;

@end
