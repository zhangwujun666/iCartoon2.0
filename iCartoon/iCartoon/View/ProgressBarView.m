//
//  ProgressBarView.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/27.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "ProgressBarView.h"

@interface ProgressBarView()

@property (strong, nonatomic) UIView *progressView;
@property (strong, nonatomic) UILabel *progressLabel;

@property (assign, nonatomic) NSString *rate;
@property (assign, nonatomic) float rateValue;
//0-未开始；1-进行中；2-已结束 3-即将开始 4-即将结束
@property (assign, nonatomic) NSInteger status;

@end

@implementation ProgressBarView

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
        self.progressView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.progressView];
        self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.progressLabel];
        self.progressLabel.backgroundColor = [UIColor clearColor];
        self.progressLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        self.progressLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    self.progressLabel.hidden = YES;
    
    self.backgroundColor = I_COLOR_WHITE;
    self.clipsToBounds = YES;
    self.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.layer.borderWidth = 1.5f;
    
    return self;
}

- (void)setRateOfProgress:(NSString *)rate withStatus:(NSInteger)status {
    self.rate = rate;
    self.rate = [NSString stringWithFormat:@"%.02lf", [self.rate doubleValue]];
    self.status = status;
    self.rateValue = [self.rate floatValue];
    self.backgroundColor = I_COLOR_WHITE;
    
    if(self.status == 0) {
        //未开始
        self.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        self.progressLabel.textColor = UIColorFromRGB(0xa0a0a0);
        self.progressLabel.text = [NSString stringWithFormat:@"%@%% 即将开始", self.rate];
        self.progressView.backgroundColor = I_COLOR_WHITE;
    } else if(self.status == 1) {
        //进行中
        self.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        self.progressLabel.textColor = UIColorFromRGB(0xffb473);
        self.progressLabel.text = [NSString stringWithFormat:@"%@%% 进行中", self.rate];
        self.progressView.backgroundColor = UIColorFromRGB(0xffb473);
    } else if(self.status == 2) {
        //已经结束
        self.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        self.progressLabel.textColor = UIColorFromRGB(0xa0a0a0);
        self.progressLabel.text = [NSString stringWithFormat:@"%@%% 已经结束", self.rate];
        self.progressView.backgroundColor = UIColorFromRGB(0xa0a0a0);
    } else if(self.status == 3) {
        //即将开始
        self.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        self.progressLabel.textColor = UIColorFromRGB(0xa0a0a0);
        self.progressLabel.text = [NSString stringWithFormat:@"%@%% 即将开始", self.rate];
        self.progressView.backgroundColor = I_COLOR_WHITE;
    } else if(self.status == 4) {
        //即将结束
        self.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        self.progressLabel.textColor = UIColorFromRGB(0xffb473);
        self.progressLabel.text = [NSString stringWithFormat:@"%@%% 即将结束", self.rate];
        self.progressView.backgroundColor = UIColorFromRGB(0xffb473);
    } else {
        //未开始
        self.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        self.progressLabel.textColor = UIColorFromRGB(0xa0a0a0);
        self.progressLabel.text = [NSString stringWithFormat:@"%@%% 即将开始", self.rate];
        self.progressView.backgroundColor = I_COLOR_WHITE;
    }
    
    [self layoutSubviews];
}

- (void)layoutSubviews {
    
    CGFloat height = self.frame.size.height - 7;
//    float rateValue = [self.rate floatValue];
    CGFloat width = (self.frame.size.width - 7) * self.rateValue / 100.0f;
    self.progressView.frame = CGRectMake(3.5, 3.5, width, height);
    self.progressView.clipsToBounds = YES;
    self.progressView.layer.cornerRadius = height / 2;
    
    [super layoutSubviews];
   
}

@end
