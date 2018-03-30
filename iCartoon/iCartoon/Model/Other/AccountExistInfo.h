//
//  AccountExistInfo.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/11.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface AccountExistInfo : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *isExist;
@property (strong, nonatomic) NSString *isLogin;

@end
