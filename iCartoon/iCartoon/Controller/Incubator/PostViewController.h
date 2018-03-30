//
//  PostViewController.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeInfo.h"
#import "DraftPostInfo.h"

typedef NS_ENUM(NSInteger, PostSourceType) {
    PostSourceTypeTheme = 0,
    PostSourceTypeNew,
    PostSourceTypeDraft
};

@interface PostViewController : UIViewController
@property (assign, nonatomic) PostSourceType type;             //帖子来源类型
@property (strong, nonatomic) ThemeInfo *themeInfo;            //从主题发帖的默认选中主题
@property (strong, nonatomic) DraftPostInfo *draftInfo;        //草稿

@end

@interface PostImage : NSObject

@property (strong, nonatomic) NSString *image;

@end
