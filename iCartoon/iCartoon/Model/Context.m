//
//  Context.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/12.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "Context.h"
#import "UserInfoDao.h"
#import "AccountInfoDao.h"
#import "LoginResultInfoDao.h"

@interface Context()

@end

@implementation Context

+ (instancetype)sharedInstance {
    static Context *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [self initContext];
    }
    return self;
}

- (void)initContext {
    _token = nil;
    _uid = nil;
    _username = nil;
    _password = nil;
    _userInfo = nil;
}

- (void)setLoginInfo:(LoginResultInfo *)loginInfo {
    _loginInfo = loginInfo;
    if(_loginInfo) {
        if(_loginInfo.uid) {
            _uid = _loginInfo.uid;
        } else {
            _uid = nil;
        }
        
        if(_loginInfo.token) {
            _token = _loginInfo.token;
        } else {
            _token = nil;
        }
    } else {
        _uid = nil;
        _token = nil;
    }
}

- (void)setUserInfo:(UserInfo *)userInfo {
    _userInfo = userInfo;
}

- (void)setBirthday:(NSString *)birthday {
    _birthday = birthday;
    if(![_birthday isEqualToString:@""]) {
        NSInteger month = [[_birthday substringWithRange:NSMakeRange(5, 2)] integerValue];
        NSInteger day = [[_birthday substringWithRange:NSMakeRange(8, 2)] integerValue];
        _constellation = [self calculateConstellationWithMonth:month day:day];
        
        
        
        
        
        
        
    }
}

#pragma mark - Public Method
- (void)userLogin {
    
}

- (void)userLogout {
    self.loginInfo = nil;
    self.userInfo = nil;
    self.token = nil;
    [[LoginResultInfoDao sharedInstance] deleteLoginResultInfo];
    [[UserInfoDao sharedInstance] deleteUserInfo];
    [[AccountInfoDao sharedInstance] deleteAccountInfo];
}

- (BOOL)isLogined {
    return (!self.uid || !self.token) ? NO : YES;
}

- (void)tokenExpired {
    self.loginInfo = nil;
    self.userInfo = nil;
    self.token = nil;
    [[UserInfoDao sharedInstance] deleteUserInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotificationRefreshHomeTask" object:nil];
}


#pragma mark - Private Method
/**
 *  根据生日计算星座
 *
 *  @param month 月份
 *  @param day   日期
 *
 *  @return 星座名称
 */
- (NSString *)calculateConstellationWithMonth:(NSInteger)month day:(NSInteger)day {
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    if(month < 1 || month > 12 || day < 1 || day > 31) {
        return @"错误日期格式!";
    }
    
    if(month == 2 && day>29){
        return @"错误日期格式!!";
    } else if(month == 4 || month == 6 || month == 9 || month == 11) {
        if(day > 30) {
            return @"错误日期格式!!!";
        }
    }

    result = [NSString stringWithFormat:@"%@", [astroString substringWithRange:NSMakeRange(month * 2 - (day < [[astroFormat substringWithRange:NSMakeRange((month - 1), 1)] intValue] - (-19)) * 2, 2)]];
    
    return [NSString stringWithFormat:@"%@座",result];
}

@end
