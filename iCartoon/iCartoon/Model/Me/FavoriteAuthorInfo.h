//
//  FavoriteAuthorInfo.h
//  iCartoon
//
//  Created by 寻梦者 on 16/3/28.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface FavoriteAuthorInfo : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *authorId;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *sign;

@end
