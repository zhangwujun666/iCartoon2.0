//
//  TabActionButton.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright (c) 2015年 xuchengxiong. All rights reserved.
//

#import "TabActionButton.h"

@interface TabActionButton ()

@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIView *bottomBorderView;

@end

@implementation TabActionButton

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
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(11.0f)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.bottomBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5f, 0.0f, 0.5f)];
        self.bottomBorderView.backgroundColor = DIVIDER_COLOR;
        [self addSubview:self.bottomBorderView];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 14.0f, 0.0f, TRANS_VALUE(5.0f))];
        self.lineView.backgroundColor = I_COLOR_YELLOW;
        [self addSubview:self.lineView];
        
        self.lineView.hidden = YES;
    }
    self.backgroundColor = [UIColor clearColor];
    
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
    
    [self setTitleColor:I_COLOR_GRAY forState:UIControlStateNormal];
    [self setTitleColor:I_COLOR_33BLACK forState:UIControlStateHighlighted];
    [self setTitleColor:I_COLOR_33BLACK forState:UIControlStateSelected];
    
    [self layoutSubviews];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:TRANS_VALUE(14.0f)]}];
    titleSize.width += 4;
    titleSize.width = floor(titleSize.width);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, titleSize.width, self.frame.size.height);
    self.lineView.frame = CGRectMake(0, self.frame.size.height - 3.0f, self.frame.size.width, TRANS_VALUE(2.5f));
}

@end
