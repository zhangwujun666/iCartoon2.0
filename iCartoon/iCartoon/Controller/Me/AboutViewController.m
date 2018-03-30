//
//  AboutViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "AboutViewController.h"
#import "ProgressHUD.h"
#import "APIConfig.h"
@interface AboutViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"关于艾漫";
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
//    [SVProgressHUD showWithStatus:@"正在获取信息..." maskType:SVProgressHUDMaskTypeClear];
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
     NSString * mainurl = [APIConfig mainURL];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",mainurl,@"goGetAboutUs"];
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
