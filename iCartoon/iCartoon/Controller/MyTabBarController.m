//
//  MyTabBarController.m
//  iCartoon
//
//  Created by 寻梦者 on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "MyTabBarController.h"
#import "HomeViewController.h"
#import "ShopViewController.h"
#import "IncubatorViewController.h"
#import "MeViewController.h"
#import "LoginViewController.h"

#import "Context.h"

@interface MyTabBarController () <UITabBarControllerDelegate, UIAlertViewDelegate>

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.tabBar setTintColor:I_COLOR_YELLOW];
    self.tabBar.alpha = 1;
    [self.tabBar setBackgroundColor:[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]];
    [self.tabBar setBarTintColor:[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]];
    [self.tabBar setSelectedImageTintColor:I_COLOR_YELLOW];
    
    HomeViewController *everydayViewController = [[HomeViewController alloc] init];
    UINavigationController *everydayNavi = [[UINavigationController alloc] initWithRootViewController:everydayViewController];
    everydayNavi.title = @"日常屋";
    UIImage *image1Off = [UIImage imageNamed:@"ic_tabbar_home_off"];
    UIImage *image1On = [UIImage imageNamed:@"ic_tabbar_home_on"];
    everydayNavi.tabBarItem.image = [image1Off imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    everydayNavi.tabBarItem.selectedImage = [image1On imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    everydayNavi.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    IncubatorViewController *incubatorViewController = [[IncubatorViewController alloc] init];
    UINavigationController *incubatorNavi = [[UINavigationController alloc] initWithRootViewController:incubatorViewController];
    incubatorNavi.title = @"孵化箱";
    UIImage *image2Off = [UIImage imageNamed:@"ic_tabbar_incubator_off"];
    UIImage *image2On = [UIImage imageNamed:@"ic_tabbar_incubator_on"];
    incubatorNavi.tabBarItem.image = [image2Off imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    incubatorNavi.tabBarItem.selectedImage = [image2On imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    incubatorNavi.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    ShopViewController *shopViewController = [[ShopViewController alloc] init];
    UINavigationController *shopNavi = [[UINavigationController alloc] initWithRootViewController:shopViewController];
    shopNavi.title = @"聚叶城";
    UIImage *image3Off = [UIImage imageNamed:@"ic_tabbar_shop_off"];
    UIImage *image3On = [UIImage imageNamed:@"ic_tabbar_shop_on"];
    shopNavi.tabBarItem.image = [image3Off imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    shopNavi.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    shopNavi.tabBarItem.selectedImage = [image3On imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    MeViewController *meViewController = [[MeViewController alloc] init];
    UINavigationController *meNavi = [[UINavigationController alloc] initWithRootViewController:meViewController];
    meNavi.title = @"我的窝";
    UIImage *image4Off = [UIImage imageNamed:@"ic_tabbar_me_off"];
    UIImage *image4On = [UIImage imageNamed:@"ic_tabbar_me_on"];
    meNavi.tabBarItem.image = [image4Off imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    meNavi.tabBarItem.selectedImage = [image4On imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    meNavi.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11.0f], NSFontAttributeName,nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor grayColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = I_COLOR_YELLOW;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    self.viewControllers = [NSArray arrayWithObjects:everydayNavi, incubatorNavi, shopNavi, meNavi, nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITabBarControllerDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSString *title = item.title;
    if([title isEqualToString:@"关注"]) {
        if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您登录后才能看到关注信息, 请先登录!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        //TODO -- 用户登录
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:navigationController animated:YES completion:^{
            
        }];
    }
}

@end
