//
//  TabButton.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright (c) 2015年 xuchengxiong. All rights reserved.
//

#import "TopTabButton.h"

@interface TopTabButton ()

@property (strong, nonatomic) UIView *lineView;

@end

@implementation TopTabButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        self.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2.0f, self.frame.size.width, 2.0f)];
        self.lineView.backgroundColor = I_COLOR_YELLOW;
        [self addSubview:self.lineView];
        
        self.lineView.hidden = YES;
    }
    self.backgroundColor = I_BACKGROUND_COLOR;
    
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if(selected) {
        _lineView.hidden = NO;
    } else {
        _lineView.hidden = YES;
    }
}

- (void)setTitle:(NSString *)title {
    
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateSelected];
    
    [self setTitleColor:I_COLOR_BLACK forState:UIControlStateNormal];
    [self setTitleColor:I_COLOR_YELLOW forState:UIControlStateHighlighted];
    [self setTitleColor:I_COLOR_YELLOW forState:UIControlStateSelected];
}

@end
