//
//  CustomAlertView.m
//  iCartoon
//
//  Created by 许成雄 on 16/4/21.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

static NSString *_titleStr;//类方法中的全局变量这样用（类型前面加static）
static NSString * _share;
static id<CustomAlertViewDelegate> _delegate;

/*只需要在分享按钮事件中 构建好分享内容publishContent传过来就好了*/
+ (void)showWithTitle:(NSString *)titleStr delegate:(id<CustomAlertViewDelegate>)delegate {
    
    _titleStr = titleStr;
    _delegate = delegate;
    _share = titleStr;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    blackView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8];
    blackView.tag = 440;
    [window addSubview:blackView];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(30), (SCREEN_HEIGHT - TRANS_VALUE(220.0f)) / 2, SCREEN_WIDTH - 2 * TRANS_VALUE(30), TRANS_VALUE(220))];
    containerView.backgroundColor = I_COLOR_WHITE;
    containerView.clipsToBounds = YES;
    containerView.layer.cornerRadius = TRANS_VALUE(6.0f);
    containerView.tag = 441;
    [window addSubview:containerView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(8.0f), TRANS_VALUE(8.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(30.0f) - 2 * TRANS_VALUE(8.0f), TRANS_VALUE(140.0f))];
    if ([_share isEqualToString:@"sharesina"]) {
        titleLabel.text = @"确定解除新浪微博绑定吗？";
    }else if ([_share isEqualToString:@"shareweixin"]){
        titleLabel.text = @"确定解除微信绑定吗？";
    }else if ([_share isEqualToString:@"shareQQ"]){
        titleLabel.text = @"确定解除QQ绑定吗？";
    }else{
        titleLabel.text = @"真的……不要人家了？(´•̥ ̯ •̥`) ꉂ ?";
    }
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    titleLabel.textColor = I_COLOR_BLACK;
    titleLabel.backgroundColor = [UIColor clearColor];
    [containerView addSubview:titleLabel];
    
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(18.0f), TRANS_VALUE(160.0f), TRANS_VALUE(96.0f), TRANS_VALUE(40.0f))];
    confirmButton.backgroundColor = UIColorFromRGB(0xe20c21);
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    [confirmButton setTitleColor:I_COLOR_WHITE forState:UIControlStateNormal];
    if ([_share hasPrefix:@"share"]) {
        [confirmButton setTitle:@"解除绑定" forState:UIControlStateNormal];
        [confirmButton setTitle:@"解除绑定" forState:UIControlStateHighlighted];
        [confirmButton setTitle:@"解除绑定" forState:UIControlStateSelected];
    }else{
        [confirmButton setTitle:@"狠心删除" forState:UIControlStateNormal];
        [confirmButton setTitle:@"狠心删除" forState:UIControlStateHighlighted];
        [confirmButton setTitle:@"狠心删除" forState:UIControlStateSelected];
    }
    [confirmButton setImage:[UIImage imageNamed:@"ic_me_delete"] forState:UIControlStateNormal];
    [confirmButton setImage:[UIImage imageNamed:@"ic_me_delete"] forState:UIControlStateSelected];
    [confirmButton setImage:[UIImage imageNamed:@"ic_me_delete"] forState:UIControlStateHighlighted];
    [confirmButton setTitleEdgeInsets:UIEdgeInsetsMake(0, TRANS_VALUE(4.0f), 0, 0)];
    confirmButton.clipsToBounds = YES;
    confirmButton.layer.cornerRadius = confirmButton.frame.size.height / 2;
    confirmButton.tag = 338;
    [confirmButton addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:confirmButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(140.0f), TRANS_VALUE(160.0f), TRANS_VALUE(96.0f), TRANS_VALUE(40.0f))];
    cancelButton.backgroundColor = UIColorFromRGB(0xc8c8c8);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    [cancelButton setTitleColor:I_COLOR_WHITE forState:UIControlStateNormal];
    [cancelButton setTitle:@"怎么会呢" forState:UIControlStateNormal];
    cancelButton.clipsToBounds = YES;
    cancelButton.layer.cornerRadius = cancelButton.frame.size.height / 2;
    cancelButton.tag = 339;
    [cancelButton addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:cancelButton];
    
    //为了弹窗不那么生硬，这里加了个简单的动画
    containerView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
    blackView.alpha = 0;
    [UIView animateWithDuration:0.35f animations:^{
        containerView.transform = CGAffineTransformMakeScale(1, 1);
        blackView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

+ (void)shareBtnClick:(UIButton *)btn {
    //    NSLog(@"%@",[ShareSDK version]);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:440];
    UIView *shareView = [window viewWithTag:441];
    
    //为了弹窗不那么生硬，这里加了个简单的动画
    shareView.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.35f animations:^{
        shareView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
        blackView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [shareView removeFromSuperview];
        [blackView removeFromSuperview];
    }];
    
    switch (btn.tag) {
        case 338:
            //确定
            if([_delegate respondsToSelector:@selector(confirmButtonClick)]) {
                [_delegate confirmButtonClick];
            }
            break;
        case 339:
            //取消
            if([_delegate respondsToSelector:@selector(cancelButtonClick)]) {
                [_delegate cancelButtonClick];
            }
            break;
        default:
            break;
    }
    
}

@end
