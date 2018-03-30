//
//  HomeThemeButton.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright (c) 2015年 GlenN. All rights reserved.
//

#import "HomeThemeButton.h"

@interface HomeThemeButton ()

@property (nonatomic, strong) NSString *imageName;

@property (strong, nonatomic) UIImageView *bgImageView;

@end

@implementation HomeThemeButton

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
        CGFloat fontSize = TRANS_VALUE(12.0f);
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        CGFloat imageMarginLeft = (frame.size.width - TRANS_VALUE(66.0f)) / 2;
        CGFloat imageMarginTop = TRANS_VALUE(12.0f);
        CGFloat imageWidth = TRANS_VALUE(66.0f);
        CGFloat imageHeight = TRANS_VALUE(66.0f);
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageMarginLeft, imageMarginTop, imageWidth, imageHeight)];
        self.bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.bgImageView];
        self.bgImageView.image = [UIImage imageNamed:@"bg_theme_icon_unselected"];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageMarginLeft + 1.0f, imageMarginTop + 1.0f, imageWidth - 3.0f, imageHeight - 2.0f)];
        self.iconImageView.clipsToBounds = YES;
        self.iconImageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.iconImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.iconImageView];
        
    }
//    self.imageView.clipsToBounds = YES;
//    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
//    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.imageView.backgroundColor = [UIColor clearColor];
//    self.imageView.layer.borderColor = I_DIVIDER_COLOR.CGColor;
//    self.imageView.layer.borderWidth = 1.0f;
//    self.imageView.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
//    self.imageView.layer.shadowColor = I_COLOR_GRAY.CGColor;
//    self.imageView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
//    self.imageView.layer.shadowRadius = 4.0f;//阴影半径，默认3
    self.imageView.hidden = YES;
    
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
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitle:title forState:UIControlStateHighlighted];
    
    UIColor *normalTitleColor = [UIColor blackColor];
    UIColor *pressedTitleColor = [UIColor grayColor];
    [self setTitleColor:normalTitleColor forState:UIControlStateNormal];
    [self setTitleColor:pressedTitleColor forState:UIControlStateSelected];
    [self setTitleColor:pressedTitleColor forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected {
    if(selected) {
        self.bgImageView.image = [UIImage imageNamed:@"bg_theme_icon_unselected"];
    } else {
        self.bgImageView.image = [UIImage imageNamed:@"bg_theme_icon_unselected"];
    }
    [super setSelected:selected];
}

/**
 *button在5s上的标准是: 54 * 60
 **/
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat width = self.frame.size.width;
    CGFloat titleMarginLeft = (width - TRANS_VALUE(100.0f)) / 2;
    CGFloat titleMarginTop = TRANS_VALUE(80.0f);
    CGFloat titleWidth = TRANS_VALUE(100.0f);
    CGFloat titleHeight = TRANS_VALUE(22.0f);
    return CGRectMake(titleMarginLeft, titleMarginTop, titleWidth, titleHeight);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat width = self.frame.size.width;
    CGFloat imageMarginLeft = (width - TRANS_VALUE(66.0f)) / 2;
    CGFloat imageMarginTop = TRANS_VALUE(12.0f);
    CGFloat imageWidth = TRANS_VALUE(66.0f);
    CGFloat imageHeight = TRANS_VALUE(66.0f);
    return CGRectMake(imageMarginLeft, imageMarginTop, imageWidth, imageHeight);
}

@end
