//
//  MessageDetailViewController.m
//  iCartoon
//
//  Created by 许成雄 on 16/4/17.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "Context.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ProgressHUD.h"
@interface MessageDetailViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = I_BACKGROUND_COLOR;
    self.title = @"消息详情";
    
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
    if(!self.messageInfo || !self.messageInfo.mid) {
        return;
    }
     NSString * mainurl = [APIConfig mainURL];
//    NSString *urlStr = [NSString stringWithFormat:@"http://121.40.102.225:6060/am-v24/api/goGetSystemMessageDetail/%@/%@", self.messageInfo.mid, [Context sharedInstance].token];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@",mainurl,@"goGetSystemMessageDetail",self.messageInfo.mid, [Context sharedInstance].token];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

- (void)createUI {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f)];
    self.webView.backgroundColor = I_BACKGROUND_COLOR;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView setScalesPageToFit:YES];
}
@end
