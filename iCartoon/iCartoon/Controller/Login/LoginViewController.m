//
//  LoginViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright (c) 2015年 xuchengxiong. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "ThirdLoginButton.h"
#import "UserAPIRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "NSString+Utils.h"
#import "RegexKit.h"
#import "Context.h"
#import "MD5File.h"
#import "AccountInfoDao.h"
#import "UserInfoDao.h"
#import "LoginResultInfoDao.h"
#import "AttentionView.h"
#import "JPUSHService.h"
#import <CommonCrypto/CommonHMAC.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import <arpa/inet.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

@interface LoginViewController () <UITextFieldDelegate>
@property (strong, nonatomic) UIBarButtonItem *backButton;
//logo
@property (weak, nonatomic) UIImageView *logoImageView;
//@property (strong, nonatomic) UILabel *logoLabel;
//输入框
@property (weak, nonatomic) UITextField *mobileTextField;
@property (weak, nonatomic) UIImageView *mobileImageView;
@property (weak, nonatomic) UIImageView *passwordImageView;
@property (weak, nonatomic) UITextField *passwordTextField;
//按钮
@property (weak, nonatomic) UIButton *loginButton;
@property (weak, nonatomic) UIButton *registerButton;
@property (weak, nonatomic) UIButton *forgetPwdButton;
//提示文字
@property (weak, nonatomic) UILabel *lineLeftlbl;
@property (weak, nonatomic) UILabel *lineRightlbl;
@property (weak, nonatomic) UILabel *secondLineLeftlbl;
@property (weak, nonatomic) UILabel *secondLineRightlbl;
@property (weak, nonatomic) UILabel *promptlbl;
//第三方登录
@property (weak, nonatomic) ThirdLoginButton *weixinButton;            //微信
@property (weak, nonatomic) ThirdLoginButton *qqButton;                //qq
@property (weak, nonatomic) ThirdLoginButton *weiboButton;             //微博
//提示语句
@property (weak, nonatomic) UILabel *promptLabel;

//variables
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *password;
@property (assign, nonatomic) BOOL viewPoped;
@property (nonatomic,strong)UILabel * attention;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = I_BACKGROUND_COLOR;
    self.title = @"加入萌热";
//    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 20)];
//    topView.backgroundColor = UIColorFromRGB(0xf0821e);
//    [self.navigationController.navigationBar addSubview:topView];
    [self setBackNavgationItem];
    
    //添加view, 初始化界面控件
    [self createUI];

    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_login_cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelLoginAction)];
    self.navigationItem.rightBarButtonItem = self.backButton;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlankView)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tapGesture];
    
    [self.loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.forgetPwdButton addTarget:self action:@selector(forgetPwdAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.weixinButton addTarget:self action:@selector(loginByWeixin) forControlEvents:UIControlEventTouchUpInside];
    
    [self.qqButton addTarget:self action:@selector(loginByQQ) forControlEvents:UIControlEventTouchUpInside];
    
    [self.weiboButton addTarget:self action:@selector(loginByWeibo) forControlEvents:UIControlEventTouchUpInside];
    //TODO -- 测试代码
//    self.mobileTextField.text = @"18629530823";
//    self.passwordTextField.text = @"a51d3c19f7bfbada2cb54ab73281c164";
//    self.mobileTextField.text = @"18521508353";
//    self.passwordTextField.text = @"123456";
}

- (void)popBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    
    self.logoImageView.image = [UIImage imageNamed:@"login_pic_on_new"];
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.viewPoped = NO;
    
    AccountInfo *accountInfo = [[AccountInfoDao sharedInstance] getAccountInfo];
    NSString *mobile = (NSString *)accountInfo.username;
    NSString *password = @"";
    if(mobile != nil && ![mobile isEqualToString:@""]) {
        self.mobileTextField.text = mobile;
    } else {
         self.mobileTextField.text = @"";
    }
    
    if(password != nil && ![password isEqualToString:@""]) {
        self.passwordTextField.text = password;
    } else {
        self.passwordTextField.text = @"";
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(self.viewPoped) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
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
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField == self.mobileTextField) {
        if (SCREEN_HEIGHT <= 480) {
            self.logoImageView.image = [UIImage imageNamed:@"login_pic_on_new"];
        }else{
            self.logoImageView.image = [UIImage imageNamed:@"login_pic_on"];
            
        }
       
    } else if(textField == self.passwordTextField) {
         if (SCREEN_HEIGHT <= 480) {
        self.logoImageView.image = [UIImage imageNamed:@"login_pic_off"];
         }else{
             self.logoImageView.image = [UIImage imageNamed:@"login_pic_off_new"];
             
         }
    }
}

#pragma mark - Private Method
//点击输入框以外的空白处
- (void)tapBlankView {
    [self.mobileTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)cancelLoginAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

//登录按钮点击事件
- (void)loginAction {
    
    [self.mobileTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    NSString *mobile = self.mobileTextField.text;
    if([NSString isBlankString:mobile]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"用户手机号码不能为空!"];
        [self.view addSubview:attention];
        return;
    } else if(![RegexKit validateMobile:mobile]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"用户不存在！"];
        [self.view addSubview:attention];
        return;
    }
    NSString *password = self.passwordTextField.text;
    if([NSString isBlankString:password]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"密码不能为空！"];
        [self.view addSubview:attention];
        return;
    }
    //密码md5加密
    password = [MD5File md5:password];
    
//    NSString *verifyCode = @"123456";
    NSDictionary *params = @{
//                             @"captcha": verifyCode,
                             @"account" : mobile,
                             @"md5Password" : password
                             };
    [[AccountInfoDao sharedInstance] deleteAccountInfo];
    self.loginButton.enabled = NO;
    [[UserAPIRequest sharedInstance] userLogin:params success:^(LoginResultInfo *resultInfo) {
//        NSLog(@"resultInfo ========== %@",resultInfo);
        self.loginButton.enabled = YES;
        if(resultInfo) {
            [JPUSHService setTags:nil alias:resultInfo.token fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//                NSLog(@"设置别名成功");
            }];
            [Context sharedInstance].loginInfo = nil;
            [Context sharedInstance].loginInfo = resultInfo;
            [Context sharedInstance].username = mobile;
            [Context sharedInstance].password = password;
            [Context sharedInstance].token = resultInfo.token;
            [Context sharedInstance].isfreeze = resultInfo.isfreeze;
            [Context sharedInstance].thaw_date = resultInfo.thaw_date;
            [Context sharedInstance].thaw_time = resultInfo.thaw_time;
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",resultInfo.isfreeze] forKey:@"isfreeze"];
            [[NSUserDefaults standardUserDefaults] setObject:resultInfo.thaw_date forKey:@"thaw_date"];
            [[NSUserDefaults standardUserDefaults] setObject:resultInfo.thaw_time forKey:@"thaw_time"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            AccountInfo *accountInfo = [[AccountInfo alloc] init];
            accountInfo.username = mobile;
            accountInfo.password = password;
            [[AccountInfoDao sharedInstance] insertAccountInfo:accountInfo];
            [[LoginResultInfoDao sharedInstance] insertLoginResultInfo:resultInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshHomeTasks object:nil];
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"loadData" object:nil];
            }];
            [self loadUserInfo];
            [self performSelector:@selector(dismissLoginViewController) withObject:nil afterDelay:0.5f];
        } else {
//            NSLog(@"resultInfo ===== %@",resultInfo);
        }
    } failure:^(NSError *error) {
       
//        AttentionView * attention = [[AttentionView alloc]initTitle:[NSString stringWithFormat:@"%@",error.localizedDescription]];
        NSString * str = error.localizedDescription;
        
        UILabel * attention = [[UILabel alloc]init];
        
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-140, [UIScreen mainScreen].bounds.size.height/2-150, 280, 70);
        attention.numberOfLines = 0;
        attention.layer.masksToBounds = YES;
        attention.layer.cornerRadius = 10;
        attention.text = str;
        attention.textColor = [UIColor whiteColor];
        attention.textAlignment = NSTextAlignmentCenter;
        attention.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
        attention.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7];
        [self.attention removeFromSuperview];
        [self.view addSubview:attention];
        self.attention = attention;
        self.loginButton.enabled = YES;
        [Context sharedInstance].loginInfo = nil;
        [Context sharedInstance].username = nil;
        [Context sharedInstance].password = nil;
      
        [UIView animateKeyframesWithDuration:0 delay:1.2 options:(UIViewKeyframeAnimationOptionAllowUserInteraction) animations:^{
            self.attention.alpha = 0.1;
        } completion:^(BOOL finished) {
             _registerButton.enabled = YES;
            self.attention.hidden = YES;
            [self.attention removeFromSuperview];
        }];

//        //判断手机号是否存在与密码是否正确
//         [self checkAccountExist:mobile forAction:@"register"];
    }];
}
//判断手机号与密码
- (void)checkAccountExist:(NSString *)mobile forAction:(NSString *)action {
//    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeClear];
    [[UserAPIRequest sharedInstance] checkAccountExist:mobile success:^(AccountExistInfo *existInfo) {
//        [SVProgressHUD dismiss];
        if(existInfo != nil && [existInfo.isExist isEqualToString:@"true"]) {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"密码错误！"];
            [self.view addSubview:attention];
        } else {
            //用户手机号未注册
            if([action isEqualToString:@"register"]) {
                AttentionView * attention = [[AttentionView alloc]initTitle:@"用户不存在！"];
                [self.view addSubview:attention];
                
            } else {
               
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        AttentionView *attention = [[AttentionView alloc]initTitle:@"登录失败！"];
        [self.view addSubview:attention];
    }];
}

- (void)loadUserInfo {
    NSDictionary *params = @{};
    if(![Context sharedInstance].token) {
        [Context sharedInstance].userInfo = nil;
        return;
    }
    [[UserAPIRequest sharedInstance] getUserInfo:params success:^(UserInfo *userInfo) {
        [SVProgressHUD dismiss];
//        NSLog(@"userInfo1 ======== %@",userInfo);
        if(userInfo) {
            [[UserInfoDao sharedInstance] insertUserInfo:userInfo];
            [Context sharedInstance].userInfo = userInfo;
        } else {
            [Context sharedInstance].userInfo = nil;
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [Context sharedInstance].userInfo = nil;
//        NSLog(@"%@",error.localizedDescription);
    }];
}



- (void)dismissLoginViewController {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)loginByWeixin {
[self thirdLogin:SSDKPlatformTypeWechat];
}

- (void)loginByQQ {
    //NSLog(@"通过QQ登录");
    [self thirdLogin:SSDKPlatformSubTypeQZone];
}

- (void)loginByWeibo {
    [self thirdLogin:SSDKPlatformTypeSinaWeibo];
}
-(BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}
- (void)thirdLogin:(SSDKPlatformType)shareType {
  BOOL net =  [self connectedToNetwork];
    if (net == 0) {
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        return;
    }
if (shareType == SSDKPlatformTypeWechat) {
        [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeWechat onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {associateHandler (user.uid, user, user);
    [self reloadStateWithType:shareType userInfo:user];
}
    onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
//        NSLog(@"-----------%@",error.localizedDescription);
}];
    }else if (shareType == SSDKPlatformSubTypeQZone){
        [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeQQ
        onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
        associateHandler (user.uid, user, user);
              [self reloadStateWithType:shareType userInfo:user];
       
}
        onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
}];
        
    }else{
    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeSinaWeibo
    onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
            associateHandler (user.uid, user, user);
         [self reloadStateWithType:shareType userInfo:user];
                                       }
        onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                        
            }];
        
    }
}


-(void)reloadStateWithType:(SSDKPlatformType)type userInfo:(SSDKUser *)userInfo {
//    NSLog(@"userInfo ======= %@",userInfo);
    NSString *unionId = nil;
    if([userInfo uid]) {
        unionId = [userInfo uid];
    }
    NSString *nickname = @"尊敬的游客";
    if([userInfo nickname]) {
        nickname = [userInfo nickname];
    }
    NSString *gender = @"1";
    if([userInfo gender] == 0) {
        gender = @"2";
    } else {
        gender = @"1";
    }
    NSString *typeStr = @"";
    if(type == SSDKPlatformTypeWechat) {
        typeStr = @"3";
    } else if(type == SSDKPlatformSubTypeQZone) {
        typeStr = @"2";
    } else {
        typeStr = @"1";
    }
    
    NSString *avatar = @"null";
    if([userInfo icon]) {
        avatar = [userInfo icon];
    }
    NSString *deviceId = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSDictionary *params = @{@"deviceId" : deviceId,
                             @"uniqueId" : unionId,
                             @"nickName" : nickname,
                             @"gender": gender,
                             @"avatar": avatar,
                             @"type" : typeStr,
                             @"bloodType":@"",
                             @"signature":@""
                             };
//    NSLog(@"params ============== %@",params);
    [SVProgressHUD showWithStatus:@"正在使用第三方登录, 请稍等..." maskType:SVProgressHUDMaskTypeClear];
//    NSLog(@"params ================== %@",params);
    [[UserAPIRequest sharedInstance] thirdLogin:params success:^(LoginResultInfo *resultInfo) {
//        NSLog(@"resultInfo ======== %@",resultInfo);
        [SVProgressHUD dismiss];
         self.loginButton.enabled = YES;
        if(resultInfo) {
            [Context sharedInstance].loginInfo = nil;
            [Context sharedInstance].loginInfo = resultInfo;
            [Context sharedInstance].isfreeze = resultInfo.isfreeze;
            [Context sharedInstance].thaw_date = resultInfo.thaw_date;
            [Context sharedInstance].thaw_time = resultInfo.thaw_time;
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",resultInfo.isfreeze] forKey:@"isfreeze"];
             [[NSUserDefaults standardUserDefaults] setObject:resultInfo.thaw_date forKey:@"thaw_date"];
             [[NSUserDefaults standardUserDefaults] setObject:resultInfo.thaw_time forKey:@"thaw_time"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            AttentionView * attention = [[AttentionView alloc]initTitle:@"用户登录成功！" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        
            [Context sharedInstance].loginInfo = nil;
            [Context sharedInstance].loginInfo = resultInfo;
            [Context sharedInstance].username = nil;
            [Context sharedInstance].password = nil;
            AccountInfo *accountInfo = [[AccountInfo alloc] init];
            accountInfo.username = nil;
            accountInfo.password = nil;
            
            [[LoginResultInfoDao sharedInstance] insertLoginResultInfo:resultInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshHomeTasks object:nil];
//            [self dismissViewControllerAnimated:YES completion:^{
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"loadData" object:nil];
//            }];
           [self loadUserInfo];
            [self performSelector:@selector(dismissLoginViewController) withObject:nil afterDelay:1.0f];

           // _block();//更新铃铛图片
            
        }
    } failure:^(NSError *error) {
//        NSLog(@"localizedDescription ===== %@",error.localizedDescription) ;
        [Context sharedInstance].loginInfo = nil;
        [Context sharedInstance].username = nil;
        [Context sharedInstance].password = nil;
        [SVProgressHUD dismiss];
    }];
}

//快速注册按钮点击事件
- (void)registerAction {
    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

//忘记密码按钮点击事件
- (void)forgetPwdAction {
    ForgetPasswordViewController *forgetPwdViewController = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgetPwdViewController animated:YES];
}

//添加view
- (void)createUI {
    //logo图片
    [self.view addSubview:self.logoImageView];
    if (SCREEN_HEIGHT <= 480) {
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(TRANS_VALUE(14.0f));
            make.left.equalTo(self.view.mas_left).with.offset(([UIScreen mainScreen].bounds.size.width-TRANS_VALUE(268.0f))/2);
            make.size.mas_equalTo(CGSizeMake(TRANS_VALUE(268.0f), TRANS_VALUE(159.0f)));
        }];

    }else{
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(TRANS_VALUE(14.0f));
        make.left.equalTo(self.view.mas_left).with.offset(([UIScreen mainScreen].bounds.size.width-TRANS_VALUE(268.0f))/2);
        make.size.mas_equalTo(CGSizeMake(TRANS_VALUE(268.0f), TRANS_VALUE(189.0f)));
    }];}
    //手机号码输入框
    [self.view addSubview:self.mobileTextField];
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).with.offset(CONVER_VALUE(5.0f));
        make.left.equalTo(self.view.mas_left).with.offset(CONVER_VALUE(35.0f));
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(295.0f), CONVER_VALUE(41.0f)));
    }];
    //密码输入框
    [self.view addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mobileTextField.mas_bottom).with.offset(CONVER_VALUE(kPaddingWidth));
        make.left.mas_equalTo(self.mobileTextField.mas_left);
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(295.0f), CONVER_VALUE(41.0f)));
    }];
    self.mobileTextField.delegate = self;
    self.passwordTextField.delegate = self;
    //登录按钮
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).with.offset(CONVER_VALUE(kPaddingWidth));
        make.left.mas_equalTo(self.passwordTextField.mas_left);
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(295.0f), CONVER_VALUE(41.0f)));
    }];
    //立即注册
    [self.view addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).with.offset(CONVER_VALUE(5.0f));
        make.left.mas_equalTo(self.loginButton.mas_left);
    }];
    //忘记密码
    [self.view addSubview:self.forgetPwdButton];
    [self.forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).with.offset(CONVER_VALUE(5.0f));
        make.right.mas_equalTo(self.loginButton.mas_right);
    }];
    //提示文字
    [self.view addSubview:self.promptlbl];
    [self.promptlbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerButton.mas_bottom).with.offset(CONVER_VALUE(5.0f));
        make.centerX.mas_equalTo(self.loginButton.mas_centerX);
    }];
    //提示文字左边线
    [self.view addSubview:self.lineLeftlbl];
    [self.lineLeftlbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.promptlbl.mas_centerY);
        make.left.mas_equalTo(self.loginButton.mas_left);
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(90.0f), 1.0f));
    }];
    //提示文字右边线    
    [self.view addSubview:self.lineRightlbl];
    [self.lineRightlbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.promptlbl.mas_centerY);
        make.right.mas_equalTo(self.loginButton.mas_right);
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(90.0f), 1.0f));
    }];
    //提示文字左边白线
    [self.view addSubview:self.secondLineLeftlbl];
    [self.secondLineLeftlbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineLeftlbl.mas_bottom);
        make.left.mas_equalTo(self.loginButton.mas_left);
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(90.0f), 1.0f));
    }];
    //提示文字右边白线
    [self.view addSubview:self.secondLineRightlbl];
    [self.secondLineRightlbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineRightlbl.mas_bottom);
        make.right.mas_equalTo(self.loginButton.mas_right);
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(90.0f), 1.0f));
    }];

    //第三方登录微信
    [self.view addSubview:self.weixinButton];
    [self.weixinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptlbl.mas_bottom).with.offset(10.0f);
        make.left.mas_equalTo(self.loginButton.mas_left);
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(55.0f), CONVER_VALUE(55.0f)));
    }];
    //第三方登录微博
    [self.view addSubview:self.weiboButton];
    [self.weiboButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.weixinButton);
        make.right.mas_equalTo(self.loginButton.mas_right);
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(55.0f), CONVER_VALUE(55.0f)));
    }];
    //第三方登录qq
    [self.view addSubview:self.qqButton];
    [self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.weixinButton);
        make.centerX.mas_equalTo(self.loginButton.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(55.0f), CONVER_VALUE(55.0f)));
    }];
    
    //标签
    [self.view addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qqButton.mas_bottom).with.offset(CONVER_VALUE(35.0f));
        make.centerX.mas_equalTo(self.qqButton.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(320.0f), CONVER_VALUE(20.0f)));
    }];
    
//    self.lineLeftlbl.hidden = YES;
//    self.lineRightlbl.hidden = YES;
//    self.secondLineLeftlbl.hidden = YES;
//    self.secondLineRightlbl.hidden = YES;
//    self.promptlbl.hidden = YES;
//    //第三方登录
//    self.weixinButton.hidden = YES;
//    self.qqButton.hidden = YES;
//    self.weiboButton.hidden = YES;
}

#pragma mark getter && setter
- (UIImageView *)logoImageView
{
    if (_logoImageView == nil) {
        UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        tmpImgView.image = [UIImage imageNamed:@"login_pic_on_new"];
        [self.view addSubview:(_logoImageView = tmpImgView)];
    }
    return _logoImageView;
}

- (UITextField *)mobileTextField
{
    if (_mobileTextField == nil) {
        UITextField *tmpTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        tmpTextField.borderStyle  = UITextBorderStyleNone;
        tmpTextField.backgroundColor  = I_COLOR_EDITTEXT;
        tmpTextField.clipsToBounds = YES;
        tmpTextField.layer.borderColor = UIColorFromRGB(0xbebebe).CGColor;
        tmpTextField.layer.borderWidth = 1.0f;
        tmpTextField.layer.cornerRadius = CONVER_VALUE(41.0f) / 2;
        tmpTextField.textColor = I_COLOR_33BLACK;
        tmpTextField.font = [UIFont systemFontOfSize:15.0f];
        tmpTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        tmpTextField.keyboardType = UIKeyboardTypeNumberPad;
        tmpTextField.tintColor = TEXT_COLOR_GRAY;
        tmpTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xd2d2d2),NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
        UIView *mobileLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CONVER_VALUE(50.0f), CONVER_VALUE(41.0f))];
        [mobileLeftView addSubview:self.mobileImageView];
        tmpTextField.leftView = mobileLeftView;
        tmpTextField.leftViewMode = UITextFieldViewModeAlways;
        
        [self.view addSubview:(_mobileTextField = tmpTextField)];
    }
    return _mobileTextField;
}

- (UIImageView *)mobileImageView
{
    if (_mobileImageView == nil) {
        UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CONVER_VALUE(20.0f), CONVER_VALUE(8.0f), CONVER_VALUE(24.0f), CONVER_VALUE(24.0f))];
        tmpImgView.image = [UIImage imageNamed:@"ic_login_userNew"];
        tmpImgView.contentMode = UIViewContentModeScaleAspectFit;
        tmpImgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:(_mobileImageView = tmpImgView)];
    }
    return _mobileImageView;
}

- (UITextField *)passwordTextField
{
    if (_passwordTextField == nil) {
        UITextField *tmpTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        tmpTextField.borderStyle = UITextBorderStyleNone;
        tmpTextField.backgroundColor  = I_COLOR_EDITTEXT;
        tmpTextField.clipsToBounds = YES;
        tmpTextField.layer.borderColor = UIColorFromRGB(0xbebebe).CGColor;
        tmpTextField.layer.borderWidth = 1.0f;
        tmpTextField.layer.cornerRadius = CONVER_VALUE(41.0f) / 2;
        tmpTextField.textColor = I_COLOR_33BLACK;
        tmpTextField.font = [UIFont systemFontOfSize:15.0f];
        tmpTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xd2d2d2),NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
        tmpTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        tmpTextField.tintColor = TEXT_COLOR_GRAY;
        [tmpTextField setSecureTextEntry:YES];
        UIView *passwordLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CONVER_VALUE(50.0f), CONVER_VALUE(41.0f))];
        [passwordLeftView addSubview:self.passwordImageView];
        tmpTextField.leftView = passwordLeftView;
        tmpTextField.leftViewMode = UITextFieldViewModeAlways;
        [self.view addSubview:(_passwordTextField = tmpTextField)];
    }
    return _passwordTextField;
}

- (UIImageView *)passwordImageView
{
    if (_passwordImageView == nil) {
        UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CONVER_VALUE(20.0f), CONVER_VALUE(8.0f), CONVER_VALUE(24.0f), CONVER_VALUE(24.0f))];
        tmpImgView.image = [UIImage imageNamed:@"ic_login_pwdNew"];
        tmpImgView.contentMode = UIViewContentModeScaleAspectFit;
        tmpImgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:(_passwordImageView = tmpImgView)];
    }
    return _passwordImageView;
}

- (UIButton *)loginButton
{
    if (_loginButton == nil) {
        UIButton *tmpBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        tmpBtn.backgroundColor = UIColorFromRGB(0xf0821e);
        tmpBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.5f];
        [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tmpBtn setTitle:@"加入萌热" forState:UIControlStateNormal];
        tmpBtn.layer.cornerRadius = CONVER_VALUE(41.0f) / 2;
        tmpBtn.clipsToBounds = YES;
        [self.view addSubview:(_loginButton = tmpBtn)];
    }
    return _loginButton;
}

- (UIButton *)registerButton
{
    if (_registerButton == nil) {
        UIButton *tmpBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        tmpBtn.backgroundColor = [UIColor clearColor];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0f]};
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"还没有账号?立即注册" attributes:attributes];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x646464) range:NSMakeRange(0, 6)];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xf0821e) range:NSMakeRange(6, 4)];
        [tmpBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
        [self.view addSubview:(_registerButton = tmpBtn)];
    }
    return _registerButton;
}

- (UIButton *)forgetPwdButton
{
    if (_forgetPwdButton == nil) {
        UIButton *tmpBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        tmpBtn.backgroundColor = [UIColor clearColor];
        tmpBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [tmpBtn setTitleColor:UIColorFromRGB(0x646464) forState:UIControlStateNormal];
        [tmpBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [self.view addSubview:(_forgetPwdButton = tmpBtn)];
    }
    return _forgetPwdButton;
}

- (UILabel *)promptlbl
{
    if (_promptlbl == nil) {
        UILabel *tmplbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tmplbl.backgroundColor = [UIColor clearColor];
        tmplbl.font = [UIFont  systemFontOfSize:15.0f];
        tmplbl.text = @"使用关联登录";
//        tmplbl.textColor = UIColorFromRGB(0x828282);
        tmplbl.textColor =[UIColor grayColor];
        [self.view addSubview:(_promptlbl = tmplbl)];
    }
    return _promptlbl;
}

- (UILabel *)lineLeftlbl
{
    if (_lineLeftlbl == nil) {
        UILabel *tmplbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tmplbl.backgroundColor = UIColorFromRGB(0xbebebe);
        [self.view addSubview:(_lineLeftlbl = tmplbl)];
    }
    return _lineLeftlbl;
}

- (UILabel *)lineRightlbl
{
    if (_lineRightlbl == nil) {
        UILabel *tmplbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tmplbl.backgroundColor = UIColorFromRGB(0xbebebe);
        [self.view addSubview:(_lineRightlbl = tmplbl)];
    }
    return _lineRightlbl;
}

- (UILabel *)secondLineLeftlbl
{
    if (_secondLineLeftlbl == nil) {
        UILabel *tmplbl = [[UILabel alloc] initWithFrame:CGRectZero];
//        tmplbl.backgroundColor = UIColorFromRGB(0xbebebe);
        tmplbl.backgroundColor =[UIColor whiteColor];
        [self.view addSubview:(_secondLineLeftlbl = tmplbl)];
    }
    return _secondLineLeftlbl;
}

- (UILabel *)secondLineRightlbl
{
    if (_secondLineRightlbl == nil) {
        UILabel *tmplbl = [[UILabel alloc] initWithFrame:CGRectZero];
//        tmplbl.backgroundColor = UIColorFromRGB(0xbebebe);
        tmplbl.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:(_secondLineRightlbl = tmplbl)];
    }
    return _secondLineRightlbl;
}

- (ThirdLoginButton *)weixinButton
{
    if (_weixinButton == nil) {
        ThirdLoginButton *tmpBtn = [[ThirdLoginButton alloc] initWithFrame:CGRectZero];
        [tmpBtn setTitle:@"微信"];
//        tmpBtn.titleLabel.textColor=[UIColor grayColor];
        [tmpBtn setImage:@"ic_login_weixinNew"];
        [self.view addSubview:(_weixinButton = tmpBtn)];
    }
    return _weixinButton;
}

- (ThirdLoginButton *)qqButton
{
    if (_qqButton == nil) {
        ThirdLoginButton *tmpBtn = [[ThirdLoginButton alloc] initWithFrame:CGRectZero];
        [tmpBtn setTitle:@"QQ"];
        [tmpBtn setImage:@"ic_login_qqNew"];
        [self.view addSubview:(_qqButton = tmpBtn)];
    }
    return _qqButton;
}

- (ThirdLoginButton *)weiboButton {
    if (_weiboButton == nil) {
        ThirdLoginButton *tmpBtn = [[ThirdLoginButton alloc] initWithFrame:CGRectZero];
        [tmpBtn setTitle:@"新浪微博"];
        [tmpBtn setImage:@"ic_login_sinaNew"];
        [self.view addSubview:(_weiboButton = tmpBtn)];
    }
    return _weiboButton;
}

- (UILabel *)promptLabel {
    if(_promptLabel == nil) {
        UILabel *tmplbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tmplbl.backgroundColor = [UIColor clearColor];
        tmplbl.font = [UIFont systemFontOfSize:14.0f];
        tmplbl.textAlignment = NSTextAlignmentCenter;
       // tmplbl.text = @"成为熊宝,解锁更多姿势(ง •̀_•́)ง";
        tmplbl.textColor = I_COLOR_33BLACK;
        [self.view addSubview:(_promptLabel = tmplbl)];
    }
    return _promptLabel;
}



@end
