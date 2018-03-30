//
//  FavoriteAuthorViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "FavoriteAuthorViewController.h"
#import "FavoriteAuthorTableViewCell.h"
#import "FavoriteAuthorInfo.h"
#import "AuthorDetailViewController.h"

//下拉刷新
#import <MJRefresh/MJRefresh.h>
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "MeAPIRequest.h"
#import "ConcernedAuthorInfo.h"
#import "AttentionView.h"
#import "ProgressHUD.h"
@interface FavoriteAuthorViewController () <UITableViewDataSource, UITableViewDelegate, FavoriteAuthorTableViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *authorArray;

@property (assign, nonatomic) NSInteger pageNo;
@property (assign, nonatomic) NSInteger pageSize;

@property (strong, nonatomic)UIImageView *img;
@property (strong, nonatomic)UILabel *lab;
@property (nonatomic,strong) NSString *isfreeze;
@property (nonatomic,strong) NSString *thaw_date;
@property (nonatomic,strong) NSString *thaw_time;
@property (nonatomic,strong)NSString * isshow;
@property (nonatomic,strong)NSString * isshowfree;
@end

@implementation FavoriteAuthorViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的关注";
    [self setBackNavgationItem];
    
    self.pageNo = 1;
    self.pageSize = 10;
    
    [self createUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
#pragma mark - MyCorncernedTableViewCellDelegate
- (void)cancelConcernAtIndexPath:(NSIndexPath *)indexPath {
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
    //TODO -- 取消关注
    ConcernedAuthorInfo *author = [self.authorArray objectAtIndex:indexPath.row];
    NSString *authorId = author.authorId;
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

    NSString *type = @"2";   //取消关注
    NSDictionary *params = @{
                             @"authorId" : authorId,
                             @"type" : type
                             };
//    [SVProgressHUD showWithStatus:@"正在取消关注..." maskType:SVProgressHUDMaskTypeClear];
    [[MeAPIRequest sharedInstance] followAuthor:params success:^(CommonInfo *resultInfo) {
//        [SVProgressHUD dismiss];
        if([resultInfo isSuccess]) {
            [self.authorArray removeObjectAtIndex:indexPath.row];
            AttentionView * attention = [[AttentionView alloc]initTitle:@"就算爱淡了，也记得偶尔来看看我" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            attention.label1.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:attention];
            
 
            
            
        } else {
//            [TSMessage showNotificationWithTitle:@"取消关注失败" subtitle:nil type:TSMessageNotificationTypeError];
            AttentionView *attention = [[AttentionView alloc]initTitle:@"取消关注失败"];
            [self.view addSubview:attention];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.authorArray != nil ? self.authorArray.count : 0;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CONVER_VALUE(105.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0f;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    view.backgroundColor = I_BACKGROUND_COLOR;
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"FavoriteAuthorTableViewCell";
    FavoriteAuthorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[FavoriteAuthorTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if(indexPath.row < self.authorArray.count) {
        //TOOD -- 我的关注
        ConcernedAuthorInfo *authorInfo = (ConcernedAuthorInfo *)[self.authorArray objectAtIndex:indexPath.row];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.authorInfo = authorInfo;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //TOOD －－ 用户详情页面
    if(indexPath.row < self.authorArray.count) {
        ConcernedAuthorInfo *selectedAuthorInfo = (ConcernedAuthorInfo *)[self.authorArray objectAtIndex:indexPath.row];
        AuthorInfo *authorInfo = [[AuthorInfo alloc] init];
        authorInfo.uid = selectedAuthorInfo.authorId;
        authorInfo.nickname = selectedAuthorInfo.nickname;
        authorInfo.avatar = selectedAuthorInfo.avatarUrl;
        AuthorDetailViewController *authorDetailViewController = [[AuthorDetailViewController alloc] init];
        authorDetailViewController.authorInfo = authorInfo;
        [self.navigationController pushViewController:authorDetailViewController animated:YES];

    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < self.authorArray.count) {
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

#pragma mark - Private Method
- (void)createUI {
    //实例化表单控件
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = I_DIVIDER_COLOR;
    self.tableView.backgroundColor = I_BACKGROUND_COLOR;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(0.0f))];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MyRefreshHeader *header = [MyRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MyRefreshFooter *footer = [MyRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
    
    //设置tableview分割线
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (void)loadData {
    [self loadNewData];
}

#pragma mark - Private Method
//刷新数据
- (void)loadNewData {
    [self.img removeFromSuperview];
    [self.lab removeFromSuperview];
    self.pageNo = 1;
    [self.tableView.mj_footer resetNoMoreData];
    if(!self.authorArray) {
        self.authorArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.authorArray removeAllObjects];
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
    NSDictionary *params = @{
                             @"pageNo" : pageNo,
                             @"pageSize" : pageSize
                             };
    [[MeAPIRequest sharedInstance] getUserFollowedAuthors:params success:^(NSArray *authorArray) {
        [self.tableView.mj_header endRefreshing];
        if(authorArray) {
            [self.authorArray addObjectsFromArray:authorArray];
            if(authorArray.count >= self.pageSize) {
                self.pageNo ++;
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.authorArray.count==0) {
            self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(120.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
            self.img.contentMode = UIViewContentModeScaleAspectFit;
            self.img.image = [UIImage imageNamed:@"no_data_hint"];
            [self.tableView addSubview:_img];
            
            self.lab= [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(280.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
            self.lab.textColor = I_COLOR_33BLACK;
            self.lab.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
            self.lab.textAlignment = NSTextAlignmentCenter;
            self.lab.text = @"你还没有关注，快去逛逛吧！";
            [self.tableView addSubview:self.lab];
            
        }

        [self.tableView reloadData];
    } failure:^(NSError *error) {
        self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(120.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
        self.img.contentMode = UIViewContentModeScaleAspectFit;
        self.img.image = [UIImage imageNamed:@"bg_network"];
        [self.tableView addSubview:_img];
        
        self.lab= [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(280.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
        self.lab.textColor = I_COLOR_33BLACK;
        self.lab.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
        self.lab.textAlignment = NSTextAlignmentCenter;
        self.lab.text = @"页面好像走丢了，刷新试试吧...";
        [self.tableView addSubview:self.lab];
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        //        [TSMessage showNotificationWithTitle:[error localizedDescription] subtitle:nil type:TSMessageNotificationTypeError];
//        AttentionView *attention = [[AttentionView alloc]initTitle:[error localizedDescription]];
//        [self.view addSubview:attention];
        [self.tableView reloadData];
    }];
}

//加载更多数据
- (void)loadMoreData {
    [ProgressHUD show:nil];
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
    NSDictionary *params = @{
                             @"pageNo" : pageNo,
                             @"pageSize" : pageSize
                             };
    [[MeAPIRequest sharedInstance] getUserFollowedAuthors:params success:^(NSArray *authorArray) {
        [ProgressHUD dismiss];
        if(authorArray) {
            [self.authorArray addObjectsFromArray:authorArray];
            if(authorArray.count >= self.pageSize) {
                [self.tableView.mj_footer endRefreshing];
                self.pageNo ++;
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [ProgressHUD dismiss];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        //        [TSMessage showNotificationWithTitle:[error localizedDescription] subtitle:nil type:TSMessageNotificationTypeError];
//        AttentionView *attention = [[AttentionView alloc]initTitle:[error localizedDescription]];
//        [self.view addSubview:attention];
        [self.tableView reloadData];
    }];
}


@end
