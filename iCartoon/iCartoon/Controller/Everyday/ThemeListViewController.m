//
//  TopicListViewControllerTopicListViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/29.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "ThemeListViewController.h"
#import "TaskTableViewCell.h"
#import "ThemeDetailViewController.h"
#import "UIImage+Color.h"

#import "IndexAPIRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "ProgressHUD.h"
@interface ThemeListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *topicArray;

@end

@implementation ThemeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = I_COLOR_WHITE;
    self.navigationItem.title = @"迷之次元";
    
    [self setBackNavgationItem];
    
    [self createUI];
//    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(!self.topicArray || [self.topicArray count] == 0) {
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
#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = self.topicArray != nil ? self.topicArray.count : 0;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ThemeGroupInfo *group = (ThemeGroupInfo *)[self.topicArray objectAtIndex:section];
    NSMutableArray *subTopicArray = group.list;
    NSInteger count = subTopicArray != nil ? subTopicArray.count : 0;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRANS_VALUE(44.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TRANS_VALUE(30.0f);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = TRANS_VALUE(30.0f);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(16.0f), TRANS_VALUE(0), TRANS_VALUE(280.0f), TRANS_VALUE(30))];
    titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    titleLabel.textColor = I_COLOR_33BLACK;
    [view addSubview:titleLabel];
    ThemeGroupInfo *group = (ThemeGroupInfo *)[self.topicArray objectAtIndex:section];
    NSString *titleStr = (NSString *)group.tag;
    titleLabel.text = titleStr;
    titleLabel.backgroundColor = [UIColor clearColor];
    view.backgroundColor = I_BACKGROUND_COLOR;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGFloat height = TRANS_VALUE(0.0f);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    view.backgroundColor = I_COLOR_WHITE;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"TopicTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    cell.textLabel.textColor = I_COLOR_33BLACK;
    ThemeGroupInfo *group = (ThemeGroupInfo *)[self.topicArray objectAtIndex:indexPath.section];
    NSMutableArray *subTopicArray = group.list;
    if(indexPath.row < [subTopicArray count]) {
        //TOOD -- 我的任务
        ThemeInfo *themeInfo = (ThemeInfo *)[subTopicArray objectAtIndex:indexPath.row];
        NSString *topicTitle = (NSString *)themeInfo.title;
        cell.textLabel.text = topicTitle;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ThemeGroupInfo *group = (ThemeGroupInfo *)[self.topicArray objectAtIndex:indexPath.section];
    NSMutableArray *subTopicArray = group.list;
    if(indexPath.row < [subTopicArray count]) {
        dispatch_async(dispatch_get_main_queue(), ^ {
            //跳转界面
            ThemeDetailViewController *topicDetailViewController = [[ThemeDetailViewController alloc] init];
            ThemeInfo *themeInfo = [subTopicArray objectAtIndex:indexPath.row];
            topicDetailViewController.themeInfo = themeInfo;
            topicDetailViewController.themeId = themeInfo.tid;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:topicDetailViewController];
            [self presentViewController:navigationController animated:YES completion:^{
                [navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:I_COLOR_YELLOW] forBarMetrics:UIBarMetricsDefault];
            }];
                           
        });
   }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ThemeGroupInfo *group = (ThemeGroupInfo *)[self.topicArray objectAtIndex:indexPath.section];
    NSMutableArray *subTopicArray = group.list;
    if(indexPath.row < [subTopicArray count]) {
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
}

//返回索引数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *titlesArray = [NSMutableArray arrayWithCapacity:0];
    for(ThemeGroupInfo *group in self.topicArray) {
        NSString *title = (NSString *)group.tag;
        [titlesArray addObject:title];
    }
    return titlesArray;
}

//返回每个索引的内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ThemeGroupInfo *group = (ThemeGroupInfo *)[self.topicArray objectAtIndex:section];
    NSString *title = group.tag;
    return title;
}

//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark - Private Method
- (void)loadData {
    if(!self.topicArray) {
        self.topicArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.topicArray removeAllObjects];
    [ProgressHUD show:nil];
    [[IndexAPIRequest sharedInstance] getAllThemes:nil success:^(NSArray *groupThemes) {
        [ProgressHUD dismiss];
        if(groupThemes) {
            [self.topicArray addObjectsFromArray:groupThemes];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [ProgressHUD dismiss];
        [self.tableView reloadData];
    }];
}

- (void)createUI {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, TRANS_VALUE(60.0f))];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(16.0f), TRANS_VALUE(5), TRANS_VALUE(250.0f), TRANS_VALUE(24))];
    titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(20.0f)];
    titleLabel.textColor = I_COLOR_YELLOW;
    [headerView addSubview:titleLabel];
    titleLabel.text = @"迷之次元";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    headerView.backgroundColor = I_COLOR_WHITE;
    
    UILabel *allLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(16.0f), TRANS_VALUE(30), TRANS_VALUE(270.0f), TRANS_VALUE(30))];
    allLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(16.0f)];
    allLabel.textColor = I_COLOR_33BLACK;
    [headerView addSubview:allLabel];
    allLabel.text = @"全部";
    allLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
    
    //实例化表单控件
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20 + TRANS_VALUE(60.0f), SCREEN_WIDTH - TRANS_VALUE(50.0f), SCREEN_HEIGHT - 20 - TRANS_VALUE(60.0f)) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = I_DIVIDER_COLOR;
    self.tableView.backgroundColor = I_COLOR_WHITE;
    [self.view addSubview:self.tableView];
    self.tableView.sectionIndexColor = I_COLOR_DARKGRAY;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20.0f)];
    footerView.backgroundColor = I_COLOR_WHITE;
    self.tableView.tableFooterView = footerView;
    
    //设置tableview分割线
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}


@end
