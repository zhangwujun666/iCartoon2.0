//
//  MyReleaseViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//
#define kCellIdentifier_PostTableViewCell @"PostTableViewCell"
#import "MyReleaseViewController.h"
#import "TopTabButton.h"
#import "PostTableViewCell.h"
#import "PostDetailViewController.h"

#import "MeAPIRequest.h"
#import "PostAPIRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>

//下拉刷新，上拉加载
#import <MJRefresh/MJRefresh.h>
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import "AttentionView.h"
#import "Context.h"
#import "LoginViewController.h"
#import "ThemeDetailViewController.h"
#import "AuthorDetailViewController.h"
#import "CustomAlertView.h"
#import "ProgressHUD.h"
#import "UIImageView+Webcache.h"
#define KBottomBarHeight CONVER_VALUE(70.0f)

@interface MyReleaseViewController () <PostTableViewCellDelegate,UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,CustomAlertViewDelegate>//{UITableViewCellEditingStyle selectEditingStyle;}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *postArray;

@property (assign, nonatomic) NSInteger pageNo;
@property (assign, nonatomic) NSInteger pageSize;

@property (strong, nonatomic) NSIndexPath *selectIndexPath;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *allSelectBtn;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) NSMutableArray *selectedIndexArr;
@property (strong, nonatomic) UIBarButtonItem *manageBarBtnItem;
@property (strong, nonatomic) UIBarButtonItem *cancelBarBtnItem;
@property (assign, nonatomic) BOOL flag;
@property (strong, nonatomic) NSMutableArray *tagArr;
@property (nonatomic,strong) NSString *isfreeze;
@property (nonatomic,strong) NSString *thaw_date;
@property (nonatomic,strong) NSString *thaw_time;
@property (nonatomic,strong)NSString * isshow;
@property (nonatomic,strong)NSString * isshowfree;
@end

@implementation MyReleaseViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideBox" object:nil];
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
    self.title = @"我发的脑洞";
    self.pageNo = 1;
    self.pageSize = 10;
    [self createUI];
     [self addTargetAction];
    [self loadData];
    _flag = NO;
    self.selectIndexPath = nil;
}
- (void)addTargetAction {
    [self.allSelectBtn addTarget:self action:@selector(allSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)allSelectAction:(UIButton *)btn {
    btn.selected ^= 1;
    if (btn.selected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changPicture" object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changPictureBack" object:nil];
    }
    if(self.postArray.count >0) {
        [self.selectedIndexArr removeAllObjects];
        for (NSInteger i=0; i<self.postArray.count; i++) {
            PostTableViewCell *cell = (PostTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.mSelected = !btn.selected;
            if(btn.selected) {
                [self.selectedIndexArr addObject:[NSNumber numberWithInteger:i]];
            }
        }
        [self.tableView reloadData];
    }
}

- (void)deleteAction {
    if (self.selectedIndexArr.count != 0) {
        [CustomAlertView showWithTitle:@"" delegate:self];
    }
}
#pragma mark - CustomAlertViewDelegate
- (void)confirmButtonClick {
    NSMutableArray *msgDetailArr = [NSMutableArray array];
    NSMutableArray *indexPathArr = [NSMutableArray array];
    for (NSNumber *tempNum in self.selectedIndexArr) {
        [msgDetailArr addObject:[self.postArray objectAtIndex:[tempNum integerValue]]];
        [indexPathArr addObject:[NSIndexPath indexPathForRow:[tempNum integerValue] inSection:0]];
    }
    [self deletePosts:msgDetailArr atIndexPaths:indexPathArr];
    [self.tableView reloadData];
}

- (void)cancelButtonClick {
    if([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
        NSInteger count = self.postArray != nil ? [self.postArray count] : 0;
        return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostInfo *postInfo = nil;
    if(indexPath.row < self.postArray.count) {
        postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
    }
    if(!postInfo) {
        return 0.0f;
    }
    CGFloat height = [PostTableViewCell heightForCell:indexPath withCommentInfo:postInfo];
    return height ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
     return TRANS_VALUE(138.0f);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UserInfo *  userInfo = [Context sharedInstance].userInfo ;
    CGFloat height = TRANS_VALUE(138.0f);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,height)];
     view.backgroundColor = I_BACKGROUND_COLOR;
    UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(132.0f))];
    pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    pictureImageView.image = [UIImage imageNamed:@"bg_author_top"];
    pictureImageView.backgroundColor = RGBCOLOR(231, 231, 231);
    [view addSubview:pictureImageView];
    
    UIImageView * avatarBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - TRANS_VALUE(66.0f)) / 2-2, TRANS_VALUE(12.0f), TRANS_VALUE(70.0f), TRANS_VALUE(70.0f))];
    avatarBackImageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarBackImageView.backgroundColor =UIColorFromRGB(0xf0f0f0);
    avatarBackImageView.clipsToBounds = YES;
    avatarBackImageView.alpha=0.5;
    avatarBackImageView.layer.cornerRadius = avatarBackImageView.frame.size.height / 2;
    [view addSubview:avatarBackImageView];
    UIImageView * avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - TRANS_VALUE(66.0f)) / 2, TRANS_VALUE(14.0f), TRANS_VALUE(66.0f), TRANS_VALUE(66.0f))];
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"ic_topic_detail_avatar"]];
    avatarImageView.backgroundColor = I_COLOR_WHITE;
    avatarImageView.clipsToBounds = YES;
    avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height / 2;
    [view addSubview:avatarImageView];
    
    UILabel * speakLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(142.0f), TRANS_VALUE(110.0f), TRANS_VALUE(22.0f))];
    speakLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
    speakLabel.textColor = I_COLOR_33BLACK;
    speakLabel.textAlignment = NSTextAlignmentRight;
    speakLabel.text = @"发言 120";
    [view addSubview:speakLabel];
    
    UILabel * userLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - TRANS_VALUE(110.0f), TRANS_VALUE(142.0f), TRANS_VALUE(110.0f), TRANS_VALUE(22.0f))];
    userLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
    userLabel.textColor = UIColorFromRGB(0x191919);
    userLabel.textAlignment = NSTextAlignmentLeft;
    userLabel.text = @"关注 120";
    [view addSubview:userLabel];
    speakLabel.hidden = YES;
    userLabel.hidden = YES;
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(86.0f), SCREEN_WIDTH, TRANS_VALUE(24.0f))];
    titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    titleLabel.textColor = UIColorFromRGB(0x191919);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = userInfo.nickname;
    [view addSubview:titleLabel];
    
    UILabel * descLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), TRANS_VALUE(106.0f), SCREEN_WIDTH, TRANS_VALUE(18.0f))];
    descLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
    descLabel.textColor = UIColorFromRGB(0x736441);
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.text = userInfo.signature;
    [view addSubview:descLabel];
    return view;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = TRANS_VALUE(150.0f);
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PostTableViewCell";
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    self.selectIndexPath = indexPath;
    if(indexPath.row < [self.postArray count]) {
        PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
        cell.postItem = postInfo;
        if(_flag) {
            [cell changeState];
        }else {
            [cell backState];
        }
    }
    if (self.selectedIndexArr.count != 0) {
        for (int i = 0; i < self.tagArr.count; i++) {
            if ([self.tagArr[i] isEqualToString:cell.postItem .pid]) {
                [cell.checkBox setImage:[UIImage imageNamed:@"ic_message_on"] forState:UIControlStateNormal];
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO -- 跳转
//    if (self.tableView.editing) {
        PostInfo *postInfo = nil;
        postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
        
        PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
        postDetailViewController.postId = postInfo.pid;
        postDetailViewController.postInfo = postInfo;
        [self.navigationController pushViewController:postDetailViewController animated:YES];
//    }else{
//        NSLog(@"hahahahahahahahahahahah");
//    }
    
}
#pragma mark - Private Method
- (void)loadData {
    //TODO -- 默认选中设计
    [self loadNewData];
}
- (void)loadNewData {
    self.pageNo = 1;
    [self.tableView.mj_footer resetNoMoreData];
    //刷新设计师帖子列表
    if(!self.postArray) {
        self.postArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.postArray removeAllObjects];
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
    NSDictionary *params = @{
                             @"pageNo" : pageNo,
                             @"pageSize" : pageSize,
                             @"type" : @"1"
                             };
    [ProgressHUD show:nil];
    [[MeAPIRequest sharedInstance] getUserPublishedPosts:params success:^(NSArray *postList) {
        [ProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        if(postList) {
            [self.postArray addObjectsFromArray:postList];
            if(postList.count >= self.pageSize) {
                self.pageNo ++;
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
         [self  updateBarBtnItem];
    } failure:^(NSError *error) {
        [ProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
    }];
}
- (void)loadMoreData {
    //加载更多设计帖子列表
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
    NSDictionary *params = @{
                             @"pageNo" : pageNo,
                             @"pageSize" : pageSize,
                             @"type" : @"1"
                             };
    [ProgressHUD show:nil];
    [[MeAPIRequest sharedInstance] getUserPublishedPosts:params success:^(NSArray *postList) {
        [ProgressHUD dismiss];
        if(postList) {
            [self.postArray addObjectsFromArray:postList];
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

//删除帖子
- (void)deletePosts:(NSMutableArray *)postInfos atIndexPaths:(NSMutableArray *)indexPaths {
    if(postInfos == nil || postInfos.count == 0) {
        return;
    }
    NSMutableArray *postIds = [NSMutableArray arrayWithCapacity:0];
    for(PostInfo *postInfo in postInfos) {
        [postIds addObject:postInfo.pid];
    }
    NSDictionary *params = @{
                             @"postIds" : postIds,
                             };
    [SVProgressHUD showWithStatus:@"正在删除我发布的创意..." maskType:SVProgressHUDMaskTypeClear];
    [[PostAPIRequest sharedInstance] deletePosts:params success:^(CommonInfo *resultInfo) {
        [SVProgressHUD dismiss];
        if([resultInfo isSuccess]) {
             [[NSNotificationCenter defaultCenter]postNotificationName:@"finish" object:nil];
            [self cancelBarBtnAction];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.postArray removeObjectsInArray:postInfos];
            [self.tableView endUpdates];
        } else {
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self cancelBarBtnAction];
        [self.tableView reloadData];
    }];
    
}

- (void)createUI {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self setBackNavgationItem];
        //添加表单
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top);
            make.left.mas_equalTo(self.view.mas_left);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - kTopAndStatusBarHeight));
        }];
//        selectEditingStyle = UITableViewCellEditingStyleDelete;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.bottomView];
        //设置tableview分割线
        if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    
    
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MyRefreshFooter *footer = [MyRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.mj_footer = footer;
    //        if (self.postArray.count==0) {
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    
}
- (UIView *)bottomView {
    if(!_bottomView) {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kTopAndStatusBarHeight, SCREEN_WIDTH, KBottomBarHeight)];
        tempView.backgroundColor = [UIColor whiteColor];
        [tempView addSubview:self.allSelectBtn];
        [tempView addSubview:self.deleteBtn];
        [self.view addSubview:(_bottomView = tempView)];
    }
    return _bottomView;
}
- (UIButton *)allSelectBtn {
    _flag = YES;
    if(!_allSelectBtn) {
        UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(CONVER_VALUE(10.0f), CONVER_VALUE(20.0f), CONVER_VALUE(70.0f), CONVER_VALUE(25.0f))];
        [tempBtn setBackgroundColor:[UIColor clearColor]];
        [tempBtn setTitle:@"全选" forState:UIControlStateNormal];
        [tempBtn.titleLabel setFont:[UIFont systemFontOfSize:CONVER_VALUE(15.0f)]];
        [tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tempBtn setImage:[UIImage imageNamed:@"ic_message_off"] forState:UIControlStateNormal];
        [tempBtn setImage:[UIImage imageNamed:@"ic_message_on"] forState:UIControlStateHighlighted];
        [tempBtn setImage:[UIImage imageNamed:@"ic_message_on"] forState:UIControlStateSelected];
        [tempBtn setImageEdgeInsets:UIEdgeInsetsMake(0, - CONVER_VALUE(25.0f), 0, 0)];
        [self.view addSubview:(_allSelectBtn = tempBtn)];
    }
    return _allSelectBtn;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(CONVER_VALUE(90.0f), CONVER_VALUE(10.0f), CONVER_VALUE(275.0f), CONVER_VALUE(50.0f))];
        [tempBtn setBackgroundColor:UIColorFromRGB(0xE10C21)];
        [tempBtn setTitle:@"删除" forState:UIControlStateNormal];
        [tempBtn setImage:[UIImage imageNamed:@"ic_me_delete"] forState:UIControlStateNormal];
        [tempBtn setImage:[UIImage imageNamed:@"ic_me_delete"] forState:UIControlStateSelected];
        [tempBtn setImage:[UIImage imageNamed:@"ic_me_delete"] forState:UIControlStateHighlighted];
        tempBtn.layer.cornerRadius = CONVER_VALUE(50.0f) / 2;
        tempBtn.clipsToBounds = YES;
        [tempBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [self.view addSubview:(_deleteBtn = tempBtn)];
    }
    return _deleteBtn;
}

- (NSMutableArray *)postArray {
    if (!_postArray) {
        _postArray = [NSMutableArray array];
    }
    return _postArray;
}

- (NSMutableArray *)selectedIndexArr {
    if (!_selectedIndexArr) {
        _selectedIndexArr = [NSMutableArray array];
    }
    return _selectedIndexArr;
}
- (UIBarButtonItem *)manageBarBtnItem {
    if (!_manageBarBtnItem) {
//        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0, 0,TRANS_VALUE(30.0f),TRANS_VALUE(30.0f));
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), 44.0f)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, CONVER_VALUE(10.0f), 0, CONVER_VALUE(-10.0f))];
        [button setTitle:@"管理" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(13)];
        _manageBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        [button addTarget:self action:@selector(manageBarBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _manageBarBtnItem;
}

- (UIBarButtonItem *)cancelBarBtnItem {
    if(!_cancelBarBtnItem) {
       UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), 44.0f)];
        [ button setTitleEdgeInsets:UIEdgeInsetsMake(0, CONVER_VALUE(10.0f), 0, CONVER_VALUE(-10.0f))];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(13)];
         _cancelBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        [button addTarget:self action:@selector(cancelBarBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBarBtnItem;
}
- (void)manageBarBtnAction {
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

    if (self.postArray.count == 0) {
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

//    selectEditingStyle = UITableViewCellEditingStyleNone;
    [self.tableView setEditing:NO animated:YES];
    [self.tableView setAllowsSelectionDuringEditing:YES];
    [self updateBarBtnItem];
    _flag = YES;
    [self showBottomView:YES];
    [self.tableView reloadData];
}

- (void)cancelBarBtnAction {
  //  selectEditingStyle = UITableViewCellEditingStyleDelete;
    [self.tagArr removeAllObjects];
    [self.tableView setEditing:NO animated:YES];
    [self.tableView setAllowsSelectionDuringEditing:NO];
    [self updateBarBtnItem];
    [self showBottomView:NO];
    //刷新tableView
    _flag = NO;
    [self.tableView reloadData];
}
- (void)updateBarBtnItem {
    if (self.postArray.count > 0) {
        if(self.tableView.allowsSelectionDuringEditing) {
            self.navigationItem.rightBarButtonItem = self.cancelBarBtnItem;
            return;
        }
        if(!self.tableView.editing) {
            self.navigationItem.rightBarButtonItem = self.manageBarBtnItem;
        }
    } else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(void)showBottomView:(BOOL)show{
    [UIView animateWithDuration:0.3 animations:^{
        if(show) {
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-kTopAndStatusBarHeight-KBottomBarHeight));
            }];
            [self.bottomView setTransform:CGAffineTransformMakeTranslation(0, -KBottomBarHeight)];
            self.allSelectBtn.selected = NO;
        } else {
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-kTopAndStatusBarHeight));
            }];
            [self.bottomView setTransform:CGAffineTransformIdentity];
        }
    }];
}

- (UITableView *)tableView {
    if(!_tableView) {
        UITableView *tmpTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tmpTableView.backgroundColor = I_BACKGROUND_COLOR;
        tmpTableView.dataSource = self;
        tmpTableView.delegate = self;
        tmpTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [tmpTableView registerClass:[PostTableViewCell class] forCellReuseIdentifier:kCellIdentifier_PostTableViewCell];
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [tmpTableView setTableFooterView:view];
        [self.view addSubview:(_tableView = tmpTableView)];
    }
    return _tableView;
}
#pragma mark - PostTableViewCellDelegate
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
    
    }];
}


//点击头像
-(void)clickAuthorAtItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath{
    AuthorDetailViewController *authorDetailViewController= [[AuthorDetailViewController alloc]init];
    authorDetailViewController.authorInfo = postInfo.author;
    authorDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:authorDetailViewController animated:YES];
}
- (NSMutableArray *)tagArr{
    if (!_tagArr) {
        _tagArr = [NSMutableArray array];
    }
    return _tagArr;
}
//点击checkbox
- (void)clickCheckboxAtItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath tag : (NSInteger)tag {
    [self.selectedIndexArr addObject:[NSNumber numberWithInteger:indexPath.row]];
    [self.tagArr addObject:[NSString stringWithFormat:@"%ld",tag]];
}
//取消点击checkbox
- (void)unclickCheckboxAtItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath tag : (NSInteger)tag{
    if (self.selectedIndexArr.count != 0) {
        for (int i = 0;i < self.selectedIndexArr.count;i++) {
           NSNumber * num = self.selectedIndexArr[i];
            if (num == [NSNumber numberWithInteger:indexPath.row]) {
                [self.selectedIndexArr removeObject:num];
            }
        }
        
        if (self.tagArr.count != 0) {
            for (int i = 0;i < self.tagArr.count; i++) {
                if ([self.tagArr[i] isEqualToString:[NSString stringWithFormat:@"%ld",tag]]) {
                    [self.tagArr removeObject:self.tagArr[i]];
                }
            }
        }
        
    }
}
@end
