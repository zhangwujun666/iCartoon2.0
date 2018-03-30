//
//  MeViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "MeViewController.h"
#import "LoginViewController.h"
#import "EditInfoViewController.h"
#import "ReplyCommentViewController.h"
#import "MyCollectionViewController.h"
#import "MyReleaseViewController.h"
#import "MyPostViewController.h"
#import "MyRelativeViewController.h"
#import "ConcernedThemeViewController.h"
#import "MyTaskViewController.h"
#import "MyCommentsViewController.h"
#import "MyPraisedViewController.h"
#import "DraftBoxViewController.h"
#import "FavoriteAuthorViewController.h"
#import "MyFunsViewController.h"
#import "MyShareViewController.h"
#import "SettingViewController.h"
#import "AppDelegate.h"
#import "MeItem.h"
#import "UserInfoDao.h"

#import "UIImage+Color.h"
#import "Context.h"
#import "MeAPIRequest.h"
#import "UserAPIRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIImageView+Webcache.h"
#import "DraftBoxViewController.h"
#import "MyMessageViewController.h"
#import "MyMessageNewViewController.h"
#import "MeAPIRequest.h"
#import <TSMessages/TSMessage.h>

#import <AFNetworking.h>
#import "WXApi.h"

@interface MeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIBarButtonItem *settingButton;
@property (strong, nonatomic) UIBarButtonItem *messageButton;

@property (strong,nonatomic)  UIButton * mMessageButton;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *incubatorButton;
@property (strong, nonatomic) UIButton *shopButton;

@property (assign, nonatomic) BOOL incubatorShow;
@property (strong, nonatomic) UserInteractionInfo *interactionInfo;

@property (strong, nonatomic) NSMutableArray *itemArray;
@property (strong, nonatomic) UIImageView * imagV;
@property (strong, nonatomic) UIView * bacView;
@property (strong, nonatomic) NSMutableArray  * messageArray;
@property (strong, nonatomic) NSMutableArray  * isReadArray;
@property (nonatomic,strong) UIImageView *avatarImageView;
@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;
@property (nonatomic,assign)int qqAuth;
@property (nonatomic,assign)int weixinAuth;
@property (nonatomic,assign)int weixboAuth;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tabBarItem.badgeValue = @"1";
    self.view.backgroundColor = I_BACKGROUND_COLOR;
    self.navigationItem.title = @"我的窝";
    self.settingButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_navi_setting"] style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonAction)];
//    self.navigationItem.leftBarButtonItem = self.settingButton;
    
   // _mMessageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CONVER_VALUE(16.0f), CONVER_VALUE(25.0f))];
    
    _mMessageButton = [[UIButton alloc] initWithFrame:CGRectMake(CONVER_VALUE(18.0f), 0,  CONVER_VALUE(16.0f), CONVER_VALUE(25.0f))];
    [_mMessageButton setImageEdgeInsets:UIEdgeInsetsMake(0,CONVER_VALUE(5.0f), 0,CONVER_VALUE(-10.0f))];
    _mMessageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
       [_mMessageButton addTarget:self action:@selector(messageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.messageButton = [[UIBarButtonItem alloc] initWithCustomView:_mMessageButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"reload" object:nil];
//    self.navigationItem.rightBarButtonItem = self.messageButton;
    self.incubatorShow = YES;
//    [self loadUserData];
//    [self loadUserInfo];
//    [self getUserInteractionInfo];
    [self createUI];
    
}
- (void)addTargetAction {
    NSString * token = [Context sharedInstance].token;
    self.requestManager = [AFHTTPRequestOperationManager manager];
    self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableDictionary * paramaDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString * mainurl = [APIConfig mainURL];
    NSString * path = [NSString stringWithFormat:@"%@/%@/%@",mainurl,@"ShowThirdPartyBinding",token];
    
    [self.requestManager GET:path parameters:paramaDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
      
        NSDictionary * dic = responseObject[@"response"][@"result"];
//          NSLog(@"dic --------------------------- %@",dic);
        self.qqAuth = [dic[@"qq"] intValue];
        self.weixboAuth = [dic[@"wx"] intValue];
        self.weixinAuth = [dic[@"wb"] intValue];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![Context sharedInstance].token) {
        [_mMessageButton setImage:[UIImage imageNamed:@"ic_navi_message_off"] forState:UIControlStateNormal];
        [_mMessageButton setImage:[UIImage imageNamed:@"ic_navi_message_off"] forState:UIControlStateFocused];
        [_mMessageButton setImage:[UIImage imageNamed:@"ic_navi_message_off"] forState:UIControlStateSelected];
        self.tableView.scrollEnabled = NO;
        self.navigationItem.leftBarButtonItem = self.settingButton;
        self.navigationItem.rightBarButtonItem =self.messageButton;
        //[self loadData];
    } else {
        self.navigationItem.leftBarButtonItem = self.settingButton;
        self.navigationItem.rightBarButtonItem = self.messageButton;
            self.tableView.scrollEnabled = YES;
        [self loadUserData];
       [self loadUserInfo];
       [self getUserInteractionInfo];
        [self belling];
    [self addTargetAction];
    }
    
 
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Private Method
- (void)settingButtonAction {
    //TOOD -- 设置按钮点击事件
    if (![Context sharedInstance].token) {
        [[AppDelegate sharedDelegate] showLoginViewController:YES index:3];
    }
    else{
        SettingViewController *settingViewController = [[SettingViewController alloc] init];
        settingViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingViewController animated:YES];
    }
}

- (void)messageButtonAction {
    //TOOD -- 消息按钮点击事件
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
        if(![Context sharedInstance].userInfo ||
           ![Context sharedInstance].token) {
            [[AppDelegate sharedDelegate]showLoginViewController:YES index:3];
            return;
        }
        
    } else {
        MyMessageNewViewController *messageViewController = [[MyMessageNewViewController alloc] init];
        messageViewController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:messageViewController animated:YES];
    }
   
}

- (void)myReleasedAction {
    //TOOD -- 消息按钮点击事件
    MyReleaseViewController *releaseViewController = [[MyReleaseViewController alloc] init];
    releaseViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:releaseViewController animated:YES];
}

- (void)myFavourAction {
    //TOOD -- 消息按钮点击事件
//    MyPraisedViewController *praisedViewController = [[MyPraisedViewController alloc] init];
//    praisedViewController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:praisedViewController animated:YES];
}

- (NSMutableArray *)isReadArray{
    if (!_isReadArray) {
        _isReadArray = [NSMutableArray array];
    }
    return _isReadArray;
}
-(void)belling{
    if(!self.messageArray) {
        self.messageArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.messageArray removeAllObjects];
    
    [[MeAPIRequest  sharedInstance]  getMessageList:nil success:^(NSArray *messageList) {
//        NSLog(@"%@",messageList);
        [self.isReadArray removeAllObjects];
        for (int i = 0; i < messageList.count; i++) {
            MessageInfo * infor = messageList[i];
            if ([infor.status isEqualToString:@"0"]) {
                [self.isReadArray addObject:infor.status];
            }
        }
        if(messageList) {
            [self.messageArray addObjectsFromArray:messageList];
        }
        [self.tableView reloadData];
        if (self.messageArray.count != 0 && self.isReadArray.count != 0) {
            [_mMessageButton setImage:[UIImage imageNamed:@"ic_navi_message"] forState:UIControlStateNormal];
            [_mMessageButton setImage:[UIImage imageNamed:@"ic_navi_message"] forState:UIControlStateFocused];
            [_mMessageButton setImage:[UIImage imageNamed:@"ic_navi_message"] forState:UIControlStateSelected];
        }else{
            [_mMessageButton setImage:[UIImage imageNamed:@"ic_navi_message_off"] forState:UIControlStateNormal];
            [_mMessageButton setImage:[UIImage imageNamed:@"ic_navi_message_off"] forState:UIControlStateFocused];
            [_mMessageButton setImage:[UIImage imageNamed:@"ic_navi_message_off"] forState:UIControlStateSelected];
        }
        
    } failure:^(NSError *error) {
        [self.tableView reloadData];
    }];
    
}


- (void)myConcernedAction {
    //TOOD -- 消息按钮点击事件
    ConcernedThemeViewController *concernedViewController = [[ConcernedThemeViewController alloc] init];
    concernedViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:concernedViewController animated:YES];
}

- (void)tabButtonAction:(UIButton *)sender {
    if(sender == self.incubatorButton) {
        if(self.incubatorShow) {
            return;
        } else {
            self.bacView.hidden = YES;
            self.incubatorShow = YES;
            self.tableView.scrollEnabled = YES;
            [self.incubatorButton setSelected:YES];
            [self.shopButton setSelected:NO];
        }
    } else {
        if(self.incubatorShow) {
            self.incubatorShow = NO;
            [self.incubatorButton setSelected:NO];
            [self.shopButton setSelected:YES];
            //self.tableView.hidden = YES;
            self.tableView.scrollEnabled = NO;
            UIView * bacView = [[UIView alloc]initWithFrame:CGRectMake(0, TRANS_VALUE(111.0f), [UIScreen mainScreen].bounds.size.width, self.tableView.frame.size.height-TRANS_VALUE(24.0f))];
            bacView.userInteractionEnabled = NO;
            bacView.backgroundColor = [UIColor whiteColor];
            self.bacView = bacView;
            [self.tableView addSubview:self.bacView];
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-120, 70, 240, 160)];
            imageView.image = [UIImage imageNamed:@"no_data_hint"];
            self.imagV = imageView;
            [self.bacView addSubview:self.imagV];
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imagV.frame)+20, [UIScreen mainScreen].bounds.size.width, 30)];
            lab.text = @"功能尚未开放, 敬请期待...";
            lab.textColor = [UIColor blackColor];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont systemFontOfSize:18];
            [self.bacView addSubview:lab];
             self.imagV.userInteractionEnabled = NO;
            self.bacView.userInteractionEnabled = NO;
        }
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)loadUserInfo {
    NSDictionary *params = @{};
    if(![Context sharedInstance].token) {
        [Context sharedInstance].userInfo = nil;
        [self.tableView reloadData];
        return;
    }

    [[UserAPIRequest sharedInstance] getUserInfo:params success:^(UserInfo *userInfo) {
        if(userInfo) {
            [Context sharedInstance].userInfo = userInfo;
            [[UserInfoDao sharedInstance] insertUserInfo:userInfo];
        } else {
            [Context sharedInstance].userInfo = nil;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
        [Context sharedInstance].userInfo = nil;
 //       [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }];
    
}

- (void)getUserInteractionInfo {
    if(![Context sharedInstance].token) {
        [Context sharedInstance].userInfo = nil;
        self.interactionInfo = [[UserInteractionInfo alloc] init];
        self.interactionInfo.favorNum = @"0";
        self.interactionInfo.postNum = @"0";
        self.interactionInfo.concernedNum = @"0";
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        return;
    }
//    [SVProgressHUD showWithStatus:@"正在获取用户互动信息..." maskType:SVProgressHUDMaskTypeClear];
    [[MeAPIRequest sharedInstance] getUserInteractionInfo:nil success:^(UserInteractionInfo *interactionInfo) {
//        [SVProgressHUD dismiss];
        if(interactionInfo) {
            self.interactionInfo = interactionInfo;
        } else {
            self.interactionInfo = [[UserInteractionInfo alloc] init];
            self.interactionInfo.favorNum = @"0";
            self.interactionInfo.postNum = @"0";
            self.interactionInfo.concernedNum = @"0";
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
        self.interactionInfo = [[UserInteractionInfo alloc] init];
        self.interactionInfo.favorNum = @"0";
        self.interactionInfo.postNum = @"0";
        self.interactionInfo.concernedNum = @"0";
        [self.tableView reloadData];
    }];

}

#pragma mark - Action
- (void)editInfoAction {
    //TODO -- 编辑信息
    EditInfoViewController *editInfoViewController = [[EditInfoViewController alloc] init];
    editInfoViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editInfoViewController animated:YES];
}

- (void)loginAction {
    //TODO -- 登录或者注册
    [[AppDelegate sharedDelegate]showLoginViewController:YES index:3];
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
        return 2;
    } else {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
        if(section == 0) {
            return 1;
        } else {
            return 1;
        }
    } else {
        if(section <= 1) {
            return 1;
        } else {
            NSInteger count = self.itemArray != nil ? self.itemArray.count : 0;
            return count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
        if(indexPath.section == 0) {
            return TRANS_VALUE(81.0f);
        } else {
            return TRANS_VALUE(370.0f);
        }
    } else {
        if(indexPath.section == 0) {
            return TRANS_VALUE(80.0f);
        } else if(indexPath.section == 1) {
            return TRANS_VALUE(80.0f);
        } else {
            return TRANS_VALUE(44.0f);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
        if(section == 0) {
            return TRANS_VALUE(0.0f);
        } else {
            return TRANS_VALUE(0.0f);
        }
    } else {
        if (section==0) {
            return TRANS_VALUE(0.0f);
        }else{
            return TRANS_VALUE(5.0f);
        }

    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0f;
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
        if(section == 1) {
            height = TRANS_VALUE(5.0f);
        }
    } else {
        if(section == 2) {
            height = TRANS_VALUE(5.0f);
        }
    }

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    view.backgroundColor = RGBCOLOR(240, 240, 240);
    return view;
}

- (void)tapclick{
    [[AppDelegate sharedDelegate]showLoginViewController:YES index:3];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
        if(indexPath.section == 0) {
            UITableViewCell *cell = [self notLoginInfoCellWithTableView:tableView];
//            UIImageView *imageBackView = (UIImageView *)[cell.contentView.subviews objectAtIndex:0];
//            UIImageView *avatarImageView = (UIImageView *)[cell.contentView.subviews objectAtIndex:2];
            UIButton *loginButton = (UIButton *)[cell.contentView.subviews objectAtIndex:3];
//            avatarImageView.image = [UIImage imageNamed:@"ic_avatar_default"];
            [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
            cell.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapclick)];
            [cell addGestureRecognizer:tap];
            return cell;
        } else {
            UITableViewCell *cell = [self notLoginLoadingCellWithTableView:tableView];
            UIImageView *loadingImageView = (UIImageView *)[cell.contentView.subviews objectAtIndex:0];
            loadingImageView.image = [UIImage imageNamed:@"no_data_hint"];
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }
    }   else {
       
        if(indexPath.section == 0) {
 UserInfo *userInfo = [Context sharedInstance].userInfo;
            UITableViewCell *cell = [self loginInfoCellWithTableView:tableView];
            NSString *avatarURL = userInfo.avatar != nil ? userInfo.avatar : @"";
            if (!self.avatarImageView) {
                 self.avatarImageView = (UIImageView *)[cell.contentView.subviews objectAtIndex:1];
            }
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarURL] placeholderImage:[UIImage imageNamed:@""]];
            UILabel *infoLabel = (UILabel *)[cell.contentView.subviews objectAtIndex:2];
            UILabel *signLabel = (UILabel *)[cell.contentView.subviews objectAtIndex:3];
            signLabel.adjustsFontSizeToFitWidth = YES;
            
            infoLabel.adjustsFontSizeToFitWidth = YES;
           
            NSString *infoStr = nil;
            if([userInfo.gender isEqualToString:@"1"]) {
//                infoStr = [NSString stringWithFormat:@"%@ ♂", userInfo.nickname];
                infoStr = [NSString stringWithFormat:@"%@", userInfo.nickname];
            } else {
//                infoStr = [NSString stringWithFormat:@"%@ ♀", userInfo.nickname];
                infoStr = [NSString stringWithFormat:@"%@", userInfo.nickname];
            }
            infoLabel.text = infoStr;
            if(!userInfo.signature || [userInfo.signature isEqualToString:@""]) {
                signLabel.text = @"懒癌晚期, 什么都不想留下";
            } else {
//                 NSString * goodMsg = [userInfo.signature stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                signLabel.text = userInfo.signature;
            }
            return cell;
        } else if(indexPath.section == 1) {
            UITableViewCell *cell = [self myCellWithTableView:tableView];
            UIButton *incubatorButton = (UIButton *)[cell.contentView.subviews objectAtIndex:0];
            UIButton *shopButton = (UIButton *)[cell.contentView.subviews objectAtIndex:1];
            self.incubatorButton = incubatorButton;
            self.shopButton = shopButton;
            
            UIButton *releasedButton = (UIButton *)[cell.contentView.subviews objectAtIndex:2];
            NSString *releasedStr = [NSString stringWithFormat:@"我发的脑洞"];
            UILabel *releasedLabel = (UILabel *)[releasedButton viewWithTag:10000];
            if (self.interactionInfo.postNum) {
                 releasedLabel.text = [NSString stringWithFormat:@"%@", self.interactionInfo.postNum];
            }else{
                 releasedLabel.text = [NSString stringWithFormat:@"%@", @"0"];
            }
           
            [releasedButton setTitle:releasedStr forState:UIControlStateNormal];
            [releasedButton addTarget:self action:@selector(myReleasedAction) forControlEvents:UIControlEventTouchUpInside];
            UIButton *favourButton = (UIButton *)[cell.contentView.subviews objectAtIndex:3];
            NSString *favourStr = [NSString stringWithFormat:@"我得到的赞"];
            UILabel *favorLabel = (UILabel *)[favourButton viewWithTag:10000];
            if (self.interactionInfo.favorNum) {
                favorLabel.text = [NSString stringWithFormat:@"%@", self.interactionInfo.favorNum];
            }else{
                favorLabel.text = [NSString stringWithFormat:@"0"];
            }
            [favourButton setTitle:favourStr forState:UIControlStateNormal];
            [favourButton addTarget:self action:@selector(myFavourAction) forControlEvents:UIControlEventTouchUpInside];
            NSString *concernedStr = [NSString stringWithFormat:@"关注的熊窝"];
            UIButton *concernedButton = (UIButton *)[cell.contentView.subviews objectAtIndex:4];
            [concernedButton setTitle:concernedStr forState:UIControlStateNormal];
            UILabel *concernedLabel = (UILabel *)[concernedButton viewWithTag:10000];
            if (self.interactionInfo.concernedNum) {
                concernedLabel.text = [NSString stringWithFormat:@"%@", self.interactionInfo.concernedNum];
            }else{
                concernedLabel.text = [NSString stringWithFormat:@"0"];
            }
            [concernedButton addTarget:self action:@selector(myConcernedAction) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if(self.incubatorShow) {
                [self.incubatorButton setSelected:YES];
                [self.shopButton setSelected:NO];
            } else {
                [self.incubatorButton setSelected:NO];
                [self.shopButton setSelected:YES];
            }
            [self.incubatorButton addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.shopButton addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        } else {
            UITableViewCell *cell = [self settingCellWithTableView:tableView];
            UIImageView *iconImageView = (UIImageView *)[cell.contentView.subviews objectAtIndex:0];
            UILabel *titleLabel = (UILabel *)[cell.contentView.subviews objectAtIndex:1];
            UIImageView *weixinImageView = (UIImageView *)[cell.contentView.subviews objectAtIndex:2];
            UIImageView *qqImageView = (UIImageView *)[cell.contentView.subviews objectAtIndex:3];
            UIImageView *weiboImageView = (UIImageView *)[cell.contentView.subviews objectAtIndex:4];
            
            if(indexPath.row < [self.itemArray count]) {
                MeItem *item = [self.itemArray objectAtIndex:indexPath.row];
                iconImageView.image = [UIImage imageNamed:item.icon];
                titleLabel.text = item.title;
            }
           
            if(indexPath.row < [self.itemArray count] - 1) {
                weixinImageView.hidden = YES;
                weiboImageView.hidden = YES;
                qqImageView.hidden = YES;
            } else {
                weixinImageView.hidden = YES;

//                检查是否安装微信
                BOOL weixinExixt = 1;
//                [WXApi isWXAppInstalled];
                NSLog(@"=========%d",[WXApi isWXAppInstalled]);
//                判断微信是否授权
//                NSLog(@"----------------%d",weixinExixt);
                if(weixinExixt) {
                    weixinImageView.hidden = NO;
                    if (self.weixinAuth == 1) {
                        weixinImageView.image = [UIImage imageNamed:@"ic_bind_weixin"];
                    }else{
                         weixinImageView.image = [UIImage imageNamed:@"ic_login_weixinNew"];
                    }
                }
              
                if(self.qqAuth == 1) {
                    qqImageView.image = [UIImage imageNamed:@"ic_bind_qq"];
                }else{
                     qqImageView.image = [UIImage imageNamed:@"ic_login_qqNew"];
                }
                
                if(self.weixboAuth == 1) {
                    weiboImageView.image = [UIImage imageNamed:@"ic_bind_weibo"];
                }else{
                     weiboImageView.image = [UIImage imageNamed:@"ic_login_sinaNew"];
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
        if(indexPath.section == 1) {
            if(indexPath.row == 0) {
                SettingViewController *settingViewController = [[SettingViewController alloc] init];
                settingViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:settingViewController animated:YES];
            }
        }
    } else {
        if(indexPath.section == 0) {
            EditInfoViewController *editInfoViewController = [[EditInfoViewController alloc] init];
            editInfoViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:editInfoViewController animated:YES];
        } else if(indexPath.section == 2) {
            if(indexPath.row == 0 && self.incubatorButton.selected == YES) {
                MyTaskViewController *myTaskViewController = [[MyTaskViewController alloc] init];
                myTaskViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myTaskViewController animated:YES];
            } else if(indexPath.row == 1&& self.incubatorButton.selected == YES) {
                DraftBoxViewController *draftBoxVC = [[DraftBoxViewController alloc] init];
                draftBoxVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:draftBoxVC animated:YES];
            } else if(indexPath.row == 2&& self.incubatorButton.selected == YES) {
                MyCollectionViewController *myCollectionViewController = [[MyCollectionViewController alloc] init];
                myCollectionViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myCollectionViewController animated:YES];
            } else if(indexPath.row == 3&& self.incubatorButton.selected == YES) {
                FavoriteAuthorViewController *favoriteAuthorViewController = [[FavoriteAuthorViewController alloc] init];
                favoriteAuthorViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:favoriteAuthorViewController animated:YES];
            } else if(indexPath.row == 4&& self.incubatorButton.selected == YES) {
                //我的粉丝
                MyFunsViewController *myFunsViewController = [[MyFunsViewController alloc] init];
                myFunsViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myFunsViewController animated:YES];
            } else if(indexPath.row == 5&& self.incubatorButton.selected == YES) {
//                我的评论
                MyCommentsViewController *myCommentsViewController = [[MyCommentsViewController alloc] init];
                myCommentsViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myCommentsViewController animated:YES];
            }  else if(indexPath.row == 6&& self.incubatorButton.selected == YES) {
                ReplyCommentViewController *replyCommentViewController = [[ReplyCommentViewController alloc] init];
                replyCommentViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:replyCommentViewController animated:YES];
            }else if(indexPath.row == 7&& self.incubatorButton.selected == YES) {
                //我的社交绑定
                MyShareViewController *shareViewController = [[MyShareViewController alloc] init];
                shareViewController.qqAuth = self.qqAuth;
                shareViewController.weixboAuth = self.weixboAuth;
                shareViewController.weixinAuth = self.weixinAuth;
                shareViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shareViewController animated:YES];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section <= 1 && indexPath.row == 0) {
        if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
        }
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
        }
    } else {
        if(indexPath.row < [self.itemArray count]) {
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
    
}

#pragma mark - UITableViewCell初始化函数
- (UITableViewCell *)loginInfoCellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"MeLoginInfoTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIImageView *imageBackView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(4.0f), TRANS_VALUE(4.0f), TRANS_VALUE(74.0f), TRANS_VALUE(74.0f))];
        imageBackView.clipsToBounds = YES;
        imageBackView.layer.cornerRadius = imageBackView.frame.size.width / 2;
        imageBackView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        [cell.contentView addSubview:imageBackView];

        UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(8.0f), TRANS_VALUE(8.0f), TRANS_VALUE(66.0f), TRANS_VALUE(66.0f))];
        avatarImageView.clipsToBounds = YES;
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2;
          avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        avatarImageView.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0f];
        avatarImageView.image = [UIImage imageNamed:@"ic_avatar_default"];
        [cell.contentView addSubview:avatarImageView];
        avatarImageView.backgroundColor = I_COLOR_YELLOW;
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(88.0f), TRANS_VALUE(16.0f) , TRANS_VALUE(200.0f), TRANS_VALUE(20.0f))];
        infoLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(16.0f)];
        infoLabel.textAlignment = NSTextAlignmentLeft;
        infoLabel.text = @"Lucy ♀";
        infoLabel.textColor = I_COLOR_33BLACK;
        [cell.contentView addSubview:infoLabel];
        UILabel *signLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(88.0f), TRANS_VALUE(40.0f) , TRANS_VALUE(200.0f), TRANS_VALUE(18.0f))];
        signLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(13.0f)];
        signLabel.textColor = I_COLOR_GRAY;
        signLabel.textAlignment = NSTextAlignmentLeft;
        signLabel.text = @"懒癌晚期, 什么都不想留下";
        [cell.contentView addSubview:signLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(300.0f), TRANS_VALUE(33.0f), TRANS_VALUE(8.0f), TRANS_VALUE(14.0f))];
        arrowImageView.image = [UIImage imageNamed:@"ic_me_arrow_left"];
        arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:arrowImageView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = I_COLOR_WHITE;
    return cell;
}

- (UITableViewCell *)notLoginInfoCellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"MeNotLoginInfoTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIImageView *imageBackView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(4.0f), TRANS_VALUE(4.0f), TRANS_VALUE(74.0f), TRANS_VALUE(74.0f))];
        imageBackView.clipsToBounds = YES;
        imageBackView.layer.cornerRadius = imageBackView.frame.size.width / 2;
        imageBackView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        [cell.contentView addSubview:imageBackView];

        UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(8.0f), TRANS_VALUE(8.0f), TRANS_VALUE(66.0f), TRANS_VALUE(66.0f))];
        avatarImageView.clipsToBounds = YES;
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2;
        avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        avatarImageView.image = [UIImage imageNamed:@"user_test"];
        [cell.contentView addSubview:avatarImageView];
        avatarImageView.backgroundColor = I_COLOR_YELLOW;
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(88.0f), TRANS_VALUE(16.0f) , TRANS_VALUE(200.0f), TRANS_VALUE(20.0f))];
        infoLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(16.0f)];
        infoLabel.textAlignment = NSTextAlignmentLeft;
        infoLabel.text = @"没有登录的围观群众";
        infoLabel.textColor = I_COLOR_33BLACK;
        [cell.contentView addSubview:infoLabel];
        
        UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(88.0f), TRANS_VALUE(40.0f), TRANS_VALUE(74.0f), TRANS_VALUE(24.0f))];
        loginButton.backgroundColor = UIColorFromRGB(0xf0821e);
        loginButton.clipsToBounds = YES;
        loginButton.layer.cornerRadius = TRANS_VALUE(2.0f);
        loginButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(13.0f)];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
        [cell.contentView addSubview:loginButton];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(300.0f), TRANS_VALUE(33.0f), TRANS_VALUE(8.0f), TRANS_VALUE(14.0f))];
        arrowImageView.image = [UIImage imageNamed:@"ic_me_arrow_left"];
        arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:arrowImageView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = I_COLOR_WHITE;
    return cell;
}

- (UITableViewCell *)notLoginLoadingCellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"MeNotLoginLoadingTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIImageView *loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(60.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
         loadingImageView.contentMode = UIViewContentModeScaleAspectFit;    loadingImageView.image = [UIImage imageNamed:@"ic_login_no"];
        loadingImageView.userInteractionEnabled = NO;
        cell.userInteractionEnabled = NO;
        [cell.contentView addSubview:loadingImageView];
//        loadingImageView.backgroundColor = I_COLOR_YELLOW;
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(220.0f), SCREEN_WIDTH, TRANS_VALUE(80.0f))];
        label.textColor = I_COLOR_33BLACK;
        label.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"成为熊宝，解锁更多姿势(ง •̀_•́)ง";
        label.numberOfLines = 0;
        [cell.contentView addSubview:label];
}
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = I_COLOR_WHITE;
    return cell;
}
- (UITableViewCell *)myCellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"MeMyTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIButton *incubatorButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, TRANS_VALUE(24.0f))];
        incubatorButton.backgroundColor = [UIColor whiteColor];
        incubatorButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
        incubatorButton.titleLabel.numberOfLines = 0;
        incubatorButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [incubatorButton setTitle:@"孵化箱" forState:UIControlStateNormal];
        [incubatorButton setTitleColor:I_COLOR_GRAY forState:UIControlStateNormal];
        [incubatorButton setTitleColor:I_COLOR_WHITE forState:UIControlStateSelected];
        [incubatorButton setTitleColor:I_COLOR_WHITE forState:UIControlStateHighlighted];
        [incubatorButton setBackgroundImage:[UIImage imageWithColor:I_COLOR_WHITE] forState:UIControlStateNormal];
        [incubatorButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xf0821e)] forState:UIControlStateSelected];
        [incubatorButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xf0821e)] forState:UIControlStateHighlighted];
        [cell.contentView addSubview:incubatorButton];
        
        UIButton *shopButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, TRANS_VALUE(24.0f))];
        shopButton.backgroundColor = [UIColor whiteColor];
        shopButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
        shopButton.titleLabel.numberOfLines = 0;
        shopButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [shopButton setTitle:@"聚叶城" forState:UIControlStateNormal];
        [shopButton setTitleColor:I_COLOR_GRAY forState:UIControlStateNormal];
        [shopButton setTitleColor:I_COLOR_WHITE forState:UIControlStateSelected];
        [shopButton setTitleColor:I_COLOR_WHITE forState:UIControlStateHighlighted];
        [shopButton setBackgroundImage:[UIImage imageWithColor:I_COLOR_WHITE] forState:UIControlStateNormal];
        [shopButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xf0821e)] forState:UIControlStateSelected];
        [shopButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xf0821e)] forState:UIControlStateHighlighted];
        [cell.contentView addSubview:shopButton];

        CGFloat width = (SCREEN_WIDTH - 2.0f) / 3;
        UIButton *releasedButton = [[UIButton alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(24), width, TRANS_VALUE(49.0f))];
        releasedButton.backgroundColor = [UIColor whiteColor];
        releasedButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
        releasedButton.titleLabel.numberOfLines = 0;
        releasedButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        releasedButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        [releasedButton setTitleColor:I_COLOR_33BLACK forState:UIControlStateNormal];
        [cell.contentView addSubview:releasedButton];
        UILabel *releasedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, TRANS_VALUE(40.0f))];
        releasedLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(24.0f)];
        releasedLabel.textColor = I_COLOR_YELLOW;
        releasedLabel.textAlignment = NSTextAlignmentCenter;
        releasedLabel.tag = 10000;
        [releasedButton addSubview:releasedLabel];
        
        UIButton *favorButton = [[UIButton alloc] initWithFrame:CGRectMake(width + 1.0f, TRANS_VALUE(24), width, TRANS_VALUE(49.0f))];
        favorButton.backgroundColor = [UIColor whiteColor];
        favorButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
        favorButton.titleLabel.numberOfLines = 0;
        favorButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        favorButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        [favorButton setTitleColor:I_COLOR_33BLACK forState:UIControlStateNormal];
        [cell.contentView addSubview:favorButton];
        UILabel *favorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, TRANS_VALUE(40.0f))];
        favorLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(24.0f)];
        favorLabel.textColor = I_COLOR_YELLOW;
        favorLabel.textAlignment = NSTextAlignmentCenter;
        favorLabel.tag = 10000;
        [favorButton addSubview:favorLabel];
        
        UIButton *concernedButton = [[UIButton alloc] initWithFrame:CGRectMake(2 * width + 2.0f, TRANS_VALUE(24), width, TRANS_VALUE(49.0f))];
        concernedButton.backgroundColor = [UIColor whiteColor];
        concernedButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
        concernedButton.titleLabel.numberOfLines = 0;
        concernedButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [concernedButton setTitleColor:I_COLOR_33BLACK forState:UIControlStateNormal];
        concernedButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        UILabel *concernedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, TRANS_VALUE(40.0f))];
        concernedLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(24.0f)];
        concernedLabel.textColor = I_COLOR_YELLOW;
        concernedLabel.textAlignment = NSTextAlignmentCenter;
        concernedLabel.tag = 10000;
        [concernedButton addSubview:concernedLabel];
        [cell.contentView addSubview:concernedButton];
        
        UIView *dividerTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(0.5f))];
        dividerTop.backgroundColor = I_COLOR_YELLOW;
        [cell.contentView addSubview:dividerTop];
        
        UIView *dividerBottom = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(24.0f), SCREEN_WIDTH, TRANS_VALUE(0.5f))];
        dividerBottom.backgroundColor = I_COLOR_YELLOW;
        [cell.contentView addSubview:dividerBottom];
        
        UIView *divider01 = [[UIView alloc] initWithFrame:CGRectMake(width, TRANS_VALUE(25.0f), TRANS_VALUE(0.5f), TRANS_VALUE(56.0f))];
        divider01.backgroundColor = I_DIVIDER_COLOR;
        [cell.contentView addSubview:divider01];
        
        UIView *divider02 = [[UIView alloc] initWithFrame:CGRectMake(2 * width + 1.5f, TRANS_VALUE(25.0f), TRANS_VALUE(0.5f), TRANS_VALUE(56.0f))];
        divider02.backgroundColor = I_DIVIDER_COLOR;
        [cell.contentView addSubview:divider02];
        
        UIView *bottomDivider = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(80) - 0.5f, SCREEN_WIDTH, 0.5f)];
        bottomDivider.backgroundColor = I_DIVIDER_COLOR;
        [cell.contentView addSubview:bottomDivider];
    }
    cell.backgroundColor = I_COLOR_WHITE;
    //cell.backgroundColor =[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell *)settingCellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"MeItemTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(25.0f), TRANS_VALUE(10.0f), TRANS_VALUE(20.0f), TRANS_VALUE(24.0f))];
        iconImageView.image = [UIImage imageNamed:@"ic_me_setting"];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:iconImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(60.0f), TRANS_VALUE(7.0f), TRANS_VALUE(240.0f), TRANS_VALUE(30.0f))];
        titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = @"设置";
        titleLabel.textColor = I_COLOR_33BLACK;
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *weixinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(200.0f), TRANS_VALUE(10.0f), TRANS_VALUE(24.0f), TRANS_VALUE(24.0f))];
        weixinImageView.image = [UIImage imageNamed:@"ic_login_weixinNew"];
        weixinImageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:weixinImageView];
        
        UIImageView *qqImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(230.0f), TRANS_VALUE(10.0f), TRANS_VALUE(24.0f), TRANS_VALUE(24.0f))];
        qqImageView.image = [UIImage imageNamed:@"ic_login_qqNew"];
        qqImageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:qqImageView];
        
        UIImageView *weiboImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(260.0f), TRANS_VALUE(10.0f), TRANS_VALUE(24.0f), TRANS_VALUE(24.0f))];
        weiboImageView.image = [UIImage imageNamed:@"ic_login_sinaNew"];
        weiboImageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:weiboImageView];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(300.0f), TRANS_VALUE(15.0f), TRANS_VALUE(8.0f), TRANS_VALUE(14.0f))];
        arrowImageView.image = [UIImage imageNamed:@"ic_me_arrow_left_gray"];
        arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:arrowImageView];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = I_COLOR_WHITE;
    return cell;
}

#pragma mark - Private Method
- (void)loadData {
    if(!self.itemArray) {
        self.itemArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.itemArray removeAllObjects];
    [self.tableView reloadData];
}
- (void)loadUserData {
    
    if(!self.itemArray) {
        self.itemArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.itemArray removeAllObjects];
    MeItem *item0 = [[MeItem alloc] init];
    item0.icon = @"ic_me_task";
    item0.title = @"我的任务";
    [self.itemArray addObject:item0];
    MeItem *item1 = [[MeItem alloc] init];
    item1.icon = @"ic_me_draft";
    item1.title = @"我的草稿";
    [self.itemArray addObject:item1];
    MeItem *item2 = [[MeItem alloc] init];
    item2.icon = @"ic_me_collection";
    item2.title = @"我的收藏";
    [self.itemArray addObject:item2];
    MeItem *item3 = [[MeItem alloc] init];
    item3.icon = @"ic_me_author";
    item3.title = @"我的关注";
    [self.itemArray addObject:item3];
    MeItem *item4 = [[MeItem alloc] init];
    item4.icon = @"ic_me_fans";
    item4.title = @"我的粉丝";
    [self.itemArray addObject:item4];
    
    MeItem *item5 = [[MeItem alloc] init];
    item5.icon = @"ic_me_comment";
    item5.title = @"我的评论";
    [self.itemArray addObject:item5];
    
    MeItem *item6 = [[MeItem alloc] init];
    item6.icon = @"ic_me_reply_comment";
    item6.title = @"我的消息";
    [self.itemArray addObject:item6];
    MeItem *item7 = [[MeItem alloc] init];
    item7.icon = @"ic_me_share";
    item7.title = @"社交绑定";
    [self.itemArray addObject:item7];
    
    [self.tableView reloadData];
}
-(void)reload{
    [self.tableView reloadData];
}

- (void)createUI {
    //实例化表单控件
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.separatorColor = I_DIVIDER_COLOR;
     self.tableView.separatorColor =UIColorFromRGB(0xdcdcdc);
    self.tableView.backgroundColor = I_BACKGROUND_COLOR;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(0.0f))];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
        self.tableView.scrollEnabled = NO;
    }else{
        self.tableView.scrollEnabled = YES;
    }
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    设置tableview分割线
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
