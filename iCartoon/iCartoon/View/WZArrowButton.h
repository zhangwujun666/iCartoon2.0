//
//  WZArrowButton.h
//  iCartoon
//
//  Created by wangzheng on 16/5/20.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZArrowButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) UIImageView *iconImageView;

- (void)setImage:(NSString *)imageName;
- (void)setTitle:(NSString *)title;
@end
