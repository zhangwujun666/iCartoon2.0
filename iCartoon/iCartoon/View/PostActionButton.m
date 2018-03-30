//
//  PostActionButton.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright (c) 2015年 GlenN. All rights reserved.
//

#import "PostActionButton.h"

@interface PostActionButton ()

@property (nonatomic, strong) NSString *imageName;
@property (strong, nonatomic) NSString *titleStr;
@property (assign, nonatomic) CGFloat titleWidth;

@end

@implementation PostActionButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        CGFloat fontSize = TRANS_VALUE(12.0f);
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
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
    if (title.length>4) {
        title = @"1万";
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
    CGFloat titleMarginLeft = (width - TRANS_VALUE(13.0f) - 1 * self.titleWidth) / 2 + TRANS_VALUE(13.0f) +TRANS_VALUE(3.0f);
//        CGFloat titleMarginLeft = (width - TRANS_VALUE(10.0f) - 1 * self.titleWidth - TRANS_VALUE(3.0f)) / 2+TRANS_VALUE(10.0f);
    CGFloat titleMarginTop = (height - TRANS_VALUE(20.0f)) / 2;
    CGFloat titleWidth = self.titleWidth;
    CGFloat titleHeight = TRANS_VALUE(20.0f);
    return CGRectMake(titleMarginLeft, titleMarginTop, titleWidth, titleHeight);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat imageMarginLeft = (width - TRANS_VALUE(10.0f) - 1 * self.titleWidth - TRANS_VALUE(3.0f)) / 2;
    CGFloat imageMarginTop = (height - TRANS_VALUE(10.0f)) / 2;
    CGFloat imageWidth = TRANS_VALUE(10.0f);
    CGFloat imageHeight = TRANS_VALUE(10.0f);
    return CGRectMake(imageMarginLeft, imageMarginTop, imageWidth, imageHeight);
}

@end
