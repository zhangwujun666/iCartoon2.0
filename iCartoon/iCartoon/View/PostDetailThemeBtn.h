//
//  PostDetailThemeBtn.h
//  iCartoon
//
//  Created by glanway on 16/5/3.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostDetailThemeBtn : UIButton

- (instancetype)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) UIImageView *iconImageView;

- (void)setImage:(NSString *)imageName;
- (void)setTitle:(NSString *)title;

@end
