//
//  DiscoveryDetailViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "PostDetailViewController.h"
#import "PublishCommentViewController.h"
#import "PostDetailTableViewCell.h"
#import "PostDetailView.h"
#import "PopoverView.h"
#import "PostFavorerTableViewCell.h"
#import "CommentTableViewCell.h"
#import "AuthorDetailViewController.h"
#import "ThemeDetailViewController.h"
#import "LookBigPicViewController.h"
#import "TabActionButton.h"
#import "AppDelegate.h"
#import "UIImage+Color.h"
#import "PostDetailInfo.h"
#import "LoginViewController.h"
#import "PostAPIRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "IncubatorViewController.h"
#import "Context.h"
#import "APIConfig.h"
#import "AttentionView.h"
//下拉刷新
#import <MJRefresh/MJRefresh.h>
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import "PublishTaskViewController.h"
#import "ShareCustomView.h"
#import "ProgressHUD.h"
#import "LoginViewController.h"
#import "AFNetworking.h"
@interface PostDetailViewController () <UITableViewDataSource, UITableViewDelegate, CommentTableViewCellDelegate, PostDetailViewDelegate>

@property (strong, nonatomic) UIBarButtonItem *moreButton;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *favorerListButton;
@property (strong, nonatomic) UIButton *disfavorerListButton;
@property (nonatomic,strong)AttentionView * attention;
@property (strong, nonatomic) UIView *bottomBarView;
@property (strong, nonatomic) UITextField *commentTextField;         //评论框
@property (strong, nonatomic) UIButton *favorButton;                 //点赞按钮
@property (strong, nonatomic) UIButton *disfavorButton;              //吐糟按钮
@property (strong, nonatomic) UIButton *commentButton;               //评论按钮

@property (strong, nonatomic) NSMutableArray *commentArray;
@property (strong, nonatomic) NSIndexPath *selectIndexPath;

@property (strong, nonatomic) PostDetailInfo *postDetailInfo;

@property (assign, nonatomic) BOOL isShowFavorers;                   //显示点赞的人

@property (strong, nonatomic) PostCommentInfo *replyCommentInfo;     //要回复的帖子

@property (assign, nonatomic) NSInteger pageNo;
@property (assign, nonatomic) NSInteger pageSize;
@property (nonatomic ,strong)NSMutableArray * dataArray;

@property (copy ,nonatomic) NSString * strTag;
@property (copy ,nonatomic) NSString *reportBtnTag;//举报类型
@property (nonatomic,strong)AFHTTPRequestOperationManager*requestManager;
@property (nonatomic,strong) NSString *isfreeze;
@property (nonatomic,strong) NSString *thaw_date;
@property (nonatomic,strong) NSString *thaw_time;
@property (nonatomic,strong)NSString * isshowfree;
@end
@implementation PostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *isfreeze = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfreeze"];
    NSString *thaw_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_date"];
    NSString *thaw_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_time"];
    NSString *isshowfree = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshowfree"];
    self.isshowfree = isshowfree;
//    NSLog(@"%@------%@-----%@",isfreeze,thaw_time,thaw_date);
    self.isfreeze = isfreeze;
    self.thaw_date = thaw_date;
    self.thaw_time = thaw_time;
     _strTag  =  @"PostDetailView";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"详细内容";
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
    self.pageNo = 1;
    self.pageSize = 10;
    self.dataArray = [NSMutableArray array];
    [self createUI];
   [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPostInfo) name:kNotificationRefreshComments object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert) name:@"showAlert" object:nil];
    
//    [self   tipPostSuccessfulOrFailure];
}
-(void)tipPostSuccessfulOrFailure{
    if ([_send  isEqualToString:@"发布"]) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(showTipView) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
    }

}
-(void)showAlert{
    AttentionView *attention = [[AttentionView alloc]initTitle:@"评论已发送至草稿箱！"];
    [self.view addSubview:attention];
}
-(void)showTipView{
    AttentionView * attention = [[AttentionView alloc]initTitle:@"发帖成功" andtitle2:@""];
    attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
    attention.label1.frame=CGRectMake(5, 15, 220, 40);
    [self.view addSubview:attention];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.replyCommentInfo = nil;
}

- (void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)refreshPostInfo {
    //刷新评论信息
    self.postDetailInfo.commentCount = [NSString stringWithFormat:@"%ld", [self.postDetailInfo.commentCount integerValue] + 1];
    [self.tableView reloadData];
    [self refreshCommentList];
}

- (void)refreshCommentList {
    if(self.postId != nil && ![self.postId isEqualToString:@""]) {
        [self getCommentListOfPost:self.postId];
    }
}

#pragma mark - PostDetailViewDelegate
- (void)authorClickAtItem:(AuthorInfo *)authorInfo {
    if(authorInfo != nil) {
        AuthorDetailViewController *authorDetailViewController = [[AuthorDetailViewController alloc] init];
        authorDetailViewController.authorInfo = authorInfo;
        authorDetailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:authorDetailViewController animated:YES];
    }
}

- (void)themeClickAtItem:(ThemeInfo *)themeInfo {
    if(themeInfo != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //跳转界面
            ThemeDetailViewController *topicDetailViewController = [[ThemeDetailViewController alloc] init];
            topicDetailViewController.themeInfo = themeInfo;
            topicDetailViewController.themeId = themeInfo.tid;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:topicDetailViewController];
            [self presentViewController:navigationController animated:YES completion:^{
            }];
        });
    }
}

- (void)pictureClickAtIndex:(NSInteger)index forImages:(NSArray *)images {
    LookBigPicViewController *picVC = [[LookBigPicViewController alloc] init];
    NSMutableArray *thumbnailArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *pictureArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
    for(PostPictureInfo *pictureInfo in images) {
        [thumbnailArray addObject:pictureInfo.imageUrl];
        [pictureArray addObject:pictureInfo.imageUrl];
        [titleArray addObject:@""];
    }
    [picVC initWithAllBigUrlArray:pictureArray andSmallUrlArray:thumbnailArray andTargets:self andIndex:index];
    [picVC bigPicDescribe:titleArray];
    [picVC pushChildViewControllerFromCenter];
}

#pragma mark - Action
- (void)moreButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    CGPoint point = CGPointMake(button.frame.origin.x + button.frame.size.width * 3 / 4, button.frame.origin.y + button.frame.size.height + 10.0f);
    NSString *collectStatus = self.postDetailInfo.collectStatus;
    if (![Context sharedInstance].token) {
        NSArray *titles = @[@"收藏", @"分享"];
        NSArray *images = @[@"ic_dropdown_collect_off", @"ic_dropdown_share_off"];
        if([collectStatus isEqualToString:@"1"]) {
            titles = @[@"取消收藏", @"分享"];
            images = @[@"ic_dropdown_collect_on", @"ic_dropdown_share_off"];
        } else if([collectStatus isEqualToString:@"2"]){
            titles = @[@"收藏", @"分享"];
            images = @[@"ic_dropdown_collect_off", @"ic_dropdown_share_off"];
        }
        
        PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:images];
         __block PopoverView *poppop = pop;
        pop.selectRowAtIndex = ^(NSInteger index){
            //        NSLog(@"select index:%ld", index);
            if(index == 0) {
                if ([self.isfreeze isEqualToString:@"1"]) {
                    poppop.isshowfree = 1;
                }
                //收藏帖子
                [self collectPost];
            }if (index == 1) {
                //社交化分享
                [self socialShareAction:button];
            }        };
        [pop show];


    }else{
    NSArray *titles = @[@"收藏", @"分享",@"举报"];
    NSArray *images = @[@"ic_dropdown_collect_off", @"ic_dropdown_share_off", @"report"];
    if([collectStatus isEqualToString:@"1"]) {
        titles = @[@"取消收藏", @"分享",@"举报"];
        images = @[@"ic_dropdown_collect_on", @"ic_dropdown_share_off", @"report"];
    } else if([collectStatus isEqualToString:@"2"]){
        titles = @[@"收藏", @"分享",@"举报"];
        images = @[@"ic_dropdown_collect_off", @"ic_dropdown_share_off", @"report"];
    }
        PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:images];
         __block PopoverView *poppop = pop;
        pop.selectRowAtIndex = ^(NSInteger index){
            //        NSLog(@"select index:%ld", index);
            if(index == 0) {
                if ([self.isfreeze isEqualToString:@"1"]) {
                    poppop.isshowfree = 1;
                }
                //收藏帖子
                [self collectPost];
            }if (index == 1) {
                poppop.isshowfree = 0;
                //社交化分享
                [self socialShareAction:button];
            }if(index ==2){
                if ([self.isfreeze isEqualToString:@"1"]) {
                    poppop.isshowfree = 1;
                }
                [self  showReportView];
            }
        };
        [pop show];

      }

}
#pragma mark - 举报弹窗
-(void)showReportView{
    NSString *isfreeze = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfreeze"];
    NSString *thaw_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_date"];
    NSString *thaw_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_time"];
    NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
    NSString *isshowfree = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshowfree"];
   
    //    NSLog(@"%@------%@-----%@",isfreeze,thaw_time,thaw_date);
    self.isfreeze = isfreeze;
    self.thaw_date = thaw_date;
    self.thaw_time = thaw_time;
//    self.isshow = isshow;
    self.isshowfree = isshowfree;

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

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    blackView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6];
    [window addSubview:blackView];
     blackView.tag = 440;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blackViewClick)];
    [blackView addGestureRecognizer:tapGesture];
    UIView *reportView = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(40.0f),TRANS_VALUE(120.0f), SCREEN_WIDTH-TRANS_VALUE(82.0f), TRANS_VALUE(240.0f))];
    reportView.backgroundColor = [UIColor whiteColor];
    reportView.layer.cornerRadius = 5;
    reportView.tag = 441;
    [window addSubview:reportView];
    NSArray *reportItem = @[@"广告等垃圾信息",@"色情信息",@"不友善内容",@"盗文盗图",@"其他",@"取消"];
    for (int i = 0; i < 6; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(TRANS_VALUE(15.0f), i*TRANS_VALUE(40.0f), reportView.frame.size.width, TRANS_VALUE(40.0f))];
        
         [button setTitle:reportItem[i] forState:UIControlStateNormal];
         [button setTitle:reportItem[i] forState:UIControlStateSelected];
         [button setTitle:reportItem[i] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button. contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        button.tag = 10000+i;
        [button addTarget:self action:@selector(reportBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [reportView addSubview:button];
        if(i!=5){
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, i*TRANS_VALUE(40.0f)+TRANS_VALUE(40.0f), reportView.frame.size.width, 1)];
        lineView.backgroundColor = I_BACKGROUND_COLOR;
            [reportView addSubview:lineView];}
        
    }
 
    
}
-(void)reportBtnClick:(UIButton *)Btn{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:440];
    UIView *reportView = [window viewWithTag:441];
    switch (Btn.tag) {
        case 10000:
            self.reportBtnTag = @"1";
            break;
        case 10001:
            self.reportBtnTag = @"2";
             break;
        case 10002:
            self.reportBtnTag = @"3";
             break;
        case 10003:
            self.reportBtnTag = @"4";
             break;
        case 10004:
            self.reportBtnTag = @"5";
             break;
        case 10005:
           self.reportBtnTag = @"6";
        break;
        default:
            break;
    }
    if (Btn.tag==10005) {
      
    }else{
        NSString * token = [Context sharedInstance].token;
        NSString * topicId = self.postId;
        NSString *deviceId = [[UIDevice currentDevice].identifierForVendor UUIDString];
        NSDictionary *params = @{
                                 @"postId" : topicId,
                                 @"deviceId":deviceId,
                                 @"token":token,
                                 @"type":@"1"
                                 };
         NSString * mainurl = [APIConfig mainURL];
        NSString * path = [NSString stringWithFormat:@"%@/%@",mainurl,@"ReportTopic"];
        path = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",path,topicId,deviceId,token,self.reportBtnTag];
        self.requestManager = [AFHTTPRequestOperationManager manager];
        self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil]; // 设置content-Type为text/html
        [self.requestManager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [self.requestManager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * dic = responseObject[@"response"];
                AttentionView *attention = [[AttentionView alloc]initTitle:[NSString stringWithFormat:@"%@",dic[@"message"]]];
                [self.view addSubview:attention];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        }];
}
    
    [blackView removeFromSuperview];
    [reportView removeFromSuperview];

    
}
-(void)blackViewClick{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:440];
    UIView *reportView = [window viewWithTag:441];
    [blackView removeFromSuperview];
    [reportView removeFromSuperview];
    
}
#pragma mark - 收藏任务
- (void)collectPost {
    NSString *isfreeze = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfreeze"];
    NSString *thaw_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_date"];
    NSString *thaw_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_time"];
    NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
    NSString *isshowfree = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshowfree"];
   
    //    NSLog(@"%@------%@-----%@",isfreeze,thaw_time,thaw_date);
    self.isfreeze = isfreeze;
    self.thaw_date = thaw_date;
    self.thaw_time = thaw_time;
//    self.isshow = isshow;
    self.isshowfree = isshowfree;
    if(![Context sharedInstance].token) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"想收藏，那就先做我们的熊宝吧！" andtitle2:@"ヾ(≧∇≦*)ゝ"];
        [self.view addSubview:attention];
    
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
    if(!self.postId) {
        return;
    }
    if(!self.postDetailInfo) {
        return;
    };
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *collectStatus = self.postDetailInfo.collectStatus;
    [params setObject:self.postId forKey:@"postId"];
    NSString *type = [collectStatus isEqualToString:@"1"] ? @"2" : @"1";
    NSString *actionStr = @"收藏";
    if([type isEqualToString:@"1"]) {
        actionStr = @"收藏";
    } else {
        actionStr = @"取消收藏";
    }
    [params setObject:type forKey:@"type"];
//    NSString *messageStr = [NSString stringWithFormat:@"正在%@帖子...", actionStr];
    [[PostAPIRequest sharedInstance] collectPost:params success:^(CommonInfo *resultInfo) {
        if(resultInfo && [resultInfo isSuccess]) {

            if ([actionStr isEqualToString:@"收藏"]) {
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
           
            self.postDetailInfo.collectStatus = [self.postDetailInfo.collectStatus isEqualToString:@"1"] ? @"2" : @"1";
        } else {

                    }
    } failure:^(NSError *error) {

    }];
    
}

#pragma mark - Action
- (void)showFavorerList:(UIButton *)sender {
    //TODO -- 显示点赞的人
    self.isShowFavorers = YES;
    [self.favorerListButton setSelected:YES];
    [self.disfavorerListButton setSelected:NO];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - CommentTableViewCellDelegate
- (void)clickAuthorAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < [self.commentArray count]) {
        //TODO －－ 作者详情
        self.replyCommentInfo = [self.commentArray objectAtIndex:indexPath.row];
        AuthorDetailViewController *authorDetailViewController = [[AuthorDetailViewController alloc] init];
        authorDetailViewController.authorInfo = self.replyCommentInfo.author;
        [self.navigationController pushViewController:authorDetailViewController animated:YES];
    }
}
- (void)replyCommentAtIndexPath:(NSIndexPath *)indexPath {
    //TODO -- 回复按钮
    if(indexPath.row < [self.commentArray count]) {
        self.replyCommentInfo = [self.commentArray objectAtIndex:indexPath.row];
        if(!self.postDetailInfo || !self.postDetailInfo.pid) {
            return;
        }
        if(![Context sharedInstance].userInfo ||
           ![Context sharedInstance].token) {
           [[AppDelegate sharedDelegate] showLoginViewController:YES];
            return;
        }
        PublishCommentViewController *publishCommentViewController = [[PublishCommentViewController alloc] init];
        _strTag  =  @"PostDetailView";
        
        publishCommentViewController.strTag = _strTag ;
        publishCommentViewController.block = ^() {
                AttentionView * attention = [[AttentionView alloc]initTitle:@"回复成功" andtitle2:@""];
                attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
                attention.label1.frame=CGRectMake(5, 15, 220, 40);
                [self.view addSubview:attention];
        };
        
        publishCommentViewController.postDetailInfo = self.postDetailInfo;
        publishCommentViewController.replyCommentInfo = self.replyCommentInfo;
        publishCommentViewController.draftCommentInfo = nil;
        publishCommentViewController.type = CommentSourceTypeNew;
        [self.navigationController pushViewController:publishCommentViewController animated:YES];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TRANS_VALUE(48.0f);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(48.0f))];
    view.backgroundColor = I_BACKGROUND_COLOR;
    CGFloat height = TRANS_VALUE(40.0f);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(8.0f), SCREEN_WIDTH, height)];
    
    headerView.backgroundColor = I_BACKGROUND_COLOR;
   // headerView.backgroundColor = [UIColor redColor];
    UIView *actionBarView = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(0.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
    actionBarView.backgroundColor = I_COLOR_WHITE;
    [headerView addSubview:actionBarView];
    UILabel *commentLab = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(16.0f), TRANS_VALUE(5.0f),SCREEN_WIDTH/2 - TRANS_VALUE(16.0f), TRANS_VALUE(34.0f))];
    commentLab.textAlignment =NSTextAlignmentLeft;
    NSString *commentCount = self.postDetailInfo.commentCount != nil ? self.postDetailInfo.commentCount : @"0";
    NSString *commentTitle = [NSString stringWithFormat:@"评论 %@", commentCount];
    commentLab.textColor = I_COLOR_GRAY;

    commentLab.text = commentTitle;
    
    [actionBarView addSubview:commentLab];
UILabel *favorerLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 , TRANS_VALUE(5.0f), SCREEN_WIDTH/2 - TRANS_VALUE(16.0f), TRANS_VALUE(34.0f))];
    NSString *favorCount = self.postDetailInfo.favorCount != nil ? self.postDetailInfo.favorCount : @"0";
    NSString *favorTitle = [NSString stringWithFormat:@"赞 %@", favorCount];
    favorerLab.textColor = I_COLOR_GRAY ;
    favorerLab.textAlignment = NSTextAlignmentRight;

     favorerLab.text = favorTitle;
    
    [actionBarView addSubview:favorerLab];
    UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(39.0f), SCREEN_WIDTH, TRANS_VALUE(0.5f))];
    dividerView.backgroundColor = I_DIVIDER_COLOR;
    [actionBarView addSubview:dividerView];
    [view addSubview:headerView];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        NSInteger count = self.commentArray != nil ? self.commentArray.count : 0;
        return count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < [self.commentArray count]) {
        PostCommentInfo *commentInfo = (PostCommentInfo *)[self.commentArray objectAtIndex:indexPath.row];
        CGFloat height = [CommentTableViewCell heightForCell:indexPath withCommentInfo:commentInfo];
        return height;
    } else {
        return TRANS_VALUE(0.0f);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CommentTableViewCell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ([self.isfreeze isEqualToString:@"1"]) {
        cell.userInteractionEnabled = NO;
    }else{
         cell.userInteractionEnabled = YES;
    }
    if(indexPath.row < [self.commentArray count]) {
        PostCommentInfo *commentInfo = (PostCommentInfo *)[self.commentArray objectAtIndex:indexPath.row];
        cell.commentInfo = commentInfo;
    }
    cell.selectIndexPath = indexPath;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *isfreeze = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfreeze"];
    NSString *thaw_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_date"];
    NSString *thaw_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_time"];
    NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
    NSString *isshowfree = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshowfree"];
  
    //    NSLog(@"%@------%@-----%@",isfreeze,thaw_time,thaw_date);
    self.isfreeze = isfreeze;
    self.thaw_date = thaw_date;
    self.thaw_time = thaw_time;
//    self.isshow = isshow;
    self.isshowfree = isshowfree;
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

    if (indexPath.section==0) {
        if(indexPath.row < [self.commentArray count]) {
            self.replyCommentInfo = [self.commentArray objectAtIndex:indexPath.row];
            if(!self.postDetailInfo || !self.postDetailInfo.pid) {
                return;
            }
            if(![Context sharedInstance].userInfo ||
               ![Context sharedInstance].token) {
                [[AppDelegate sharedDelegate] showLoginViewController:YES];
                return;
            }
            PublishCommentViewController *publishCommentViewController = [[PublishCommentViewController alloc] init];
            
            
            _strTag  =  @"PostDetailView2";
            
            publishCommentViewController.strTag = _strTag ;

            
            publishCommentViewController.block = ^() {
                AttentionView * attention = [[AttentionView alloc]initTitle:@"回复成功！" andtitle2:@""];
                attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
                attention.label1.frame=CGRectMake(5, 15, 220, 40);
                [self.view addSubview:attention];
            };
            
            publishCommentViewController.postDetailInfo = self.postDetailInfo;
            publishCommentViewController.replyCommentInfo = self.replyCommentInfo;
            publishCommentViewController.draftCommentInfo = nil;
            publishCommentViewController.type = CommentSourceTypeNew;
            [self.navigationController pushViewController:publishCommentViewController animated:YES];
        }

        
    }
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < [self.commentArray count]) {
        if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    } else {
        if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
        }
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
        }
    }
}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(indexPath.section == 0) {
////        return UITableViewCellEditingStyleDelete;
//    } else {
//        return UITableViewCellEditingStyleNone;
//    }
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(editingStyle == UITableViewCellEditingStyleDelete) {
//        self.selectIndexPath = indexPath;
//    }
//}

//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = self.tableView.tableHeaderView.frame.size.height;
//    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}



#pragma mark - Private Method
- (void)loadData {
    [self getPostDetailInfo:self.postId];
}

- (void)getPostDetailInfo:(NSString *)postId {
    if(!postId) {
        return;
    }
    self.postDetailInfo = nil;
    NSDictionary *params = @{
                             @"postId" : postId,
                             };
    [ProgressHUD show:nil];
    [[PostAPIRequest sharedInstance] getPostInfo:params success:^(PostDetailInfo *detailInfo) {
        if(detailInfo) {
             [ProgressHUD dismiss];
            self.postDetailInfo = detailInfo;
            //TODO － fixed
//            NSLog(@"content ==== %@",self.postDetailInfo.content);
            if(!self.postDetailInfo.commentCount) {
                self.postDetailInfo.commentCount = @"0";
            }
            if(!self.postDetailInfo.createTime) {
                self.postDetailInfo.createTime = @"未知时间";
            }
            if(self.postDetailInfo.favorStatus != nil && [self.postDetailInfo.favorStatus isEqualToString:@"1"]) {
                [self.favorButton setSelected:YES];
            } else {
                [self.favorButton setSelected:NO];
            }
                PostDetailView *headerView = [[PostDetailView alloc] initWithPostInfo:self.postDetailInfo andDataArray:self.pictureArray];
                headerView.delegate = self;
                self.tableView.tableHeaderView = headerView;
            if ([self.fromWhere isEqualToString:@"ReplyCommentViewController"]) {
                self.fromWhere = nil;
//                [self loadData];
            }
        } else {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
            self.tableView.tableHeaderView = headerView;
        }
         [self getCommentListOfPost:self.postId];
    } failure:^(NSError *error) {
         [ProgressHUD dismiss];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.tableHeaderView = headerView;
        [self.tableView reloadData];
    }];
}
- (void)refreshPostDetailInfo:(NSString *)postId {
    if(!postId) {
        return;
    }
    self.postDetailInfo = nil;
    
    NSDictionary *params = @{
                             @"postId" : postId,
                             };
    [[PostAPIRequest sharedInstance] getPostInfo:params success:^(PostDetailInfo *detailInfo) {
        if(detailInfo) {
            self.postDetailInfo = detailInfo;
            //TODO － fixed
            if(!self.postDetailInfo.commentCount) {
                self.postDetailInfo.commentCount = @"0";
            } 
            if(!self.postDetailInfo.createTime) {
                self.postDetailInfo.createTime = @"未知时间";
            }
            if(self.postDetailInfo.favorStatus != nil && [self.postDetailInfo.favorStatus isEqualToString:@"1"]) {
                [self.favorButton setSelected:YES];
            } else {
                [self.favorButton setSelected:NO];
            }
            PostDetailView *headerView = [[PostDetailView alloc] initWithPostInfo:self.postDetailInfo andDataArray:self.dataArray];
                headerView.delegate = self;
                self.tableView.tableHeaderView = headerView;
        } else {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
            self.tableView.tableHeaderView = headerView;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.tableHeaderView = headerView;
        [self.tableView reloadData];
    }];
}

- (void)getCommentListOfPost:(NSString *)postId {
    if(!self.commentArray) {
        self.commentArray = [NSMutableArray arrayWithCapacity:0];
    }
    self.pageNo = 1;
    self.pageSize = 10;
    [self.commentArray removeAllObjects];
    if(!postId ) {
        return;
    }
    [self.tableView.mj_footer resetNoMoreData];
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
    NSDictionary *params = @{
                             @"postId" : postId,
                             @"pageNo" : pageNo,
                             @"pageSize" : pageSize
                             };
    [[PostAPIRequest sharedInstance] getPostComments:params success:^(NSArray *commentArray) {
        if(commentArray ) {
            [self.commentArray addObjectsFromArray:commentArray];
            if(commentArray.count >= self.pageSize) {
                self.pageNo ++;
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
        if(self.type != nil && [self.type isEqualToString:@"fromComment"] && self.commentArray.count > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
          [self   tipPostSuccessfulOrFailure];//发布帖子  加载后 出现的提示弹框（已优化系列）
        
    } failure:^(NSError *error) {
        //[SVProgressHUD dismiss];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreComments {
    if(!self.postId ) {
        return;
    }
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
    NSDictionary *params = @{
                             @"postId" : self.postId,
                             @"pageNo" : pageNo,
                             @"pageSize" : pageSize
                             };
    [[PostAPIRequest sharedInstance] getPostComments:params success:^(NSArray *commentArray) {
        if(commentArray) {
            [self.commentArray addObjectsFromArray:commentArray];
            if(commentArray.count >= self.pageSize) {
                self.pageNo ++;
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
    }];
}


- (void)createUI {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f - TRANS_VALUE(36.0f)) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = UIColorFromRGB(0xdcdcdc);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = I_BACKGROUND_COLOR;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    //获取UITableView的header
    CGFloat height = TRANS_VALUE(620.0f);
    height = TRANS_VALUE(0.0f);
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    headerView.contentMode = UIViewContentModeScaleToFill;
    headerView.image = [UIImage imageNamed:@"bg_topic_detail"];
    self.tableView.tableHeaderView = headerView;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MyRefreshFooter *footer = [MyRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    self.tableView.mj_footer = footer;
    
    self.bottomBarView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64.0f - TRANS_VALUE(36.0f), SCREEN_WIDTH, TRANS_VALUE(36.0f))];
    self.bottomBarView.backgroundColor = I_COLOR_WHITE;
   
    if (self.navigationController.navigationBar.frame.size.height == 44) {
         [self.view addSubview:self.bottomBarView];
    }else{
        self.bottomBarView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64.0f - TRANS_VALUE(36.0f)-44, SCREEN_WIDTH, TRANS_VALUE(36.0f))];
    }
    self.favorButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, TRANS_VALUE(36.0f))];
    self.favorButton.backgroundColor = I_COLOR_WHITE;
    [self.favorButton setImage:[UIImage imageNamed:@"ic_action_favor_undo"] forState:UIControlStateNormal];
    [self.favorButton setImage:[UIImage imageNamed:@"ic_action_favor_done"] forState:UIControlStateHighlighted];
    [self.favorButton setImage:[UIImage imageNamed:@"ic_action_favor_done"] forState:UIControlStateSelected];
    [self.favorButton setTitle:@"赞" forState:UIControlStateNormal];
    [self.favorButton setTitleColor:I_COLOR_33BLACK forState:UIControlStateNormal];
    [self.favorButton setTitleColor:I_COLOR_YELLOW forState:UIControlStateHighlighted];
    [self.favorButton setTitleColor:I_COLOR_YELLOW forState:UIControlStateSelected];
    self.favorButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(10.0f)];
    self.favorButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.favorButton setTitleEdgeInsets:UIEdgeInsetsMake(0, TRANS_VALUE(5.0f), 0, 0)];
    [self.bottomBarView addSubview:self.favorButton];
    
    self.commentButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, TRANS_VALUE(36.0f))];
    self.commentButton.backgroundColor = I_COLOR_WHITE;
    [self.commentButton setImage:[UIImage imageNamed:@"ic_action_comment_undo"] forState:UIControlStateNormal];
    [self.commentButton setTitleColor:I_COLOR_33BLACK forState:UIControlStateNormal];
    [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
    self.commentButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(10.0f)];
    self.commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0, TRANS_VALUE(5.0f), 0, 0)];
    [self.bottomBarView addSubview:self.commentButton];
    
//    if ([self.isfreeze isEqualToString:@"1"]) {
//        self.favorButton.userInteractionEnabled = NO;
//        self.commentButton.userInteractionEnabled = NO;
//    }else{
//        self.favorButton.userInteractionEnabled = YES;
//        self.commentButton.userInteractionEnabled = YES;
//    }

    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 1.0f, TRANS_VALUE(8.0f), 1.0f, TRANS_VALUE(20.0f))];
    imgView.image=[UIImage imageNamed:@"ic_post_midline"];

    
    [self.bottomBarView addSubview:imgView];
    
    UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1.0f)];
    dividerView.backgroundColor = I_DIVIDER_COLOR;
    [self.bottomBarView addSubview:dividerView];
    
    [self.commentButton addTarget:self action:@selector(commentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.favorButton addTarget:self action:@selector(favorButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"CommentTableViewCell"];
    //设置tableview分割线
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Action
- (void)commentButtonAction {
    NSString *isfreeze = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfreeze"];
    NSString *thaw_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_date"];
    NSString *thaw_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_time"];
    NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
    NSString *isshowfree = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshowfree"];
  
    //    NSLog(@"%@------%@-----%@",isfreeze,thaw_time,thaw_date);
    self.isfreeze = isfreeze;
    self.thaw_date = thaw_date;
    self.thaw_time = thaw_time;
//    self.isshow = isshow;
    self.isshowfree = isshowfree;
    if(!self.postDetailInfo || !self.postDetailInfo.pid) {
        return;
    }
    if(![Context sharedInstance].userInfo ||
       ![Context sharedInstance].token) {
        if ([self.fromWhere isEqualToString:@"ThemeDetail"]) {
            LoginViewController * login = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
            return;
        }else{
        [[AppDelegate sharedDelegate] showLoginViewController1:YES];
            return;
        }

       
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
    PublishCommentViewController *publishCommentViewController = [[PublishCommentViewController alloc] init];
    _strTag  =  @"PostDetailView3";
    
    publishCommentViewController.strTag = _strTag ;
    
    publishCommentViewController.block = ^(){
        AttentionView * attention = [[AttentionView alloc]initTitle:@"评论成功！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
    };
    
    
    publishCommentViewController.postDetailInfo = self.postDetailInfo;
    publishCommentViewController.replyCommentInfo = nil;
    publishCommentViewController.draftCommentInfo = nil;
    publishCommentViewController.isComment = YES;
    publishCommentViewController.type = CommentSourceTypeNew;
    [self.navigationController pushViewController:publishCommentViewController animated:YES];
}
- (void)favorButtonAction {
    NSString *isfreeze = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfreeze"];
    NSString *thaw_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_date"];
    NSString *thaw_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_time"];
    NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
    NSString *isshowfree = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshowfree"];
       //    NSLog(@"%@------%@-----%@",isfreeze,thaw_time,thaw_date);
    self.isfreeze = isfreeze;
    self.thaw_date = thaw_date;
    self.thaw_time = thaw_time;
//    self.isshow = isshow;
    self.isshowfree = isshowfree;
    if (self.attention) {
        self.attention.hidden = YES;
    }
    NSString *type = @"1";
    if([self.postDetailInfo.favorStatus isEqualToString:@"1"]) {
        type = @"3";
    }
    if(![Context sharedInstance].token) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"点赞是熊宝哒特权！" andtitle2:@"*/ω＼*)"];
        [self.view addSubview:attention];
        return;
    }
//    NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
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

    if ([type isEqualToString:@"1"]) {
        self.attention = [[AttentionView alloc]initTitle:@"阿里嘎多！"];
        [self.view addSubview:self.attention];
    }else{
        AttentionView *attentionView = [[AttentionView alloc]initTitle:@"啊嘞？"];
        [self.view addSubview:attentionView];
    }
    [self actPostWithType:type];
}
- (void)actPostWithType:(NSString *)type {
    NSDictionary * params = nil;
    if (self.postId) {
         params = @{
                                 @"postId": self.postId,
                                 @"favorType" : type
                                 };
    }
    [[PostAPIRequest sharedInstance] favorPost:params success:^(CommonInfo *resultInfo) {
        if(resultInfo && [resultInfo isSuccess]) {
            [self refreshPostDetailInfo:self.postId];
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                if (self.postId) {
                    [dic setObject:self.postId forKey:@"postId"];
                }
                [dic setObject:@"1" forKey:@"isRefrese"];
                NSNotification * noti = [NSNotification notificationWithName:kNotificationRefreshPosts object:nil userInfo:dic];
               [[NSNotificationCenter defaultCenter] postNotification:noti];
            
        } else {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 社交化分享
//社交化分享
- (void)socialShareAction:(id)sender {
    //1、构造分享内容
    //1.1、要分享的图片（以下分别是网络图片和本地图片的生成方式的示例）
    NSString *attachmentURL = nil;
    if(self.postDetailInfo.images.count > 0) {
        PostPictureInfo *pictureInfo = (PostPictureInfo *)[self.postDetailInfo.images objectAtIndex:0];
        if(pictureInfo.imageUrl) {
            attachmentURL = pictureInfo.imageUrl;
        }
    }
    NSString *postDetailUrl = @"http://www.mob.com";
    if(self.postDetailInfo.pid) {
        postDetailUrl = [NSString stringWithFormat:@"%@/%@", [APIConfig postDetailURL], self.postDetailInfo.pid];
    }
   
    
    //1.2、以下参数分别对应：内容、默认内容、图片、标题、链接、描述、分享类型
    NSString *contentStr = [NSString stringWithFormat:@"@all, 分享我喜欢的帖子给小伙伴们，希望你们喜欢!\n%@", self.postDetailInfo.title];
    NSArray* imageArray = nil;
    //1、创建分享参数
    if (attachmentURL) {
        imageArray = @[attachmentURL];
    }
//    if (imageArray) {
         [ShareCustomView shareWithContentString:contentStr :imageArray :postDetailUrl:@"帖子详情"];
//    }
    
}

@end
