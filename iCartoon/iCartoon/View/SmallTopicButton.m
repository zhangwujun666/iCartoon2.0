//
//  SmallTopicButton.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright (c) 2015年 GlenN. All rights reserved.
//

#import "SmallTopicButton.h"

@interface SmallTopicButton ()

@property (strong, nonatomic) UIView *bgImageView;

@property (nonatomic, strong) NSString *imageName;

@end

@implementation SmallTopicButton

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
        CGFloat fontSize = TRANS_VALUE(9.0f);
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        CGFloat width = self.frame.size.width;
        CGFloat imageMarginLeft = (width - TRANS_VALUE(50.0f)) / 2;
        CGFloat imageMarginTop = TRANS_VALUE(5.0f);
        CGFloat imageWidth = TRANS_VALUE(50.0f);
        CGFloat imageHeight = TRANS_VALUE(50.0f);
        CGRect rect = CGRectMake(imageMarginLeft, imageMarginTop, imageWidth, imageHeight);
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        CALayer *layer = [self.iconImageView layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:self.imageView.frame.size.width / 2];
        [layer setBorderWidth:0.5f];
        [layer setBorderColor:UIColorFromRGB(0xc0c0c0).CGColor];
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.iconImageView.backgroundColor = [UIColor clearColor];
        
        self.bgImageView = [[UIView alloc] initWithFrame:rect];
        self.bgImageView.layer.shadowColor = UIColorFromRGB(0xc0c0c0).CGColor;
        self.bgImageView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        self.bgImageView.layer.shadowOpacity = 1;
        self.bgImageView.layer.shadowRadius = 1.0f;
        self.bgImageView.clipsToBounds = NO;
        
        [self.bgImageView addSubview:self.iconImageView];
        
        [self addSubview:self.bgImageView];
    }
    self.bgImageView.userInteractionEnabled = NO;
    
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.layer.borderColor = I_DIVIDER_COLOR.CGColor;
    self.imageView.layer.borderWidth = 1.0f;
    self.imageView.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
    self.imageView.layer.shadowColor = I_COLOR_GRAY.CGColor;
    self.imageView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    self.imageView.layer.shadowRadius = 4.0f;//阴影半径，默认3
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
//    if (title.length<=7) {
//    
//    }else{
//        NSString *str=[title substringFromIndex:7];
//        NSString *str1=[title substringToIndex:7];
//        if (str1.length>7) {
//            str1=[str1 substringFromIndex:7];
//            NSMutableString *newStr=[NSMutableString stringWithFormat:@"%@\n%@...",str,str1];
//            title =newStr;
//        }
//        title =[NSString stringWithFormat:@"%@\n%@",str,str1];
//    }
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitle:title forState:UIControlStateHighlighted];
    
    UIColor *normalTitleColor = I_COLOR_33BLACK;
    UIColor *pressedTitleColor = I_COLOR_YELLOW;
    [self setTitleColor:normalTitleColor forState:UIControlStateNormal];
    [self setTitleColor:pressedTitleColor forState:UIControlStateSelected];
    [self setTitleColor:pressedTitleColor forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected {
    if(selected) {
        self.iconImageView.layer.borderColor = I_COLOR_YELLOW.CGColor;
        self.bgImageView.layer.shadowColor = RGBACOLOR(237, 131, 47, 0.5f).CGColor;
    } else {
        self.iconImageView.layer.borderColor = UIColorFromRGB(0xc0c0c0).CGColor;
        self.bgImageView.layer.shadowColor = UIColorFromRGB(0xc0c0c0).CGColor;
    }
    [super setSelected:selected];
}

/**
 *button在5s上的标准是: 54 * 60
 **/
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat width = self.frame.size.width;
    CGFloat titleMarginLeft = (width - TRANS_VALUE(72.0f)) / 2;
    CGFloat titleMarginTop = TRANS_VALUE(62.0f);
    CGFloat titleWidth = TRANS_VALUE(75.0f);
    CGFloat titleHeight = TRANS_VALUE(22.0f);
    return CGRectMake(titleMarginLeft, titleMarginTop, titleWidth, titleHeight);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat width = self.frame.size.width;
    CGFloat imageMarginLeft = (width - TRANS_VALUE(50.0f)) / 2;
    CGFloat imageMarginTop = TRANS_VALUE(12.0f);
    CGFloat imageWidth = TRANS_VALUE(50.0f);
    CGFloat imageHeight = TRANS_VALUE(50.0f);
    return CGRectMake(imageMarginLeft, imageMarginTop, imageWidth, imageHeight);
}

@end
