//
//  LoginResultInfo.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/11.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface LoginResultInfo : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *avatar;
@property (assign,nonatomic)int isfreeze;
@property (strong,nonatomic)NSString * thaw_date;
@property (strong,nonatomic)NSString * thaw_time;

@end
