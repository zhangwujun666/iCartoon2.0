//
//  WZArrowButton.m
//  iCartoon
//
//  Created by wangzheng on 16/5/20.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "WZArrowButton.h"

@interface WZArrowButton()
@property (nonatomic, strong) NSString *imageName;
@property (strong, nonatomic) NSString *titleStr;
@property (assign, nonatomic) CGFloat titleWidth;
@end

@implementation WZArrowButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      // self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //self.imageView.backgroundColor = [UIColor redColor];
        self.titleLabel.backgroundColor=  [UIColor clearColor];
    }
    return self;
}
- (void)setImage:(NSString *)imageName {
    if(imageName == nil) {
        return;
    }
    self.imageName = imageName;
    UIImage *normalImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@", imageName]];
    UIImage *pressedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@", imageName]];
    [self setImage:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [self setImage:[pressedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [self setImage:[pressedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
}

//设置按钮标题
- (void)setTitle:(NSString *)title {
    if(title == nil) {
        title = @"";
    }
    self.titleStr = title;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:TRANS_VALUE(12.0f)],NSFontAttributeName, nil];
    CGRect rect = [self.titleStr boundingRectWithSize:CGSizeMake(MAXFLOAT, TRANS_VALUE(20.0f)) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    CGFloat titleWidth = floor(rect.size.width + 2);
    self.titleWidth = titleWidth;
    [self setTitle:self.titleStr forState:UIControlStateNormal];
    [self setTitle:self.titleStr forState:UIControlStateSelected];
    [self setTitle:self.titleStr forState:UIControlStateHighlighted];
    
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
    CGFloat titleMarginLeft = TRANS_VALUE(28.0f);
    CGFloat titleMarginTop = (height - TRANS_VALUE(20.0f)) / 2;
    CGFloat titleWidth = 1.5 * self.titleWidth;
    CGFloat titleHeight = TRANS_VALUE(20.0f);
    return CGRectMake(titleMarginLeft, titleMarginTop, titleWidth, titleHeight);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat height = self.frame.size.height;
    CGFloat imageMarginLeft = self.titleLabel.frame.size.width+TRANS_VALUE(3.0f);
    CGFloat imageMarginTop = (height - TRANS_VALUE(13.0f)) / 2;
    CGFloat imageWidth = TRANS_VALUE(7.0f);
    CGFloat imageHeight = TRANS_VALUE(13.0f);
    return CGRectMake(imageMarginLeft, imageMarginTop, imageWidth, imageHeight);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
