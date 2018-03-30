//
//  ShareActionButton.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright (c) 2015年 GlenN. All rights reserved.
//

#import "ShareActionButton.h"

@interface ShareActionButton ()

@property (nonatomic, strong) NSString *imageName;

@end

@implementation ShareActionButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        CGFloat fontSize = CONVER_VALUE(14.0f);
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = UIColorFromRGB(0x828282);
    }
    return self;
}

//设置按钮图片
- (void)setImage:(NSString *)imageName {
    if(imageName == nil) {
        return;
    }
    self.imageName = imageName;
    UIImage *normalImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", imageName]];
    UIImage *pressedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", imageName]];
    [self setImage:normalImage forState:UIControlStateNormal];
    [self setImage:pressedImage forState:UIControlStateSelected];
    [self setImage:pressedImage forState:UIControlStateHighlighted];
}

//设置按钮标题
- (void)setTitle:(NSString *)title {
    if(title == nil) {
        title = @"";
    }
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitle:title forState:UIControlStateHighlighted];
    
    UIColor *normalTitleColor = [UIColor blackColor];
    UIColor *pressedTitleColor = [UIColor blackColor];
    [self setTitleColor:normalTitleColor forState:UIControlStateNormal];
    [self setTitleColor:pressedTitleColor forState:UIControlStateSelected];
    [self setTitleColor:pressedTitleColor forState:UIControlStateHighlighted];
}

/**
 *button在5s上的标准是: 54 * 60
 **/
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleMarginLeft = TRANS_VALUE(0.0f);
    CGFloat titleMarginTop = TRANS_VALUE(50.0f);
    CGFloat titleWidth = self.frame.size.width;
    CGFloat titleHeight = TRANS_VALUE(20.0f);
    return CGRectMake(titleMarginLeft, titleMarginTop, titleWidth, titleHeight);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageMarginLeft = (self.frame.size.width - TRANS_VALUE(44.0f)) / 2;
    CGFloat imageMarginTop = TRANS_VALUE(6.0f);
    CGFloat imageWidth = TRANS_VALUE(44.0f);
    CGFloat imageHeight = TRANS_VALUE(44.0f);
    return CGRectMake(imageMarginLeft, imageMarginTop, imageWidth, imageHeight);
}

@end
