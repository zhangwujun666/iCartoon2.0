//
//  EverydayViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright © 2015年 wonders. All rights reserved.
//
#import "HomeViewController.h"
#import "ThemeDetailViewController.h"
#import "TaskDetailViewController.h"
#import "PostDetailViewController.h"
#import "TaskListViewController.h"
#import "NewSearchViewController.h"
#import "WebViewController.h"
#import "AllThemeViewController.h"
#import "MorePostsViewController.h"
#import "MoreCommodityViewController.h"
#import "MyCommentsViewController.h"
#import "PublishCommentViewController.h"
#import "ThemeDrawerViewController.h"
#import "AuthorDetailViewController.h"
#import "UserAPIRequest.h"
#import "TopScrollTableViewCell.h"
#import "TaskTableViewCell.h"
#import "ThemeTableViewCell.h"
#import "PostTableViewCell.h"
#import "CommodityTableViewCell.h"
#import "AppDelegate.h"
#import "TopicButton.h"
#import "TopicItem.h"
#import "LoginSucAttentionView.h"
#import "Context.h"
#import "APIConfig.h"
#import "PostAPIRequest.h"
#import "IndexAPIRequest.h"
#import "IncubatorAPIRequest.h"
#import "MeAPIRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "UIButton+Webcache.h"
//下拉刷新，上拉加载
#import <MJRefresh/MJRefresh.h>
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import "MyMessageNewViewController.h"
#import "AttentionView.h"
#import "LoginViewController.h"
#import "WZArrowButton.h"
@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, TopScrollTableViewCellDelegate, ThemeTableViewCellDelegate, TaskTableViewCellDelegate, PostTableViewCellDelegate, LoginSucAttentionViewDelegate>

@property (strong, nonatomic) UIBarButtonItem *menuButton;
@property (strong, nonatomic) UIBarButtonItem * mEssageButton;
@property (strong, nonatomic) UIButton * messageButton;

@property (weak, nonatomic) LoginSucAttentionView *attentionView;//登录成功关注
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *bannerArray;
@property (strong, nonatomic) NSMutableArray *taskArray;
@property (strong, nonatomic) NSMutableArray *themeArray;
@property (strong, nonatomic) NSMutableArray *postArray;
@property (strong, nonatomic) NSMutableArray *commodityArray;

@property (assign, nonatomic) NSInteger pageNo;
@property (assign, nonatomic) NSInteger pageSize;
//首页刷新
@property (strong, nonatomic) NSString *refreshTime;
@property (strong, nonatomic) NSString *loadTime;
@property (strong, nonatomic) NSString *prePostId;
@property (strong,nonatomic)  NSMutableArray * messageArray;
@property (strong,nonatomic)NSMutableArray * isReadArray;
@property (nonatomic,strong) NSString *isfreeze;
@property (nonatomic,strong) NSString *thaw_date;
@property (nonatomic,strong) NSString *thaw_time;
@property (nonatomic,strong)NSString * isshow;
@property (nonatomic,strong)NSString * isshowfree;
@end

@implementation HomeViewController

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
    [self setNavigationButtons];
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeTasks) name:kNotificationRefreshHomeTasks object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomePosts) name:kNotificationRefreshPosts object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAttentionView) name:kNotificationShowAttention object:nil];
    
    //记载新数据
    self.pageNo = 1;
    self.pageSize = 10;
    self.refreshTime = @"";
    self.prePostId = @"";
    self.loadTime = @"";
    [self loadNewData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
}
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIImageView *navBarHairlineImageView;
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    navBarHairlineImageView.hidden = YES;
    if( [Context sharedInstance].token) {
        [self  belling];
    }else{
        [_messageButton setImage:[UIImage imageNamed:@"ic_navi_message_off"] forState:UIControlStateNormal];
        [_messageButton setImage:[UIImage imageNamed:@"ic_navi_message_off"] forState:UIControlStateFocused];
        [_messageButton setImage:[UIImage imageNamed:@"ic_navi_message_off"] forState:UIControlStateSelected];
    }
}
//设置Navigation上的按钮
- (void)setNavigationButtons {
    //搜索按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, CONVER_VALUE(290.0f), 30)];
    button.backgroundColor = I_COLOR_WHITE;
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 4.0f;
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button setTitleColor:I_COLOR_GRAY forState:UIControlStateNormal];
    [button setTitleColor:I_COLOR_GRAY forState:UIControlStateHighlighted];
    [button setTitleColor:I_COLOR_GRAY forState:UIControlStateSelected];
    NSString *titleStr = @"可以搜索社区和商城哟ヽ(•ω•)ゝ";
    [button setTitle:titleStr forState:UIControlStateNormal];
    [button setTitle:titleStr forState:UIControlStateHighlighted];
    [button setTitle:titleStr forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"ic_search_gay"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"ic_search_gay"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"ic_search_gay"] forState:UIControlStateSelected];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 9, 0, 0)];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = button;
    
    UIButton *mMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(CONVER_VALUE(-20.0f), 0, CONVER_VALUE(25.5f), CONVER_VALUE(22.5f))];
    [mMenuButton setImage:[UIImage imageNamed:@"ic_navi_menu"] forState:UIControlStateNormal];
    [mMenuButton setImage:[UIImage imageNamed:@"ic_navi_menu"] forState:UIControlStateFocused];
    [mMenuButton setImage:[UIImage imageNamed:@"ic_navi_menu"] forState:UIControlStateSelected];
    [mMenuButton setImageEdgeInsets:UIEdgeInsetsMake(0, CONVER_VALUE(-11.0f), 0, 0)];
    [mMenuButton addTarget:self action:@selector(menuButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.menuButton = [[UIBarButtonItem alloc] initWithCustomView:mMenuButton];
    self.navigationItem.leftBarButtonItem = self.menuButton;
    
    _messageButton = [[UIButton alloc] initWithFrame:CGRectMake(CONVER_VALUE(18.0f), 0,  CONVER_VALUE(16.0f), CONVER_VALUE(25.0f))];
    [_messageButton setImageEdgeInsets:UIEdgeInsetsMake(0,CONVER_VALUE(5.0f), 0,CONVER_VALUE(-10.0f))];
    [_messageButton setImage:[[UIImage imageNamed:@"ic_navi_message_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_messageButton setImage:[UIImage imageNamed:@"ic_navi_message_off"] forState:UIControlStateFocused];
    [_messageButton setImage:[UIImage imageNamed:@"ic_navi_message_off"] forState:UIControlStateSelected];
        [_messageButton addTarget:self action:@selector(messageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.mEssageButton = [[UIBarButtonItem alloc] initWithCustomView:_messageButton];
    self.navigationItem.rightBarButtonItem = self.mEssageButton;
     if( [Context sharedInstance].token) {
      [self  belling];
     }
}
- (void)refreshHomeTasks {
    [self getHomeTasks];
}
- (NSMutableArray *)isReadArray{
    if (!_isReadArray) {
        _isReadArray = [NSMutableArray array];
    }
    return _isReadArray;
}
-(void)belling{
    if(!self.messageArray) {
        self.messageArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.messageArray removeAllObjects];
    
    [[MeAPIRequest  sharedInstance]  getMessageList:nil success:^(NSArray *messageList) {
        [self.isReadArray removeAllObjects];
        for (int i = 0; i < messageList.count; i++) {
             MessageInfo * infor = messageList[i];
            if ([infor.status isEqualToString:@"0"]) {
                [self.isReadArray addObject:infor.status];
            }
        }
        if(messageList) {
            [self.messageArray addObjectsFromArray:messageList];
        }
      
        if (self.messageArray.count != 0 && self.isReadArray.count!= 0) {
            
            [_messageButton setImage:[UIImage imageNamed:@"ic_navi_message"] forState:UIControlStateNormal];
            [_messageButton setImage:[UIImage imageNamed:@"ic_navi_message"] forState:UIControlStateFocused];
            [_messageButton setImage:[UIImage imageNamed:@"ic_navi_message"] forState:UIControlStateSelected];
        }else{
            [_messageButton setImage:[UIImage imageNamed:@"ic_navi_message_off"] forState:UIControlStateNormal];
            [_messageButton setImage:[UIImage imageNamed:@"ic_navi_message_off"] forState:UIControlStateFocused];
            [_messageButton setImage:[UIImage imageNamed:@"ic_navi_message_off"] forState:UIControlStateSelected];
        }
    } failure:^(NSError *error) {
        [self.tableView reloadData];
    }];
    
}

- (void)refreshHomePosts {
    //获取首页帖子列表
    [self getHomePostsWithTheme:nil];
}

//显示关注弹框
- (void)showAttentionView {
    AttentionView * attention = [[AttentionView alloc]initTitle:@"获得称谓“熊宝”" andtitle2:@""];
    attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
    attention.label1.frame=CGRectMake(5, 15, 220, 40);
    [self.view  addSubview:attention];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.6];
}
- (void)delayMethod{
    [self.attentionView show];
}

#pragma mark LoginSucAttentionViewDelegate
- (void)attentItemsArr:(NSArray *)itemsArr {
    if(![Context sharedInstance].token) {
        [Context sharedInstance].userInfo = nil;
        return;
    }
    
    NSMutableArray *themeIds = [NSMutableArray arrayWithCapacity:0];
    for(int i = 0, n = (int)itemsArr.count; i < n; i++) {
        ThemeInfo *themeInfo = (ThemeInfo *)[itemsArr objectAtIndex:i];
        [themeIds addObject:themeInfo.tid];
    }
    NSDictionary *params = @{@"token" : [Context sharedInstance].token, @"type" : @"1", @"themeIds": themeIds};
    [[UserAPIRequest sharedInstance] followThemes:params success:^(CommonInfo *result) {
       // [SVProgressHUD dismiss];
        if([result isSuccess]) {
            ///关注成功后跳转
            [self.attentionView hidden];
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(delayMethod1) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
            
        } else {
        }
    } failure:^(NSError *error) {
       // [SVProgressHUD dismiss];
    }];
    
}
- (void)delayMethod1{
    AttentionView * attention = [[AttentionView alloc]initTitle:@"欢迎加入熊窝！"];
    [self.view addSubview:attention];
}
//菜单按钮点击事件
- (void)menuButtonAction {
    ThemeDrawerViewController *themeDrawerViewController = [[ThemeDrawerViewController alloc] init];
    themeDrawerViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:themeDrawerViewController animated:YES];
}

//消息按钮点击事件
- (void)messageButtonAction {
    if(![Context sharedInstance].token) {
    [[AppDelegate sharedDelegate] showLoginViewController:YES];
    } else {
        
        MyMessageNewViewController *messageViewController = [[MyMessageNewViewController alloc] init];
        messageViewController.hidesBottomBarWhenPushed = YES;
        

        [_messageButton setImage:[UIImage imageNamed:@"ic_navi_message_off"] forState:UIControlStateNormal];
        [_messageButton setImage:[UIImage imageNamed:@"ic_navi_message_off"] forState:UIControlStateFocused];
        [_messageButton setImage:[UIImage imageNamed:@"ic_navi_message_off"] forState:UIControlStateSelected];
   
        [self.navigationController pushViewController:messageViewController animated:YES];
        
    }

}

//搜索按钮点击事件
- (void)searchAction {
    NewSearchViewController *searchViewController = [[NewSearchViewController alloc] init];
    searchViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchViewController animated:YES];
}

//更多按钮点击事件
- (void)moreButtonAction:(id)sender {
    NSInteger index = ((UIButton *)sender).tag - 5000;
    if(index == 1) {
        //更多任务按钮
        TaskListViewController *taskListViewController = [[TaskListViewController alloc] init];
        taskListViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:taskListViewController animated:YES];
    } else if(index == 2) {
        //更多熊巢
        ThemeDrawerViewController *themeDrawerViewController = [[ThemeDrawerViewController alloc] init];
        themeDrawerViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:themeDrawerViewController animated:YES];

//        AllThemeViewController *moreThemeViewController = [[AllThemeViewController alloc] init];
//        moreThemeViewController.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:moreThemeViewController animated:YES];
    } else {
        //更多热议
        MorePostsViewController *morePostsViewController = [[MorePostsViewController alloc] init];
        morePostsViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:morePostsViewController animated:YES];
    }
}

#pragma mark - TaskTableViewCellDelegate
- (void)collectTaskForItem:(TaskInfo *)taskItem atIndexPath:(NSIndexPath *)indexPath {
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
    if ([self.isshow isEqualToString:@"1"]) {
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

    if(taskItem) {
        [self collectTask:taskItem atIndexPath:indexPath];
    }
}

//收藏任务
- (void)collectTask:(TaskInfo *)taskInfo atIndexPath:(NSIndexPath *)indexPath {
    if(!taskInfo || !taskInfo.tid) {
        return;
    }
    NSString *collectStatus = taskInfo.collectStatus;
    if(!collectStatus) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"该任务不能进行收藏操作！"];
        [self.view addSubview:attention];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:taskInfo.tid forKey:@"taskId"];
    NSString *type = [collectStatus isEqualToString:@"1"] ? @"2" : @"1";
    [params setObject:type forKey:@"type"];
    
    NSString *tipTitle = @"";
    if([collectStatus isEqualToString:@"1"]) {
        tipTitle = @"取消收藏";
  
        AttentionView * attention = [[AttentionView alloc]initTitle:@"那，再见啦~"];

        [self.view addSubview:attention];
        
    } else if([collectStatus isEqualToString:@"0"]) {
        tipTitle = @"收藏";
      
        AttentionView * attention = [[AttentionView alloc]initTitle:@"(｡･∀･)ﾉﾞ嗨，我在收藏栏等你"];
        [self.view addSubview:attention];

        
    }
    [[IndexAPIRequest sharedInstance] collectTask:params success:^(CommonInfo *resultInfo) {
        if(resultInfo && [resultInfo isSuccess]) {
            if(indexPath.row < self.taskArray.count) {
                TaskInfo *taskInfo = [self.taskArray objectAtIndex:indexPath.row];
                taskInfo.collectStatus = [taskInfo.collectStatus isEqualToString:@"1"] ? @"0" : @"1";
                [self.taskArray replaceObjectAtIndex:indexPath.row withObject:taskInfo];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            }
        } else {
            AttentionView * attention = [[AttentionView alloc]initTitle:[NSString stringWithFormat:@"%@失败", tipTitle]];

            [self.view addSubview:attention];
            
        }
    } failure:^(NSError *error) {

    }];
}

#pragma mark - ThemeTableViewCellDelegate
- (void)themeButtonClickedAtItem:(ThemeInfo *)themeInfo {
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

#pragma mark - PostTableViewCellDelegate
- (void)commentPostForItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath {
    if(![Context sharedInstance].token) {
        PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
        PostInfo *postInfo = [self.postArray objectAtIndex:indexPath.row];
        postDetailViewController.postId = postInfo.pid;
        postDetailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:postDetailViewController animated:YES];
        return;
    }
    if(postInfo != nil && postInfo.pid != nil) {
        PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
        postDetailViewController.postId = postInfo.pid;
        postDetailViewController.hidesBottomBarWhenPushed = YES;
        postDetailViewController.type = @"fromComment";
        [self.navigationController pushViewController:postDetailViewController animated:YES];
    }
}

- (void)favorPostForItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath {
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
    
    if ([self.isshow isEqualToString:@"1"]) {
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

    if(![Context sharedInstance].token) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"点赞是熊宝哒特权！" andtitle2:@"*/ω＼*)"];
        [self.view addSubview:attention];
        return;
    }
    if(postInfo != nil && postInfo.pid != nil) {
        [self favorPost:postInfo atIndexPath:indexPath];
    }
}
- (void)clickAuthorAtItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath {
    AuthorDetailViewController *authorDetailViewController = [[AuthorDetailViewController alloc] init];
    authorDetailViewController.authorInfo = postInfo.author;
    authorDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:authorDetailViewController animated:YES];
}

- (void)clickThemeAtItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath {
    if(!postInfo.theme) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //跳转界面
        ThemeDetailViewController *topicDetailViewController = [[ThemeDetailViewController alloc] init];
        topicDetailViewController.themeInfo = postInfo.theme;
        topicDetailViewController.themeId = postInfo.theme.tid;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:topicDetailViewController];
        [self presentViewController:navigationController animated:YES completion:^{
        }];
    });
}

//为帖子点赞
- (void)favorPost:(PostInfo *)postInfo atIndexPath:(NSIndexPath *)indexPath {
    NSString *type = @"1";
    if([postInfo.favorStatus isEqualToString:@"1"]) {
        type = @"3";
    }
    [self actPostWithType:type withPostId:postInfo.pid atIndexPath:indexPath];
}

- (void)actPostWithType:(NSString *)type withPostId:(NSString *)postId atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *params = @{
                             @"postId": postId,
                             @"favorType" : type
                             };
    [[PostAPIRequest sharedInstance] favorPost:params success:^(CommonInfo *resultInfo) {
//        [SVProgressHUD dismiss];
        if(resultInfo && [resultInfo isSuccess]) {
            if(indexPath.row < self.postArray.count) {
                PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
                postInfo.favorStatus = [postInfo.favorStatus isEqualToString:@"1"] ? @"0" : @"1";
                if([postInfo.favorStatus isEqualToString:@"1"]) {
                    postInfo.favorCount = [NSString stringWithFormat:@"%ld", [postInfo.favorCount integerValue] + 1];
                    
                    AttentionView * attention = [[AttentionView alloc]initTitle:@"阿里嘎多！"];
                    [self.view addSubview:attention];
                } else {
                    postInfo.favorCount = [NSString stringWithFormat:@"%ld", [postInfo.favorCount integerValue] - 1];
                    AttentionView * attention = [[AttentionView alloc]initTitle:@"啊嘞？"];
                    
                    [self.view addSubview:attention];
                }
                [self.postArray replaceObjectAtIndex:indexPath.row withObject:postInfo];
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"操作失败！"];
            [self.view addSubview:attention];
        }
    } failure:^(NSError *error) {
}];
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0) {
        if(self.bannerArray != nil && self.bannerArray.count > 0) {
            return 1;
        } else {
            return 0;
        }
    } else if(section == 1) {

        NSInteger count = self.taskArray != nil ? self.taskArray.count : 0;
        return count;
    } else if(section == 2){
        return 1;
    } else {
        NSInteger count = self.postArray != nil ? self.postArray.count : 10;
        return count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"indexPath.section ======= %ld",indexPath.section);
    if(indexPath.section == 0) {
        if(self.bannerArray != nil && self.bannerArray.count > 0) {
            return TRANS_VALUE(160.0f);
        } else {
            return 0.0f;
        }
    } else if(indexPath.section == 1) {
        return TRANS_VALUE(91.0f);
    } else if(indexPath.section == 2) {
        return TRANS_VALUE(112.0f);
    } else  {
//        NSLog(@"++++++++++++++++++++++++++++");
        if (self.postArray.count != 0) {
            PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
            CGFloat height = [PostTableViewCell heightForCell:indexPath withCommentInfo:postInfo];
            return height;
        }else{
            return 100;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return 0.0f;
    } else {
        return TRANS_VALUE(36.0f);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        CGFloat height = TRANS_VALUE(0.0f);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        return view;
    } else  {
        NSString *titleStr = @"今日任务";
        NSString *iconStr = @"ic_home_task";
        if(section == 1) {
            titleStr = @"今日任务";
            iconStr = @"ic_home_task";
        } else if(section == 2) {
            titleStr = @"熊窝推荐";
            iconStr = @"ic_home_theme";
        } else if(section == 3) {
            titleStr = @"脑洞推荐";
            iconStr = @"ic_home_post";
        }
        UIView *view = [self sectionHeaderWithTitle:titleStr andIcon:iconStr inSection:section];
        return view;
    }
}
- (UIView *)sectionHeaderWithTitle:(NSString *)title andIcon:(NSString *)icon inSection:(NSInteger)section {
    CGFloat height = TRANS_VALUE(36.0f);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    view.backgroundColor = I_COLOR_WHITE;
    UIView * lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(0.5f))];
    lineView1.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [view addSubview:lineView1];
    UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(0.5f), SCREEN_WIDTH, TRANS_VALUE(0.5f))];
    lineView2.backgroundColor = [UIColor whiteColor];
    [view addSubview:lineView2];
    UIImageView *bgImageVeiw = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(1.0f), SCREEN_WIDTH, TRANS_VALUE(32.0f))];
    bgImageVeiw.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [view addSubview:bgImageVeiw];
    UIImageView *bgImageVeiw2 = [[UIImageView alloc] init];
    bgImageVeiw2.contentMode = UIViewContentModeScaleAspectFill;
     bgImageVeiw2.image = [UIImage imageNamed:@"daily_division"];
    bgImageVeiw2.frame = CGRectMake(0, CGRectGetMaxY(bgImageVeiw.frame)+TRANS_VALUE(2.0f), SCREEN_WIDTH, bgImageVeiw.image.size.height);
    [view addSubview:bgImageVeiw2];
    
    UIImageView *taskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(114.0f), TRANS_VALUE(7.0f), TRANS_VALUE(18.0f), TRANS_VALUE(18.0f))];
    taskImageView.contentMode = UIViewContentModeScaleAspectFit;
    taskImageView.image = [UIImage imageNamed:icon];
    [view addSubview:taskImageView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(140.0f), TRANS_VALUE(1.0f), TRANS_VALUE(80.0f), TRANS_VALUE(30.0f))];
    titleLabel.textColor = I_COLOR_BLACK;
    titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(13.0f)];
    titleLabel.text = title;
    [view addSubview:titleLabel];
    
    NSString *actionTitle = @"更多任务";
    if(section == 1) {
        actionTitle = @"更多任务";
    } else if(section == 2) {
        actionTitle = @"更多熊窝";
    }
    if (section == 3) {
        
    }else{
        WZArrowButton *moreButton = [[WZArrowButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(220.0f), TRANS_VALUE(1.0f), TRANS_VALUE(100.0f), TRANS_VALUE(30.0f))];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // moreButton.contentMode = UIViewContentModeRight;
        [moreButton setTitle:actionTitle forState:UIControlStateNormal];
        [moreButton setImage:@"ic_home_section_arrow"];
        [moreButton setTitle:actionTitle];
        [moreButton setTitleColor:I_COLOR_GRAY forState:UIControlStateNormal];
        [view addSubview:moreButton];
        moreButton.tag = 5000 + section;
        [moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"\nindexPath.row === %ld",indexPath.section);
    if(indexPath.section == 0) {
        static NSString *identifier = @"TopScrollTableViewCell";
        TopScrollTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell) {
            cell = [[TopScrollTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        if(indexPath.row < 1) {
            //TOOD -- 滚动banner
            cell.delegate = self;
            cell.topList = self.bannerArray;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if(indexPath.section == 1) {
        static NSString *identifier = @"TaskTableViewCell";
        TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell) {
            cell = [[TaskTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        if(indexPath.row < self.taskArray.count) {
            //TOOD -- 我的任务
            TaskInfo *taskInfo = (TaskInfo *)[self.taskArray objectAtIndex:indexPath.row];
            cell.indexPath = indexPath;
            cell.taskItem = taskInfo;
            UIView *imageViewSepE = [[UIView alloc]initWithFrame:CGRectMake(0, TRANS_VALUE(91.0f), SCREEN_WIDTH, 0.5)];
            imageViewSepE.backgroundColor = I_DIVIDER_COLOR;
            [cell.contentView addSubview:imageViewSepE];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if(indexPath.section == 2) {
        static NSString *identifier = @"ThemeTableViewCell";
        ThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell) {
            cell = [[ThemeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.delegate = self;
        
        if(self.themeArray != nil) {
            //TOOD -- 我的主题
            cell.themeArray = self.themeArray;
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        static NSString *identifier = @"PostTableViewCell";
        PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell) {
            cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        if(indexPath.row < [self.postArray count]) {
            //TOOD -- 帖子列表
            PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
            cell.postItem = postInfo;
            cell.indexPath = indexPath;
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         [cell setNeedsDisplay];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        
    } else if(indexPath.section == 1) {
        TaskDetailViewController *taskDetailViewController = [[TaskDetailViewController alloc] init];
        TaskInfo *taskInfo = [self.taskArray objectAtIndex:indexPath.row];
        taskDetailViewController.taskId = taskInfo.tid;
        taskDetailViewController.draftStatus = taskInfo.draftStatus;
        taskDetailViewController.taskInfo = taskInfo;
        taskDetailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:taskDetailViewController animated:YES];
    } else if(indexPath.section == 3){
        PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
        if (self.postArray.count != 0) {
            PostInfo *postInfo = [self.postArray objectAtIndex:indexPath.row];
            postDetailViewController.postId = postInfo.pid;
            postDetailViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:postDetailViewController animated:YES];
        }
    }
    
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(indexPath.section == 1) {
//        if(indexPath.row < self.taskArray.count) {
//            if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//                [cell setSeparatorInset:UIEdgeInsetsZero];
//            }
//            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//                [cell setLayoutMargins:UIEdgeInsetsZero];
//            }
//        } else {
//            if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//                [cell setSeparatorInset:UIEdgeInsetsZero];
//            }
//            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//                [cell setLayoutMargins:UIEdgeInsetsZero];
//            }
//        }
//    } else if(indexPath.section == 3){
//        if(indexPath.row < self.postArray.count) {
//            if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//                [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
//            }
//            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//                [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
//            }
//        } else {
//            if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//                [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
//                
//            }
//            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//                [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
//            }
//        }
//    }
//    
//}

//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = TRANS_VALUE(150.0f);
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - TopScrollTableViewCellDelegate
- (void)didClickTopBannerInfo:(HomeBannerInfo *)bannerInfo {
    //TODO -- 点击某一个topbanner,1超链接，绑定Link字段; 2帖子，RelatedId为帖子ID; 3任务，RelatedId为任务ID; 4主题，RelatedId为主题ID
    if([bannerInfo.relatedType isEqualToString:@"1"]) {
        //打开网页
        NSString *relatedURL = bannerInfo.link;
        WebViewController *webViewController = [[WebViewController alloc] init];
//        webViewController.bannerInfo = bannerInfo;
        webViewController.urlStr = relatedURL;
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
    } else if([bannerInfo.relatedType isEqualToString:@"2"]) {
        //帖子
        NSString *relatedId = bannerInfo.relatedId;
        PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
        postDetailViewController.postId = relatedId;
        postDetailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:postDetailViewController animated:YES];
    } else if([bannerInfo.relatedType isEqualToString:@"3"]) {
        //任务
        NSString *relatedId = bannerInfo.relatedId;
        TaskDetailViewController *taskDetailViewController = [[TaskDetailViewController alloc] init];
        taskDetailViewController.taskId = relatedId;
        taskDetailViewController.taskInfo = nil;
        taskDetailViewController.imageUrl = bannerInfo.imageUrl;
        taskDetailViewController.titleStr = bannerInfo.title;
        taskDetailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:taskDetailViewController animated:YES];
    } else if([bannerInfo .relatedType isEqualToString:@"4"]) {
        //主题
        NSString *relatedId = bannerInfo.relatedId;
        ThemeDetailViewController *topicDetailViewController = [[ThemeDetailViewController alloc] init];
        topicDetailViewController.themeId = relatedId;
        topicDetailViewController.themeInfo = nil;
        topicDetailViewController.fromWhere = 1;
        topicDetailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:topicDetailViewController animated:YES];
        
    }
}


#pragma mark - Private Method
//加载新数据
- (void)loadNewData {
    //TODO -- 避免过度重载
    dispatch_queue_t queue = dispatch_queue_create("serial", NULL);
    dispatch_sync(queue, ^{
        //获取首页帖子列表(刷新)
        [self getHomePostsWithTheme:nil];
    });
    dispatch_sync(queue, ^{
        //获取首页滚动图列表
        [self getHomeTopBanners];
    });
    dispatch_sync(queue, ^{
        //获取主页任务列表
        [self getHomeTasks];
    });
    dispatch_sync(queue, ^{
        //获取主页主题列表
        [self getHomeThemes];
    });
   
    
}

- (void)loadMoreData {
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:pageNo forKey:@"pageNo"];
    [params setObject:pageSize forKey:@"pageSize"];
    [params setObject:ACTION_TYPE_LOAD_MORE forKey:@"actionType"];
    if (self.loadTime != nil) {
         [params setObject:self.loadTime forKey:@"refreshTime"];
    }
    if (self.prePostId != nil) {
         [params setObject:self.prePostId forKey:@"postId"];
    }
    [[IncubatorAPIRequest sharedInstance] homeIndexPosts:params success:^(NSArray *postList) {
        //[SVProgressHUD dismiss];
        if(postList && postList.count > 0) {
            NSSortDescriptor *creatTimeDesc = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO];
            NSArray *descs = [NSArray arrayWithObjects:creatTimeDesc, nil];
            NSArray *sortedArray = [postList sortedArrayUsingDescriptors:descs];
            PostInfo *lastestPost = [sortedArray lastObject];
            self.prePostId = lastestPost.pid;
            self.loadTime = lastestPost.createTime;
            PostInfo *keyPost = (PostInfo *)[self.postArray lastObject];
            PostInfo *firstPost = (PostInfo *)[sortedArray objectAtIndex:0];
            if([firstPost.createTime compare:keyPost.createTime] == NSOrderedAscending) {
                [self.postArray addObjectsFromArray:sortedArray];
                if(postList.count >= self.pageSize) {
                    self.pageNo ++;
                    [self.tableView.mj_footer endRefreshing];
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        //刷新tableview
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSError *error) {
        //[SVProgressHUD dismiss];
        //刷新tableview
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

//获取首页滚动图列表
- (void)getHomeTopBanners {
    if(!self.bannerArray) {
        self.bannerArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.bannerArray removeAllObjects];

    [[IndexAPIRequest sharedInstance] getIndexBanners:nil success:^(NSArray *bannerList) {
        //[SVProgressHUD dismiss];
//        NSLog(@"bannerList +++++++++++++ %@",bannerList);
        if(bannerList) {
            [self.bannerArray addObjectsFromArray:bannerList];
        }

    } failure:^(NSError *error) {
 
    }];
}

//获取主页任务列表
- (void)getHomeTasks {
//     NSLog(@"------------------------%s",__func__);
    if(!self.taskArray) {
        self.taskArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.taskArray removeAllObjects];

    NSDictionary *params = @{
                             @"pageNo" : @"1",
                             @"pageSize" : @"3"
                             };
    [[IndexAPIRequest sharedInstance] getIndexTasks:params success:^(NSArray *taskArray) {
//        [SVProgressHUD dismiss];
//        NSLog(@"taskArray ============== %ld",taskArray.count);
        if(taskArray) {
            [self.taskArray addObjectsFromArray:taskArray];
         
        }
   [self.tableView reloadData];
       
    } failure:^(NSError *error) {

        if([error.localizedDescription isEqualToString:@"用户未登录"]) {
            [self refreshHomeTasks];
        }
    }];
}

//获取主页帖子主题列表
- (void)getHomeThemes {
//     NSLog(@"------------------------%s",__func__);
    if(!self.themeArray) {
        self.themeArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.themeArray removeAllObjects];
   
    [[IndexAPIRequest sharedInstance] getIndexThemes:nil success:^(NSArray *themeList) {
       // [SVProgressHUD dismiss];
        if(themeList) {
            [self.themeArray addObjectsFromArray:themeList];
        }

    } failure:^(NSError *error) {    }];
}

//获取主页的帖子列表
- (void)getHomePostsWithTheme:(ThemeInfo *)theme {
//    NSLog(@"------------------------%s",__func__);
    self.pageNo = 1;
    if(!self.postArray) {
        self.postArray = [NSMutableArray arrayWithCapacity:0];
//        [self.postArray removeAllObjects];
    }
    [self.tableView.mj_footer resetNoMoreData];
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:pageNo forKey:@"pageNo"];
    [params setObject:pageSize forKey:@"pageSize"];
    [params setObject:ACTION_TYPE_REFRESH forKey:@"actionType"];
    [params setObject:@"" forKey:@"refreshTime"];
    [params setObject:@"" forKey:@"postId"];
    [[IncubatorAPIRequest sharedInstance] homeIndexPosts:params success:^(NSArray *postList) {
         [self.postArray removeAllObjects];
        [self.tableView.mj_header endRefreshing];
        if(postList && postList.count > 0) {
            if(self.postArray.count == 0) {
                 [self.postArray addObjectsFromArray:postList];
            } else {
                [self.postArray insertObjects:postList atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, postList.count)]];
            }
            PostInfo *lastPost = [self.postArray lastObject];
            self.loadTime = lastPost.createTime;
            self.prePostId = lastPost.pid;
            if(postList.count >= self.pageSize) {
                self.pageNo ++;
            }
        } else {
            PostInfo *lastPost = [self.postArray lastObject];
            self.loadTime = lastPost.createTime;
            self.prePostId = lastPost.pid;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        //刷新tableview
       [self.tableView reloadData];
//       [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSError *error) {
        PostInfo *lastPost = [self.postArray lastObject];
        self.loadTime = lastPost.createTime;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)createUI {
    //实例化表单控件
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = I_DIVIDER_COLOR;
    self.tableView.backgroundColor = I_COLOR_WHITE;
    self.tableView.showsVerticalScrollIndicator = NO;
       [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, SCREEN_WIDTH, 0)];
    [self.view addSubview:self.tableView];
//    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(0.0f))];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20.0f)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MyRefreshHeader *header = [MyRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MyRefreshFooter *footer = [MyRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    
    //设置tableview分割线
//    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
    
//    [self.tableView registerClass:[TopScrollTableViewCell class] forCellReuseIdentifier:@"TopScrollTableViewCell"];
//    [self.tableView registerClass:[TaskTableViewCell class] forCellReuseIdentifier:@"TaskTableViewCell"];
//    [self.tableView registerClass:[ThemeTableViewCell class] forCellReuseIdentifier:@"ThemeTableViewCell"];
//    [self.tableView registerClass:[PostTableViewCell class] forCellReuseIdentifier:@"PostTableViewCell"];
}

- (LoginSucAttentionView *)attentionView {
    if (!_attentionView) {
        LoginSucAttentionView *tempView = [[LoginSucAttentionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        tempView.delegate = self;
        [self.view addSubview:(_attentionView = tempView)];
    }
    return _attentionView;
}

@end
