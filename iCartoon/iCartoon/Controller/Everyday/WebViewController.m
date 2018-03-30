//
//  WebViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "WebViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "AttentionView.h"
#import "ProgressHUD.h"
@interface WebViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"其他";
    [self setBackNavgationItem];
    
    [self createUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [ProgressHUD show:nil];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [ProgressHUD dismiss];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [ProgressHUD dismiss];
}
#pragma mark - Private Method
- (void)loadData {
    //TOOD --  添加网页url
    NSString *urlStr = nil;
    if(self.urlStr) {
        urlStr = self.urlStr;
    }
    if(!urlStr) {
//        [TSMessage showNotificationWithTitle:@"网页链接错误" subtitle:nil type:TSMessageNotificationTypeError];
        AttentionView *attention = [[AttentionView alloc]initTitle:@"网页链接错误"];
        [self.view addSubview:attention];
        return;
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

- (void)createUI {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f)];
    self.webView.backgroundColor = I_COLOR_WHITE;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView setScalesPageToFit:YES];
}


@end
