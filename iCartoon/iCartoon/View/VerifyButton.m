//
//  VerifyButton.m
//  iCartoon
//
//  Created by 许成雄 on 16/4/2.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "VerifyButton.h"

@interface VerifyButton() {
    NSString *_title;
    NSInteger _countDown;
    BOOL _canSend;
    NSTimer *_timer;
}

@end

@implementation VerifyButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title {
    _title = title;
    if(!_title || [_title isEqualToString:@""]) {
        _title = @"获取验证码";
    }
    _canSend = NO;
    self = [super initWithFrame:frame];
    if(self) {
        self.titleLabel.font = [UIFont systemFontOfSize:CONVER_VALUE(16.0f)];
    }
    self.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    [self setTitleColor:I_COLOR_WHITE forState:UIControlStateNormal];
    [self setTitleColor:I_COLOR_WHITE forState:UIControlStateHighlighted];
    [self setTitleColor:I_COLOR_WHITE forState:UIControlStateSelected];
    [self setTitle:_title forState:UIControlStateNormal];
    [self setTitle:_title forState:UIControlStateHighlighted];
    [self setTitle:_title forState:UIControlStateSelected];
    
    self.clipsToBounds = YES;
    self.backgroundColor =I_COLOR_YELLOW;
//    UIColorFromRGB(0xFCAA6C);
    self.layer.cornerRadius = CONVER_VALUE(41.0f) / 2;

    _countDown = 60;
    
    return self;
}

- (void)start {
    [self startTimer];
}

- (void)startTimer {
    [self setEnabled:NO];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void)onTimer {
    if (_countDown > 0) {
        [self setTitle:[NSString stringWithFormat:@"%ld秒重新获取", (long)_countDown] forState:UIControlStateDisabled];
        
//    self.backgroundColor = I_COLOR_YELLOW;
   self.backgroundColor =  UIColorFromRGB(0xFCAA6C);
        
        _countDown --;
    } else {
        _countDown = 60;
        [_timer invalidate];
        _timer = nil;
        [self setTitle:@"60秒重新获取" forState:UIControlStateDisabled];
        [self setTitle:@"重发验证码" forState:UIControlStateNormal];
        [self setEnabled:YES];
//        self.backgroundColor =  UIColorFromRGB(0xFCAA6C);
        
            self.backgroundColor = I_COLOR_YELLOW;
        
    }
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

@end
