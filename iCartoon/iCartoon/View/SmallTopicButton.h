//
//  SmallTopicButton.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright (c) 2015年 GlenN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmallTopicButton : UIButton

@property (strong, nonatomic) UIImageView *iconImageView;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setImage:(NSString *)imageName;
- (void)setTitle:(NSString *)title;
- (void)setSelected:(BOOL)selected;

@end