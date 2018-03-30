//
//  MyTabBar.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/27.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "MyTabBar.h"

@interface MyTabBar() <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIButton *centerButton;

@end

@implementation MyTabBar

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
        //去处顶部分割线
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, RGBACOLOR(231, 231, 231, 0.0f).CGColor);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self setShadowImage:img];
        [self setBackgroundImage:[[UIImage alloc] init]];
        
        UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1.0f)];
        dividerView.backgroundColor = RGBCOLOR(236, 236, 236);
        [self addSubview:dividerView];
        //添加中间按钮
        self.centerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(75.0f), TRANS_VALUE(66.0f))];
        [self.centerButton setBackgroundImage:[UIImage imageNamed:@"ic_tabbar_post"] forState:UIControlStateNormal];
        [self.centerButton setBackgroundImage:[UIImage imageNamed:@"ic_tabbar_post"] forState:UIControlStateHighlighted];
        [self.centerButton setBackgroundImage:[UIImage imageNamed:@"ic_tabbar_post"] forState:UIControlStateSelected];
        [self addSubview:self.centerButton];
        self.backgroundColor = [UIColor clearColor];
        
        [self.centerButton addTarget:self action:@selector(centerButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    self.clipsToBounds = NO;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, TRANS_VALUE(2.0f))];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 1.设置中间按钮的位置, 偏移量Y = 24.5 - (33 - 24.5);
    self.centerButton.center = CGPointMake(self.frame.size.width * 0.5f, 17.0f);
    // 2.设置其它UITabBarButton的位置和尺寸
    CGFloat tabbarButtonWidth = TRANS_VALUE(50.0f);
    CGFloat tabbarButtonHeight = 44.0f;
    CGFloat tabbarButtonY = 3.0f;
    CGFloat tabbarButtonX = TRANS_VALUE(9.0f);
    CGFloat tabbarButtonIndex = 0;
    for(UIView *childView in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if([childView isKindOfClass:class]) {
            childView.frame = CGRectMake(tabbarButtonX, tabbarButtonY, tabbarButtonWidth, tabbarButtonHeight);
            tabbarButtonX += (tabbarButtonWidth + TRANS_VALUE(9.0));
            tabbarButtonIndex ++;
            if(tabbarButtonIndex == 2) {
                tabbarButtonX += TRANS_VALUE(75.0f);
            }
        }
    }
}

//子视图超出超出父视图的处理
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
//    if(view == nil) {
//        CGPoint tempoint = [self.centerButton convertPoint:point fromView:self];
//        if (CGRectContainsPoint(self.centerButton.bounds, tempoint)) {
//            view = self.centerButton;
//        }
//    }
    return view;
}

#pragma mark - Action
- (void)singleTapAction:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self];
    NSLog(@"handleSingleTap!!!!!!\npoint-->x:%f,y:%f",point.x,point.y);
}

- (void)centerButtonClickAction:(UIButton *)sender {

    if([self.tabBarDelegate respondsToSelector:@selector(tabBar:didClickCenterButton:)]) {
        [self.tabBarDelegate tabBar:self didClickCenterButton:sender];
    }
}

@end
