//
//  UserRelativeInfo.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/13.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface UserRelativeInfo : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *messageCount;
@property (strong, nonatomic) NSString *commentCount;
@property (strong, nonatomic) NSString *collectionCount;

@end
