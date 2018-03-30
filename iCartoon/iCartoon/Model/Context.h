//
//  Context.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/12.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "LoginResultInfo.h"
#import "ThemeInfo.h"

@interface Context : NSObject

+ (instancetype)sharedInstance;

@property (strong, nonatomic) LoginResultInfo *loginInfo;

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *uid;

@property (strong, nonatomic) UserInfo *userInfo;

//暂存信息
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *signature;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *constellation;      //星座

@property (strong, nonatomic) ThemeInfo *selectThemeInfo;   //选择的主题

@property (assign,nonatomic)int isfreeze;
@property (strong,nonatomic)NSString * thaw_date;
@property (strong,nonatomic)NSString * thaw_time;


- (void)tokenExpired;
- (BOOL)isLogined;
- (void)userLogin;
- (void)userLogout;



@end
