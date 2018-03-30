//
//  AuthorInfo.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/16.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface AuthorInfo : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *avatar;

@end
