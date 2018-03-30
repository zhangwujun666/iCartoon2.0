//
//  AgreementViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/9/3.
//  Copyright (c) 2015年 xuchengxiong. All rights reserved.
//

#import "AgreementViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ProgressHUD.h"
@interface AgreementViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *mWebView;

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = I_BACKGROUND_COLOR;
    self.title = @"用户协议";
    
    [self setBackNavgationItem];
    
    [self addViews];
    
    //加载网页
    NSString * mainurl = [APIConfig mainURL];
    NSString *htmlPath = [NSString stringWithFormat:@"%@/%@",mainurl,@"goGetUserProtocol"];
    if(htmlPath) {
        NSURL *url = [NSURL URLWithString:htmlPath];
//         NSLog(@"htmlPath = %@",url);
        [self.mWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addViews {
    self.mWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f)];
    self.mWebView.backgroundColor = [UIColor clearColor];
    self.mWebView.scrollView.backgroundColor = [UIColor clearColor];
    [self.mWebView setScalesPageToFit:NO];
    [self.view addSubview:self.mWebView];
    self.mWebView.delegate = self;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [SVProgressHUD showWithStatus:@"正在获取用户协议, 请稍等..." maskType:SVProgressHUDMaskTypeClear];
    [ProgressHUD show:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '90%'";
    [self.mWebView stringByEvaluatingJavaScriptFromString:str];
    [ProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [ProgressHUD dismiss];
}

@end
