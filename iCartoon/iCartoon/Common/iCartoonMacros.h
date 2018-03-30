//
//  iCartoonMacros.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright © 2015年 wonders. All rights reserved.
//

#ifndef iCartoonMacros_h
#define iCartoonMacros_h

#define iCartoonErrorDomain @"mobi.w3studio.apps.ios.iCartoon"

#define kPaddingWidth 10.0

#define kTopAndStatusBarHeight 64.0f

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//根据屏幕转化的对应值
#define TRANS_VALUE(x) ceil(SCREEN_WIDTH * x / 320)

#define CONVER_VALUE(x) ceil(SCREEN_WIDTH * x / 375)

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//中文字体：微软雅黑
//英文、数字：arial
//黑色文字：#2C3031
//灰色文字：#AEAEAE
//绿色文字：#12BE4F
//页面背景颜色：#F5F5F5
//分割线、边框线：#CBCBCB

//#define I_COLOR_YELLOW    RGBACOLOR(237, 131, 47, 1.0f)      //黄色
//#define I_COLOR_YELLOW    UIColorFromRGB(0xEE822F)      //黄色
#define I_COLOR_YELLOW    UIColorFromRGB(0xf0821e)
#define I_COLOR_WHITE     RGBACOLOR(255, 255, 255, 1.0f)     //白色
#define I_COLOR_BLACK     RGBACOLOR(20, 20, 20, 1.0f)        //黑色
#define I_COLOR_EDITTEXT  UIColorFromRGB(0xf4f8f9)            //浅黑色
#define I_COLOR_33BLACK  UIColorFromRGB(0x333333)            //浅黑色
#define I_COLOR_DARKGRAY  UIColorFromRGB(0x858585)           //深灰色
#define I_COLOR_GRAY      UIColorFromRGB(0x999999)           //灰色
#define I_COLOR_DARKGREEN RGBACOLOR(134, 203, 201, 1.0f)     //青绿色
#define I_BACKGROUND_COLOR  RGBACOLOR(240, 240, 240, 1.0f)   //背景颜色
#define I_DIVIDER_COLOR  RGBACOLOR(231, 231, 231, 1.0f)      //分割条颜色
#define I_TAB_BACKGROUND_COLOR  RGBACOLOR(240, 240, 240, 1.0f) //灰白色

//#define IH_COLOR_GREEN    UIColorFromRGB(0x12BE4F)           //绿色
#define IH_COLOR_ORANGE   RGBACOLOR(252, 102, 34, 1.0f)      //橙色
#define TEXT_COLOR_BLACK  UIColorFromRGB(0xF8B62C)           //黑色文字
#define TEXT_COLOR_GRAY   UIColorFromRGB(0xAEAEAE)           //灰色文字
#define TEXT_COLOR_GREEN  UIColorFromRGB(0x12BE4F)           //绿色文字
#define BACKGROUND_COLOR  UIColorFromRGB(0xFFFFFF)           //页面背景颜色
#define DIVIDER_COLOR     UIColorFromRGB(0xCBCBCB)           //分割线颜色
#define BORDER_COLOR      UIColorFromRGB(0xCBCBCB)           //边框线颜色


#define ACTION_TYPE_REFRESH       @"refresh"
#define ACTION_TYPE_LOAD_MORE          @"loadMore"

//通知相关的宏定义
#define kNotificationRefreshHomeTasks  @"kNotificationRefreshHomeTasks"
#define kNotificationRefreshPosts  @"kNotificationRefreshPosts"
#define kNotificationRefreshPostItem  @"kNotificationRefreshPostItem"
#define kNotificationRefreshComments  @"kNotificationRefreshComments"
#define kNotificationRefreshDrafts    @"kNotificationRefreshDrafts"
#define kNotificationRefreshTaskComments  @"kNotificationRefreshTaskComments"
#define kNotificationRefreshTaskDrafts    @"kNotificationRefreshTaskDrafts"
#define kNotificationRefreshTaskContribute    @"kNotificationRefreshTaskContribute"
#define kNotificationUserLogout @"kNotificationUserLogout"

#define kNotificationShowAttention    @"kNotificationShowAttention"

#endif /* iCartoonMacros_h */
