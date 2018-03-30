//
//  ReplyCommentViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "ReplyCommentViewController.h"
#import "TopTabButton.h"
#import "ReplyCommentTableViewCell.h"
#import "PostDetailViewController.h"

#import "MeAPIRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>

//下拉刷新，上拉加载
#import <MJRefresh/MJRefresh.h>
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import "AttentionView.h"
#import "ProgressHUD.h"
@interface ReplyCommentViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) TopTabButton *replyButton;         //回复我的
@property (strong, nonatomic) TopTabButton *commentButton;       //评论我的
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *replyArray;
@property (strong, nonatomic) NSMutableArray *commentArray;

@property (assign, nonatomic) NSInteger pageNo;
@property (assign, nonatomic) NSInteger pageSize;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic)UIImageView *img;
@property (strong, nonatomic)UILabel *lab;

@property (assign, nonatomic) BOOL isReplySelected;

@end

@implementation ReplyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = I_BACKGROUND_COLOR;
    self.navigationItem.title = @"我的消息";
    [self setBackNavgationItem];
    
    self.pageNo = 0;
    self.pageSize = 100;
    self.type = @"2";
    
    [self createUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)tabButtonAction:(id)sender {
    TopTabButton *button = (TopTabButton *)sender;
    if(!button.isSelected) {
        if(button == self.replyButton) {
            [self.replyButton setSelected:YES];
            [self.commentButton setSelected:NO];
            self.isReplySelected = YES;
            self.type = @"2";
            //TODO -- 选中回复我的
        } else {
            [self.replyButton setSelected:NO];
            [self.commentButton setSelected:YES];
            self.isReplySelected = NO;
            self.type = @"1";
            //TODO -- 选中评论我的
        }
        [self loadNewData];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.isReplySelected) {
        NSInteger count = self.replyArray != nil ? [self.replyArray count] : 0;
        return count;
    } else {
        NSInteger count = self.commentArray != nil ? [self.commentArray count] : 0;
        return count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TRANS_VALUE(0.0f);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = TRANS_VALUE(0.0f);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    view.backgroundColor = I_BACKGROUND_COLOR;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRANS_VALUE(140.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ReplyCommentTableViewCell";
    ReplyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[ReplyCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if(self.isReplySelected) {
        if(indexPath.row < [self.replyArray count]) {
            MyMessageInfo *messageInfo = (MyMessageInfo *)[self.replyArray objectAtIndex:indexPath.row];
            cell.messageInfo = messageInfo;
            cell.type = 1;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        if(indexPath.row < [self.commentArray count]) {
            MyMessageInfo *messageInfo = (MyMessageInfo *)[self.commentArray objectAtIndex:indexPath.row];
            cell.messageInfo = messageInfo;
            cell.type = 2;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO -- 跳转
    if(self.isReplySelected) {
        if(indexPath.row < [self.replyArray count]) {
            PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
            MyMessageInfo *messageInfo = (MyMessageInfo *)[self.replyArray objectAtIndex:indexPath.row];
            PostInfo *postInfo = messageInfo.postInfo;
           postDetailViewController.fromWhere = @"ReplyCommentViewController";
            if(!postInfo || !postInfo.pid) {
                return;
            }
            postDetailViewController.postId = postInfo.pid;
            [self.navigationController pushViewController:postDetailViewController animated:YES];
        }
    } else {
        if(indexPath.row < [self.commentArray count]) {
            PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
            MyMessageInfo *messageInfo = (MyMessageInfo *)[self.commentArray objectAtIndex:indexPath.row];
            PostInfo *postInfo = messageInfo.postInfo;
            if(!postInfo || !postInfo.pid) {
                return;
            }
            postDetailViewController.postId = postInfo.pid;
            [self.navigationController pushViewController:postDetailViewController animated:YES];
        }
    }
}

#pragma mark - Private Method
- (void)loadData {
    [self.replyButton setSelected:YES];
    [self.commentButton setSelected:NO];
    self.isReplySelected = YES;
    //TODO -- 默认选中评论我的
    self.type = @"2";
    [self loadNewData];
}

- (void)loadNewData {
    self.pageNo = 1;
    [self.tableView.mj_footer resetNoMoreData];
    if(self.isReplySelected) {
        
            [self.img removeFromSuperview];
            [self.lab removeFromSuperview];
       
        //刷新评论我的列表
        if(!self.replyArray) {
            self.replyArray = [NSMutableArray arrayWithCapacity:0];
        }
        [self.replyArray removeAllObjects];
        NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
        NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
        NSDictionary *params = @{
                                 @"pageNo" : pageNo,
                                 @"pageSize" : pageSize,
                                 @"type" : self.type
                                 };
        [ProgressHUD show:nil];
        [[MeAPIRequest sharedInstance] getReplyAndComments:params success:^(NSArray *postList) {
//            NSLog(@"\npostList ==== %@",postList);
            [ProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            if(postList) {
                [self.replyArray addObjectsFromArray:postList];
                if(postList.count >= self.pageSize) {
                    self.pageNo ++;
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (self.replyArray.count==0) {
                self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(120.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
                self.img.contentMode = UIViewContentModeScaleAspectFit;
                self.img.image = [UIImage imageNamed:@"no_data_hint"];
                [self.tableView addSubview:_img];
                
                self.lab= [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(280.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
                self.lab.textColor = I_COLOR_33BLACK;
                self.lab.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
                self.lab.textAlignment = NSTextAlignmentCenter;
                self.lab.text = @"你暂时还没有数据…";
                [self.tableView addSubview:self.lab];
                  self.tableView.backgroundColor=[UIColor whiteColor];
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
              self.tableView.backgroundColor=[UIColor whiteColor];
            [ProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView reloadData];
        }];
    } else {
        //吐槽帖子列表
        
            [self.img   removeFromSuperview];
            [self.lab removeFromSuperview];
     
        if(!self.commentArray) {
            self.commentArray = [NSMutableArray arrayWithCapacity:0];
        }
        [self.commentArray removeAllObjects];
        NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
        NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
        NSDictionary *params = @{
                                 @"pageNo" : pageNo,
                                 @"pageSize" : pageSize,
                                 @"type" : self.type
                                 };
        [ProgressHUD show:nil];
        [[MeAPIRequest sharedInstance] getReplyAndComments:params success:^(NSArray *postList) {
            [ProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            if(postList) {
                [self.commentArray addObjectsFromArray:postList];
                if(postList.count >= self.pageSize) {
                    self.pageNo ++;
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (self.commentArray.count==0) {
                self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(120.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
                self.img.contentMode = UIViewContentModeScaleAspectFit;
                self.img.image = [UIImage imageNamed:@"no_data_hint"];
                [self.tableView addSubview:_img];
                
                self.lab= [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(280.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
                self.lab.textColor = I_COLOR_33BLACK;
                self.lab.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
                self.lab.textAlignment = NSTextAlignmentCenter;
                self.lab.text = @"你暂时还没有数据…";
                [self.tableView addSubview:self.lab];
                  self.tableView.backgroundColor=[UIColor whiteColor];

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
              self.tableView.backgroundColor=[UIColor whiteColor];
            [ProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView reloadData];
        }];
    }
}

- (void)loadMoreData {
    if(self.isReplySelected) {
        //设计帖子列表
        NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
        NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
        NSDictionary *params = @{
                                 @"pageNo" : pageNo,
                                 @"pageSize" : pageSize,
                                 @"type" : self.type
                                 };
        [ProgressHUD show:nil];
        [[MeAPIRequest sharedInstance] getReplyAndComments:params success:^(NSArray *postList) {
            [ProgressHUD dismiss];
            if(postList) {
                [self.replyArray addObjectsFromArray:postList];
                if(postList.count >= self.pageSize) {
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
    } else {
        NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
        NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
        NSDictionary *params = @{
                                 @"pageNo" : pageNo,
                                 @"pageSize" : pageSize,
                                 @"type" : self.type
                                 };
        [ProgressHUD show:nil];
        [[MeAPIRequest sharedInstance] getReplyAndComments:params success:^(NSArray *postList) {
            [ProgressHUD dismiss];
            if(postList) {
                [self.commentArray addObjectsFromArray:postList];
                if(postList.count >= self.pageSize) {
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
}

- (void)createUI {
    CGFloat buttonWidth = (SCREEN_WIDTH - 2 * TRANS_VALUE(0.0f)) / 2;
    CGFloat buttonHeight = TRANS_VALUE(35.0f);
    UIView *topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, buttonHeight)];
    topBarView.backgroundColor = I_COLOR_WHITE;
    [self.view addSubview:topBarView];
    
    self.replyButton = [[TopTabButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), 0.0f, buttonWidth, buttonHeight)];
    [self.replyButton setTitle:@"回复我的"];
    [self.view addSubview:self.replyButton];
    self.commentButton = [[TopTabButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f) + buttonWidth, 0, buttonWidth, buttonHeight)];
    [self.commentButton setTitle:@"评论我的"];
    [self.view addSubview:self.commentButton];
    
    //实例化表单控件
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, buttonHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f - buttonHeight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = I_DIVIDER_COLOR;
    self.tableView.backgroundColor = I_BACKGROUND_COLOR;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(0.0f))];
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
    
    [self.replyButton addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentButton addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.replyButton setSelected:YES];
    [self.commentButton setSelected:NO];
    
    [self.tableView reloadData];
}

@end
