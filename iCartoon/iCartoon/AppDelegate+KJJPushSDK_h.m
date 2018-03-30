//
//  AppDelegate+KJJPushSDK_h.m
//  iCartoon
//
//  Created by wangzheng on 16/8/4.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "AppDelegate+KJJPushSDK_h.h"
#import "KJJPushHelper.h"
#import "UserAPIRequest.h"
#import "SVProgressHUD.h"
#import "Context.h"
//客户2eae811c68728b7d6dc2c3af
//测试087e3886db669a4cdc3bb406
#define JPushSDK_AppKey  @"2eae811c68728b7d6dc2c3af"
#define isProduction    YES

static NSString * _from;
@implementation AppDelegate (KJJPushSDK_h)
-(void)JPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
  
    [KJJPushHelper setupWithOption:launchOptions appKey:JPushSDK_AppKey channel:nil apsForProduction:isProduction advertisingIdentifier:nil];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required - 注册 DeviceToken
    [KJJPushHelper registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [KJJPushHelper handleRemoteNotification:userInfo completion:nil];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    _from = userInfo[@"from"];
    // IOS 7 Support Required
    [KJJPushHelper handleRemoteNotification:userInfo completion:completionHandler];
//   NSLog(@"userInfo ========== %@",userInfo);
//    if (application.applicationState == UIApplicationStateActive) {
        if ([userInfo[@"from"] isEqualToString:@"exception_login"]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message:userInfo[@"aps"][@"alert"]
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"确定",nil];
            [alert show];
        }
 if (application.applicationState == UIApplicationStateActive) {
    if ([userInfo[@"from"] isEqualToString:@"account_freeze"]) {
        if ([userInfo[@"aps"][@"alert"] isEqualToString:@"账号被解冻啦o(*￣▽￣*)ゞ 下次不要再犯错咯！"]) {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"isfreeze"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"isshow"];
             [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"thaw_time"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1"forKey:@"isshowfree"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message:@"账号被解冻啦o(*￣▽￣*)ゞ 下次不要再犯错咯！"
                                  delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"确定",nil];
            [alert show];

        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isfreeze"];
             [self loadUserInfo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message:@"o(≧口≦)o已被萌热娘关进小黑屋，时间到了再放你出来！"
                                  delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"确定",nil];
            [alert show];

        }
    }
 }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSDictionary *params = @{};
    [[UserAPIRequest sharedInstance] userLogout:params success:^(CommonInfo *resultInfo) {
        [SVProgressHUD dismiss];
        if(resultInfo && [resultInfo isSuccess]) {
            //TODO -- 退出登录, 清除用户信息
            _from = nil;
            [[Context sharedInstance] userLogout];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshHomeTasks object:nil];
            
        } else {
           
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
    

    [[AppDelegate sharedDelegate] showLoginViewController:YES];

}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [KJJPushHelper showLocalNotificationAtFront:notification];
    return;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [self loadUserInfo];
    return;
}
- (void)loadUserInfo {
    NSDictionary *params = @{};
    if(![Context sharedInstance].token) {
        [Context sharedInstance].userInfo = nil;
        return;
    }
    [[UserAPIRequest sharedInstance] getUserInfo:params success:^(UserInfo *userInfo) {
        [SVProgressHUD dismiss];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr =  [dateFormatter stringFromDate:[NSDate date]];
        //date1当前时间
        NSDate *date1=[dateFormatter dateFromString:dateStr];
        //date2解冻时间
        NSDate *date2=[dateFormatter dateFromString:userInfo.thaw_date];
//
        int time= (int)[date1 timeIntervalSinceDate:date2];
//        NSLog(@"time ============= %d",(int)time);
//         NSLog(@"userInfo1 ======== %d\n=========%@",-(int)time,userInfo.thaw_time);
//         NSLog(@"userInfo ============= %@",userInfo);
        
        if (userInfo.isfreeze == 1 && time < 0) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isfreeze"];
             [[NSUserDefaults standardUserDefaults] setObject:userInfo.thaw_time forKey:@"thaw_time"];
            [[NSUserDefaults standardUserDefaults] synchronize];
           
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"isfreeze"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"isshow"];
             [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"thaw_time"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isshowfree"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [Context sharedInstance].userInfo = nil;
    }];
}

@end
