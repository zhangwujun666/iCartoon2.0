//
//  PostThemeButton.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright (c) 2015年 GlenN. All rights reserved.
//

#import "PostThemeButton.h"

@interface PostThemeButton ()

@property (nonatomic, strong) NSString *imageName;

@end

@implementation PostThemeButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        CGFloat fontSize = TRANS_VALUE(12.0f);
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return self;
}

//设置按钮图片
- (void)setImage:(NSString *)imageName {
    if(imageName == nil) {
        return;
    }
    self.imageName = imageName;
    UIImage *normalImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@", imageName]];
    UIImage *pressedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@", imageName]];
    [self setImage:normalImage forState:UIControlStateNormal];
    [self setImage:pressedImage forState:UIControlStateSelected];
    [self setImage:pressedImage forState:UIControlStateHighlighted];
}

//设置按钮标题
- (void)setTitle:(NSString *)title {
    if(title == nil) {
        title = @"";
    }
    if (title.length > 20) {
        
        NSString  * a = [title substringToIndex:20];
        
        title = [NSString  stringWithFormat:@"%@...",a];
    }

    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitle:title forState:UIControlStateHighlighted];
    
    UIColor *normalTitleColor = I_COLOR_GRAY;
    UIColor *pressedTitleColor = I_COLOR_GRAY;
    [self setTitleColor:normalTitleColor forState:UIControlStateNormal];
    [self setTitleColor:pressedTitleColor forState:UIControlStateSelected];
    [self setTitleColor:pressedTitleColor forState:UIControlStateHighlighted];
}

/**
 *button在5s上的标准是: 54 * 60
 **/
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat titleMarginLeft = TRANS_VALUE(16.0f);
    CGFloat titleMarginTop = (height - TRANS_VALUE(20.0f)) / 2;
    CGFloat titleWidth = width - TRANS_VALUE(30.0f);
    CGFloat titleHeight = TRANS_VALUE(20.0f);
    return CGRectMake(titleMarginLeft, titleMarginTop, titleWidth, titleHeight);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat height = self.frame.size.height;
    CGFloat imageMarginLeft = TRANS_VALUE(0.0f);
    CGFloat imageMarginTop = (height - TRANS_VALUE(10.0f)) / 2;
    CGFloat imageWidth = TRANS_VALUE(10.0f);
    CGFloat imageHeight = TRANS_VALUE(10.0f);
    return CGRectMake(imageMarginLeft, imageMarginTop, imageWidth, imageHeight);
}

@end
