//
//  MorePostViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "MorePostsViewController.h"
#import "PostTableViewCell.h"
#import "PostDetailViewController.h"
#import "TopTabButton.h"
#import "Context.h"
#import "LoginViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "ThemeDetailViewController.h"
#import "AuthorDetailViewController.h"
#import "IncubatorAPIRequest.h"
#import "PostAPIRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
//下拉刷新，上拉加载
#import <MJRefresh/MJRefresh.h>
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import "AttentionView.h"
#import "ProgressHUD.h"
@interface MorePostsViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, PostTableViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *postArray;

@property (assign, nonatomic) NSInteger pageNo;
@property (assign, nonatomic) NSInteger pageSize;

@property (strong, nonatomic) NSString *refreshTime;
@property (strong, nonatomic) NSString *loadTime;
@property (strong, nonatomic) NSString *prePostId;

@end

@implementation MorePostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"更多热议";
    
    [self setBackNavgationItem];
    
//    //导航栏操作按钮
//    self.menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_navi_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonAction)];
//    self.navigationItem.leftBarButtonItem = self.menuButton;
//    self.searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_navi_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonAction)];
//    self.navigationItem.rightBarButtonItem = self.searchButton;
    
    self.pageNo = 1;
    self.pageSize = 50;
    
    [self createUI];
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
    
    } else {
        [self loadData];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - UIAlertVeiwDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        //TODO -- 用户登录
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:navigationController animated:YES completion:^{
            
        }];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.postArray != nil ? [self.postArray count] : 0;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
    CGFloat height = [PostTableViewCell heightForCell:indexPath withCommentInfo:postInfo];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0f;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    view.backgroundColor = RGBCOLOR(247, 247, 247);
    return view;
}


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
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
    PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
    postDetailViewController.postId = postInfo.pid;
    postDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postDetailViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < self.postArray.count) {
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
//回复
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

//点击标签按钮
-(void)clickThemeAtItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath{
    if (!postInfo.theme) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        ThemeDetailViewController *topicDeatailViewController =[[ThemeDetailViewController alloc]init];
        topicDeatailViewController.themeInfo=postInfo.theme;
        topicDeatailViewController.themeId=postInfo.theme.tid;
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:topicDeatailViewController];
        [self presentViewController:navigationController animated:YES completion:^{
            
        }];
    });
}

- (void)favorPostForItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath {
    if(![Context sharedInstance].token) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"点赞是熊宝哒特权！" andtitle2:@"*/ω＼*)"];
        [self.view addSubview:attention];
        return;
    }
    if(postInfo != nil && postInfo.pid != nil) {
        [self favorPost:postInfo atIndexPath:indexPath];
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
    NSDictionary *params = @{
                             @"postId": postId,
                             @"favorType" : type
                             };
    [[PostAPIRequest sharedInstance] favorPost:params success:^(CommonInfo *resultInfo) {
        //        [SVProgressHUD dismiss];
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
            [self.tableView reloadData];
        } else {
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        //        [TSMessage showNotificationWithTitle:[error localizedDescription] subtitle:nil type:TSMessageNotificationTypeError];
        //        AttentionView *attention = [[AttentionView alloc]initTitle:[error localizedDescription]];
        //        [self.view addSubview:attention];
    }];
}


//点击头像
-(void)clickAuthorAtItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath{
    AuthorDetailViewController *authorDetailViewController= [[AuthorDetailViewController alloc]init];
    authorDetailViewController.authorInfo = postInfo.author;
    authorDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:authorDetailViewController animated:YES];
}



//刷新数据
- (void)loadNewData {
    self.pageNo = 1;
    if(!self.postArray) {
        self.postArray = [NSMutableArray arrayWithCapacity:0];
        [self.postArray removeAllObjects];
    }
    [self.tableView.mj_footer resetNoMoreData];
   [ProgressHUD show:nil];
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:pageNo forKey:@"pageNo"];
    [params setObject:pageSize forKey:@"pageSize"];
    [params setObject:@"2" forKey:@"type"];
    [params setObject:ACTION_TYPE_REFRESH forKey:@"actionType"];
    [params setObject:self.refreshTime forKey:@"refreshTime"];
    [params setObject:self.prePostId forKey:@"postId"];
    [[IncubatorAPIRequest sharedInstance] getIncubatorPosts:params success:^(NSArray *postList) {
        [ProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        if(postList && postList.count > 0) {
//            NSSortDescriptor *creatTimeDesc = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO];
//            NSArray *descs = [NSArray arrayWithObjects:creatTimeDesc, nil];
//            NSArray *sortedArray = [postList sortedArrayUsingDescriptors:descs];
//            PostInfo *firstPost = [sortedArray firstObject];
            //self.refreshTime = firstPost.createTime;
            if(self.postArray.count == 0) {
                [self.postArray addObjectsFromArray:postList];
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
        //刷新tableview
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

//获取更多数据
- (void)loadMoreData {
//    [SVProgressHUD showWithStatus:@"正在加载更多帖子..." maskType:SVProgressHUDMaskTypeClear];
    [ProgressHUD show:nil];
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:pageNo forKey:@"pageNo"];
    [params setObject:pageSize forKey:@"pageSize"];
    [params setObject:@"2" forKey:@"type"];
    [params setObject:ACTION_TYPE_LOAD_MORE forKey:@"actionType"];
    [params setObject:self.loadTime forKey:@"refreshTime"];
    [params setObject:self.prePostId forKey:@"postId"];
    [[IncubatorAPIRequest sharedInstance] getIncubatorPosts:params success:^(NSArray *postList) {
        [ProgressHUD dismiss];
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
         [ProgressHUD dismiss];
        //刷新tableview
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
    }];
}

- (void)loadData {
    //TODO -- 默认选中设计师
    self.loadTime = @"";
    self.refreshTime = @"";
    self.prePostId = @"";
    [self loadNewData];
}

- (void)createUI {
    //实例化表单控件
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f - 0) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = I_BACKGROUND_COLOR;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MyRefreshHeader *header = [MyRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MyRefreshFooter *footer = [MyRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    
    [self.tableView registerClass:[PostTableViewCell class] forCellReuseIdentifier:@"AttentionTableViewCell"];
    
    [self.tableView reloadData];

}


@end
