//
//  AttentionView.m
//  iCartoon
//
//  Created by besture on 16/4/21.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "AttentionView.h"

@implementation AttentionView
- (instancetype)initTitle:(NSString *)title andtitle2 :(NSString *)title2
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-135, [UIScreen mainScreen].bounds.size.height/2-110, 270, 80);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        self.label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 250, 40)];
        self.label1.text = title;
        self.label1.adjustsFontSizeToFitWidth = YES;
        //self.label1.numberOfLines = 0;
        self.label1.textColor = [UIColor whiteColor];
        self.label1.textAlignment = NSTextAlignmentCenter;
        self.label1.font = [UIFont systemFontOfSize:16];
        [self addSubview: self.label1];
        
        self.label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 250, 40)];
        self.label2.font = [UIFont systemFontOfSize:16];
        self.label2.textColor = [UIColor whiteColor];
        self.label2.textAlignment = NSTextAlignmentCenter;
        self.label2.text = title2;
        [self addSubview:self.label2];
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7];
        [self show];
    }
    return self;
}
- (instancetype)initTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        self.label1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, 220, 40)];
        self.label1.text = title;
        self.label1.adjustsFontSizeToFitWidth = YES;
        self.label1.textColor = [UIColor whiteColor];
        self.label1.textAlignment = NSTextAlignmentCenter;
        self.label1.font = [UIFont systemFontOfSize:16];
        [self addSubview: self.label1];
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7];
        [self show];
    }
    return self;
}
- (instancetype)initTitlestr:(NSString *)title{
    self = [super init];
    if (self) {
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-140, [UIScreen mainScreen].bounds.size.height/2-150, 280, 90);
        self.label1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, 270, 60)];
        self.label1.numberOfLines = 0;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        self.label1.text = title;
        self.label1.textColor = [UIColor whiteColor];
        self.label1.textAlignment = NSTextAlignmentCenter;
        self.label1.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
          [self addSubview: self.label1];
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7];
       
               [self show];
    }
    return self;

}
- (void)show{
    [UIView animateKeyframesWithDuration:0 delay:1.2 options:(UIViewKeyframeAnimationOptionAllowUserInteraction) animations:^{
        self.alpha = 0.1;
//        sleep(3);
           } completion:^(BOOL finished) {
               self.hidden = YES;
        [self removeFromSuperview];
    }];
}





@end
