//
//  AuthorDetailViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/30.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "AuthorDetailViewController.h"
#import "AuthorTopTableViewCell.h"
#import "AuthorPostTableViewCell.h"
#import "UIImage+Color.h"

#import "PostDetailViewController.h"
#import "ThemeDetailViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "IndexAPIRequest.h"
#import "MeAPIRequest.h"
#import "IncubatorAPIRequest.h"
#import "PostAPIRequest.h"
#import "Context.h"
#import "AttentionView.h"
//下拉刷新
#import <MJRefresh/MJRefresh.h>
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import "AttentionView.h"
#import "ProgressHUD.h"
@interface AuthorDetailViewController () <UITableViewDataSource, UITableViewDelegate, AuthorPostTableViewCellDelegate>

@property (strong, nonatomic) UIBarButtonItem *attentionButton;              //关注

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *postArray;

@property (strong, nonatomic) AuthorDetailInfo *authorDetailInfo;

@property (assign, nonatomic) NSInteger pageNo;
@property (assign, nonatomic) NSInteger pageSize;
@property (strong, nonatomic) NSString *refreshTime;
@property (strong, nonatomic) NSString *prePostId;
@property (strong, nonatomic) NSString *loadTime;
@property (nonatomic,strong) NSString *isfreeze;
@property (nonatomic,strong) NSString *thaw_date;
@property (nonatomic,strong) NSString *thaw_time;
@property (nonatomic,strong)NSString * isshow;
@property (nonatomic,strong)NSString * isshowfree;

@end

@implementation AuthorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *isfreeze = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfreeze"];
    NSString *thaw_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_date"];
    NSString *thaw_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_time"];
    NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
    
    //    NSLog(@"%@------%@-----%@",isfreeze,thaw_time,thaw_date);
    self.isfreeze = isfreeze;
    self.thaw_date = thaw_date;
    self.thaw_time = thaw_time;
    self.isshow = isshow;
     NSString *isshowfree = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshowfree"];
self.isshowfree = isshowfree;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = I_BACKGROUND_COLOR;
    self.title = @"大大们的窝";
    
    [self setBackNavgationItem];
    if ([self.authorInfo.uid isEqualToString:[Context sharedInstance].uid]) {
        
    }else{
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, CONVER_VALUE(-10.0f))];
        [button setTitle:@"关注" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(13)];
        button.titleLabel.textAlignment = NSTextAlignmentRight;
        [button addTarget:self action:@selector(attionButtonAction) forControlEvents:UIControlEventTouchUpInside];
        self.attentionButton = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = self.attentionButton;
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :I_COLOR_WHITE }];
    
    self.pageNo = 1;
    self.pageSize = 10;
    
    [self createUI];
    
    self.prePostId = @"";
    self.refreshTime = @"";
    self.loadTime = @"";
    if (self.authorUid) {
        self.authorInfo = [[AuthorInfo alloc]init];
        self.authorInfo.uid = self.authorUid;
    }
    if(!self.authorInfo || !self.authorInfo.uid) {
        AuthorInfo *authorInfo = [[AuthorInfo alloc] init];
        authorInfo.uid = nil;
        authorInfo.nickname = @"匿名大大";
        authorInfo.avatar = @"ic_avatar_default";
        self.authorInfo = authorInfo;
    } else {
        [self loadAuthorInfo];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.authorInfo.uid != nil) {
        [self loadAuthorInfo];
        [self loadAuthorPosts];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - AuthorPostTableViewCellDelegate
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
        }
    } failure:^(NSError *error) {

    }];
}

#pragma mark - Action
- (void)attionButtonAction {
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
    //TODO -- 关注按钮点击事件
    
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
        
        AttentionView * attention = [[AttentionView alloc]initTitle:@"只有熊宝可以关注人家！" andtitle2:@"*/ω＼*)"];
        [self.view addSubview:attention];
        return;
    }
    NSString *authorId = self.authorInfo.uid;
    if(!authorId || [authorId isEqualToString:@""]) {
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

    if ([self.authorInfo.uid isEqualToString:[Context sharedInstance].uid]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"您不能关注自己"];
        [self.view addSubview:attention];
        return;
    }
    NSString *type = @"1";   //1:关注 2:取消
    NSString *attentStr = @"关注";
    if([self.authorDetailInfo.isFollowed isEqualToString:@"1"]) {
        attentStr = @"取消关注";
        type = @"2";
    } else {
        attentStr = @"关注";
        type = @"1";
    }
    
    NSDictionary *params = @{
                             @"authorId" : authorId,
                             @"type" : type
                             };
    [[MeAPIRequest sharedInstance] followAuthor:params success:^(CommonInfo *resultInfo) {
        if([resultInfo isSuccess]) {
            if ([attentStr isEqualToString:@"关注"]) {
                AttentionView * attention = [[AttentionView alloc]initTitle:@"今天开始你就是本大大的小熊宝了" andtitle2:@""];
                attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
                attention.label1.frame=CGRectMake(5, 15, 220, 40);
                 attention.label1.font = [UIFont systemFontOfSize:14];
                [self.view addSubview:attention];
            }else{
                AttentionView * attention = [[AttentionView alloc]initTitle:@"就算爱淡了，也记得偶尔来看看我" andtitle2:@""];
                attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
                attention.label1.frame=CGRectMake(5, 15, 220, 40);
                attention.label1.font = [UIFont systemFontOfSize:14];
                [self.view addSubview:attention];
                
            }

            //刷新作者信息
            [self refreshAuthorInfo];
        } else {

        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView reloadData];

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
        return TRANS_VALUE(132.0f);
    } else {
        PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
        CGFloat height = [AuthorPostTableViewCell heightForCell:indexPath withCommentInfo:postInfo];
        return height;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0.0f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if(section == 0) {
//        CGFloat height = TRANS_VALUE(0.0f);
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
//        return view;
//    } else {
//        CGFloat height = TRANS_VALUE(0.0f);
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
//        return view;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 0) {
        return TRANS_VALUE(6.0f);
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
        static NSString *identifier = @"AuthorTopTableViewCell";
        AuthorTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell) {
            cell = [[AuthorTopTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.authorInfo = self.authorDetailInfo;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        static NSString *identifier = @"PostTableViewCell";
        AuthorPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell) {
            cell = [[AuthorPostTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        if(indexPath.row < [self.postArray count]) {
            PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
            cell.postItem = postInfo;
            cell.indexPath = indexPath;
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        
    } else {
        if(indexPath.row < self.postArray.count) {
            PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
            PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
            //        postDetailViewController.postInfo = postInfo;
            postDetailViewController.postId = postInfo.pid;
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

#pragma mark - Private Method
- (void)loadData {
    
    [self loadAuthorInfo];
    [self loadAuthorPosts];
    
}

- (void)refreshAuthorInfo {
    if(!self.authorInfo.uid) {
        return;
    }
    self.authorDetailInfo = nil;
    NSDictionary *params = @{
                             @"authorId" : self.authorInfo.uid
                             };
//    [SVProgressHUD showWithStatus:@"正在获取作者信息..." maskType:SVProgressHUDMaskTypeClear];
//    [ProgressHUD show:nil];
    [[IncubatorAPIRequest sharedInstance] getAuthorInfo:params success:^(AuthorDetailInfo *detailInfo) {
//        [ProgressHUD dismiss];
        if(detailInfo) {
            self.authorDetailInfo = detailInfo;
        }
        [self showAttentionButton:self.authorDetailInfo];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSError *error) {
//        [ProgressHUD dismiss];
        self.authorDetailInfo = nil;
        [self showAttentionButton:self.authorDetailInfo];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)loadAuthorInfo {
    if(!self.authorInfo.uid) {
        return;
    }
    self.authorDetailInfo = nil;
    NSDictionary *params = @{
                             @"authorId" : self.authorInfo.uid
                             };
    [ProgressHUD show:nil];
    [[IncubatorAPIRequest sharedInstance] getAuthorInfo:params success:^(AuthorDetailInfo *detailInfo) {
        [ProgressHUD dismiss];
        if(detailInfo) {
            self.authorDetailInfo = detailInfo;
//            NSLog(@"detailInfo = %@",detailInfo);
        }
        [self showAttentionButton:self.authorDetailInfo];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
        self.authorDetailInfo = nil;
        [self showAttentionButton:self.authorDetailInfo];
        [self.tableView reloadData];
    }];
}
-(void)showView{
    AttentionView *showView=[[AttentionView alloc]initTitle:@"大大走丢了，无法关注！"];
    [self.tableView addSubview:showView];
    
}
- (void)showAttentionButton:(AuthorDetailInfo *)authorInfo {
    if(!authorInfo) {
//        self.navigationItem.rightBarButtonItem = nil;
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0,TRANS_VALUE(30.0f),TRANS_VALUE(30.0f));
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, CONVER_VALUE(-10.0f))];
        button.titleLabel.textAlignment = NSTextAlignmentRight;
        [button setTitle:@"关注" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(13)];
        self.attentionButton = [[UIBarButtonItem alloc]initWithCustomView:button];
        [button addTarget:self action:@selector(showView) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = self.attentionButton;
    } else {
        if([authorInfo.isFollowed isEqualToString:@"1"]) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0,TRANS_VALUE(60.0f),TRANS_VALUE(30.0f));
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, CONVER_VALUE(-10.0f))];
            [button setTitle:@"取消关注" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(13)];
            button.titleLabel.textAlignment = NSTextAlignmentRight;
            self.attentionButton = [[UIBarButtonItem alloc]initWithCustomView:button];
            [button addTarget:self action:@selector(attionButtonAction) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = self.attentionButton;
        } else {
            if ([self.authorInfo.uid isEqualToString:[Context sharedInstance].uid]) {
                
            }else{
                UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, CONVER_VALUE(-10.0f))];
                [button setTitle:@"关注" forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(13)];
                button.titleLabel.textAlignment = NSTextAlignmentRight;
                [button addTarget:self action:@selector(attionButtonAction) forControlEvents:UIControlEventTouchUpInside];
                self.attentionButton = [[UIBarButtonItem alloc]initWithCustomView:button];
                self.navigationItem.rightBarButtonItem = self.attentionButton;
            }
        }
    }
}


- (void)loadAuthorPosts {
    if(!self.postArray) {
        self.postArray = [NSMutableArray arrayWithCapacity:0];
        [self.postArray removeAllObjects];
    }
    
    [self.tableView.mj_footer resetNoMoreData];
//    [SVProgressHUD showWithStatus:@"正在获取最新的作者帖子列表..." maskType:SVProgressHUDMaskTypeClear];
    [ProgressHUD show:nil];
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:pageNo forKey:@"pageNo"];
    [params setObject:pageSize forKey:@"pageSize"];
    [params setObject:ACTION_TYPE_REFRESH forKey:@"actionType"];
    [params setObject:self.refreshTime forKey:@"refreshTime"];
    [params setObject:self.prePostId forKey:@"postId"];
    [params setObject:self.authorInfo.uid forKey:@"authorId"];
    [[IncubatorAPIRequest sharedInstance] getAuthorPosts:params success:^(NSArray *postList) {
        [ProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        if(postList && postList.count > 0) {
            NSSortDescriptor *creatTimeDesc = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO];
            NSArray *descs = [NSArray arrayWithObjects:creatTimeDesc, nil];
            NSArray *sortedArray = [postList sortedArrayUsingDescriptors:descs];
            PostInfo *firstPost = [sortedArray firstObject];
            self.refreshTime = firstPost.createTime;
            if(self.postArray.count == 0) {
                [self.postArray addObjectsFromArray:sortedArray];
            } else {
                [self.postArray insertObjects:sortedArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, sortedArray.count)]];
            }
            
            PostInfo *lastPost = [self.postArray lastObject];
            self.loadTime = lastPost.createTime;
            if(postList.count >= self.pageSize) {
                self.pageNo ++;
            }
        } else {
            PostInfo *lastPost = [self.postArray lastObject];
            self.loadTime = lastPost.createTime;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        //刷新tableview
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [ProgressHUD dismiss];
        PostInfo *lastPost = [self.postArray lastObject];
        self.loadTime = lastPost.createTime;
        //        [TSMessage showNotificationWithTitle:[error localizedDescription] subtitle:nil type:TSMessageNotificationTypeError];
//        AttentionView *attention = [[AttentionView alloc]initTitle:[error localizedDescription]];
//        [self.view addSubview:attention];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)loadMorePosts {
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
    [SVProgressHUD showWithStatus:@"正在加载更多作者帖子..." maskType:SVProgressHUDMaskTypeClear];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:pageNo forKey:@"pageNo"];
    [params setObject:pageSize forKey:@"pageSize"];
    [params setObject:ACTION_TYPE_LOAD_MORE forKey:@"actionType"];
    [params setObject:self.loadTime forKey:@"refreshTime"];
    [params setObject:self.prePostId forKey:@"postId"];
    [params setObject:self.loadTime forKey:@"refreshTime"];
     [params setObject:self.authorInfo.uid forKey:@"authorId"];
    [[IncubatorAPIRequest sharedInstance] getAuthorPosts:params success:^(NSArray *postList) {
        [SVProgressHUD dismiss];
        if(postList && postList.count > 0) {
            NSSortDescriptor *creatTimeDesc = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO];
            NSArray *descs = [NSArray arrayWithObjects:creatTimeDesc, nil];
            NSArray *sortedArray = [postList sortedArrayUsingDescriptors:descs];
            PostInfo *lastestPost = [sortedArray lastObject];
            self.prePostId = lastestPost.pid;
            self.loadTime = lastestPost.createTime;
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
        //刷新tableview
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"localizedDescription ========= %@",error.localizedDescription);
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
    }];
}

- (void)createUI {
    //实例化表单控件
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
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
    
    //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
//    MyRefreshHeader *header = [MyRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//    self.tableView.mj_header = header;
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
    
    [self.tableView registerClass:[AuthorTopTableViewCell class] forCellReuseIdentifier:@"TopicTopTableViewCell"];
    [self.tableView registerClass:[AuthorPostTableViewCell class] forCellReuseIdentifier:@"PostTableViewCell"];
}
@end
