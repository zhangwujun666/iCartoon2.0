//
//  MyMessageNewViewController.m
//  iCartoon
//
//  Created by cxl on 16/3/27.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MyMessageTableViewCell.h"
#import "TopTabButton.h"
#import <TSMessages/TSMessage.h>
#import "MeAPIRequest.h"
#import "NSString+Utils.h"
#import "ProgressHUD.h"
#define TITLE_CONTENT @"您的帖子【《暗杀教室》原创设计】被举报内容抄袭，已删除。如有不便，敬请谅解。"
#define HEAD_DETAIL @"您所购买的全职亚克力牌暂时缺货。请问是等待补货还是选择其他等价商品？"
#define HEAD_TITLE  @"【客服】双马尾的无尾熊"


@interface MyMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray *myTableViewArr;
@property (strong, nonatomic) TopTabButton *incubatorBtn;//孵化箱
@property (strong, nonatomic) TopTabButton *jycBtn;//聚叶城
@property (assign, nonatomic) BOOL isJycSelected;
@end

@implementation MyMessageViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self addTargetAction];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark Private Method
- (void)createUI {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setBackNavgationItem];
    self.title = @"我的消息";    
    CGFloat buttonWidth = (SCREEN_WIDTH - 2 * TRANS_VALUE(0.0f)) / 2;
    CGFloat buttonHeight = TRANS_VALUE(35.0f);
    UIView *topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, buttonHeight)];
    topBarView.backgroundColor = I_TAB_BACKGROUND_COLOR;
    [self.view addSubview:topBarView];
    self.jycBtn = [[TopTabButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f)+buttonWidth, 0.0f, buttonWidth, buttonHeight)];
    [self.jycBtn setTitle:@"我在聚叶城"];
    [topBarView addSubview:self.jycBtn];
    self.incubatorBtn = [[TopTabButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), 0, buttonWidth, buttonHeight)];
    [self.incubatorBtn setTitle:@"我在聚叶城"];
    [topBarView addSubview:self.incubatorBtn];
    //添加表单
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topBarView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-kTopAndStatusBarHeight-buttonHeight));
    }];
    [self.incubatorBtn setSelected:YES];
    [self.jycBtn setSelected:NO];
    self.isJycSelected = NO;
}

- (void)requestData {
    [self.myTableViewArr removeAllObjects];
    if (self.isJycSelected) {
        if (self.myTableViewArr.count == 0) {
            [self.myTableView removeFromSuperview];
        }
    } else {
        if(!self.myTableViewArr) {
            self.myTableViewArr = [NSMutableArray arrayWithCapacity:0];
        }
        [self.myTableViewArr removeAllObjects];
        [ProgressHUD show:nil];
        [[MeAPIRequest sharedInstance] getMessageList:nil success:^(NSArray *messageList) {
            NSLog(@"messageList ====== %@",messageList);
            [ProgressHUD dismiss];
            if(messageList) {
                for(MessageInfo *message in messageList) {
                    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
                    [mutableDict setObject:@"0" forKey:@"isShowDetail"];
                    [mutableDict setObject:message forKey:@"item"];
                    [self.myTableViewArr addObject:mutableDict];
        }
            }
            [self.myTableView reloadData];
        } failure:^(NSError *error) {
            [ProgressHUD dismiss];
            [self.myTableView reloadData];
        }];
    }
    [self.myTableView reloadData];
}

- (void)addTargetAction {
    [self.jycBtn addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.incubatorBtn addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tabButtonAction:(id)sender {
    TopTabButton *button = (TopTabButton *)sender;
    if(!button.isSelected) {
        if(button == self.jycBtn) {
            //TODO -- 选中聚叶城            
            [self.jycBtn setSelected:YES];
            [self.incubatorBtn setSelected:NO];
            self.isJycSelected = YES;
            [self requestData];
        } else {
            //TODO -- 选中孵化箱
            [self.jycBtn setSelected:NO];
            [self.incubatorBtn setSelected:YES];
            self.isJycSelected = NO;

            [self requestData];
        }
    }
}

- (CGFloat)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    NSDictionary *dics = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]};
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dics context:nil].size;
    return ceil(sizeToFit.height);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myTableViewArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isShowDetail = [[self.myTableViewArr[indexPath.row] objectForKey:@"isShowDetail"] boolValue];
    MessageInfo *messageInfo = (MessageInfo *)[self.myTableViewArr[indexPath.row] objectForKey:@"item"];
    NSString *titleStr = messageInfo.title;
    NSString *contentStr = messageInfo.content;
    titleStr = titleStr != nil ? titleStr : @"系统消息";
    contentStr = contentStr != nil ? contentStr : @"";
    contentStr = [NSString flattenHTML:contentStr trimWhiteSpace:YES];
    MyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyMessageTableViewCell forIndexPath:indexPath];
    [cell setTitle:titleStr content:contentStr isShow:isShowDetail];
    __weak typeof(self)weakSelf = self;
    cell.headBtnTapAction = ^(BOOL isShow) {
        ;
        if (weakSelf.myTableView.isEditing) {
            
        }else{
            if (isShow) {
                [weakSelf.myTableViewArr[indexPath.row] setObject:@"0" forKey:@"isShowDetail"];
            }else{
                [weakSelf.myTableViewArr[indexPath.row] setObject:@"1" forKey:@"isShowDetail"];
            }
            [weakSelf.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        }

    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除消息接口处理
        [self.myTableViewArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!self.isJycSelected) {
        BOOL isShowDetail = [[self.myTableViewArr[indexPath.row] objectForKey:@"isShowDetail"] boolValue];
        if (isShowDetail) {
            CGFloat titleHeight = [self heightForString:TITLE_CONTENT fontSize:TRANS_VALUE(13.0f) andWidth:SCREEN_WIDTH-CONVER_VALUE(30.0f)];
            return CONVER_VALUE(43.0f) + CONVER_VALUE(30.0f) + titleHeight;
        }else{
            return CONVER_VALUE(43.0f) + CONVER_VALUE(0.0f) + CONVER_VALUE(0.0f);
        }
    } else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!self.isJycSelected) {
        if (section == 0) {
//            return CONVER_VALUE(110.0f);
            return 0.01f;
        }else{
            return 0.01f;
        }
    } else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.isJycSelected) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CONVER_VALUE(120.0f))];
//        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        headView.backgroundColor = [UIColor redColor];
        UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CONVER_VALUE(10.0f), CONVER_VALUE(10.0f), CONVER_VALUE(80.0f), CONVER_VALUE(80.0f))];
        headImgView.image = [UIImage imageNamed:@"ic_login_logoNew"];
        headImgView.layer.cornerRadius = CONVER_VALUE(80.0f)/2;
        headImgView.layer.masksToBounds = YES;
        [headView addSubview:headImgView];

        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLbl.font = [UIFont systemFontOfSize:CONVER_VALUE(15.0f)];
        titleLbl.text = HEAD_TITLE;
        [headView addSubview:titleLbl];
        UILabel *detailLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        detailLbl.font = [UIFont systemFontOfSize:CONVER_VALUE(14.0f)];
        detailLbl.numberOfLines = 2;
        detailLbl.text = HEAD_DETAIL;
        [headView addSubview:detailLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headView.mas_top).with.offset(CONVER_VALUE(20.0f));
            make.left.equalTo(headImgView.mas_right).with.offset(CONVER_VALUE(15.0f));
            make.width.mas_equalTo(SCREEN_WIDTH-CONVER_VALUE(120.0f));
        }];
        [detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLbl.mas_bottom).with.offset(CONVER_VALUE(10.0f));
            make.left.equalTo(headImgView.mas_right).with.offset(CONVER_VALUE(15.0f));
            make.width.mas_equalTo(SCREEN_WIDTH-CONVER_VALUE(120.0f));
        }];
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.backgroundColor = UIColorFromRGB(0xEFF0F1);
        tempLbl.layer.borderColor = UIColorFromRGB(0xDCDCDC).CGColor;
        tempLbl.layer.borderWidth = 0.5;
        [headView addSubview:tempLbl];
        [tempLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headView.mas_bottom).with.offset(-CONVER_VALUE(10.0f));
            make.left.mas_equalTo(headView.mas_left);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, CONVER_VALUE(10.0f)));
        }];
        headImgView.hidden = YES;
        titleLbl.hidden = YES;
        tempLbl.hidden = YES;
        headView.hidden = YES;
        return headView;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark getter && setter
- (UITableView *)myTableView {
    if(!_myTableView) {
        UITableView *tmpTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tmpTableView.backgroundColor = I_BACKGROUND_COLOR;
        tmpTableView.dataSource = self;
        tmpTableView.delegate = self;
        tmpTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [tmpTableView registerClass:[MyMessageTableViewCell class] forCellReuseIdentifier:kCellIdentifier_MyMessageTableViewCell];
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [tmpTableView setTableFooterView:view];
        [self.view addSubview:(_myTableView = tmpTableView)];
    }
    return _myTableView;
}

- (NSMutableArray *)myTableViewArr {
    if(!_myTableViewArr) {
        _myTableViewArr = [NSMutableArray array];
    }
    return _myTableViewArr;
}


@end
