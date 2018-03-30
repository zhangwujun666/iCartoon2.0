//
//  MyShareViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "MyShareViewController.h"
#import "MyShareTableViewCell.h"
#import "Context.h"
#import "UserInfoDao.h"
#import "UserAPIRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "AttentionView.h"
#import "CustomAlertView.h"

#import "WXApi.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

@interface MyShareViewController ()<UITableViewDataSource,UITableViewDelegate,CustomAlertViewDelegate>
@property (weak, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray *myTableViewArr;
@property (nonatomic,strong)NSDictionary * resultDic;
@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;
@property (nonatomic,strong)NSArray * arr;
@property (nonatomic,strong)NSString * state;
@property (nonatomic,assign)int cancleAurth;
@property (nonatomic,strong)SSDKUser * user;
@property (nonatomic,strong) NSString *isfreeze;
@property (nonatomic,strong) NSString *thaw_date;
@property (nonatomic,strong) NSString *thaw_time;
@property (nonatomic,strong)NSString * isshow;
@property (nonatomic,strong)NSString * isshowfree;

@end

@implementation MyShareViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setBackNavgationItem];
    self.title = @"社交绑定";
     [self requestData];
    [self createUI];
//    [self addTargetAction];
   
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
    //添加表单
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-kTopAndStatusBarHeight));
    }];
    
    //设置tableview分割线
    if([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }

}

- (void)requestData {
    BOOL weixinExixt = 1;
    [WXApi isWXAppInstalled];
        _arr = [NSArray array];
        if (weixinExixt) {
            BOOL sinaWeiboAuthoried = [ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo];
            BOOL weixinAuthoried = [ShareSDK hasAuthorized:SSDKPlatformTypeWechat];
            BOOL qqAuthoried = [ShareSDK hasAuthorized:SSDKPlatformSubTypeQZone];
            _arr = @[
                             @{@"imgName":@"ic_bind_qq",
                               @"titleName":@"QQ",
                               @"status":[NSString stringWithFormat:@"%d",qqAuthoried]},
                             @{@"imgName":@"ic_bind_weixin",
                               @"titleName":@"微信",
                               @"status":[NSString stringWithFormat:@"%d",weixinAuthoried]},
                             @{@"imgName":@"ic_bind_weibo",
                               @"titleName":@"新浪微博",
                               @"status":[NSString stringWithFormat:@"%d",sinaWeiboAuthoried]}                     ];
        }else{
            BOOL sinaWeiboAuthoried = [ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo];
            BOOL qqAuthoried = [ShareSDK hasAuthorized:SSDKPlatformSubTypeQZone];
            _arr = @[
                             @{@"imgName":@"ic_bind_qq",
                               @"titleName":@"QQ",
                               @"status":[NSString stringWithFormat:@"%d",qqAuthoried]},
                             @{@"imgName":@"ic_bind_weibo",
                               @"titleName":@"新浪微博",
                               @"status":[NSString stringWithFormat:@"%d",sinaWeiboAuthoried]}];
        }
        [self.myTableViewArr addObjectsFromArray:_arr];
        [self.myTableView reloadData];

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
        self.qqAuth = [dic[@"qq"] intValue];
        self.weixboAuth = [dic[@"wx"] intValue];
        self.weixinAuth = [dic[@"wb"] intValue];
        [self.myTableView reloadData];
//        NSLog(@"responseObject ====== %@",responseObject[@"response"][@"result"]);
//        NSLog(@"-------%@------%@-------%@",self.qqAuth,self.weixinAuth,self.weixboAuth);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MyShareTableViewCell forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)configureCell:(MyShareTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic = [NSDictionary dictionary];
    if (self.myTableViewArr.count != 0) {
        dic = self.myTableViewArr[indexPath.row];
    }
    BOOL weixinExixt = 1;
//    [WXApi isWXAppInstalled];
    if (weixinExixt) {

        if(self.weixboAuth == 1 && indexPath.row == 2) {
            [cell setImgName:[dic objectForKey:@"imgName"] title:[dic objectForKey:@"titleName"] status:@"1"];
        } else if(self.weixboAuth == 0 && indexPath.row == 2){
            [cell setImgName:[dic objectForKey:@"imgName"] title:[dic objectForKey:@"titleName"] status:@"0"];
        }

        if(self.weixinAuth == 1 && indexPath.row == 1) {
            [cell setImgName:[dic objectForKey:@"imgName"] title:[dic objectForKey:@"titleName"] status:@"1"];
        } else if(self.weixinAuth == 0 && indexPath.row == 1){
            [cell setImgName:[dic objectForKey:@"imgName"] title:[dic objectForKey:@"titleName"] status:@"0"];
        }

        if(self.qqAuth == 1 && indexPath.row == 0) {
            [cell setImgName:[dic objectForKey:@"imgName"] title:[dic objectForKey:@"titleName"] status:@"1"];
        } else if(self.qqAuth == 0 && indexPath.row == 0){
            [cell setImgName:[dic objectForKey:@"imgName"] title:[dic objectForKey:@"titleName"] status:@"0"];
        }

    }else{

        if(self.weixboAuth == 1 && indexPath.row == 1) {
            [cell setImgName:[dic objectForKey:@"imgName"] title:[dic objectForKey:@"titleName"] status:@"1"];
        } else if(self.weixboAuth == 0 && indexPath.row == 1){
            [cell setImgName:[dic objectForKey:@"imgName"] title:[dic objectForKey:@"titleName"] status:@"0"];
        }

        if(self.qqAuth == 1 && indexPath.row == 0) {
            [cell setImgName:[dic objectForKey:@"imgName"] title:[dic objectForKey:@"titleName"] status:@"1"];
        } else if(self.qqAuth == 0 && indexPath.row == 0){
            [cell setImgName:[dic objectForKey:@"imgName"] title:[dic objectForKey:@"titleName"] status:@"0"];
        }
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL isExitWeiXin = 1;
    [WXApi isWXAppInstalled];
    
    if (isExitWeiXin) {
        if(indexPath.row == 2) {

            if(self.weixboAuth == 1) {
                   _cancleAurth = 1;
                 [CustomAlertView showWithTitle:@"sharesina" delegate:self];

            } else {
                [ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo];
                [self thirdLogin:SSDKPlatformTypeSinaWeibo];
                 [self.myTableView reloadData];
            }
        } else if(indexPath.row == 1) {
            if(self.weixinAuth == 1) {
                 _cancleAurth = 2;
                 [CustomAlertView showWithTitle:@"shareweixin" delegate:self];
            } else {
                [ShareSDK hasAuthorized:SSDKPlatformTypeWechat];
                [self thirdLogin:SSDKPlatformTypeWechat];
                [self.myTableView reloadData];
            }
        } else if(indexPath.row == 0) {
            if(self.qqAuth == 1) {
                   _cancleAurth = 3;
                 [CustomAlertView showWithTitle:@"shareQQ" delegate:self];
                } else {
                [ShareSDK hasAuthorized:SSDKPlatformSubTypeQZone];
                [self thirdLogin:SSDKPlatformSubTypeQZone];
                [self.myTableView reloadData];
            }
        }

    }else{
        if(indexPath.row == 1) {

            if(self.weixboAuth) {
                   _cancleAurth = 1;
                 [CustomAlertView showWithTitle:@"sharesina" delegate:self];
            } else {
                [ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo];
                [self thirdLogin:SSDKPlatformTypeSinaWeibo];
                [self.myTableView reloadData];
            }
        } else if(indexPath.row == 0) {

            if(self.qqAuth) {
                   _cancleAurth = 3;
                 [CustomAlertView showWithTitle:@"shareQQ" delegate:self];

            } else {
                [ShareSDK hasAuthorized:SSDKPlatformSubTypeQZone];
                [self thirdLogin:SSDKPlatformSubTypeQZone];
                [self.myTableView reloadData];
            }
        }
    }
}
#pragma mark - CustomAlertViewDelegate
- (void)confirmButtonClick {
    if (_cancleAurth == 1) {
        [self reloadStateWithType:SSDKPlatformTypeSinaWeibo userInfo:self.user];
         [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
    }if (_cancleAurth == 2) {
         [self reloadStateWithType:SSDKPlatformTypeWechat userInfo:self.user];
         [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    }if (_cancleAurth == 3) {
         [self reloadStateWithType:SSDKPlatformSubTypeQZone userInfo:self.user];
        [ShareSDK cancelAuthorize:SSDKPlatformSubTypeQZone];
    }
}

- (void)cancelButtonClick {
    
}
- (void)thirdLogin:(SSDKPlatformType)shareType {
        if (shareType == SSDKPlatformTypeWechat) {
        [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeWechat onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {associateHandler (user.uid, user, user);
            _user = user;
            [self reloadStateWithType:shareType userInfo:user];
        }
                                    onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                        //        NSLog(@"-----------%@",error.localizedDescription);
                                    }];
    }else if (shareType == SSDKPlatformSubTypeQZone){
        [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeQQ
                                       onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                           associateHandler (user.uid, user, user);
                                              _user = user;
                                           [self reloadStateWithType:shareType userInfo:user];
                                           
                                       }
                                    onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    }];
        
    }else{
        [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeSinaWeibo
                                       onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                           associateHandler (user.uid, user, user);
                                              _user = user;
                                           [self reloadStateWithType:shareType userInfo:user];
                                       }
                                    onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                        
                                    }];
        
    }
}
-(void)reloadStateWithType:(SSDKPlatformType)type userInfo:(SSDKUser *)userInfo {
    //现实授权信息，包括授权ID、授权有效期等。
    //此处可以在用户进入应用的时候直接调用，如授权信息不为空且不过期可帮用户自动实现登录。
//    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:type];
//    NSLog(@"uid:%@\n", [credential uid]);                 //用户标识
//    NSLog(@"token:%@\n", [credential token]);
//    NSLog(@"secret:%@\n", [credential secret]);
//    NSLog(@"expired:%@\n", [credential expired]);
//    NSLog(@"nextInfo:%@\n", [credential extInfo]);
    
    NSString *unionId = @"18521508353";
    if ([userInfo uid]) {
        unionId = [userInfo uid];
    }
     NSString *typeStr = @"3";
    if(type == SSDKPlatformTypeWechat) {
        typeStr = @"3";
    } else if(type == SSDKPlatformSubTypeQZone) {
        typeStr = @"2";
    } else {
        typeStr = @"1";
    }
    NSString * token = [Context sharedInstance].token;
    self.requestManager = [AFHTTPRequestOperationManager manager];
    self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableDictionary * paramaDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString * state = @"1";
    if (_cancleAurth) {
        state = @"2";
    }
    NSString * mainurl = [APIConfig mainURL];
     NSString * path = [NSString stringWithFormat:@"%@/%@/",mainurl,@"ThirdPartyBinding"];
    NSString * urlpath = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",path,unionId,typeStr,state,token];
    [self.requestManager GET:urlpath parameters:paramaDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self addTargetAction];
          [self requestData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}
- (void)loadUserInfo {
    NSDictionary *params = @{};
    if(![Context sharedInstance].token) {
        [Context sharedInstance].userInfo = nil;
        return;
    }
    [[UserAPIRequest sharedInstance] getUserInfo:params success:^(UserInfo *userInfo) {
        if(userInfo) {
//            NSLog(@"userInfo = %@",userInfo);
            [[UserInfoDao sharedInstance] insertUserInfo:userInfo];
            [Context sharedInstance].userInfo = userInfo;
        } else {
            [Context sharedInstance].userInfo = nil;
        }
    } failure:^(NSError *error) {
        [Context sharedInstance].userInfo = nil;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CONVER_VALUE(50.0f);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - Private Method
//- (void)cancelAuthorWithType:(ShareType)shareType {
//    [ShareSDK cancelAuthWithType:ShareTypeTencentWeibo];
//}

#pragma mark getter && setter
- (UITableView *)myTableView {
    if (!_myTableView) {
        UITableView *tmpTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tmpTableView.backgroundColor = I_BACKGROUND_COLOR;
        tmpTableView.dataSource = self;
        tmpTableView.delegate = self;
        tmpTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [tmpTableView registerClass:[MyShareTableViewCell class] forCellReuseIdentifier:kCellIdentifier_MyShareTableViewCell];
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [tmpTableView setTableFooterView:view];
        [self.view addSubview:(_myTableView = tmpTableView)];
    }
    return _myTableView;
}

- (NSMutableArray *)myTableViewArr {
    if (!_myTableViewArr) {
        _myTableViewArr = [NSMutableArray array];
    }
    return _myTableViewArr;
}

@end
