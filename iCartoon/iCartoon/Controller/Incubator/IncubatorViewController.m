//
//  DiscoveryViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "IncubatorViewController.h"
#import "PostTableViewCell.h"
#import "HACursor.h"
#import "TopicButton.h"
#import "PostViewController.h"
#import "PostDetailViewController.h"
#import "NewSearchViewController.h"
#import "ThemeDrawerViewController.h"
#import "PublishCommentViewController.h"
#import "AuthorDetailViewController.h"
#import "ThemeDetailViewController.h"

#import "AttentionView.h"
#import "ThemeInfo.h"
#import "IncubatorTypeInfo.h"
#import "AppDelegate.h"
#import "Context.h"
#import "IncubatorAPIRequest.h"
#import "PostAPIRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
//下拉刷新
#import <MJRefresh/MJRefresh.h>
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import "ProgressHUD.h"

#import <AFNetworking.h>

@interface IncubatorViewController () <UITableViewDataSource, UITableViewDelegate, HACursorDelegate, UITextFieldDelegate, PostTableViewCellDelegate>

@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) UIBarButtonItem *menuButton;           //菜单按钮
@property (strong, nonatomic) UIBarButtonItem *postButton;           //发布帖子

@property (strong, nonatomic) UITableView *currentTableView;

@property (strong, nonatomic) HACursor *mHACursor;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *topicArray;
@property (strong, nonatomic) NSMutableArray *topicTitleArray;
@property (strong, nonatomic) NSMutableArray *postArray;

@property (assign, nonatomic) NSInteger selectIndex;

@property (assign, nonatomic) NSInteger pageNo;
@property (assign, nonatomic) NSInteger pageSize;

@property (strong, nonatomic) NSString *refreshTime;
@property (strong, nonatomic) NSString *loadTime;
@property (strong, nonatomic) NSString *from;

@property (strong, nonatomic)UIImageView *img;
@property (strong, nonatomic)UILabel *lab;
@property (strong, nonatomic) NSString *isRefrese;
@property (nonatomic,assign)BOOL isBack;
@property (nonatomic,strong)NSString * contentStr;
@property (nonatomic,strong)NSString * titleStr;
@property (nonatomic,strong)NSString * selectedTheme;
@property (nonatomic,strong)NSArray *pictureArray;
@property (nonatomic,strong)NSMutableDictionary *result;
@property (strong,nonatomic) UIButton * myBtn1;//未登录时加在标题上  登陆后移除self
@property (strong,nonatomic) UIButton * myBtn2;
@property (nonatomic,strong) NSArray * postList;
@property (nonatomic,assign)BOOL isFinish;
@property (nonatomic,strong)NSIndexPath * indexPath;
@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;

@property (nonatomic,strong) NSString *isfreeze;
@property (nonatomic,strong) NSString *thaw_date;
@property (nonatomic,strong) NSString *thaw_time;
@property (nonatomic,strong)NSString * isshow;
@property (nonatomic,strong)NSString * isshowfree;
- (void)setSelectIndex:(NSInteger)index;

@end

@implementation IncubatorViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(![Context sharedInstance].token) {
        _myBtn1 = [[UIButton  alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/4, TRANS_VALUE(34))];
        [_myBtn1  addTarget:self action:@selector(toLogin:) forControlEvents:UIControlEventTouchUpInside];
        //        _myBtn1.backgroundColor = [UIColor  redColor];
        [self.view addSubview:_myBtn1];
        _myBtn2 = [[UIButton  alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3/4, 0, SCREEN_WIDTH/4, TRANS_VALUE(34))];
        [_myBtn2  addTarget:self action:@selector(toLogin:) forControlEvents:UIControlEventTouchUpInside];
        //        _myBtn2.backgroundColor = [UIColor  redColor];
        [self.view addSubview:_myBtn2];
    }else{
        
        
        
    }
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_myBtn1  removeFromSuperview];
    [_myBtn2  removeFromSuperview];
}

- (void)toLogin:(UIButton *)sender{
//    [self loadBlankData];
    [[AppDelegate sharedDelegate] showLoginViewController:YES index:1];
    return;
}
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
    self.navigationItem.title = @"孵化箱";
    [self setNavigationButtons];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPostList:) name:kNotificationRefreshPosts object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postBack:) name:@"postBack" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postfinish) name:@"finish" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postfailure) name:@"postfailure" object:nil];
    
    //加载数据
    self.pageNo = 1;
    if (self.selectIndex == 0) {
         self.pageSize = 10;
    }else{
         self.pageSize = 15;
    }
    self.refreshTime = @"";
    self.prePostId = @"";
    [self loadData];
}
- (void)postfailure{
    if (self.postArray.count>0) {
        [self.postArray removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"postBack" object:nil];
}
- (void)postfinish{
//    NSLog(@"\n++++++++++++++%s",__func__);
    self.isFinish = YES;
    self.prePostId = @"";
    self.refreshTime = @"";
    sleep(2);
    [self loadNewData];
}
- (void)postBack:(NSNotification *)noti{
    NSString * avatar = [Context sharedInstance].userInfo.avatar;
    NSString * nickname = [Context sharedInstance].userInfo.nickname;
    self.titleStr = noti.userInfo[@"titleStr"];
    self.contentStr = noti.userInfo[@"contentStr"];
    self.selectedTheme = noti.userInfo[@"selectedTheme"];
    self.pictureArray = noti.userInfo[@"pictureArray"];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:avatar,@"avatar",nickname,@"nickname" ,nil];
    NSMutableArray * userArray = [NSMutableArray array];
    [userArray addObject:dic];
    NSArray * userList = [MTLJSONAdapter modelsOfClass:[AuthorInfo class] fromJSONArray: userArray error:nil];
    NSMutableDictionary * arr = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.titleStr,@"title",self.contentStr,@"content",self.pictureArray,@"images",userList[0],@"author", self.selectedTheme,@"theme",nil];
    NSMutableArray * array  = [NSMutableArray array];
    [array addObject:arr];
    self.postList = [MTLJSONAdapter modelsOfClass:[PostInfo class] fromJSONArray: array error:nil];
    self.refreshTime = @"";
    self.prePostId = @"";
    self.selectIndex = 0;
    [self loadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)refreshPostList:(NSNotification *)noti {
//    self.isBack = 1;
//    self.prePostId = @"";
//    self.refreshTime = @"";
//    [self loadNewData];
    if ([noti.userInfo[@"isRefrese"] isEqualToString:@"1"]) {
        [self favorPostForItem:self.postArray[self.indexPath.row] indexPath:self.indexPath];
    }
    if ([noti.userInfo[@"isRefrese"] isEqualToString:@"2"]) {
        PostInfo * info = self.postArray[self.indexPath.row];
        int count = [info.commentCount intValue];
        count += 1;
        info.commentCount = [NSString stringWithFormat:@"%d",count];
        [self.postArray replaceObjectAtIndex:self.indexPath.row withObject:info];
        [self.currentTableView reloadData];
    }
   
}

 //加载热门帖子
- (void)loadHostPosts {
//    self.selectIndex = 1;
//    self.from = @"homepage";
//    if(_mHACursor != nil) {
//        [_mHACursor setSelectIndex:self.selectIndex];
//    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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
    
//    UIButton *mMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22 + 8, 18)];
//    mMenuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIButton *mMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(CONVER_VALUE(-20.0f), 0, CONVER_VALUE(25.5f), CONVER_VALUE(22.5f))];
    [mMenuButton setImage:[UIImage imageNamed:@"ic_navi_menu"] forState:UIControlStateNormal];
    [mMenuButton setImage:[UIImage imageNamed:@"ic_navi_menu"] forState:UIControlStateFocused];
    [mMenuButton setImage:[UIImage imageNamed:@"ic_navi_menu"] forState:UIControlStateSelected];
        [mMenuButton setImageEdgeInsets:UIEdgeInsetsMake(0, CONVER_VALUE(-11.0f), 0, 0)];
    [mMenuButton addTarget:self action:@selector(menuButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.menuButton = [[UIBarButtonItem alloc] initWithCustomView:mMenuButton];
    self.navigationItem.leftBarButtonItem = self.menuButton;
    
//    UIButton *mPostButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 22)];
//    mPostButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
    UIButton *mPostButton = [[UIButton alloc] initWithFrame:CGRectMake(CONVER_VALUE(18.0f), 0,  CONVER_VALUE(20.5f), CONVER_VALUE(22.5f))];
    [mPostButton setImageEdgeInsets:UIEdgeInsetsMake(0,CONVER_VALUE(5.0f), 0,CONVER_VALUE(-10.0f))];
    [mPostButton setImage:[UIImage imageNamed:@"ic_navi_post"] forState:UIControlStateNormal];
    [mPostButton setImage:[UIImage imageNamed:@"ic_navi_post"] forState:UIControlStateFocused];
    [mPostButton setImage:[UIImage imageNamed:@"ic_navi_post"] forState:UIControlStateSelected];
    [mPostButton addTarget:self action:@selector(postButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.postButton = [[UIBarButtonItem alloc] initWithCustomView:mPostButton];
    self.navigationItem.rightBarButtonItem = self.postButton;
}

#pragma mark - Action
- (void)menuButtonAction {
    //TODO -- 菜单按钮点击事件
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    ThemeDrawerViewController *themeDrawerViewController = [[ThemeDrawerViewController alloc] init];
    themeDrawerViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:themeDrawerViewController animated:YES];
}

- (void)postButtonAction {
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
    //TODO -- 发帖按钮点击事件
    if(![Context sharedInstance].token || ![Context sharedInstance].uid) {
        [[AppDelegate sharedDelegate]showLoginViewController:YES index:1];
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

    PostViewController *postViewController = [[PostViewController alloc] init];
    postViewController.themeInfo = nil;
    postViewController.type = PostSourceTypeNew;
    postViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postViewController animated:YES];
}

//搜索按钮点击事件
- (void)searchAction {
    NewSearchViewController *searchViewController = [[NewSearchViewController alloc] init];
    searchViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark - PostTableViewCellDelegate
- (void)commentPostForItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath {
    if(![Context sharedInstance].token) {
        PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
        postDetailViewController.postId = postInfo.pid;
        postDetailViewController.hidesBottomBarWhenPushed = YES;
        postDetailViewController.type = @"fromComment";
        [self.navigationController pushViewController:postDetailViewController animated:YES];
        return;
    }
    if(postInfo != nil && postInfo.pid != nil) {
        //TODO -- 评论帖子
        PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
        postDetailViewController.postId = postInfo.pid;
        postDetailViewController.hidesBottomBarWhenPushed = YES;
        postDetailViewController.type = @"fromComment";
        [self.navigationController pushViewController:postDetailViewController animated:YES];
    }
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

    if(![Context sharedInstance].token) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"点赞是熊宝哒特权！" andtitle2:@"*/ω＼*)"];
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

//为帖子点赞
- (void)favorPost:(PostInfo *)postInfo atIndexPath:(NSIndexPath *)indexPath {
    NSString *type = @"1";
    if([postInfo.favorStatus isEqualToString:@"1"]) {
        type = @"3";
    }
    [self actPostWithType:type withPostId:postInfo.pid atIndexPath:indexPath];
}

- (void)actPostWithType:(NSString *)type withPostId:(NSString *)postId atIndexPath:(NSIndexPath *)indexPath {
//    [SVProgressHUD showWithStatus:@"正在为帖子点赞或者取消点赞..." maskType:SVProgressHUDMaskTypeClear];
    NSDictionary *params = @{
                             @"postId": postId,
                             @"favorType" : type
                             };
    [[PostAPIRequest sharedInstance] favorPost:params success:^(CommonInfo *resultInfo) {
//
  [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshPosts object:nil];
        if(resultInfo && [resultInfo isSuccess]) {
            if(indexPath.row < self.self.postArray.count) {
                PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
                postInfo.favorStatus = [postInfo.favorStatus isEqualToString:@"1"] ? @"0" : @"1";
                if([postInfo.favorStatus isEqualToString:@"1"]) {
                    postInfo.favorCount = [NSString stringWithFormat:@"%ld", [postInfo.favorCount integerValue] + 1];
                    
                    AttentionView * attention = [[AttentionView alloc]initTitle:@"阿里嘎多！" andtitle2:@""];
                    attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
                    attention.label1.frame=CGRectMake(5, 15, 220, 40);
                    [self.view addSubview:attention];
                } else {
                    postInfo.favorCount = [NSString stringWithFormat:@"%ld", [postInfo.favorCount integerValue] - 1];
 
                    AttentionView * attention = [[AttentionView alloc]initTitle:@"啊嘞？" andtitle2:@""];
                    attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
                    attention.label1.frame=CGRectMake(5, 15, 220, 40);
                    
                    [self.view addSubview:attention];
                    
                }
                
                [self.postArray replaceObjectAtIndex:indexPath.row withObject:postInfo];
            }
            [self.currentTableView reloadData];
        } else {
        }
    } failure:^(NSError *error) {

    }];
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"\n ------%ld-------- %ld",(long)section,self.postArray.count);
    NSInteger count = self.postArray != nil ? self.postArray.count : 10;
    return count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < self.postArray.count) {
        PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
        CGFloat height =[PostTableViewCell heightForCell:indexPath withCommentInfo:postInfo];
        return height;
    } else {
        return 0.0f;
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0.0f;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    CGFloat height = 0.0f;
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
//    view.backgroundColor = RGBCOLOR(247, 247, 247);
//    return view;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DiscoveryTableViewCell";
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if(indexPath.row < [self.postArray count]) {
        //TOOD -- 发现列表
        PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
        cell.postItem = postInfo;
    }
    cell.indexPath = indexPath;
    cell.isshow = self.isshow;
    cell.isfreeze = self.isfreeze;
    cell.thaw_time = self.thaw_time;
    cell.thaw_date = self.thaw_date;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
    if (self.postArray.count != 0) {
        PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
        postDetailViewController.postId = postInfo.pid;
        postDetailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:postDetailViewController animated:YES];
    }
}

#pragma mark - HACursorDelegate
- (void)cursor:(HACursor *)cursor selectedAtIndex:(NSInteger)index {
//     NSLog(@"++++++++++++++++++++++%s",__func__);
    self.isBack = 0;
    if(index == self.selectIndex) {
//        if(!self.from || ![self.from isEqualToString:@"homepage"]) {
            return;
//        }
    }
    if(index < [self.topicArray count]) {
        //TODO -- 刷新tableview
        self.selectIndex = index;
        self.prePostId = @"";
        self.refreshTime = @"";
        //刷新tableview
        [self.postArray removeAllObjects];
        if((![Context sharedInstance].token && index == 2)||(![Context sharedInstance].token && index == 3)) {
            [self loadBlankData];
            [[AppDelegate sharedDelegate] showLoginViewController:YES index:1];
            return;
        }
        [self loadNewData];
   
    }
}

//刷新数据
- (void)loadBlankData {
//    NSLog(@"++++++++++++++++++++++%s",__func__);
    [_img  removeFromSuperview];
    [_lab  removeFromSuperview];
    
    if(!self.postArray) {
        self.postArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.postArray removeAllObjects];
    for(int i = 0; i < 4; i++) {
        UIView *view = (UIView *)[self.view viewWithTag:(i + 10000)];
        UITableView *tableView = (UITableView *)[view.subviews objectAtIndex:0];
        if(view != nil && tableView != nil) {
            [tableView.mj_footer resetNoMoreData];
            [tableView.mj_header endRefreshing];
            [tableView reloadData];
        }
    }
    if(self.selectIndex < 2) {
        [self loadNewData];
    }
}
- (void)addTargetAction {
    self.requestManager = [AFHTTPRequestOperationManager manager];
    self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableDictionary * paramaDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString * mainurl = [APIConfig mainURL];
    NSString * path = [NSString stringWithFormat:@"%@/%@/%@",mainurl,@"FreshGetNewTopics_v2",self.refreshTime];
    NSString *urlPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.requestManager GET:urlPath parameters:paramaDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
         IncubatorTypeInfo *typeInfo = [self.topicArray objectAtIndex:self.selectIndex];
        NSArray * arr = responseObject[@"response"][@"result"];
        if (arr.count>0) {
            if ([self.refreshTime isEqualToString:@""]==NO && self.refreshTime != nil && [self.isRefrese isEqualToString:@"1"]==NO && [typeInfo.type isEqualToString:@"1"]) {
                  [self showNewStatusCount:(int)arr.count];
                
            }
            [ProgressHUD dismiss];
        }else{
            if ([self.refreshTime isEqualToString:@""]==NO && self.refreshTime != nil && [self.isRefrese isEqualToString:@"1"]==NO && [typeInfo.type isEqualToString:@"1"]) {
                [self showNewStatusCount:0];
            }
            [ProgressHUD dismiss];
        }
//
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

//刷新数据
- (void)loadNewData {
//    NSLog(@"++++++++++++++++++++++%s",__func__);
    [_img  removeFromSuperview];
    [_lab  removeFromSuperview];
    if (self.isBack == 1) {
        
    }else{
         [ProgressHUD show:nil];
    }
    self.pageNo = 1;
    IncubatorTypeInfo *typeInfo = [self.topicArray objectAtIndex:self.selectIndex];
    if(!typeInfo.type) {
        return;
    }
    if(!self.postArray) {
        self.postArray = [NSMutableArray arrayWithCapacity:0];
//        [self.postArray removeAllObjects];
    }
    UIView *view = (UIView *)[self.view viewWithTag:(self.selectIndex + 10000)];
    UITableView *tableView = (UITableView *)[view.subviews objectAtIndex:0];
    [tableView.mj_footer resetNoMoreData];
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:pageNo forKey:@"pageNo"];
    if (self.selectIndex == 0) {
         [params setObject:pageSize forKey:@"10"];
    }else{
         [params setObject:pageSize forKey:@"pageSize"];
    }
    [params setObject:typeInfo.type forKey:@"type"];
    [params setObject:ACTION_TYPE_REFRESH forKey:@"actionType"];
    if (self.refreshTime != nil) {
        [self addTargetAction];
    }
         [params setObject:@"" forKey:@"refreshTime"];
         [params setObject:@"" forKey:@"postId"];
    if ([self.refreshTime isEqualToString:@""]==NO && self.refreshTime != nil && [self.isRefrese isEqualToString:@"1"]==NO) {
      
    }else{
        self.isRefrese = @"2";
    }
    [[IncubatorAPIRequest sharedInstance] getIncubatorPosts:params success:^(NSArray *postList) {
        [ProgressHUD dismiss];
        [self.postArray removeAllObjects];
        UIView *view = (UIView *)[self.view viewWithTag:(self.selectIndex + 10000)];
        UITableView *tableView = (UITableView *)[view.subviews objectAtIndex:0];
        self.currentTableView = tableView;
        [tableView.mj_header endRefreshing];
        if(postList && postList.count > 0) {
            NSSortDescriptor *creatTimeDesc = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO];
           NSSortDescriptor *isTopedDesc = [NSSortDescriptor sortDescriptorWithKey:@"isToped" ascending:NO];
            NSArray *descs = [NSArray arrayWithObjects:creatTimeDesc, isTopedDesc, nil];
            NSArray *sortedArray = [postList sortedArrayUsingDescriptors:descs];
            PostInfo *firstPost = [sortedArray firstObject];
            self.refreshTime = firstPost.createTime;
            if(self.postArray.count == 0) {
                [self.postArray addObjectsFromArray:postList];
                if (self.titleStr) {
//                    NSLog(@"self.isFinish ===++++=== %d",self.isFinish);
//                    if (self.isFinish) {
//                         self.titleStr = nil;
//                        self.isFinish = NO;
//                    }else{
                        [self.postArray insertObject:self.postList[0] atIndex:0];
//                        NSLog(@"\npostList ===== %@",self.postList);
                        self.titleStr = nil;
                         self.isFinish = NO;
//                         NSLog(@"self.isFinish ===++++=== %d",self.isFinish);
                    }
//                }
            } else {
                if(![typeInfo.type isEqualToString:@"1"] && ![typeInfo.type isEqualToString:@"2"] && ![typeInfo.type isEqualToString:@"3"]) {
                    [self.postArray insertObjects:postList atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, postList.count)]];
                }
            }
            PostInfo *lastPost = [self.postArray lastObject];
            self.loadTime = lastPost.createTime;
            self.prePostId = lastPost.pid;
            if(postList.count >= self.pageSize) {
                self.pageNo ++;
            } else {
                [tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            PostInfo *lastPost = [self.postArray lastObject];
            self.loadTime = lastPost.createTime;
            self.prePostId = lastPost.pid;
            [tableView.mj_footer endRefreshingWithNoMoreData];
        }
        //刷新tableview
          [tableView reloadData];
                            if (self.postArray.count <= 0) {
                                self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(120.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
                                self.img.contentMode = UIViewContentModeScaleAspectFit;
                                self.img.image = [UIImage imageNamed:@"no_data_hint"];
                                [tableView addSubview:_img];
        
                                self.lab= [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(280.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
                                self.lab.textColor = I_COLOR_33BLACK;
                                self.lab.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
                                self.lab.textAlignment = NSTextAlignmentCenter;
                                self.lab.text = @"还没有帖子呦，请去逛逛吧！";
                                [tableView addSubview:self.lab];
                            }else{
                                
                                [_img  removeFromSuperview];
                                [_lab  removeFromSuperview];

                            }
//         NSLog(@"\nself.postArray ====== %@\n +++++++ %ld",self.postArray[0],tableView.tag);
                                
    } failure:^(NSError *error) {
//        NSLog(@"localizedDescription ========== %@",error.localizedDescription);
       [ProgressHUD dismiss];
        PostInfo *lastPost = [self.postArray lastObject];
        self.loadTime = lastPost.createTime;
        self.prePostId = lastPost.pid;
        //刷新tableview
        UIView *view = (UIView *)[self.view viewWithTag:(self.selectIndex + 10000)];
        UITableView *tableView = (UITableView *)[view.subviews objectAtIndex:0];
//        [tableView.mj_footer endRefreshingWithNoMoreData];
        [tableView.mj_header endRefreshing];
        [tableView reloadData];
        
        //经过调试 本画面与关注的熊宝无数据时有关  切勿乱删
        if(self.postArray.count <= 0) {
            self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(120.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
            self.img.contentMode = UIViewContentModeScaleAspectFit;
            self.img.image = [UIImage imageNamed:@"no_data_hint"];
            [tableView addSubview:_img];
            
            self.lab= [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(280.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
            self.lab.textColor = I_COLOR_33BLACK;
            self.lab.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
            self.lab.textAlignment = NSTextAlignmentCenter;
            self.lab.text = @"还没有帖子呦，请去逛逛吧！";
              [tableView addSubview:self.lab];
        }else{
            [_img  removeFromSuperview];
            [_lab  removeFromSuperview];
        }
    }];
}
- (void)showNewStatusCount:(int)count
{
    // 1.创建一个按钮
    UIButton *btn = [[UIButton alloc] init];
    // below : 下面  btn会显示在self.navigationController.navigationBar的下面
    [self.mHACursor insertSubview:btn belowSubview:self.mHACursor.scrollNavBar];
    // 2.设置图片和文字
    btn.userInteractionEnabled = NO;
    btn.backgroundColor = [UIColor colorWithRed:44/255.0 green:44/255.0 blue:44/255.0 alpha:0.6];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
    NSString *title = nil;
    if (count == 0) {
          title = [NSString stringWithFormat:@"暂无帖子更新"];
    }else{
        title = [NSString stringWithFormat:@"有%d条新帖子",count];
    }
    
        [btn setTitle:title forState:UIControlStateNormal];
    // 3.设置按钮的初始frame
    CGFloat btnH = CONVER_VALUE(40.0f);
    CGFloat btnY = 0 ;
    CGFloat btnX = 0;
    CGFloat btnW = self.view.frame.size.width;
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    // 4.通过动画移动按钮(按钮向下移动 btnH + 1)
    [UIView animateWithDuration:0.5 animations:^{
        
        btn.transform = CGAffineTransformMakeTranslation(0, TRANS_VALUE(34.0f));
        
    } completion:^(BOOL finished) { // 向下移动的动画执行完毕后
        
        // 建议:尽量使用animateWithDuration, 不要使用animateKeyframesWithDuration
        [UIView animateWithDuration:0.5 delay:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
            btn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            // 将btn从内存中移除
            [btn removeFromSuperview];
        }];
        
    }];
}
//获取更多数据
- (void)loadMoreData {
    [_img  removeFromSuperview];
    [_lab  removeFromSuperview];
    
    IncubatorTypeInfo *typeInfo = [self.topicArray objectAtIndex:self.selectIndex];
    
    if(!typeInfo.type) {
        return;
    }
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
    NSString *pageSize = [NSString string];
    if (self.selectIndex == 0) {
       pageSize =@"10";
    }else{
       pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:pageNo forKey:@"pageNo"];
    [params setObject:pageSize forKey:@"pageSize"];
    [params setObject:typeInfo.type forKey:@"type"];
    [params setObject:ACTION_TYPE_LOAD_MORE forKey:@"actionType"];
    if (self.refreshTime != nil ||self.refreshTime) {
        [params setObject:self.loadTime forKey:@"refreshTime"];
    }
    if (self.prePostId != nil) {
    [params setObject:self.prePostId forKey:@"postId"];
    }
    [[IncubatorAPIRequest sharedInstance] getIncubatorPosts:params success:^(NSArray *postList) {
        if (postList.count != 0) {
            [_img  removeFromSuperview];
            [_lab  removeFromSuperview];
        }
        UIView *view = (UIView *)[self.view viewWithTag:(self.selectIndex + 10000)];
        UITableView *tableView = (UITableView *)[view.subviews objectAtIndex:0];
        self.currentTableView = tableView;
        if(postList && postList.count > 0) {
            NSSortDescriptor *creatTimeDesc  = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO];
            NSArray *descs = [NSArray arrayWithObjects:creatTimeDesc, nil];
            NSArray *sortedArray = [postList sortedArrayUsingDescriptors:descs];
            PostInfo *lastestPost = [sortedArray lastObject];
            self.prePostId = lastestPost.pid;
            self.loadTime = lastestPost.createTime;
//            NSLog(@"\n%@",lastestPost.title);
//            if (self.selectIndex == 0) {
//                [tableView.mj_footer endRefreshing];
//            }else{
                 [self.postArray addObjectsFromArray:sortedArray];
//            }
            if(postList.count >= self.pageSize) {
                self.pageNo ++;
                [tableView.mj_footer endRefreshing];
            } else {
                [tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [tableView.mj_footer endRefreshingWithNoMoreData];
        
        }
    //刷新tableview
        [tableView reloadData];
    } failure:^(NSError *error) {
        //刷新tableview
        UIView *view = (UIView *)[self.view viewWithTag:(self.selectIndex + 10000)];
        UITableView *tableView = (UITableView *)[view.subviews objectAtIndex:0];
        [tableView.mj_footer endRefreshingWithNoMoreData];
        [tableView reloadData];
    }];
}


#pragma mark - Private Method
- (void)loadData {
    //获取发现主题列表
    [self getIncubatorTypes];
}

//获取主页帖子主题列表
- (void)getIncubatorTypes {
//     NSLog(@"++++++++++++++++++++++%s",__func__);
    if(!self.topicArray) {
        self.topicArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.topicArray removeAllObjects];
    if(!self.topicTitleArray) {
        self.topicTitleArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.topicTitleArray removeAllObjects];
    
    IncubatorTypeInfo *typeInfo1 = [[IncubatorTypeInfo alloc] init];
    typeInfo1.type = @"1";
    typeInfo1.title = @"最新脑洞";
    [self.topicArray addObject:typeInfo1];
    
    IncubatorTypeInfo *typeInfo2 = [[IncubatorTypeInfo alloc] init];
    typeInfo2.type = @"2";
    typeInfo2.title = @"热门围观";
    [self.topicArray addObject:typeInfo2];
    
    IncubatorTypeInfo *typeInfo3 = [[IncubatorTypeInfo alloc] init];
    typeInfo3.type = @"3";
    typeInfo3.title = @"关注的窝";
    [self.topicArray addObject:typeInfo3];
    IncubatorTypeInfo *typeInfo4 = [[IncubatorTypeInfo alloc] init];
    typeInfo4.type = @"4";
    typeInfo4.title = @"关注的宝";
    [self.topicArray addObject:typeInfo4];
    [self.topicTitleArray addObject:typeInfo1.title];
    [self.topicTitleArray addObject:typeInfo2.title];
    [self.topicTitleArray addObject:typeInfo3.title];
    [self.topicTitleArray addObject:typeInfo4.title];
    [self createUI];
    [self loadNewData];
    
}

- (void)createUI {
    if (self.mHACursor) {
        [self.mHACursor removeFromSuperview];
    }
    self.mHACursor = [[HACursor alloc] init];
    self.mHACursor.frame = CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(34));
    self.mHACursor.titles = self.topicTitleArray;
    self.mHACursor.pageViews = [self createPageViews];
    //设置根滚动视图的高度
    
    if(SCREEN_WIDTH == 320 && SCREEN_HEIGHT <= 568) {
        self.mHACursor.rootScrollViewHeight = SCREEN_HEIGHT - 20.0f - TRANS_VALUE(80.0f);
    } else {
        self.mHACursor.rootScrollViewHeight = SCREEN_HEIGHT - 10.0f - TRANS_VALUE(80.0f);
    }
    
    self.mHACursor.backgroundColor = I_BACKGROUND_COLOR;
//    //默认值是白色
    self.mHACursor.titleNormalColor = I_COLOR_33BLACK;
    //默认值是白色改为黄色
    self.mHACursor.titleSelectedColor =I_COLOR_YELLOW;
    //是否显示排序按钮
    self.mHACursor.showSortbutton = NO;
    //默认的最小值是5，小于默认值的话按默认值设置
    self.mHACursor.minFontSize = TRANS_VALUE(14.0f);
    //默认的最大值是25，小于默认值的话按默认值设置，大于默认值按设置的值处理
    //cursor.maxFontSize = 30;
    //cursor.isGraduallyChangFont = NO;
    //在isGraduallyChangFont为NO的时候，isGraduallyChangColor不会有效果
    //cursor.isGraduallyChangColor = NO;
    [self.view addSubview:self.mHACursor];
    
    self.mHACursor.delegate = self;
   
}

- (NSMutableArray *)createPageViews {
    NSMutableArray *pageViews = [NSMutableArray array];
    for (NSInteger i = 0; i < self.topicArray.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - TRANS_VALUE(34.0f) - 49.0f)];
        view.backgroundColor = BACKGROUND_COLOR;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - TRANS_VALUE(34.0f) - 49.0f )];
        [view addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = I_BACKGROUND_COLOR;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
        MyRefreshHeader *header = [MyRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        tableView.mj_header = header;
        
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        MyRefreshFooter *footer = [MyRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        tableView.mj_footer = footer;
//        if (self.postArray.count==0) {
            [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
            [footer setTitle:@"" forState:MJRefreshStateIdle];
//        }else{
//        [footer setTitle:MJRefreshAutoFooterNoMoreDataText forState:MJRefreshStateNoMoreData];
//            [footer setTitle:MJRefreshAutoFooterIdleText forState:MJRefreshStateIdle];
//        }
        [tableView registerClass:[PostTableViewCell class] forCellReuseIdentifier:@"DiscoveryTableViewCell"];
        
        view.tag = i + 10000;
        [pageViews addObject:view];
    }
    return pageViews;
}


@end
