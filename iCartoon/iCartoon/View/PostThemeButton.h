//
//  PostThemeButton.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright (c) 2015年 GlenN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostThemeButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) UIImageView *iconImageView;

- (void)setImage:(NSString *)imageName;
- (void)setTitle:(NSString *)title;

@end
