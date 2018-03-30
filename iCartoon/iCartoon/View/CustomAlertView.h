//
//  CustomAlertView.h
//  iCartoon
//
//  Created by 许成雄 on 16/4/21.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CustomAlertView;
@protocol CustomAlertViewDelegate <NSObject>

@optional
- (void)confirmButtonClick;
- (void)cancelButtonClick;

@end

@interface CustomAlertView : NSObject

+ (void)showWithTitle:(NSString *)titleStr delegate:(id<CustomAlertViewDelegate>)delegate;


@end
