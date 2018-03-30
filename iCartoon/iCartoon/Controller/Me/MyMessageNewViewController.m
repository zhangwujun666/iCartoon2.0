//
//  MyMessageNewViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "MyMessageNewViewController.h"
#import "MyMessageNewTableViewCell.h"
#import "MessageDetailViewController.h"
#import "MessageInfo.h"
#import "MyRefreshHeader.h"
#import "MeAPIRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "CustomAlertView.h"
#import "AttentionView.h"
#import "TopTabButton.h"
#import "MyRefreshFooter.h"
#define KBottomBarHeight CONVER_VALUE(70.0f)

@interface MyMessageNewViewController () <UITableViewDataSource, UITableViewDelegate, CustomAlertViewDelegate> {
    UITableViewCellEditingStyle selectEditingStyle;
}

@property (strong, nonatomic) TopTabButton *incubatorBtn;//孵化箱
@property (strong, nonatomic) TopTabButton *jycBtn;//聚叶城
@property (assign, nonatomic) BOOL isJycSelected;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIBarButtonItem *manageBarBtnItem;
@property (strong, nonatomic) UIBarButtonItem *cancelBarBtnItem;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *allSelectBtn;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (assign ,nonatomic) BOOL isReplySelected;

@property (strong, nonatomic) NSMutableArray *messageArray;
@property (strong, nonatomic) NSMutableArray *selectedIndexArr;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic,strong)UILabel *lab;
@property (nonatomic,strong)UIImageView * img;
@property (nonatomic,strong)UIImageView * imgV;
@property (strong ,nonatomic)UIView * topBarView;
@property (nonatomic,strong)UIView * Myview;
@property (nonatomic,strong) NSString *isfreeze;
@property (nonatomic,strong) NSString *thaw_date;
@property (nonatomic,strong) NSString *thaw_time;
@property (nonatomic,strong)NSString * isshow;
@property (nonatomic,assign)int pageNo;
@property (nonatomic,assign)int pagesize;
@property (nonatomic,assign)BOOL hasloadmore;
@property (nonatomic,strong)NSString * isshowfree;

@end

@implementation MyMessageNewViewController
#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setBackNavgationItem];
    self.title = @"系统消息";
    self.pageNo = 1;
    self.pagesize = 10;
    [self createUI];
    [self addTargetAction];
    
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Private Method
- (void)createUI {
    CGFloat buttonWidth = (SCREEN_WIDTH - 2 * TRANS_VALUE(0.0f)) / 2;
    CGFloat buttonHeight = TRANS_VALUE(35.0f);
    _topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, buttonHeight)];
    _topBarView.backgroundColor = I_COLOR_WHITE;
    [self.view addSubview:_topBarView];
        self.jycBtn = [[TopTabButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f)+buttonWidth, 0.0f, buttonWidth, buttonHeight)];
        [self.jycBtn setTitle:@"商城消息"];
     [_topBarView addSubview:self.jycBtn];
    
        self.incubatorBtn = [[TopTabButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), 0, buttonWidth, buttonHeight)];
        [self.incubatorBtn setTitle:@"我的消息"];
        [_topBarView addSubview:self.incubatorBtn];
    
    //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
//    MyRefreshHeader *header = [MyRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//    self.tableView.mj_header = header;
    MyRefreshFooter *footer = [MyRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMorePosts)];
    self.tableView.mj_footer = footer;
    //设置tableview分割线
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }


    [self.incubatorBtn addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.jycBtn addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.incubatorBtn setSelected:YES];
    [self.jycBtn setSelected:NO];
    
    [self.tableView reloadData];
   // selectEditingStyle = UITableViewCellEditingStyleDelete;
    [self.view addSubview:self.bottomView];
}

- (void)loadMorePosts{
    self.hasloadmore = YES;
    self.pageNo++;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%d",self.pagesize] forKey:@"pageSize"];
    [dic setValue:[NSString stringWithFormat:@"%d",self.pageNo] forKey:@"pageNo"];
     [self.tableView.mj_footer endRefreshing];
    [[MeAPIRequest sharedInstance] getMessageList:dic success:^(NSArray *messageList) {
        [self.tableView.mj_footer endRefreshing];
        
        if(messageList) {
            [self.messageArray addObjectsFromArray:messageList];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
}
#pragma mark - Action
- (void)tabButtonAction:(id)sender {
    TopTabButton *button = (TopTabButton *)sender;
    if(!button.isSelected) {
        if(button == self.incubatorBtn) {
            [self.incubatorBtn setSelected:YES];
            [self.jycBtn setSelected:NO];
            self.isReplySelected = YES;
//            self.type = @"2";
            //TODO -- 选中孵化箱
            [self.lab removeFromSuperview];
            [self.img removeFromSuperview];
            [self.Myview removeFromSuperview];
            self.tableView.scrollEnabled = YES;
            if (self.messageArray.count == 0) {
                self.img = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-118,[UIScreen mainScreen].bounds.size.height/2-200,236,160)];
                self.img.contentMode = UIViewContentModeScaleAspectFit;
                self.img.image = [UIImage imageNamed:@"no_data_hint"];
                [self.tableView addSubview:_img];
                
                self.lab= [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.img.frame), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
                self.lab.textColor = [UIColor blackColor];
                self.lab.font = [UIFont systemFontOfSize:TRANS_VALUE(17.0f)];
                self.lab.textAlignment = NSTextAlignmentCenter;
                self.lab.text = @"你没有消息哦！";
                [self.tableView addSubview:self.lab];
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                self.tableView.backgroundColor=[UIColor whiteColor];

            }else{
                [self.lab removeFromSuperview];
                [self.img removeFromSuperview];
                [self.Myview removeFromSuperview];
                self.tableView.scrollEnabled = YES;
            }
        } else {
            [self.incubatorBtn setSelected:NO];
            [self.jycBtn setSelected:YES];
            self.isReplySelected = NO;
            self.tableView.scrollEnabled = NO;
            UIView * Myview = [[UIView alloc]init];
            Myview.frame = CGRectMake(0, TRANS_VALUE(35.0f), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            Myview.backgroundColor = [UIColor whiteColor];
            self.Myview = Myview;
            [self.view addSubview:self.Myview];
            UIImageView * imagview = [[UIImageView alloc]init];
            imagview.image = [[UIImage imageNamed:@"no_data_hint"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            imagview.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-118,[UIScreen mainScreen].bounds.size.height/2-200,236,160);
            self.imgV =imagview;
            [Myview addSubview:self.imgV];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imagview.frame), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor blackColor];
            self.lab.font = [UIFont systemFontOfSize:17];
            label.text = @"功能尚未开发，敬请期待...";
            [self.Myview addSubview:label];
        }
        [self loadData];
    }
}


- (void)addTargetAction {
    [self.allSelectBtn addTarget:self action:@selector(allSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)loadData {
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%d",self.pagesize] forKey:@"pageSize"];
    [dic setValue:[NSString stringWithFormat:@"%d",self.pageNo] forKey:@"pageNo"];
    if(!self.messageArray) {
        self.messageArray = [NSMutableArray arrayWithCapacity:0];
    }
    if (self.hasloadmore) {
        
    }else{
         [self.messageArray removeAllObjects];
    }
    [[MeAPIRequest sharedInstance] getMessageList:dic success:^(NSArray *messageList) {
    [self.tableView.mj_header endRefreshing];

        if(messageList) {
            [self.messageArray addObjectsFromArray:messageList];
        }
        if (self.messageArray.count==0) {
            [self.lab removeFromSuperview];
            [self.img removeFromSuperview];
            self.img = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-118,[UIScreen mainScreen].bounds.size.height/2-200,236,160)];
            self.img.contentMode = UIViewContentModeScaleAspectFit;
            self.img.image = [UIImage imageNamed:@"no_data_hint"];
            [self.tableView addSubview:_img];
            
            self.lab= [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.img.frame), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
            self.lab.textColor = [UIColor blackColor];
            self.lab.font = [UIFont systemFontOfSize:17];
            self.lab.textAlignment = NSTextAlignmentCenter;
            self.lab.text = @"你没有消息哦！";
            [self.tableView addSubview:self.lab];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.tableView.backgroundColor=[UIColor whiteColor];
        }

        [self.tableView reloadData];
       [self updateBarBtnItem];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        [self updateBarBtnItem];
    }];
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

    if (self.messageArray.count == 0) { return;}
    selectEditingStyle = UITableViewCellEditingStyleNone;
    [self.tableView setEditing:YES animated:YES];
    [self.tableView setAllowsSelectionDuringEditing:YES];
    [self updateBarBtnItem];
    [self showBottomView:YES];
}

- (void)cancelBarBtnAction {
    selectEditingStyle = UITableViewCellEditingStyleDelete;
    [self.tableView setEditing:NO animated:YES];
    [self.tableView setAllowsSelectionDuringEditing:NO];
    [self updateBarBtnItem];
    [self showBottomView:NO];
    //刷新tableView
//    [self updateEditingArr];
}

- (void)updateBarBtnItem {
    if (self.messageArray.count > 0) {
        if (self.tableView.allowsSelectionDuringEditing) {
            self.navigationItem.rightBarButtonItem = self.cancelBarBtnItem;
            return;
        }
        if(self.tableView.editing) {
        } else{
            self.navigationItem.rightBarButtonItem = self.manageBarBtnItem;
        }
    } else{
        self.navigationItem.rightBarButtonItem = nil;
    }
//    [self.myTableView reloadData];
}

-(void)showBottomView:(BOOL)show{
    [UIView animateWithDuration:0.3 animations:^{
        if(show) {
//            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-kTopAndStatusBarHeight-KBottomBarHeight));
//            }];
            [self.bottomView setTransform:CGAffineTransformMakeTranslation(0, -KBottomBarHeight)];
        } else {
//            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-kTopAndStatusBarHeight));
//            }];
            [self.bottomView setTransform:CGAffineTransformIdentity];
        }
    }];
}

- (void)allSelectAction:(UIButton *)btn
{
    btn.selected ^= 0;
    if (!btn.selected) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"AllSelect" object:nil];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"AllCancel" object:nil];
    }
    if(self.messageArray.count >0) {
        btn.selected = !btn.selected;
        [self.selectedIndexArr removeAllObjects];
        for (NSInteger i=0; i<self.messageArray.count; i++) {
            MyMessageNewTableViewCell *cell = (MyMessageNewTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.mSelected = btn.selected;
            if (btn.selected) {
                [self.selectedIndexArr addObject:[NSNumber numberWithInteger:i]];
            }
        }
        [self.tableView reloadData];
    }
}

//删除多个消息
- (void)deleteAction {
    self.selectedIndexPath = nil;
    [CustomAlertView showWithTitle:@"是否要删除?" delegate:self];
}

//删除草稿箱数据
- (void)deleteMessages:(NSArray *)messageArr {
    if (messageArr.count > 0) {
        //删除消息
        NSMutableArray *messageIds = [NSMutableArray arrayWithCapacity:0];
        for(MessageInfo *messageInfo in messageArr) {
            [messageIds addObject:messageInfo.mid];
        }
        if(!messageIds || messageIds.count == 0) {
            return;
        }
        [self deleteMessagesWithIds:messageIds];
    }
}

- (void)deleteMessagesWithIds:(NSArray *)messageIds {
//    [SVProgressHUD showWithStatus:@"正在删除消息..." maskType:SVProgressHUDMaskTypeClear];
    NSDictionary *params = @{
                             @"messageIds": messageIds
                             };
    [[MeAPIRequest sharedInstance] deleteMessage:params success:^(CommonInfo *resultInfo) {
//        [SVProgressHUD dismiss];
        if([resultInfo isSuccess]) {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"删除消息成功！" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        } else {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"删除消息失败！" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        }
        [self.tableView reloadData];
        [self updateBarBtnItem];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        AttentionView * attention = [[AttentionView alloc]initTitle:@"删除消息失败！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        [self.tableView reloadData];
        [self updateBarBtnItem];
    }];
}

- (NSString*)convertNull:(id)object {
    if(!object) {
        return @"";
    }
    if(object && [object isEqual:[NSNull null]]){
        return @"";
    }else if ([object isKindOfClass:[NSNull class]]){
        return @"";
    } else if (object == nil) {
        return @"";
    }
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    return [object stringValue];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        if(self.messageArray.count == 0) {
            return 0.0f;
        } else {
           // return CONVER_VALUE(44.0f);
            return 0.0f;
        }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
           NSInteger count = self.messageArray != nil ? self.messageArray.count : 0;
        return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyMessageNewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyMessageNewTableViewCell];
    if(!cell) {
        cell = [[MyMessageNewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier_MyMessageNewTableViewCell];
    }
    MessageInfo *messageInfo = nil;
    if(indexPath.row < self.messageArray.count) {
        messageInfo = (MessageInfo *)[self.messageArray objectAtIndex:indexPath.row];
    }
    cell.messageInfo = messageInfo;
    return cell;
}

#pragma mark - CustomAlertViewDelegate
- (void)confirmButtonClick {
    if(self.selectedIndexPath != nil && self.selectedIndexArr.count == 0) {
        MessageInfo *info = (MessageInfo *)self.messageArray[self.selectedIndexPath.row];
        [self deleteMessages:[NSArray arrayWithObject:info]];
        [self.messageArray removeObjectAtIndex:self.selectedIndexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    } else if(self.selectedIndexArr.count > 0 && !self.selectedIndexPath) {
        //批量删除
        NSMutableArray *msgDetailArr = [NSMutableArray array];
        NSMutableArray *indexPathArr = [NSMutableArray array];
        for (NSNumber *tempNum in self.selectedIndexArr) {
            [msgDetailArr addObject:[self.messageArray objectAtIndex:[tempNum integerValue]]];
            [indexPathArr addObject:[NSIndexPath indexPathForRow:[tempNum integerValue] inSection:0]];
        }
        [self deleteMessages:msgDetailArr];
        [self.messageArray removeObjectsInArray:msgDetailArr];
       // [self.tableView deleteRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationLeft];
        [self.selectedIndexArr removeAllObjects];
        [self cancelBarBtnAction];
    }
    if(self.tableView.isEditing) {
        [self.tableView endEditing:YES];
    }
}

- (void)cancelButtonClick {
    if(self.tableView.isEditing) {
        [self.tableView endEditing:YES];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(indexPath.row >= self.messageArray.count) {
//        return 0.0f;
//    }
    return CONVER_VALUE(44.0f);
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

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willBeginEditingRowAtIndexPath");
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    [self updateBarBtnItem];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.selectedIndexPath = indexPath;
        self.selectedIndexArr = [NSMutableArray arrayWithCapacity:0];
        [CustomAlertView showWithTitle:@"是否要删除?" delegate:self];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row < self.messageArray.count) {
        MessageInfo *messageInfo = [self.messageArray objectAtIndex:indexPath.row];
        if(tableView.editing) {
            MyMessageNewTableViewCell *cell = (MyMessageNewTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.mSelected = !cell.mSelected;
            messageInfo.isSelected = cell.mSelected;
            [self.messageArray replaceObjectAtIndex:indexPath.row withObject:messageInfo];
            if(cell.mSelected) {
                [self.selectedIndexArr addObject:[NSNumber numberWithInteger:indexPath.row]];
            } else {
                [self.selectedIndexArr removeObject:[NSNumber numberWithInteger:indexPath.row]];
            }
        } else {
            //TODO -- 跳转到帖子页面
            MessageDetailViewController *messageDetailViewController = [[MessageDetailViewController alloc] init];
            messageDetailViewController.messageInfo = messageInfo;
            [self.navigationController pushViewController:messageDetailViewController animated:YES];
        }
    }
}


#pragma mark getter && setter
- (UITableView *)tableView {
    if(!_tableView) {
        
        UITableView *tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topBarView.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-self.topBarView.frame.size.height-64) style:UITableViewStylePlain];
        tmpTableView.backgroundColor = [UIColor whiteColor];
        tmpTableView.dataSource = self;
        tmpTableView.delegate = self;
        tmpTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [tmpTableView setTableFooterView:view];
        [self.view addSubview:(_tableView = tmpTableView)];
    }
    return _tableView;
}

- (UIBarButtonItem *)manageBarBtnItem {
    if (!_manageBarBtnItem) {
        _manageBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"管理"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(manageBarBtnAction)];
    }
    return _manageBarBtnItem;
}

- (UIBarButtonItem *)cancelBarBtnItem {
    if(!_cancelBarBtnItem) {
        _cancelBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarBtnAction)];
        
        
    }
    return _cancelBarBtnItem;
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
    if(!_allSelectBtn) {
        UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(CONVER_VALUE(10.0f), CONVER_VALUE(20.0f), CONVER_VALUE(70.0f), CONVER_VALUE(25.0f))];
        [tempBtn setBackgroundColor:[UIColor clearColor]];
        [tempBtn setTitle:@"全选" forState:UIControlStateNormal];
        [tempBtn.titleLabel setFont:[UIFont systemFontOfSize:- CONVER_VALUE(15.0f)]];
        [tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tempBtn setImage:[UIImage imageNamed:@"ic_message_off"] forState:UIControlStateNormal];
        [tempBtn setImage:[UIImage imageNamed:@"ic_message_on"] forState:UIControlStateHighlighted];
        [tempBtn setImage:[UIImage imageNamed:@"ic_message_on"] forState:UIControlStateSelected];
        [tempBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -CONVER_VALUE(25.0f), 0, 0)];
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

- (NSMutableArray *)messageArray {
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}

- (NSMutableArray *)selectedIndexArr {
    if (!_selectedIndexArr) {
        _selectedIndexArr = [NSMutableArray array];
    }
    return _selectedIndexArr;
}

@end
