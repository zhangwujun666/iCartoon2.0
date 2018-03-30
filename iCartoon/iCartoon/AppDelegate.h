//
//  AppDelegate.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;

+ (id)sharedDelegate;

- (void)showMainViewController;
- (void)showMainViewControllerWithoutLogin;
- (void)showLoginViewController1:(BOOL)relogin;
- (void)showLoginViewController:(BOOL)relogin;
- (void)showLoginViewController:(BOOL)relogin index :(int)index;

@end

