//
//  AppDelegate.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright © 2015年 wonders. All rights reserved.
//
#import "AppDelegate+KJJPushSDK_h.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MyTabBarController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "ThemeListViewController.h"
#import "EAIntroView.h"
#import "Context.h"
#import "ICartoonDBHelper.h"
#import "UserInfoDao.h"
#import "UserInfo.h"
#import "LoginResultInfo.h"
#import "LoginResultInfoDao.h"
#import "AttentionView.h"
#import "HomeViewController.h"
#import "TalkingData.h"

#import "UMMobClick/MobClick.h"

#import "JPUSHService.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDK/ShareSDK.h>
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
@interface AppDelegate () <EAIntroDelegate> {
    EAIntroView *intro;
}

@property (strong, nonatomic) UINavigationController *loginNavigationController;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) MyTabBarController *myTabBarController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    application.applicationIconBadgeNumber = 0;
    // Override point for customization after application launch.
    [self JPushApplication:application didFinishLaunchingWithOptions:launchOptions];
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = @"57480cc467e58e85d3002bb7";
    UMConfigInstance.channelId =  @"";
    [MobClick startWithConfigure:UMConfigInstance];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
                                          green:173.0/255.0
                                           blue:234.0/255.0
                                          alpha:1.0];
    [self.window setTintColor:tintColor];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //注册shareSDK
    [self registerShareSDK];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UINavigationBar appearance] setBarTintColor:I_COLOR_YELLOW];
    [[UINavigationBar appearance] setBackgroundColor:I_COLOR_YELLOW];
    [[UINavigationBar appearance] setTintColor:I_COLOR_YELLOW];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:I_COLOR_WHITE];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:I_COLOR_WHITE forKey:NSForegroundColorAttributeName]];
    //初始化数据库;
    [self initDataBase];
    
    [self showRootViewController];
    
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//禁止横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

//数据库
-(void)initDataBase {
    ICartoonDBHelper *dbhelper = [[ICartoonDBHelper alloc] init];
    [dbhelper initDatabase];
    LoginResultInfo *loginResultInfo = (LoginResultInfo *)[[LoginResultInfoDao sharedInstance] getLoginResultInfo];
    [Context sharedInstance].loginInfo = loginResultInfo;
    UserInfo *userInfo = (UserInfo *)[[UserInfoDao sharedInstance] getUserInfo];
    [Context sharedInstance].userInfo = userInfo;
}

#pragma mark - Private Method
+ (id)sharedDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (void)showRootViewController {
    NSString *key = (NSString *)kCFBundleVersionKey;
    // 1.从Info.plist中取出版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    // 2.从沙盒中取出上次存储的版本号
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if ([version isEqualToString:saveVersion]) { // 不是第一次使用这个版本
        // 显示状态栏
        [self  showMainViewController];
    } else { // 版本号不一样：第一次使用新版本
        //将新版本号写入沙盒
        self.window.rootViewController = [[UIViewController alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //显示版本新特性界面
        [self createGuideView];
    }
}

- (void)showMainViewController {
    if(!self.myTabBarController) {
        self.myTabBarController = [[MyTabBarController alloc] init];
    }
    self.myTabBarController.selectedIndex = 0;
    self.window.rootViewController = self.myTabBarController;
    
    BOOL hasLogin = [[Context sharedInstance] isLogined];
    if(!hasLogin) {
        self.loginViewController = [[LoginViewController alloc] init];
        self.loginNavigationController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
        //TODO
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTabBarController presentViewController:self.loginNavigationController animated:YES completion:^{
                
            }];
        });
    }
}

- (void)showMainViewControllerWithoutLogin {
    if(!self.myTabBarController) {
        self.myTabBarController = [[MyTabBarController alloc] init];
    }
    self.myTabBarController.selectedIndex = 0;
    self.window.rootViewController = self.myTabBarController;
    if(self.loginNavigationController) {
        [self.loginNavigationController dismissViewControllerAnimated:NO completion:^{
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];

        }];
    }
    
}

- (void)delayMethod{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowAttention object:nil];
}
- (void)showLoginViewController1:(BOOL)relogin {
//    if(relogin) {
//        self.myTabBarController.selectedIndex = 0;
//    }
    if(!self.loginNavigationController) {
        self.loginViewController = [[LoginViewController alloc] init];
        self.loginNavigationController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
    }
    //TODO
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myTabBarController presentViewController:self.loginNavigationController animated:YES completion:^{
            
        }];
    });
}
- (void)showLoginViewController:(BOOL)relogin {
    if(relogin) {
        self.myTabBarController.selectedIndex = 0;
    }
    if(!self.loginNavigationController) {
        self.loginViewController = [[LoginViewController alloc] init];
        self.loginNavigationController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
    }
    //TODO
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myTabBarController presentViewController:self.loginNavigationController animated:YES completion:^{
            
        }];
    });
}
- (void)showLoginViewController:(BOOL)relogin index :(int)index{
    if(relogin) {
        self.myTabBarController.selectedIndex = index;
    }
    if(!self.loginNavigationController) {
        self.loginViewController = [[LoginViewController alloc] init];
        self.loginNavigationController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
    }
    //TODO
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myTabBarController presentViewController:self.loginNavigationController animated:YES completion:^{
            
        }];
    });

}
#pragma mark - ShareSDK注册
- (void)registerShareSDK {
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"161c165ab7854"
          activePlatforms:@[@(SSDKPlatformTypeCopy),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformTypeSinaWeibo)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
                 //初始化的import参数注意要链接原生QQSDK。
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2361981244"
                                           appSecret:@"4ede630d7c64787b4ad85cdbf1b05277"
                                         redirectUri:@"http://www.weibo.com"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxb49e5aa4f5e099cf"
                                       appSecret:@"049161324403e4f01c56e894e80c27cf"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105271077"
                                      appKey:@"DH0egF3LYFTElWqs"
                                    authType:SSDKAuthTypeBoth];
                 break;
                default:
                 break;
         }
     }];
}
#pragma makr 首页进入引导页面
- (void)createGuideView {
//    EAIntroPage *page1 = [EAIntroPage page];
//    page1.bgImage = [UIImage imageNamed:@"bg_guide_01"];
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"bg_guide_02"];
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"bg_guide_03"];
    EAIntroPage *page4 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:@"bg_guide_04"];
    
    intro = [[EAIntroView alloc] initWithFrame:self.window.bounds andPages:@[page2,page3, page4]];
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect nextRect = CGRectZero;
    CGRect skipRect = CGRectZero;
    if(SCREEN_WIDTH == 320 && SCREEN_HEIGHT == 480) {
        nextRect = CGRectMake(15, 360, SCREEN_WIDTH - 30, 40);
        skipRect = CGRectMake(15, 410, SCREEN_WIDTH - 30, 40);
    } else if(SCREEN_WIDTH == 320 && SCREEN_HEIGHT == 568) {
        nextRect = CGRectMake(15, 430, SCREEN_WIDTH - 30, 40);
        skipRect = CGRectMake(15, 480, SCREEN_WIDTH - 30, 40);
    } else if(SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 667) {
        nextRect = CGRectMake(15, 495, SCREEN_WIDTH - 30, 50);
        skipRect = CGRectMake(15, 555, SCREEN_WIDTH - 30, 50);
    } else {
        nextRect = CGRectMake(15, 540, SCREEN_WIDTH - 30, 60);
        skipRect = CGRectMake(15, 610, SCREEN_WIDTH - 30, 60);
    }
    [nextButton setFrame:nextRect];
    [nextButton setTitleColor:I_COLOR_WHITE forState:UIControlStateNormal];
    [nextButton setTitleColor:I_COLOR_WHITE forState:UIControlStateHighlighted];
    [nextButton setTitleColor:I_COLOR_WHITE forState:UIControlStateSelected];
    [nextButton setBackgroundColor:[UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:0.5f]];
    [nextButton setTitle:@"加入萌热" forState:UIControlStateNormal];
    [nextButton setTitle:@"加入萌热" forState:UIControlStateHighlighted];
    [nextButton setTitle:@"加入萌热" forState:UIControlStateSelected];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(18.0f)];
    nextButton.clipsToBounds = YES;
    nextButton.layer.borderColor = I_COLOR_WHITE.CGColor;
    nextButton.layer.borderWidth = 1.0f;
    nextButton.layer.cornerRadius = nextRect.size.height / 2;
    intro.nextButton = nextButton;
    intro.nextButton.hidden = YES;
    
    [skipButton setFrame:skipRect];
    [skipButton setBackgroundColor:[UIColor clearColor]];
    [skipButton setTitleColor:I_COLOR_WHITE forState:UIControlStateNormal];
    [skipButton setTitleColor:I_COLOR_WHITE forState:UIControlStateHighlighted];
    [skipButton setTitleColor:I_COLOR_WHITE forState:UIControlStateSelected];
    skipButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
    [skipButton setTitle:@"我想先看看" forState:UIControlStateNormal];
    [skipButton setTitle:@"我想先看看" forState:UIControlStateHighlighted];
    [skipButton setTitle:@"我想先看看" forState:UIControlStateNormal];
    intro.skipButton = skipButton;
    intro.skipButton.hidden = YES;
    CGFloat width = (SCREEN_WIDTH - 30.0f - TRANS_VALUE(90.0f)) / 2 ;
    UIView *divider01 = [[UIView alloc] initWithFrame:CGRectMake(0, floor(skipRect.size.height / 2), width, 1.0f)];
    divider01.backgroundColor = [UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:0.6f];
    [skipButton addSubview:divider01];
    
    UIView *divider02 = [[UIView alloc] initWithFrame:CGRectMake(skipRect.size.width - width, floor(skipRect.size.height / 2), width, 1.0f)];
    divider02.backgroundColor = [UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:0.6f];
    [skipButton addSubview:divider02];
    
    [intro setDelegate:self];
    [intro showInView:self.window.rootViewController.view animateDuration:0.0f];
}

#pragma mark 引导页EAIntroDelegate
//注册登录后再跳转
- (void)introDidFinish {
    [intro hideWithFadeOutDuration:0.5];
    [self showMainViewController];
}

//不登录直接跳过去
- (void)introDidSkip {
    [intro hideWithFadeOutDuration:0.5];
    [self showMainViewControllerWithoutLogin];
}


@end
