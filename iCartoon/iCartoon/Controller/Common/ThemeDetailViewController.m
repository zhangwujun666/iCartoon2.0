//
//  TopicDetailViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/30.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "ThemeDetailViewController.h"
#import "AuthorDetailViewController.h"
#import "TopicTopTableViewCell.h"
#import "ThemePostTableViewCell.h"
#import "UIImage+Color.h"

#import "PostViewController.h"
#import "LoginViewController.h"
#import "PostDetailViewController.h"
#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "IndexAPIRequest.h"
#import "PostAPIRequest.h"
#import "Context.h"
//下拉刷新
#import <MJRefresh/MJRefresh.h>
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import "AttentionView.h"
#import "ProgressHUD.h"
@interface ThemeDetailViewController () <UITableViewDataSource, UITableViewDelegate, TopicTopTableViewCellDelegate, ThemePostTableViewCellDelegate>

@property (strong, nonatomic) UIBarButtonItem *postButton;           //发布帖子

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *postArray;

@property (strong, nonatomic) ThemeDetailInfo *themeDetailInfo;

@property (assign, nonatomic) NSInteger pageNo;
@property (assign, nonatomic) NSInteger pageSize;

@property (nonatomic,strong)NSString * contentStr;
@property (nonatomic,strong)NSString * titleStr;
@property (nonatomic,strong)NSString * selectedTheme;
@property (nonatomic,strong)NSArray *pictureArray;
@property (nonatomic,strong)NSMutableDictionary *result;
@property (nonatomic,strong) NSString *isfreeze;
@property (nonatomic,strong) NSString *thaw_date;
@property (nonatomic,strong) NSString *thaw_time;
@property (nonatomic,strong)NSString * isshow;
@property (nonatomic,strong)NSString * isshowfree;

@end

@implementation ThemeDetailViewController

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
    self.title = @"主题详情";
    if(self.themeInfo.title) {
        self.title = self.themeInfo.title;
    }
    [self setBackNavgationItem];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removepost) name:@"removepost" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(haveFinishedPost) name:@"haveFinishedPost" object:nil];
    self.postButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_navi_post"] style:UIBarButtonItemStylePlain target:self action:@selector(postButtonAction)];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addPost:) name:@"addPost" object:nil];
    self.navigationItem.rightBarButtonItem = self.postButton;
    
    self.pageNo = 1;
    self.pageSize = 10;
    
    [self createUI];
    
    [self loadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.themeDetailInfo) {
//        [self loadThemePosts];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)popBack {
    if (self.fromWhere == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
            }];
    }
}

#pragma mark - Action 
- (void)editButtonAction:(id)sender {
    //TODO -- 编辑按钮
    ThemeInfo *themeInfo = [[ThemeInfo alloc] init];
    themeInfo.tid = self.themeDetailInfo.tid;
    themeInfo.title = self.themeDetailInfo.title;
    themeInfo.imageUrl = self.themeInfo.imageUrl;
    PostViewController *postViewController = [[PostViewController alloc] init];
    postViewController.type = PostSourceTypeTheme;
    postViewController.themeInfo = themeInfo;
    [self.navigationController pushViewController:postViewController animated:YES];
}
- (void)haveFinishedPost{
    sleep(2);
    self.titleStr = nil;
     [self loadThemePosts];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"haveFinishedPost" object:nil];
}
- (void)addPost:(NSNotification *)noti{
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
   
   NSArray * postList = [MTLJSONAdapter modelsOfClass:[PostInfo class] fromJSONArray: array error:nil];
//     NSLog(@"array ========= %@",postList[0]);
    [self.postArray insertObject:postList[0] atIndex:0];
    [self.tableView reloadData];
    
}
- (void)removepost{
    [self.postArray removeObjectAtIndex:0];
    [self.tableView reloadData];

}
- (void)postButtonAction {
    //TODO -- 发帖按钮点击事件
//    NSLog(@"postArray ==== %@",self.postArray);
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
        LoginViewController * login = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
            }else{
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
//                if (![self.isshowfree isEqualToString:@"1"]&&![self.isfreeze isEqualToString:@"1"]) {
//                    AttentionView * attention = [[AttentionView alloc]initTitlestr:@"账号被解冻啦o(*￣▽￣*)ゞ 下次不要再犯错咯！"];
//                    [self.view addSubview:attention];
//                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isshowfree"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                }

        ThemeInfo *themeInfo = [[ThemeInfo alloc] init];
        themeInfo.tid = self.themeDetailInfo.tid;
        themeInfo.title = self.themeDetailInfo.title;
        themeInfo.imageUrl = self.themeInfo.imageUrl;
        PostViewController *postViewController = [[PostViewController alloc] init];
        postViewController.type = PostSourceTypeTheme;
        postViewController.themeInfo = themeInfo;
        [self.navigationController pushViewController:postViewController animated:YES];
    }
    
}

#pragma mark - AuthorPostTableViewCellDelegate
- (void)commentPostForItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath {
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
        PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
        PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
        //        postDetailViewController.postInfo = postInfo;
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
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
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
    [self.navigationController pushViewController:authorDetailViewController animated:YES];
}

- (void)clickThemeAtItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath {
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

//为帖子点赞
- (void)favorPost:(PostInfo *)postInfo atIndexPath:(NSIndexPath *)indexPath {
    NSString *type = @"1";
    if([postInfo.favorStatus isEqualToString:@"1"]) {
        type = @"3";
    }
    [self actPostWithType:type withPostId:postInfo.pid atIndexPath:indexPath];
}

- (void)actPostWithType:(NSString *)type withPostId:(NSString *)postId atIndexPath:(NSIndexPath *)indexPath {
    //    [SVProgressHUD showWithStatus:@"正在为帖子点赞或者加踩..." maskType:SVProgressHUDMaskTypeClear];
    NSDictionary *params = @{
                             @"postId": postId,
                             @"favorType" : type
                             };
    [[PostAPIRequest sharedInstance] favorPost:params success:^(CommonInfo *resultInfo) {
        [SVProgressHUD dismiss];
        if(resultInfo && [resultInfo isSuccess]) {
            if(indexPath.row < self.postArray.count) {
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
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        } else {
//            [TSMessage showNotificationWithTitle:@"操作失败" subtitle:nil type:TSMessageNotificationTypeError];
            AttentionView *attention = [[AttentionView alloc]initTitle:@"操作失败"];
            [self.view addSubview:attention];
        }
    } failure:^(NSError *error) {

    }];
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 1;
    } else {
        NSInteger count = self.postArray != nil ? self.postArray.count : 0;
        return count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return TRANS_VALUE(168.0f);
    } else {
            PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
            CGFloat height = [ThemePostTableViewCell heightForCell:indexPath withCommentInfo:postInfo];
             return height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        CGFloat height = TRANS_VALUE(0.0f);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        return view;
    } else {
        CGFloat height = TRANS_VALUE(0.0f);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 0) {
        return TRANS_VALUE(8.0f);
    } else {
        return 0.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section == 0) {
        CGFloat height = TRANS_VALUE(8.0f);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        view.backgroundColor = I_BACKGROUND_COLOR;
        return view;
    } else {
        CGFloat height = TRANS_VALUE(0.0f);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        view.backgroundColor = I_COLOR_WHITE;
        return view;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        static NSString *identifier = @"TopicTopTableViewCell";
        TopicTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell) {
            cell = [[TopicTopTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.delegate = self;
        cell.themeInfo = self.themeDetailInfo;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        static NSString *identifier = @"PostTableViewCell";
        ThemePostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell) {
            cell = [[ThemePostTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        if(indexPath.row < [self.postArray count]) {
            if (indexPath.row == 0 && self.result) {
                cell.result = self.result;
            }else{
                PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
                cell.postItem = postInfo;
                cell.indexPath = indexPath;
            }
           
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        
    } else {
        if(indexPath.row < self.postArray.count&&self.titleStr == nil) {
            PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
            PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
            postDetailViewController.postInfo = postInfo;
            postDetailViewController.postId = postInfo.pid;
            postDetailViewController.fromWhere = @"ThemeDetail";
            postDetailViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:postDetailViewController animated:YES];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if(indexPath.row < 1) {
            if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        } else {
            if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
    } else {
        if(indexPath.row < [self.postArray count]) {
            if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
            }
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
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
}



#pragma mark - TopicTopTableViewCellDelegate
- (void)followActionForTheme:(ThemeDetailInfo *)themeInfo {
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
        AttentionView * attention = [[AttentionView alloc]initTitle:@"只要你答应做熊宝，就给你关注！" andtitle2:@"*/ω＼*)"];
        attention.label1.font = [UIFont systemFontOfSize:14];
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
    NSString *followStatus = themeInfo.followStatus;
    //0未关注，1已关注。如果请求没有传token则为0
    NSString *type = @"0";
    NSString *actionStr = @"关注";
    if([followStatus isEqualToString:@"0"]) {
        type = @"1";
        actionStr = @"关注";
    } else if([followStatus isEqualToString:@"1"]) {
        type = @"0";
        actionStr = @"取消关注";
    } else {
        type = @"0";
        actionStr = @"取消关注";
    }
    if(!self.themeId) {
        return;
    }
    NSDictionary *params = @{
                             @"themeIds" : @[self.themeId],
                             @"type" : type
                             };

    [[IndexAPIRequest sharedInstance] followTheme:params success:^(CommonInfo *resultInfo) {
        if(resultInfo && [resultInfo isSuccess]) {
            if ([actionStr isEqualToString:@"关注"]) {
                AttentionView * attention = [[AttentionView alloc]initTitle:@"恭喜找到熊（zu）窝（zhi）" andtitle2:@""];
                attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
                attention.label1.frame=CGRectMake(5, 15, 220, 40);
                [self.view addSubview:attention];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"changeColor" object:nil];
            }else{
                AttentionView * attention = [[AttentionView alloc]initTitle:@"知道你要远行，我们会想你的" andtitle2:@""];
                attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
                attention.label1.frame=CGRectMake(5, 15, 220, 40);
                [self.view addSubview:attention];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"changeColor" object:nil];
            }
            //刷新主题信息
            [self refreshThemeInfo];
        } else {
            AttentionView *attention = [[AttentionView alloc]initTitle:[NSString stringWithFormat:@"%@失败", actionStr]];
            [self.view addSubview:attention];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}

- (void)clickAuthorAtItem:(ThemeInfo *)theme {
    AuthorDetailViewController *authorDetailViewController = [[AuthorDetailViewController alloc] init];
    [self.navigationController pushViewController:authorDetailViewController animated:YES];
}


#pragma mark - Private Method
- (void)loadData {
    [self loadThemeInfo];
}

- (void)refreshThemeInfo {
    if(!self.themeId) {
        return;
    }
    self.themeDetailInfo = nil;
    NSDictionary *params = @{
                             @"themeId" : self.themeId
                             };
//    [SVProgressHUD showWithStatus:@"正在获取熊窝详情..." maskType:SVProgressHUDMaskTypeClear];
    [[IndexAPIRequest sharedInstance] getThemeInfo:params success:^(ThemeDetailInfo *detailInfo) {
//        [SVProgressHUD dismiss];
        if(detailInfo) {
            self.themeDetailInfo = detailInfo;
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)loadThemeInfo {
    if(!self.themeId) {
        return;
    }
    self.themeDetailInfo = nil;
    NSDictionary *params = @{
                             @"themeId" : self.themeId
                             };
    [ProgressHUD show:nil];
    [[IndexAPIRequest sharedInstance] getThemeInfo:params success:^(ThemeDetailInfo *detailInfo) {
        [ProgressHUD dismiss];
        if(detailInfo) {
            self.themeDetailInfo = detailInfo;
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        //加载帖子列表
        [self loadThemePosts];
    } failure:^(NSError *error) {
        [ProgressHUD dismiss];
        [self.tableView reloadData];
    }];
}

- (void)loadMorePosts {
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
    [ProgressHUD show:nil];
    NSDictionary *params = @{
                             @"themeId" : self.themeId,
                             @"pageNo" : pageNo,
                             @"pageSize" : pageSize
                             };
    [[IndexAPIRequest sharedInstance] getThemePosts:params success:^(NSArray *postArray) {
        [ProgressHUD dismiss];
        if(postArray) {
            [self.postArray addObjectsFromArray:postArray];
            if(postArray.count >= self.pageSize) {
                self.pageNo ++;
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSError *error) {
        [ProgressHUD dismiss];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    
}

- (void)loadThemePosts {
    if(!self.postArray) {
        self.postArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.postArray removeAllObjects];
    self.pageNo = 1;
    self.pageSize = 10;
    [self.tableView.mj_footer resetNoMoreData];
    NSString *pageNo = [NSString stringWithFormat:@"%ld", self.pageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%ld", self.pageSize];
    [ProgressHUD show:nil];
    NSDictionary *params = @{
                             @"themeId" : self.themeId,
                             @"pageNo" : pageNo,
                             @"pageSize" : pageSize
                             };
    [[IndexAPIRequest sharedInstance] getThemePosts:params success:^(NSArray *postArray) {
        [ProgressHUD dismiss];
//        NSLog(@"%@",postArray[0]);
        if(postArray) {
            [self.postArray addObjectsFromArray:postArray];
            if(postArray.count >= self.pageSize) {
                self.pageNo ++;
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSError *error) {
        [ProgressHUD dismiss];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    
}

- (void)createUI {
    //实例化表单控件
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = I_DIVIDER_COLOR;
    self.tableView.backgroundColor = I_BACKGROUND_COLOR;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20.0f)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MyRefreshFooter *footer = [MyRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMorePosts)];
    self.tableView.mj_footer = footer;
    
    //设置tableview分割线
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.tableView registerClass:[TopicTopTableViewCell class] forCellReuseIdentifier:@"TopicTopTableViewCell"];
    [self.tableView registerClass:[ThemePostTableViewCell class] forCellReuseIdentifier:@"PostTableViewCell"];
}
@end
