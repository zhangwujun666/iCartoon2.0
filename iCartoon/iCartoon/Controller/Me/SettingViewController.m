//
//  SettingViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "SettingViewController.h"
#import "ModifyPasswordViewController.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
#import "AppDelegate.h"
#import "Context.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "UserAPIRequest.h"
#import "Context.h"
#import "AttentionView.h"
@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *logoutButton;
@property (assign, nonatomic) BOOL viewPoped;
@property (nonatomic,strong) NSString *isfreeze;
@property (nonatomic,strong) NSString *thaw_date;
@property (nonatomic,strong) NSString *thaw_time;
@property (nonatomic,strong)NSString * isshow;
@property (nonatomic,strong)NSString * isshowfree;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *isfreeze = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfreeze"];
    NSString *thaw_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_date"];
    NSString *thaw_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_time"];
    NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
    
    //    NSLog(@"%@------%@-----%@",isfreeze,thaw_time,thaw_date);
    self.isfreeze = isfreeze;
    self.thaw_date = thaw_date;
    self.thaw_time = thaw_time;
    self.isshow = isshow;
    NSString *isshowfree = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshowfree"];
    self.isshowfree = isshowfree;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = I_BACKGROUND_COLOR;
    self.navigationItem.title = @"设置";
    [self setBackNavgationItem];
    
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
        [self.logoutButton setHidden:YES];
        ((UIView *)self.logoutButton.superview).hidden = YES;
    } else {
        [self.logoutButton setHidden:NO];
        ((UIView *)self.logoutButton.superview).hidden = NO;
    }
    
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
//退出登录
- (void)logoutButtonAction:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要退出当前用户?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelega
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        //TODO -- 确定退出登录
        [SVProgressHUD showWithStatus:@"正在退出登录..." maskType:SVProgressHUDMaskTypeClear];
        NSDictionary *params = @{};
        [[UserAPIRequest sharedInstance] userLogout:params success:^(CommonInfo *resultInfo) {
            [SVProgressHUD dismiss];
            if(resultInfo && [resultInfo isSuccess]) {
                [self.navigationController popToRootViewControllerAnimated:NO];
                //TODO -- 退出登录, 清除用户信息
                [[Context sharedInstance] userLogout];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshHomeTasks object:nil];
//                [self performSelector:@selector(showLoginViewController) withObject:nil afterDelay:1.0f];
                //延迟一秒跳转到登录界面
            } else {
//                [TSMessage showNotificationWithTitle:@"退出登录失败" subtitle:nil type:TSMessageNotificationTypeError];
                AttentionView *attention = [[AttentionView alloc]initTitle:@"退出登录失败"];
                [self.view addSubview:attention];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
//            [TSMessage showNotificationWithTitle:[error localizedDescription] subtitle:nil type:TSMessageNotificationTypeError];
//            AttentionView *attention = [[AttentionView alloc]initTitle:[error localizedDescription]];
//            [self.view addSubview:attention];
        }];
        
    }
}

- (void)showLoginViewController {
    [[AppDelegate sharedDelegate] showLoginViewController:YES];
}


#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
        return 1;
    } else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRANS_VALUE(42.0f);
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
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.backgroundColor = I_COLOR_WHITE;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.detailTextLabel.hidden = YES;
    
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
        if(indexPath.row == 0) {
            cell.textLabel.text = @"关于艾漫";
        } else if(indexPath.row == 1) {
            cell.textLabel.text = @"版本信息";
            NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            cell.detailTextLabel.text = versionStr;
            cell.detailTextLabel.hidden = NO;
        } else {
            cell.textLabel.text = @"检查更新";
        }
    } else {
        if(indexPath.row == 0) {
            cell.textLabel.text = @"修改密码";
        } else if(indexPath.row == 1) {
            cell.textLabel.text = @"意见反馈";
        } else if(indexPath.row == 2) {
            cell.textLabel.text = @"关于艾漫";
        } else if(indexPath.row == 3) {
            cell.textLabel.text = @"版本信息";
//            NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            cell.detailTextLabel.text = @"1.5";
            cell.detailTextLabel.hidden = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.textLabel.text = @"检查更新";
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 1) {
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

    }
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
        if(indexPath.row == 0) {
            //TODO -- 关于
            AboutViewController *aboutViewController = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:aboutViewController animated:YES];
        } else if(indexPath.row == 1) {
            //TODO -- 版本信息
            
        } else {
            //TODO -- 检查更新
            
        }

    } else {
        if(indexPath.row == 0) {
            //TODO -- 修改密码
            ModifyPasswordViewController *modifyPasswordViewController = [[ModifyPasswordViewController alloc] init];
            [self.navigationController pushViewController:modifyPasswordViewController animated:YES];
        } else if(indexPath.row == 1) {
            //TODO -- 意见反馈
            FeedbackViewController *feedbackViewController = [[FeedbackViewController alloc] init];
            
            feedbackViewController.block = ^(){
                AttentionView * attention = [[AttentionView alloc]initTitle:@"反馈成功！" andtitle2:@""];
                attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
                attention.label1.frame=CGRectMake(5, 15, 220, 40);
                [self.view addSubview:attention];
            };
    
            [self.navigationController pushViewController:feedbackViewController animated:YES];
        } else if(indexPath.row == 2) {
            //TODO -- 关于
            AboutViewController *aboutViewController = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:aboutViewController animated:YES];
        } else if(indexPath.row == 3) {
            //TODO -- 版本信息
            
        } else {
            //TODO -- 检查更新
            
        }
    }
}




- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < 5) {
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - TRANS_VALUE(60.0f)) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = I_DIVIDER_COLOR;
    self.tableView.backgroundColor = I_BACKGROUND_COLOR;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(0.0f))];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1.0f)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    
    UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1.0f)];
    dividerView.backgroundColor = RGBCOLOR(231, 231, 231);
    [footerView addSubview:dividerView];
    
    CGFloat tableViewHeight = SCREEN_HEIGHT - 64 - TRANS_VALUE(60.0f);
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, tableViewHeight, SCREEN_WIDTH, TRANS_VALUE(60.0f))];
    bottomView.backgroundColor = I_COLOR_WHITE;
    [self.view addSubview:bottomView];
    
    self.logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(10.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f), TRANS_VALUE(40.0f))];
    self.logoutButton.backgroundColor = I_COLOR_YELLOW;
    self.logoutButton.clipsToBounds = YES;
    self.logoutButton.layer.cornerRadius = TRANS_VALUE(40.0f) / 2;
    self.logoutButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(16.0f)];
    [self.logoutButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:I_COLOR_WHITE forState:UIControlStateNormal];
    [bottomView addSubview:self.logoutButton];
    
    [self.logoutButton addTarget:self action:@selector(logoutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置tableview分割线
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

}

@end
