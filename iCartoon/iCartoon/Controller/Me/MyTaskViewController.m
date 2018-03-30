//
//  MyTaskViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "MyTaskViewController.h"
#import "MyTaskTableViewCell.h"
#import "TaskDetailViewController.h"
#import "TaskTableViewCell.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "IndexAPIRequest.h"

//下拉刷新，上拉加载
#import <MJRefresh/MJRefresh.h>
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import "AttentionView.h"
#import "ProgressHUD.h"
@interface MyTaskViewController () <UITableViewDataSource, UITableViewDelegate, TaskTableViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *taskArray;

@property (assign, nonatomic) NSInteger pageNo;
@property (assign, nonatomic) NSInteger pageSize;

@property (assign, nonatomic) BOOL viewPoped;

@property (strong, nonatomic)UIImageView *img;
@property (strong, nonatomic)UILabel *lab;
@property (nonatomic,strong) NSString *isfreeze;
@property (nonatomic,strong) NSString *thaw_date;
@property (nonatomic,strong) NSString *thaw_time;
@property (nonatomic,strong)NSString * isshow;
@property (nonatomic,strong)NSString * isshowfree;
@end

@implementation MyTaskViewController

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
   
    self.navigationItem.title = @"我的任务";
    [self setBackNavgationItem];
    
    self.pageNo = 1;
    self.pageSize = 10;
    
    [self createUI];
    
    [self loadNewData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
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
#pragma mark - TaskTableViewCellDelegate
- (void)collectTaskForItem:(TaskInfo *)taskItem atIndexPath:(NSIndexPath *)indexPath {
    if(taskItem) {
        [self collectTask:taskItem atIndexPath:indexPath];
    }
}

//(收藏/取消收藏)任务
- (void)collectTask:(TaskInfo *)taskInfo atIndexPath:(NSIndexPath *)indexPath {
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

    if(!taskInfo || !taskInfo.tid) {
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

    NSString *collectStatus = taskInfo.collectStatus;
    if(!collectStatus) {
//        [TSMessage showNotificationWithTitle:@"该任务不能进行收藏操作" subtitle:nil type:TSMessageNotificationTypeWarning];
        AttentionView *attention = [[AttentionView alloc]initTitle:@"该任务不能进行收藏操作"];
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
    } else if([collectStatus isEqualToString:@"0"]) {
        tipTitle = @"收藏";
    }
//    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在%@任务...", tipTitle] maskType:SVProgressHUDMaskTypeClear];
    [[IndexAPIRequest sharedInstance] collectTask:params success:^(CommonInfo *resultInfo) {
//        [SVProgressHUD dismiss];
        if(resultInfo && [resultInfo isSuccess]) {
            if(indexPath.row < self.taskArray.count) {
                TaskInfo *taskInfo = [self.taskArray objectAtIndex:indexPath.row];
                taskInfo.collectStatus = [taskInfo.collectStatus isEqualToString:@"1"] ? @"0" : @"1";
                [self.taskArray replaceObjectAtIndex:indexPath.row withObject:taskInfo];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
//            [TSMessage showNotificationWithTitle:[NSString stringWithFormat:@"%@成功", tipTitle] subtitle:nil type:TSMessageNotificationTypeSuccess];
//            AttentionView * attention = [[AttentionView alloc]initTitle:[NSString stringWithFormat:@"%@成功", tipTitle] andtitle2:@""];
//            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
//            attention.label1.frame=CGRectMake(5, 15, 220, 40);
//            [self.view addSubview:attention];
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

        } else {
            AttentionView * attention = [[AttentionView alloc]initTitle:[NSString stringWithFormat:@"%@失败", tipTitle] andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshHomeTasks object:nil];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
//        [TSMessage showNotificationWithTitle:[error localizedDescription] subtitle:nil type:TSMessageNotificationTypeError];
//        AttentionView *attention = [[AttentionView alloc]initTitle:[error localizedDescription]];
//        [self.view addSubview:attention];
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.taskArray != nil ? self.taskArray.count : 0;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRANS_VALUE(91.0f);
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
    static NSString *identifier = @"TaskTableViewCell";
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[TaskTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if(indexPath.row < self.taskArray.count) {
        //TOOD -- 我的任务
        TaskInfo *taskInfo = (TaskInfo *)[self.taskArray objectAtIndex:indexPath.row];
        if(!taskInfo.collectStatus || [taskInfo.collectStatus isEqualToString:@""]) {
            taskInfo.collectStatus = @"1";
            [self.taskArray replaceObjectAtIndex:indexPath.row withObject:taskInfo];
        }
        cell.indexPath = indexPath;
        cell.taskItem = taskInfo;
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < self.taskArray.count) {
        TaskDetailViewController *taskDetailViewController = [[TaskDetailViewController alloc] init];
        MyTaskInfo *taskInfo = [self.taskArray objectAtIndex:indexPath.row];
        taskDetailViewController.taskId = taskInfo.tid;
        taskDetailViewController.taskInfo = nil;
        [self.navigationController pushViewController:taskDetailViewController animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < self.taskArray.count) {
        if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, TRANS_VALUE(10.0f), 0, TRANS_VALUE(10.0f))];
        }
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, TRANS_VALUE(10.0f), 0, TRANS_VALUE(10.0f))];
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
//刷新数据
- (void)loadNewData {
    
    [self.img removeFromSuperview];
    [self.lab removeFromSuperview];

    self.pageNo = 1;
    [self.tableView.mj_footer resetNoMoreData];
    if(!self.taskArray) {
        self.taskArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.taskArray removeAllObjects];
    [ProgressHUD show:nil];
    NSString *pageNo = [NSString stringWithFormat:@"%ld", self.pageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%ld", self.pageSize];
    NSDictionary *params = @{
                             @"pageNo" : pageNo,
                             @"pageSize" : pageSize
                             };
    [[IndexAPIRequest sharedInstance] getUserTasks:params success:^(NSArray *taskArray) {
        [ProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        if(taskArray) {
            [self.taskArray addObjectsFromArray:taskArray];
            if(taskArray.count >= self.pageSize) {
                self.pageNo ++;
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.taskArray.count==0) {
            self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(120.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
            self.img.contentMode = UIViewContentModeScaleAspectFit;
            self.img.image = [UIImage imageNamed:@"no_data_hint"];
            [self.tableView addSubview:_img];
            
            self.lab= [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(280.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
            self.lab.textColor = I_COLOR_33BLACK;
            self.lab.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
            self.lab.textAlignment = NSTextAlignmentCenter;
            self.lab.text = @"你还没有去参加任务呢！";
            [self.tableView addSubview:self.lab];
        }

        [self.tableView reloadData];
    } failure:^(NSError *error) {
        self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(120.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
        self.img.contentMode = UIViewContentModeScaleAspectFit;
        self.img.image = [UIImage imageNamed:@"no_data_hint"];
        [self.tableView addSubview:_img];
        
        self.lab= [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(280.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
        self.lab.textColor = I_COLOR_33BLACK;
        self.lab.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
        self.lab.textAlignment = NSTextAlignmentCenter;
        self.lab.text = @"你还没有去参加任务呢！";
        [self.tableView addSubview:self.lab];
        [ProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
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
    [[IndexAPIRequest sharedInstance] getUserTasks:params success:^(NSArray *taskArray) {
        [ProgressHUD dismiss];
        if(taskArray) {
            [self.taskArray addObjectsFromArray:taskArray];
            if(taskArray.count >= self.pageSize) {
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
        [self.tableView reloadData];
    }];
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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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

@end
