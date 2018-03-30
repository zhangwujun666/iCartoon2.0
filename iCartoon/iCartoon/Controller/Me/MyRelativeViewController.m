//
//  MyRelativeViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "MyRelativeViewController.h"
#import "MyCommentsViewController.h"
#import "ReplyCommentViewController.h"
#import "MyCollectionViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "MeAPIRequest.h"
#import "AttentionView.h"
#import "ProgressHUD.h"
@interface MyRelativeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) BOOL viewPoped;

@property (strong, nonatomic) UserRelativeInfo *userRelativeInfo;

@end

@implementation MyRelativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"关于我的";
    [self setBackNavgationItem];
    
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
#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 3;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRANS_VALUE(50.0f);
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
    static NSString *identifier = @"MyRelativeTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
        cell.textLabel.textColor = I_COLOR_33BLACK;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
        cell.detailTextLabel.textColor = I_COLOR_33BLACK;
        cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        cell.imageView.image = [UIImage imageNamed:@"ic_my_relative_comment"];
        cell.backgroundColor = I_COLOR_WHITE;
    }
    if(indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"ic_my_relative_message"];
        cell.textLabel.text = @"我的消息";
        cell.detailTextLabel.text = @"0";
        if(self.userRelativeInfo.messageCount) {
            cell.detailTextLabel.text = self.userRelativeInfo.messageCount;
        }
    } else if(indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"ic_my_relative_comment"];
        cell.textLabel.text = @"我评论过的";
        cell.detailTextLabel.text = @"0";
        if(self.userRelativeInfo.commentCount) {
            cell.detailTextLabel.text = self.userRelativeInfo.commentCount;
        }
    } else {
        cell.imageView.image = [UIImage imageNamed:@"ic_my_relative_collection"];
        cell.textLabel.text = @"我的收藏";
        cell.detailTextLabel.text = @"0";
        if(self.userRelativeInfo.collectionCount) {
            cell.detailTextLabel.text = self.userRelativeInfo.collectionCount;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        //TODO -- 我的消息
        MyCommentsViewController *myMessageViewController = [[MyCommentsViewController alloc] init];
        [self.navigationController pushViewController:myMessageViewController animated:YES];
    } else if(indexPath.row == 1) {
        //TODO -- 我评论过的
        ReplyCommentViewController *myCommentedViewController = [[ReplyCommentViewController alloc] init];
        [self.navigationController pushViewController:myCommentedViewController animated:YES];
    } else {
        //TODO -- 我的收藏
        MyCollectionViewController *myCollectionViewController = [[MyCollectionViewController alloc] init];
        [self.navigationController pushViewController:myCollectionViewController animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < 3) {
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
- (void)loadData {
    [ProgressHUD show:nil];
    [[MeAPIRequest sharedInstance] getUserRelativeInfo:nil success:^(UserRelativeInfo *info) {
        [ProgressHUD dismiss];
        if(info) {
            self.userRelativeInfo = info;
        } else {
            self.userRelativeInfo = [[UserRelativeInfo alloc] init];
            self.userRelativeInfo.messageCount = @"0";
            self.userRelativeInfo.commentCount = @"0";
            self.userRelativeInfo.collectionCount = @"0";
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [ProgressHUD dismiss];
        self.userRelativeInfo = [[UserRelativeInfo alloc] init];
        self.userRelativeInfo.messageCount = @"0";
        self.userRelativeInfo.commentCount = @"0";
        self.userRelativeInfo.collectionCount = @"0";
        [self.tableView reloadData];
    }];
}

- (void)createUI {
    //实例化表单控件
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = I_DIVIDER_COLOR;
    self.tableView.backgroundColor = I_BACKGROUND_COLOR;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(0.0f))];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //设置tableview分割线
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

}

@end
