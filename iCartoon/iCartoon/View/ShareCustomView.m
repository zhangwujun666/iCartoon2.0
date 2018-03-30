//
//  ShareCustomView.m
//  iCartoon
//
//  Created by 许成雄 on 16/4/21.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "ShareCustomView.h"
#import "ShareActionButton.h"
#import "AppDelegate.h"
#import "WHTextActivity.h"
#import "WeiboSDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <MOBFoundation/MOBFoundation.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
@implementation ShareCustomView

static id _publishContent;//类方法中的全局变量这样用（类型前面加static）
static id _publishUrl;//类方法中的全局变量这样用（类型前面加static）
static id _imageArray;
static id _titlestr;

+ (void)shareWithContentString:(NSString *)str :(NSArray *)imageArray :(NSString *)urlString :(NSString *)titlestr{
    _publishContent = str;
    _publishUrl = urlString;
    _imageArray = imageArray;
    _titlestr = titlestr;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    blackView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6];
    blackView.tag = 440;
    [window addSubview:blackView];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blackViewClick)];
    [blackView addGestureRecognizer:tapGesture];
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TRANS_VALUE(190.0f), SCREEN_WIDTH, TRANS_VALUE(190))];
    shareView.backgroundColor = [UIColor clearColor];
    shareView.tag = 441;
    [window addSubview:shareView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(8.0f), TRANS_VALUE(8.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(8.0f), TRANS_VALUE(120.0f))];
    topView.backgroundColor = I_COLOR_WHITE;
    topView.clipsToBounds = YES;
    topView.layer.cornerRadius = TRANS_VALUE(6.0f);
    [shareView addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), 0, SCREEN_WIDTH - 2 * TRANS_VALUE(8.0f), TRANS_VALUE(41.0f))];
    titleLabel.text = @"分享";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(15.0f)];
    titleLabel.textColor = I_COLOR_33BLACK;
    titleLabel.backgroundColor = [UIColor clearColor];
    [topView addSubview:titleLabel];
    
    UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(18.0f), TRANS_VALUE(41.0f), SCREEN_WIDTH -  2 * TRANS_VALUE(27.0f), TRANS_VALUE(1.0f))];
    dividerView.backgroundColor = I_DIVIDER_COLOR;
    [topView addSubview:dividerView];
    
    NSArray *btnImages = @[@"ic_share_weibo", @"ic_share_weixin", @"ic_share_friends", @"ic_share_qq",@"ic_qqzone", @"ic_share_copy"];
    NSArray *btnTitles = @[@"新浪微博", @"微信好友",@"朋友圈", @"QQ",@"QQ空间" ,@"复制链接"];
    CGFloat buttonWidth = (SCREEN_WIDTH+TRANS_VALUE(80.0f) - 2 * TRANS_VALUE(8.0f) - 2 * TRANS_VALUE(12.0f)) / btnImages.count;
    CGFloat buttonHeight = TRANS_VALUE(74.0f);
    CGFloat buttonLeftMargin = TRANS_VALUE(12.0f);
    CGFloat buttonTopMargin = TRANS_VALUE(3.0f);
    CGFloat x = buttonLeftMargin;
    UIScrollView * sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(dividerView.frame), SCREEN_WIDTH, buttonHeight)];
    sc.backgroundColor = [UIColor clearColor];
    sc.showsHorizontalScrollIndicator = NO;
    sc.contentSize = CGSizeMake(SCREEN_WIDTH+TRANS_VALUE(80.0f), buttonHeight);
    [topView addSubview:sc];
    for (int i = 0; i <btnImages.count ; i++) {
        ShareActionButton *button = [[ShareActionButton alloc] initWithFrame:CGRectMake(x, buttonTopMargin, buttonWidth, buttonHeight)];
        [button setImage:btnImages[i]];
        [button setTitle:btnTitles[i]];
        button.tag = 331+i;
        [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [sc addSubview:button];
        x += buttonWidth;
    }
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(8.0f), TRANS_VALUE(136.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(8.0f), TRANS_VALUE(40.0f))];
    cancelBtn.backgroundColor = I_COLOR_WHITE;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(15.0f)];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.clipsToBounds = YES;
    cancelBtn.layer.cornerRadius = TRANS_VALUE(6.0f);
    cancelBtn.tag = 339;
    [cancelBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancelBtn];
    
    //为了弹窗不那么生硬，这里加了个简单的动画
    shareView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
    blackView.alpha = 0;
    [UIView animateWithDuration:0.35f animations:^{
        shareView.transform = CGAffineTransformMakeScale(1, 1);
        blackView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];

}
+(void)blackViewClick{
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
    
    int shareType = 0;
    switch (btn.tag) {
        case 331:
            shareType = SSDKPlatformTypeSinaWeibo;
            break;
            
        case 332:
           shareType = SSDKPlatformSubTypeWechatSession;
            break;
            
        case 333:
            shareType = SSDKPlatformSubTypeWechatTimeline;
            break;
            
        case 334:
            shareType = SSDKPlatformSubTypeQQFriend;
            break;
            
        case 335:
            shareType = SSDKPlatformSubTypeQZone;
            break;
        case 336:
            shareType = SSDKPlatformTypeCopy;
            break;
        default:
            break;
    }
    //创建分享参数
    if (!_imageArray) {
        _publishContent = [NSString stringWithFormat:@"%@\n%@",_publishContent,[NSURL URLWithString:_publishUrl]];
    }

        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:_publishContent
                                         images:_imageArray //传入要分享的图片
                                            url:[NSURL URLWithString:_publishUrl]
                                          title:_titlestr type:SSDKContentTypeAuto];
    
    
    if (shareType == SSDKPlatformTypeSinaWeibo) {
        [self showShareEditor];
    }else{
        
        
        //进行分享
        [ShareSDK share:shareType //传入分享的平台类型
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
             NSLog(@"%@",error.localizedDescription);
             if(state == SSDKResponseStateSuccess) {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                 message:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
                 
             }else if(state == SSDKResponseStateFail) {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                 message:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
//                 NSLog(@"---------%@",error.localizedDescription);
             }
         }];
    }
}
+ (void)showShareEditor
{
//    __weak ViewController *theController = self;
    
    //创建分享参数
//    NSLog(@"_publishUrl ====== %@",_publishUrl);
    _publishContent = [NSString stringWithFormat:@"%@\n%@",_publishContent,_publishUrl];
    NSArray* imageArray = _imageArray;
    
//    if (imageArray) {
    
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:_publishContent
                                         images:imageArray
                                            url:[NSURL URLWithString:_publishUrl]
                                          title:_titlestr type:SSDKContentTypeAuto];
        
        [ShareSDK showShareEditor:SSDKPlatformTypeSinaWeibo
               otherPlatformTypes:@[@(SSDKPlatformTypeTencentWeibo)]
                      shareParams:shareParams
              onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end)
         {
             
             switch (state) {
                     
                 case SSDKResponseStateBegin:
                 {
//                     [theController showLoadingView:YES];
                     break;
                 }
                 case SSDKResponseStateSuccess:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                         message:nil
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                         message:[NSString stringWithFormat:@"%@", error]
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateCancel:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                         message:nil
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 default:
                     break;
             }
             
             if (state != SSDKResponseStateBegin)
             {
//                 [theController showLoadingView:NO];
//                 [theController.tableView reloadData];
             }
         }];
//    }
}

@end
