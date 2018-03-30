//
//  MyCommentsViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//
#define KBottomBarHeight CONVER_VALUE(70.0f)
#import "MyCommentsViewController.h"
#import "MyCommentTableViewCell.h"
#import "PostDetailViewController.h"
#import "CustomAlertView.h"
#import "MeAPIRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>

#import <AFNetworking.h>

//下拉刷新，上拉加载
#import <MJRefresh/MJRefresh.h>
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import "AttentionView.h"
#import "ProgressHUD.h"
#import "Context.h"
@interface MyCommentsViewController () <UITableViewDataSource, UITableViewDelegate,CustomAlertViewDelegate,MyCommentTableViewCellDelegate>{
      UITableViewCellEditingStyle selectEditingStyle;
}

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *messageArray;

@property (assign, nonatomic) NSInteger pageNo;
@property (assign, nonatomic) NSInteger pageSize;

@property (strong, nonatomic)UIImageView *img;
@property (strong, nonatomic)UILabel *lab;

@property (strong, nonatomic) UIBarButtonItem *manageBarBtnItem;
@property (strong, nonatomic) UIBarButtonItem *cancelBarBtnItem;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) NSMutableArray *selectedIndexArr;
@property (strong, nonatomic) NSMutableArray *indexArr;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) UIButton *allSelectBtn;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (assign, nonatomic) BOOL flag;
@property (assign, nonatomic) BOOL allSelected;;
@property (strong, nonatomic) NSMutableArray *tagArr;
@property (nonatomic,strong)AFHTTPRequestOperationManager*requestManager;
@property (nonatomic,strong) NSString *isfreeze;
@property (nonatomic,strong) NSString *thaw_date;
@property (nonatomic,strong) NSString *thaw_time;
@property (nonatomic,strong)NSString * isshow;
@property (nonatomic,strong)NSString * isshowfree;

@end

@implementation MyCommentsViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideBox1" object:nil];
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
    self.navigationItem.title = @"我的评论";
    [self setBackNavgationItem];
    self.pageNo = 1;
    self.pageSize = 20;
    _allSelected = 0;
    [self createUI];
    [self addTargetAction];
    [self loadNewData];
     _flag = NO;
}
- (void)allSelectAction:(UIButton *)btn {
//    btn.selected ^= 1;
    _allSelected ^= 1;
    if (btn.selected) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"changPictureBack1" object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changPicture1" object:nil];
    }
    if(self.messageArray.count >0) {
        btn.selected = !btn.selected;
        [self.selectedIndexArr removeAllObjects];
        for (NSInteger i=0; i<self.messageArray.count; i++) {
            MyCommentTableViewCell *cell = (MyCommentTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.mSelected = btn.selected;
            if (btn.selected) {
                [self.selectedIndexArr addObject:[NSNumber numberWithInteger:i]];
            }
        }
        [self.tableView reloadData];
    }
}
- (void)deleteAction {
    [CustomAlertView showWithTitle:@"" delegate:self];
}
- (void)addTargetAction {
    [self.allSelectBtn addTarget:self action:@selector(allSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
}
- (UIBarButtonItem *)cancelBarBtnItem {
    if(!_cancelBarBtnItem) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), 44.0f)];
        [ button setTitleEdgeInsets:UIEdgeInsetsMake(0, CONVER_VALUE(10.0f), 0, CONVER_VALUE(-10.0f))];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(13)];
        [button addTarget:self action:@selector(cancelBarBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _cancelBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    return _cancelBarBtnItem;
}

- (UIBarButtonItem *)manageBarBtnItem {
    if (!_manageBarBtnItem) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), 44.0f)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, CONVER_VALUE(10.0f), 0, CONVER_VALUE(-10.0f))];
        [button setTitle:@"管理" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(13)];
        [button addTarget:self action:@selector(manageBarBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _manageBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        
    }
    return _manageBarBtnItem;
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

    if (self.messageArray.count == 0) {
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
//        [self.view addSubview:attention];        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isshowfree"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }

    selectEditingStyle = UITableViewCellEditingStyleNone;
    [self.tableView setEditing:NO animated:YES];
    [self.tableView setAllowsSelectionDuringEditing:YES];
      _flag = YES;
    [self updateBarBtnItem];
    [self showBottomView:YES];
    [self.tableView reloadData];
}
- (NSMutableArray *)tagArr{
    if (!_tagArr) {
        _tagArr = [NSMutableArray array];
    }
    return _tagArr;
}
- (void)cancelBarBtnAction {
    self.allSelectBtn.selected = NO;
     [self.tagArr removeAllObjects];
    selectEditingStyle = UITableViewCellEditingStyleDelete;
    [self.tableView setEditing:NO animated:YES];
    [self.tableView setAllowsSelectionDuringEditing:NO];
    [self updateBarBtnItem];
     _flag = NO;
    [self showBottomView:NO];
    //刷新tableView
    [self.selectedIndexArr removeAllObjects];
     [self.tableView reloadData];
}
- (void)updateBarBtnItem {
    if (self.messageArray.count > 0) {
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

-(void)showBottomView:(BOOL)show{
    [UIView animateWithDuration:0.3 animations:^{
        if(show) {
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-kTopAndStatusBarHeight-KBottomBarHeight));
            }];
            [self.bottomView setTransform:CGAffineTransformMakeTranslation(0, -KBottomBarHeight)];
        } else {
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-kTopAndStatusBarHeight));
            }];
            [self.bottomView setTransform:CGAffineTransformIdentity];
        }
    }];
}
#pragma mark - CustomAlertViewDelegate
- (void)confirmButtonClick {
    NSMutableArray *msgDetailArr = [NSMutableArray array];
    NSMutableArray *indexPathArr = [NSMutableArray array];
    for (NSNumber *tempNum in self.selectedIndexArr) {
        [msgDetailArr addObject:[self.messageArray objectAtIndex:[tempNum integerValue]]];
        [indexPathArr addObject:[NSIndexPath indexPathForRow:[tempNum integerValue] inSection:0]];
    }
    [self deletePosts:msgDetailArr atIndexPaths:indexPathArr];
    [self.tableView reloadData];
}
//删除帖子
- (void)deletePosts:(NSMutableArray *)postInfos atIndexPaths:(NSMutableArray *)indexPaths {
    if(postInfos == nil || postInfos.count == 0) {
        return;
    }
     NSString * token = [Context sharedInstance].token;
    NSMutableArray *postIds = [NSMutableArray arrayWithCapacity:0];
    for(MessageInfo *postInfo in postInfos) {
        [postIds addObject:postInfo.mid];
    }
    NSDictionary *params = @{
                             @"commentIds" : postIds,
                             };
    NSString * mainurl = [APIConfig mainURL];
    NSString * path = [NSString stringWithFormat:@"%@/%@",mainurl,@"DeleteMyComment_v2"];
    path = [NSString stringWithFormat:@"%@/%@",path,token];
    NSDictionary * request = @{@"request":params};
    self.requestManager = [AFHTTPRequestOperationManager manager];
    self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil]; // 设置content-Type为text/html
    [self.requestManager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [self.requestManager POST:path parameters:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = responseObject[@"response"];
        if ( dic[@"success"]) {
            [self cancelBarBtnAction];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.messageArray removeObjectsInArray:postInfos];
            [self.tableView endUpdates];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self cancelBarBtnAction];
        [self.tableView reloadData];
    }];
}

- (NSMutableArray *)selectedIndexArr {
    if (!_selectedIndexArr) {
        _selectedIndexArr = [NSMutableArray array];
    }
    return _selectedIndexArr;
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
    NSInteger count = self.messageArray != nil ? self.messageArray.count : 0;
    return count;
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
    static NSString *identifier = @"MyCommentsTableViewCell";
    MyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[MyCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.tag = indexPath.row;
    cell.indexPath = indexPath;
    if(indexPath.row < self.messageArray.count) {
        MyMessageInfo *messageInfo = (MyMessageInfo *)[self.messageArray objectAtIndex:indexPath.row];
        cell.messageInfo = messageInfo;
        cell.delegate = self;
        for (int i = 0; i < self.selectedIndexArr.count; i++) {
            NSInteger index = [self.selectedIndexArr[i] integerValue];
            if (index == indexPath.row) {
                [cell changPicture];
                i = (int)self.selectedIndexArr.count;
            }else{
                [cell changPictureBack];
            }
        }
        if(_flag) {
             [cell changeState];
        }else {
            [cell backState];
        }
    }
//    if (self.selectedIndexArr.count != 0) {
//        for (int i = 0; i < self.tagArr.count; i++) {
//            if ([self.tagArr[i] isEqualToString:cell.messageInfo.postInfo.pid]) {
//                [cell.checkBox setImage:[UIImage imageNamed:@"ic_message_on"] forState:UIControlStateNormal];
//            }
//        }
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO -- 点击Item
    if (_flag) {

    }else{
        if(indexPath.row < self.messageArray.count) {
            MyMessageInfo *messageInfo = (MyMessageInfo *)[self.messageArray objectAtIndex:indexPath.row];
            PostInfo *postInfo = messageInfo.postInfo;
            if(!postInfo || !postInfo.pid) {
                return;
            }
            PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
            postDetailViewController.postId = postInfo.pid;
            [self.navigationController pushViewController:postDetailViewController animated:YES];
        }

    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self updateBarBtnItem];
    return selectEditingStyle;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    NSLog(@"didEndEditingRowAtIndexPath");
    [self updateBarBtnItem];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [CustomAlertView showWithTitle:@"" delegate:self];
    }
}

#pragma mark - Private Method
- (void)loadNewData {
    
    [self.img removeFromSuperview];
    [self.lab removeFromSuperview];
    self.pageNo = 1;
    [self.tableView.mj_footer resetNoMoreData];
    if(!self.messageArray) {
        self.messageArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.messageArray removeAllObjects];
    
    [ProgressHUD show:nil];
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
    NSDictionary *params = @{
                             @"pageNo" : pageNo,
                             @"pageSize" : pageSize
                             };
    [[MeAPIRequest sharedInstance] getMyComments:params success:^(NSArray *messageArray) {
        [ProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        if(messageArray) {
            [self.messageArray addObjectsFromArray:messageArray];
            if(self.messageArray.count >= self.pageSize) {
                self.pageNo ++;
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.messageArray.count==0) {
            self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(120.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
            self.img.contentMode = UIViewContentModeScaleAspectFit;
            self.img.image = [UIImage imageNamed:@"no_data_hint"];
            [self.tableView addSubview:_img];
            
            self.lab= [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(280.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
            self.lab.textColor = I_COLOR_33BLACK;
            self.lab.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
            self.lab.textAlignment = NSTextAlignmentCenter;
            self.lab.text = @"你还没有任何评论…";
            [self.tableView addSubview:self.lab];
        }

        [self.tableView reloadData];
         [self  updateBarBtnItem];
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
        [ProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData {
    [ProgressHUD show:nil];
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
    NSDictionary *params = @{
                             @"pageNo" : pageNo,
                             @"pageSize" : pageSize
                             };
    [[MeAPIRequest sharedInstance] getMyComments:params success:^(NSArray *messageArray) {
        [ProgressHUD dismiss];
        if(messageArray) {
            [self.messageArray addObjectsFromArray:messageArray];
            if(messageArray.count >= self.pageSize) {
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

- (void)createUI {
    //实例化表单控件
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = I_DIVIDER_COLOR;
    self.tableView.backgroundColor = I_BACKGROUND_COLOR;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(0.0f))];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - kTopAndStatusBarHeight));
    }];
    [self.view addSubview:self.bottomView];
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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //添加表单

}
//点击checkbox
- (void)clickCheckboxAtItem:(MessageInfo *)postInfo indexPath:(NSIndexPath *)indexPath tag : (NSInteger)tag {
    [self.selectedIndexArr addObject:[NSNumber numberWithInteger:indexPath.row]];
    [self.tagArr addObject:[NSString stringWithFormat:@"%ld",tag]];
}
//取消点击checkbox
- (void)unclickCheckboxAtItem:(MessageInfo *)postInfo indexPath:(NSIndexPath *)indexPath tag : (NSInteger)tag{
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
