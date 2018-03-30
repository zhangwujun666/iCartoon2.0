//
//  TaskDetailViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/23.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "PopoverView.h"
#import "TaskCommentViewController.h"
#import "PublishTaskViewController.h"
#import "LookBigPicViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "IndexAPIRequest.h"

#import "APIConfig.h"
#import "Context.h"
#import "AttentionView.h"
#import "ShareCustomView.h"

#import <JavaScriptCore/JavaScriptCore.h>
#import "TaskPictureInfo.h"
#import "AppDelegate.h"
#import "ProgressHUD.h"
#import <AFNetworking.h>
#import "AuthorDetailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface TaskDetailViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIBarButtonItem *moreButton;

@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic,strong)NSString * hasCollected;
@property (nonatomic,strong)AFHTTPRequestOperationManager * requestManager;
@property (nonatomic,strong) NSString *isfreeze;
@property (nonatomic,strong) NSString *thaw_date;
@property (nonatomic,strong) NSString *thaw_time;
@property (nonatomic,strong)NSString * isshow;
@property (nonatomic,strong)NSString * isshowfree;
@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *isfreeze = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfreeze"];
    NSString *thaw_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_date"];
    NSString *thaw_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_time"];
    NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
    NSString *isshowfree = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshowfree"];
    self.isshowfree = isshowfree;
    //    NSLog(@"%@------%@-----%@",isfreeze,thaw_time,thaw_date);
    self.isfreeze = isfreeze;
    self.thaw_date = thaw_date;
    self.thaw_time = thaw_time;
    self.isshow = isshow;

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = I_BACKGROUND_COLOR;
    self.navigationItem.title = @"任务详情";
    [self setBackNavgationItem];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50.0f, 44.0f)];
    button.backgroundColor = [UIColor clearColor];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button setTitleColor:I_COLOR_YELLOW forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"ic_navi_more"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.moreButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = self.moreButton;
    
    [self createUI];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTaskInfo) name:kNotificationRefreshTaskComments object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTaskInfo) name:kNotificationRefreshTaskContribute object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAlert) name:@"showAlert" object:nil];

}

-(void)showAlert{
    AttentionView *attention = [[AttentionView alloc]initTitle:@"评论已发送至草稿箱！"];
    [self.view addSubview:attention];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTaskInfo {
    [self loadData];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - Action
- (void)moreButtonAction:(id)sender {
    NSString *isfreeze = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfreeze"];
    NSString *thaw_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_date"];
    NSString *thaw_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_time"];
    NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
    NSString *isshowfree = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshowfree"];
  
    //    NSLog(@"%@------%@-----%@",isfreeze,thaw_time,thaw_date);
    self.isfreeze = isfreeze;
    self.thaw_date = thaw_date;
    self.thaw_time = thaw_time;
    self.isshow = isshow;
    self.isshowfree = isshowfree;
    UIButton *button = (UIButton *)sender;
    CGPoint point = CGPointMake(button.frame.origin.x + button.frame.size.width * 3 / 4, button.frame.origin.y + button.frame.size.height + 9.0f);
    NSString *collectStatus = self.taskInfo.collectStatus;
    NSArray *titles = [NSArray array];
    NSArray *images = [NSArray array];
    if (self.draftStatus == 1 ||self.draftStatus == 19 ) {
       titles = @[@"收藏", @"分享",@"投稿"];
    images = @[@"ic_dropdown_collect_off", @"ic_dropdown_share_off",@"ic_contribution_new1"];
        if([collectStatus isEqualToString:@"1"] || (![self.hasCollected isEqualToString:@"0"]&&self.hasCollected != nil)) {
            titles = @[@"取消收藏", @"分享",@"投稿"];
            images = @[@"ic_dropdown_collect_on", @"ic_dropdown_share_off",@"ic_contribution_new1"];
        } else if([collectStatus isEqualToString:@"0"]){
            titles = @[@"收藏", @"分享",@"投稿"];
            images = @[@"ic_dropdown_collect_off", @"ic_dropdown_share_off",@"ic_contribution_new1"];
        }
    }else{
        titles = @[@"收藏", @"分享"];
        images = @[@"ic_dropdown_collect_off", @"ic_dropdown_share_off"];
        if([collectStatus isEqualToString:@"1"]) {
            titles = @[@"取消收藏", @"分享"];
            images = @[@"ic_dropdown_collect_on", @"ic_dropdown_share_off"];
        } else if([collectStatus isEqualToString:@"0"]){
            titles = @[@"收藏", @"分享"];
            images = @[@"ic_dropdown_collect_off", @"ic_dropdown_share_off"];
        }
    }
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:images];
    __block PopoverView *poppop = pop;
    pop.selectRowAtIndex = ^(NSInteger index){
        if(index == 0) {
            if ([self.isfreeze isEqualToString:@"1"]) {
                 poppop.isshowfree = 1;
            }
            //收藏任务
            [self collectTask];
        }else if(index == 1) {
            //社交化分享
             poppop.isshowfree = 0;
            [self socialShareAction:button];
        }else{
            NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
            if ([isshow isEqualToString:@"1"]) {
                if ([self.isfreeze isEqualToString:@"1"]) {
                    return;
                }
            }else{
                if ([self.isfreeze isEqualToString:@"1"]) {
                    poppop.isshowfree = 1;
                                int time = [thaw_time intValue];
                                 int day = time/24/60/60;
                                NSString * attentionstr = nil;
                                if (day > 7) {
                                     attentionstr = @"萌热娘说了，屡教不改的熊宝要严惩！罚你永远关进小黑屋\no(￣ヘ￣o＃)";
                                }else{
                                    attentionstr = [NSString stringWithFormat:@"萌热娘说了，犯了错还屡教不改的熊宝要严惩！罚你关进小黑屋%d天\no(≧口≦)o",day];
                                }
                    AttentionView * attention = [[AttentionView alloc]initTitlestr:attentionstr];
                    [self.view addSubview:attention];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isshow"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    return;
                }
            }
//            if (![self.isshowfree isEqualToString:@"1"]&&![self.isfreeze isEqualToString:@"1"]) {
//                AttentionView * attention = [[AttentionView alloc]initTitlestr:@"账号被解冻啦o(*￣▽￣*)ゞ 下次不要再犯错咯！"];
//                [self.view addSubview:attention];
//                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isshowfree"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }

        PublishTaskViewController *publishTaskViewController =[[PublishTaskViewController alloc] init];
        publishTaskViewController.taskId = self.taskId;
        [self.navigationController pushViewController:publishTaskViewController animated:YES];
}
    };
    [pop show];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [ProgressHUD show:nil];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [ProgressHUD dismiss];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [ProgressHUD dismiss];
    //JS调用原生代码
    [self jsInvokation];
}

#pragma mark - Private Method
- (void)jsInvokation {
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"draftVote"] = ^() {
        NSString *isfreeze = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfreeze"];
        NSString *thaw_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_date"];
        NSString *thaw_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_time"];
        NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
        NSString *isshowfree = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshowfree"];
        //    NSLog(@"%@------%@-----%@",isfreeze,thaw_time,thaw_date);
        self.isfreeze = isfreeze;
        self.thaw_date = thaw_date;
        self.thaw_time = thaw_time;
        self.isshow = isshow;
        self.isshowfree = isshowfree;
        if(![Context sharedInstance].token) {
            [[AppDelegate sharedDelegate] showLoginViewController:YES];
        }else{
            NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
            if ([isshow isEqualToString:@"1"]) {
                if ([self.isfreeze isEqualToString:@"1"]) {
                    return;
                }
            }else{
                if ([self.isfreeze isEqualToString:@"1"]) {
                                int time = [thaw_time intValue];
                                 int day = time/24/60/60;
                                NSString * attentionstr = nil;
                                if (day > 7) {
                                     attentionstr = @"萌热娘说了，屡教不改的熊宝要严惩！罚你永远关进小黑屋\no(￣ヘ￣o＃)";
                                }else{
                                    attentionstr = [NSString stringWithFormat:@"萌热娘说了，犯了错还屡教不改的熊宝要严惩！罚你关进小黑屋%d天\no(≧口≦)o",day];
                                }
                    AttentionView * attention = [[AttentionView alloc]initTitlestr:attentionstr];
                    [self.view addSubview:attention];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isshow"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    return;
                }
            }
//            if (![self.isshowfree isEqualToString:@"1"]&&![self.isfreeze isEqualToString:@"1"]) {
//                AttentionView * attention = [[AttentionView alloc]initTitlestr:@"账号被解冻啦o(*￣▽￣*)ゞ 下次不要再犯错咯！"];
//                [self.view addSubview:attention];
//                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isshowfree"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }

//        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
        }
//        JSValue *this = [JSContext currentThis];
//        NSLog(@"this: %@",this);
//        NSLog(@"-------End Log-------");
        //TODO -- 投稿
        dispatch_async(dispatch_get_main_queue(), ^{
            PublishTaskViewController *publishTaskViewController = [[PublishTaskViewController alloc] init];
            publishTaskViewController.taskId = self.taskId;
            [self.navigationController pushViewController:publishTaskViewController animated:YES];
        });
        }
    };
    
    context[@"commentVote"] = ^() {
        NSString *isfreeze = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfreeze"];
        NSString *thaw_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_date"];
        NSString *thaw_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_time"];
        NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
        NSString *isshowfree = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshowfree"];
        //    NSLog(@"%@------%@-----%@",isfreeze,thaw_time,thaw_date);
        self.isfreeze = isfreeze;
        self.thaw_date = thaw_date;
        self.thaw_time = thaw_time;
        self.isshow = isshow;
        self.isshowfree = isshowfree;
        if(![Context sharedInstance].token) {
            [[AppDelegate sharedDelegate] showLoginViewController:YES];
        } else{
            NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
            if ([isshow isEqualToString:@"1"]) {
                if ([self.isfreeze isEqualToString:@"1"]) {
                    return;
                }
            }else{
                if ([self.isfreeze isEqualToString:@"1"]) {
                                int time = [thaw_time intValue];
                                 int day = time/24/60/60;
                                NSString * attentionstr = nil;
                                if (day > 7) {
                                     attentionstr = @"萌热娘说了，屡教不改的熊宝要严惩！罚你永远关进小黑屋\no(￣ヘ￣o＃)";
                                }else{
                                    attentionstr = [NSString stringWithFormat:@"萌热娘说了，犯了错还屡教不改的熊宝要严惩！罚你关进小黑屋%d天\no(≧口≦)o",day];
                                }
                    AttentionView * attention = [[AttentionView alloc]initTitlestr:attentionstr];
                    [self.view addSubview:attention];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isshow"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    return;
                }
            }
//            if (![self.isshowfree isEqualToString:@"1"]&&![self.isfreeze isEqualToString:@"1"]) {
//                AttentionView * attention = [[AttentionView alloc]initTitlestr:@"账号被解冻啦o(*￣▽￣*)ゞ 下次不要再犯错咯！"];
//                [self.view addSubview:attention];
//                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isshowfree"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }

//            NSLog(@"+++++++Begin Log+++++++");
            NSArray *args = [JSContext currentArguments];
            for(JSValue *jsVal in args) {
                NSLog(@"jsVal ======= %@", jsVal);
            }
            JSValue *this = [JSContext currentThis];
            NSLog(@"this ======== %@",this);
//            NSLog(@"-------End Log-------");
            //TODO -- 任务评论
            dispatch_async(dispatch_get_main_queue(), ^{
                TaskCommentViewController *taskCommentViewController = [[TaskCommentViewController alloc] init];
//                NSString *authorId = [args[0] toString];
//                NSString *commentId = [args[1] toString];
                taskCommentViewController.isComment = YES;
//                taskCommentViewController.block2=^(){
//                    AttentionView *attention = [[AttentionView alloc]initTitle:@"你的评论已发送至草稿箱！"];
//                    [self.view addSubview:attention];
//                };
                taskCommentViewController.block = ^() {
                    AttentionView * attention = [[AttentionView alloc]initTitle:@"评论成功！" andtitle2:@""];
                    attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
                    attention.label1.frame=CGRectMake(5, 15, 220, 40);
                    [self.view addSubview:attention];
                };
                taskCommentViewController.taskId = self.taskId;
                taskCommentViewController.authorId = nil;
                taskCommentViewController.commentId = nil;
                [self.navigationController pushViewController:taskCommentViewController animated:YES];
        });
        }
    };
    
    context[@"replyVoteComment"] = ^() {
        NSString *isfreeze = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfreeze"];
        NSString *thaw_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_date"];
        NSString *thaw_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_time"];
        NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
        NSString *isshowfree = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshowfree"];
        //    NSLog(@"%@------%@-----%@",isfreeze,thaw_time,thaw_date);
        self.isfreeze = isfreeze;
        self.thaw_date = thaw_date;
        self.thaw_time = thaw_time;
        self.isshow = isshow;
        self.isshowfree = isshowfree;
        if(![Context sharedInstance].token) {
            [[AppDelegate sharedDelegate] showLoginViewController:YES];
        }else{
            NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
            if ([isshow isEqualToString:@"1"]) {
                if ([self.isfreeze isEqualToString:@"1"]) {
                    return;
                }
            }else{
                if ([self.isfreeze isEqualToString:@"1"]) {
                                int time = [thaw_time intValue];
                                 int day = time/24/60/60;
                                NSString * attentionstr = nil;
                                if (day > 7) {
                                     attentionstr = @"萌热娘说了，屡教不改的熊宝要严惩！罚你永远关进小黑屋\no(￣ヘ￣o＃)";
                                }else{
                                    attentionstr = [NSString stringWithFormat:@"萌热娘说了，犯了错还屡教不改的熊宝要严惩！罚你关进小黑屋%d天\no(≧口≦)o",day];
                                }
                    AttentionView * attention = [[AttentionView alloc]initTitlestr:attentionstr];
                    [self.view addSubview:attention];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isshow"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    return;
                }
            }
//            if (![self.isshowfree isEqualToString:@"1"]&&![self.isfreeze isEqualToString:@"1"]) {
//                AttentionView * attention = [[AttentionView alloc]initTitlestr:@"账号被解冻啦o(*￣▽￣*)ゞ 下次不要再犯错咯！"];
//                [self.view addSubview:attention];
//                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isshowfree"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }

        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        for(JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
        }
        NSString *authorId = [args[0] toString];
        NSString *commentId = [args[1] toString];
        JSValue *this = [JSContext currentThis];
        NSLog(@"this: %@",this);
        NSLog(@"-------End Log-------");
        //TODO -- 任务回复
        dispatch_async(dispatch_get_main_queue(), ^{
            TaskCommentViewController *taskCommentViewController = [[TaskCommentViewController alloc] init];
            taskCommentViewController.block = ^() {
                AttentionView * attention = [[AttentionView alloc]initTitle:@"回复成功！" andtitle2:@""];
                attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
                attention.label1.frame=CGRectMake(5, 15, 220, 40);
                [self.view addSubview:attention];
            };
            taskCommentViewController.taskId = self.taskId;
            taskCommentViewController.authorId = authorId;
            taskCommentViewController.commentId = commentId;
            [self.navigationController pushViewController:taskCommentViewController animated:YES];
        });
        }
    };
    
    //查看任务图片
    context[@"showBigImage"] = ^() {
//        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
//        for(JSValue *jsVal in args) {
//            NSLog(@"%@", jsVal);
//        }
     
        NSInteger index = [[args[0] toString] integerValue];
        NSString *urlArrayStr = [args[1] toString];
        NSData *jsonData = [urlArrayStr dataUsingEncoding:NSUTF8StringEncoding];
        id jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData
                                        options:NSJSONReadingAllowFragments
                                          error:nil];
        NSArray *urlArray = [MTLJSONAdapter modelsOfClass:[TaskPictureInfo class] fromJSONArray:jsonArray error:nil];
//        NSLog(@"-------------------%@",urlArray);
        [self lookPictures:urlArray atIndex:index];
    };
    
    //点击评论者的图像
    context[@"iconClick"] = ^() {
        NSArray *args = [JSContext currentArguments];
        AuthorDetailViewController *authorDetailViewController = [[AuthorDetailViewController alloc] init];
        authorDetailViewController.authorUid = [args[0] toString];
        authorDetailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:authorDetailViewController animated:YES];
    };

}

- (void)lookPictures:(NSArray *)pictures atIndex:(NSInteger)index {
    LookBigPicViewController *picVC = [[LookBigPicViewController alloc] init];
    NSMutableArray *thumbnailArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *pictureArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
     NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:0];
     NSMutableArray *userNameArray = [NSMutableArray arrayWithCapacity:0];
    for(TaskPictureInfo *pictureInfo in pictures) {
        [thumbnailArray addObject:pictureInfo.url];
        [pictureArray addObject:pictureInfo.url];
        [titleArray addObject:pictureInfo.title];
        [contentArray addObject:pictureInfo.content];
        [userNameArray addObject:pictureInfo.userName];
    }
    [picVC initWithAllBigUrlArray:pictureArray andSmallUrlArray:thumbnailArray andTargets:self andIndex:(index - 1)];
    [picVC userNameDescribe:userNameArray];
    [picVC contentDescribe:contentArray];
    [picVC bigPicDescribe:titleArray];
    
    [picVC pushChildViewControllerFromCenter];
}

- (void)loadData {
    //TOOD --  添加网页url
    NSString * token = [Context sharedInstance].token;
//    NSDictionary *params = @{
//                             @"token":token,
//                             @"id":self.taskId
//                             };
    
    NSDictionary * params = [NSDictionary dictionary];
       NSString * mainurl = [APIConfig mainURL];
    NSString * path = [NSString stringWithFormat:@"%@/%@",mainurl,@"GetVoteInfo"];
    if (token) {
        path = [NSString stringWithFormat:@"%@/%@/%@",path,self.taskId,token];
    }else{
        path = [NSString stringWithFormat:@"%@/%@",path,self.taskId];
    }
    self.requestManager = [AFHTTPRequestOperationManager manager];
    self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil]; // 设置content-Type为text/html
    [self.requestManager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    if (!self.taskInfo) {
        [self.requestManager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * dic = responseObject[@"response"];
            //         NSArray *taskList = [MTLJSONAdapter modelsOfClass:[TaskInfo class] fromJSONArray:dic[@"result"] error:nil];
            //        NSLog(@"%@",dic[@"result"]);
            self.imageUrl = dic[@"result"][@"image"];
            self.titleStr = dic[@"result"][@"title"];
            self.draftStatus = (int)dic[@"result"][@"draftStatus"];
//            self.hasCollected = [dic[@"result"][@"hasCollected"]stringValue];                    NSLog(@"、、、、、、、%@",self.imageUrl);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
        NSString *urlStr = nil;
    if(!self.taskId) {
        urlStr = @"http://139.196.84.154/aimonTel/html/task.html";
    } else {
        if(![Context sharedInstance].token) {
            urlStr = [NSString stringWithFormat:@"%@/goGetVoteInfo/%@", [APIConfig mainURL], self.taskId];
           
        } else {
            urlStr = [NSString stringWithFormat:@"%@/goGetVoteInfo/%@/%@", [APIConfig mainURL], self.taskId, [Context sharedInstance].token];
        
        }
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

- (void)createUI {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(0.0f), SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f - TRANS_VALUE(0.0f))];
    self.webView.backgroundColor = I_COLOR_WHITE;
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
   // [self.webView setScalesPageToFit:YES];
}
#pragma mark - 收藏任务
- (void)collectTask {
    NSString *isfreeze = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfreeze"];
    NSString *thaw_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_date"];
    NSString *thaw_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_time"];
    NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
    NSString *isshowfree = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshowfree"];
  
    //    NSLog(@"%@------%@-----%@",isfreeze,thaw_time,thaw_date);
    self.isfreeze = isfreeze;
    self.thaw_date = thaw_date;
    self.thaw_time = thaw_time;
    self.isshow = isshow;
    self.isshowfree = isshowfree;
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"想收藏，那就先做我们的熊宝吧！" andtitle2:@"ヾ(≧∇≦*)ゝ"];
        [self.view addSubview:attention];
        return;
    }
    if(!self.taskInfo && !self.taskId) {
        return;
    }
    if ([isshow isEqualToString:@"1"]) {
        if ([self.isfreeze isEqualToString:@"1"]) {
            return;
        }
    }else{
        if ([self.isfreeze isEqualToString:@"1"]) {
                        int time = [thaw_time intValue];
                         int day = time/24/60/60;
                        NSString * attentionstr = nil;
                        if (day > 7) {
                             attentionstr = @"萌热娘说了，屡教不改的熊宝要严惩！罚你永远关进小黑屋\no(￣ヘ￣o＃)";
                        }else{
                            attentionstr = [NSString stringWithFormat:@"萌热娘说了，犯了错还屡教不改的熊宝要严惩！罚你关进小黑屋%d天\no(≧口≦)o",day];
                        }
             AttentionView * attention = [[AttentionView alloc]initTitlestr:attentionstr];
            [self.view addSubview:attention];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isshow"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return;
        }
    }
//    if (![self.isshowfree isEqualToString:@"1"]&&![self.isfreeze isEqualToString:@"1"]) {
//        AttentionView * attention = [[AttentionView alloc]initTitlestr:@"账号被解冻啦o(*￣▽￣*)ゞ 下次不要再犯错咯！"];
//        [self.view addSubview:attention];
//        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isshowfree"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//
     NSString *collectStatus = self.taskInfo.collectStatus;
    if (self.hasCollected) {
        collectStatus = self.hasCollected;
    }
    if(!collectStatus) {
        AttentionView *attention = [[AttentionView alloc]initTitle:@"该任务不能进行收藏操作"];
        [self.view addSubview:attention];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:self.taskId forKey:@"taskId"];
    NSString *type = [collectStatus isEqualToString:@"1"] ? @"2" : @"1";
    [params setObject:type forKey:@"type"];
    
    NSString *tipTitle = @"";
    if([collectStatus isEqualToString:@"1"]) {
        tipTitle = @"取消收藏";
    } else if([collectStatus isEqualToString:@"0"]) {
        tipTitle = @"收藏";
    }
    [[IndexAPIRequest sharedInstance] collectTask:params success:^(CommonInfo *resultInfo) {
        if(resultInfo && [resultInfo isSuccess]) {
            if ([tipTitle isEqualToString:@"收藏"]) {
                AttentionView * attention = [[AttentionView alloc]initTitle:@"(｡･∀･)ﾉﾞ嗨，我在收藏栏等你" andtitle2:@""];
                attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
                attention.label1.frame=CGRectMake(5, 15, 220, 40);
                [self.view addSubview:attention];
            }else{
                AttentionView * attention = [[AttentionView alloc]initTitle:@"那，再见啦~" andtitle2:@""];
                attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
                attention.label1.frame=CGRectMake(5, 15, 220, 40);
                [self.view addSubview:attention];
                
            }
//            NSLog(@"collectStatus ========= %@",collectStatus);
            if ([collectStatus isEqualToString:@"0"]) {
                self.taskInfo.collectStatus = @"1";
            }else{
                self.taskInfo.collectStatus = @"0";
            }
//            NSLog(@"\n%@",self.hasCollected);
            if (self.hasCollected) {
                self.hasCollected = @"0";
            }else{
                  self.hasCollected = @"1";
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshHomeTasks object:nil];
        } else {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"收藏失败！" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
//        [TSMessage showNotificationWithTitle:[error localizedDescription] subtitle:nil type:TSMessageNotificationTypeError];
//        AttentionView *attention = [[AttentionView alloc]initTitle:[error localizedDescription]];
//        [self.view addSubview:attention];
    }];
}

#pragma mark - 社交化分享
//社交化分享
- (void)socialShareAction:(id)sender {
    NSString *taskURL = nil;
    if(!self.taskId) {
        taskURL = @"http://139.196.84.154/aimonTel/html/task.html";
    } else {
        if(![Context sharedInstance].token) {
            taskURL = [NSString stringWithFormat:@"%@/shareVoteInfo/%@", [APIConfig mainURL], self.taskId];
        } else {
            taskURL = [NSString stringWithFormat:@"%@/shareVoteInfo/%@/%@", [APIConfig mainURL], self.taskId, [Context sharedInstance].token];
        }
    }
    //1.2、以下参数分别对应：内容、默认内容、图片、标题、链接、描述、分享类型
    NSString *contentStr = [NSString stringWithFormat:@"@all, 分享我最喜爱的任务给小伙伴们, 希望你们喜欢!\n%@", self.titleStr];
        NSString *attachmentURL = @"http://f.hiphotos.bdimg.com/album/w%3D2048/sign=df8f1fe50dd79123e0e09374990c5882/cf1b9d16fdfaaf51e6d1ce528d5494eef01f7a28.jpg";
        if(self.taskInfo.imageUrl) {
            attachmentURL = self.taskInfo.imageUrl;
        }else{
              attachmentURL = self.imageUrl;
        }
//    NSLog(@"taskURL ======================== %@",taskURL);
    //1、创建分享参数
    NSArray* imageArray = @[attachmentURL];
//    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
    
        [ShareCustomView shareWithContentString:contentStr :imageArray :taskURL:@"任务详情"];
    }
    
}

@end
