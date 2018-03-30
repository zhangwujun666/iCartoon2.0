//
//  LoginSucCollectionViewCell.m
//  iCartoon
//
//  Created by cxl on 16/3/26.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "LoginSucCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface LoginSucCollectionViewCell ()

@property(strong, nonatomic) UIImageView *bgImageView;
@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) UILabel *titleLabel;
@end

@implementation LoginSucCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width;
        CGRect rect = CGRectMake((width - CONVER_VALUE(72.0f)) / 2, CONVER_VALUE(11.0f), CONVER_VALUE(72.0), CONVER_VALUE(72.0));
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        self.imageView.image = [UIImage imageNamed:@"ic_theme_default"];
        self.imageView.layer.cornerRadius = CONVER_VALUE(72.0f)/2;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.borderColor = UIColorFromRGB(0xc0c0c0).CGColor;
        self.imageView.layer.borderWidth = 0.5f;
        
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((width - CONVER_VALUE(72.0f)) / 2, CONVER_VALUE(11.0f), CONVER_VALUE(72.0), CONVER_VALUE(72.0))];
        self.bgImageView.layer.cornerRadius = CONVER_VALUE(72.0f)/2;
        self.bgImageView.layer.masksToBounds = YES;
        self.bgImageView.layer.borderColor = [UIColor clearColor].CGColor;
        self.bgImageView.layer.borderWidth = 1.0;
        self.bgImageView.layer.shadowColor = UIColorFromRGB(0xc0c0c0).CGColor;
        self.bgImageView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        self.bgImageView.layer.shadowOpacity = 1.0f;
        self.bgImageView.layer.shadowRadius = 1.0;
        self.bgImageView.clipsToBounds = NO;
        
        [self.bgImageView addSubview:self.imageView];
        [self addSubview:self.bgImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONVER_VALUE(2.0f), CONVER_VALUE(84.0f), width - 2 * CONVER_VALUE(2.0f), CONVER_VALUE(36.0f))];
        self.titleLabel.textColor = UIColorFromRGB(0x191919);
        self.titleLabel.font = [UIFont systemFontOfSize:CONVER_VALUE(11.0f)];
        self.titleLabel.text = @"暗杀教室";
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)selectedCollectCell {
    self.imageView.layer.borderColor = I_COLOR_YELLOW.CGColor;
    self.bgImageView.layer.shadowColor = RGBACOLOR(237, 131, 47, 0.5f).CGColor;
    self.titleLabel.textColor = UIColorFromRGB(0xf0821e);
}

- (void)deselectCollectCell {
    self.imageView.layer.borderColor = UIColorFromRGB(0xc0c0c0).CGColor;
    self.bgImageView.layer.shadowColor = UIColorFromRGB(0xc0c0c0).CGColor;
    self.titleLabel.textColor = UIColorFromRGB(0x191919);
}

- (void)setThemeInfo:(ThemeInfo *)themeInfo {
    _themeInfo = themeInfo;
    if(_themeInfo != nil) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:themeInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"ic_theme_default"]];
        _titleLabel.text = _themeInfo.title;
    }
}


@end
