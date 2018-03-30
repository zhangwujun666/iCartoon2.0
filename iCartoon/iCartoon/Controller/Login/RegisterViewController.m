//
//  RegisterViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/9/3.
//  Copyright (c) 2015年 xuchengxiong. All rights reserved.
//

#import "RegisterViewController.h"
#import "AgreementViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "NSString+Utils.h"
#import "RegexKit.h"
#import "MD5File.h"
#import "VerifyButton.h"

#import "UserAPIRequest.h"
#import "LoginSucAttentionView.h"
#import "AppDelegate.h"
#import "Context.h"
#import "AccountInfoDao.h"
#import "LoginResultInfoDao.h"
#import "UserInfoDao.h"
#import "HomeViewController.h"
#import "AttentionView.h"
//@interface RegisterViewController ()<LoginSucAttentionViewDelegate>
@interface RegisterViewController ()
@property (weak, nonatomic) UITextField *mobileTextField;
@property (weak, nonatomic) UITextField *passwordTextField;
@property (weak, nonatomic) UITextField *retryPasswordTextField;
@property (weak, nonatomic) UITextField *verifyCodeTextField;
@property (weak, nonatomic) VerifyButton *verifyCodeButton;
@property (strong, nonatomic) UIButton *registerButton;
@property (strong, nonatomic) UIButton *agreementBtn;
@property (strong, nonatomic) UIButton *agreementBtn1;
//@property (weak, nonatomic) LoginSucAttentionView *attentionView;//登录成功关注
//用户协议
//@property (strong, nonatomic) UIImageView *checkImageView;

@property (assign, nonatomic) CGRect checkRect;
@property (assign, nonatomic) CGRect agreementRect;
@property (assign, nonatomic) BOOL hasRead;
@property (strong, nonatomic) UIAlertView *alertView;

@property (strong, nonatomic) NSString *usernameValue;
@property (strong, nonatomic) NSString *passwordValue;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = I_BACKGROUND_COLOR;
    self.navigationItem.title = @"成为熊宝";
    [self setBackNavgationItem];
    //添加view, 初始化界面控件
    [self createUI];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlankView)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tapGesture];
    
    [self.registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.verifyCodeButton addTarget:self action:@selector(verifyCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.agreementBtn addTarget:self action:@selector(agreementAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.agreementBtn1 addTarget:self action:@selector(ChangeState) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(self.alertView) {
        [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
        self.alertView = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//#pragma mark LoginSucAttentionViewDelegate
//- (void)attentItemsArr:(NSArray *)itemsArr {
//    NSLog(@"%@",itemsArr);
//    if(![Context sharedInstance].token) {
//        [Context sharedInstance].userInfo = nil;
//        return;
//    }
//    
//    NSMutableArray *themeIds = [NSMutableArray arrayWithCapacity:0];
//    for(int i = 0, n = (int)itemsArr.count; i < n; i++) {
//        ThemeInfo *themeInfo = (ThemeInfo *)[itemsArr objectAtIndex:i];
//        [themeIds addObject:themeInfo.tid];
//    }
//    NSDictionary *params = @{@"token" : [Context sharedInstance].token, @"type" : @"1", @"themeIds": themeIds};
//    [[UserAPIRequest sharedInstance] followThemes:params success:^(CommonInfo *result) {
//        [SVProgressHUD dismiss];
//        if([result isSuccess]) {
//            ///关注成功后跳转
//            [self.attentionView hidden];
//            [[AppDelegate sharedDelegate] showMainViewControllerWithoutLogin];
//        } else {
//        }
//    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//    }];
//    
//}

//用户登录
- (void)loginWithUsername:(NSString *)username andMD5Password:(NSString *)password {
    NSString *verifyCode = @"123456";
    NSDictionary *params = @{
                             @"captcha": verifyCode,
                             @"account" : username,
                             @"md5Password" : password
                             };
    [[AccountInfoDao sharedInstance] deleteAccountInfo];
    [SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeClear];
    [[UserAPIRequest sharedInstance] userLogin:params success:^(LoginResultInfo *resultInfo) {
        [SVProgressHUD dismiss];
        if(resultInfo) {
            [Context sharedInstance].loginInfo = nil;
            [Context sharedInstance].loginInfo = resultInfo;
            [Context sharedInstance].username = username;
            [Context sharedInstance].password = password;
            AccountInfo *accountInfo = [[AccountInfo alloc] init];
            accountInfo.username = username;
            accountInfo.password = password;
            [[AccountInfoDao sharedInstance] insertAccountInfo:accountInfo];
            [[LoginResultInfoDao sharedInstance] insertLoginResultInfo:resultInfo];
            [self loadUserInfo];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [Context sharedInstance].loginInfo = nil;
        [Context sharedInstance].username = nil;
        [Context sharedInstance].password = nil;
//        [TSMessage showNotificationWithTitle:[error localizedDescription] subtitle:nil type:TSMessageNotificationTypeError];
//        AttentionView *attention = [[AttentionView alloc]initTitle:[error localizedDescription]];
//        [self.view addSubview:attention];
    }];
}

//加载用户信息
- (void)loadUserInfo {
    NSDictionary *params = @{};
    if(![Context sharedInstance].token) {
        [Context sharedInstance].userInfo = nil;
        return;
    }
    [[UserAPIRequest sharedInstance] getUserInfo:params success:^(UserInfo *userInfo) {
        [SVProgressHUD dismiss];
        if(userInfo) {
            [[UserInfoDao sharedInstance] insertUserInfo:userInfo];
            [Context sharedInstance].userInfo = userInfo;
        } else {
            [Context sharedInstance].userInfo = nil;
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [Context sharedInstance].userInfo = nil;
    }];
}

#pragma mark - Private Method
//点击输入框以外的空白处
- (void)tapBlankView {
    [self.view endEditing:YES];
}

//注册按钮点击事件
- (void)registerAction {
//    NSString *username = @"18521508353";
//    NSString *password = @"123456";
//    password = [MD5File md5:password];
//    [self loginWithUsername:username andMD5Password:password];
//    [self showAttentionView];
//    return;
    
//    HomeViewController * home = [[HomeViewController alloc]init];
//    [self.navigationController presentViewController:home animated:YES completion:^{
//        //显示关注界面
//        [self showAttentionView];
//    }];
    
    if (_agreementBtn1.selected ==NO) {
        return;
    }
    
    NSString *mobile = self.mobileTextField.text;
    if([NSString isBlankString:mobile]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"用户手机号码不能为空！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    } else if(![RegexKit validateMobile:mobile]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"请输入正确的手机号码！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }
    
    //检测用户是否已注册
    [self checkAccountExist:mobile forAction:@"register"];
}

//检查手机号是否已经注册
- (void)checkAccountExist:(NSString *)mobile forAction:(NSString *)action {
    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeClear];
    [[UserAPIRequest sharedInstance] checkAccountExist:mobile success:^(AccountExistInfo *existInfo) {
        [SVProgressHUD dismiss];
        if(existInfo != nil && [existInfo.isExist isEqualToString:@"true"]) {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"该用户已存在" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        } else {
            //用户手机号未注册
            if([action isEqualToString:@"register"]) {
                [self userRegister];
            } else {
                [self sendVerifyCode];
            }
        }
    } failure:^(NSError *error) {

    }];
}

//用户注册
- (void)userRegister {
    
 
    
    NSString *mobile = self.mobileTextField.text;
    NSString *password = self.passwordTextField.text;
    if([NSString isBlankString:password]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"密码不能为空！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }
    NSString *retryPassword = self.retryPasswordTextField.text;
    if([NSString isBlankString:retryPassword]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"请再次输入密码！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    } else if(![retryPassword isEqualToString:password]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"两次输入的密码不一致，请重新输入！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }
    if (retryPassword.length<6||retryPassword.length>18) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"请输入6-18位密码！"];
        [self.view addSubview:attention];
        return;
    }
    NSString *verifyCode = self.verifyCodeTextField.text;
    if([NSString isBlankString:verifyCode]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"验证码不能为空！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }
    
    
    //密码md5加密
    password = [MD5File md5:password];
    NSString *deviceId = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    NSDictionary *params = @{
                             @"captcha" : verifyCode,
                             @"account" : mobile,
                             @"md5Password": password,
                             @"deviceId" : deviceId
                             };
    
    [SVProgressHUD showWithStatus:@"正在注册用户, 请稍等..." maskType:SVProgressHUDMaskTypeClear];
    [[UserAPIRequest sharedInstance] userRegister:params success:^(CommonInfo *commonInfo) {
        [SVProgressHUD dismiss];
        if([commonInfo isSuccess]) {
            self.usernameValue = mobile;
            self.passwordValue = password;

            //用户登录
            [self loginWithUsername:self.usernameValue andMD5Password:self.passwordValue];
            [self performSelector:@selector(gotoMainViewController) withObject:nil afterDelay:0.3f];
        } else {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"没有成为熊宝, 请稍后再试" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        AttentionView * attention = [[AttentionView alloc]initTitle:@"验证码错误"];
        [self.view addSubview:attention];
    }];
    
}

- (void)gotoMainViewController {
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[AppDelegate sharedDelegate] showMainViewControllerWithoutLogin];
}
//发送手机验证码
- (void)sendVerifyCode {
    NSString *mobile = self.mobileTextField.text;
    [self.verifyCodeButton start];
//    [SVProgressHUD showWithStatus:@"正在获取验证码，请稍等..." maskType:SVProgressHUDMaskTypeClear];
    [[UserAPIRequest sharedInstance] sendSMSCodeWithMobile:mobile success:^(CommonInfo *commonInfo) {
        [SVProgressHUD dismiss];
        if(commonInfo) {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"验证码已发送，请查看手机短信！" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        } else {
//            [TSMessage showNotificationInViewController:self.navigationController title:@"获取验证码失败, 请稍后再试..." subtitle:nil type:TSMessageNotificationTypeError];
            AttentionView * attention = [[AttentionView alloc]initTitle:@"获取验证码失败，请稍后再试！" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
//        [TSMessage showNotificationInViewController:self.navigationController title:[error localizedDescription] subtitle:nil type:TSMessageNotificationTypeError];
        AttentionView * attention = [[AttentionView alloc]initTitle:@"验证码错误"];
        [self.view addSubview:attention];
        
        
    }];
}

//获取验证码按钮点击事件
- (void)verifyCodeAction {
    NSString *mobile = self.mobileTextField.text;
    if([NSString isBlankString:mobile]) {
//        [TSMessage showNotificationInViewController:self.navigationController title:@"用户手机号码不能为空" subtitle:nil type:TSMessageNotificationTypeWarning];
        AttentionView * attention = [[AttentionView alloc]initTitle:@"用户手机号码不能为空！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    } else if(![RegexKit validateMobile:mobile]) {
//        [TSMessage showNotificationInViewController:self.navigationController title:@"请输入正确的手机号码" subtitle:nil type:TSMessageNotificationTypeWarning];
        AttentionView * attention = [[AttentionView alloc]initTitle:@"请输入正确的手机号码！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }
    [self checkAccountExist:mobile forAction:@"sendVerifyCode"];
    
    
}

//check按钮点击事件
- (void)tapCheckView:(id)sender {
    UIImageView *checkImageView = (UIImageView *)((UITapGestureRecognizer *)sender).view;
    if(!self.hasRead) {
        checkImageView.image = [UIImage imageNamed:@"ic_check_on"];
    } else {
        checkImageView.image = [UIImage imageNamed:@"ic_check_off"];
    }
    self.hasRead = !self.hasRead;

}

//用户协议点击事件
- (void)agreementAction {
    AgreementViewController *agreementViewController = [[AgreementViewController alloc] init];
    [self.navigationController pushViewController:agreementViewController animated:YES];
}

- (void)createUI {
//    
//    CGFloat textFieldWidth = SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f);
//    CGFloat textFieldHeight = TRANS_VALUE(42.0f);
//    //手机号码
//    
//    self.mobileTextField = [[UITextField alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(32.0f), TRANS_VALUE(165.0f), textFieldHeight)];
//    self.mobileTextField.borderStyle = UITextBorderStyleNone;
//    self.mobileTextField.clipsToBounds = YES;
//    self.mobileTextField.layer.borderColor = RGBCOLOR(212, 212, 212).CGColor;
//    self.mobileTextField.layer.borderWidth = 1.0f;
//    self.mobileTextField.layer.cornerRadius = TRANS_VALUE(40.0f) / 2;
//    self.mobileTextField.textColor = I_COLOR_BLACK;
//    self.mobileTextField.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(14.0f)];
//    UIImageView *mobileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(16.0f), TRANS_VALUE(7.0f), TRANS_VALUE(18.0f), TRANS_VALUE(18.0f))];
//    mobileImageView.image = [UIImage imageNamed:@"ic_login_mobile"];
//    mobileImageView.contentMode = UIViewContentModeScaleAspectFit;
//    mobileImageView.backgroundColor = [UIColor clearColor];
//    UIView *mobileLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), TRANS_VALUE(32.0f))];
//    [mobileLeftView addSubview:mobileImageView];
//    self.mobileTextField.leftView = mobileLeftView;
//    self.mobileTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.mobileTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName: TEXT_COLOR_GRAY}];
//    self.mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.mobileTextField.tintColor = TEXT_COLOR_GRAY;
//    [self.view addSubview:self.mobileTextField];
//    
//    //验证码按钮
//    CGFloat verifyCodeButtonMarginTop = TRANS_VALUE(32.0f);
//    CGFloat verifyCodeButtonMarginLeft = TRANS_VALUE(197.0f);
//    CGFloat verifyCodeButtonWidth = TRANS_VALUE(112.0f);
//    CGFloat verifyCodeButtonHeight = textFieldHeight;
//    self.verifyCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(verifyCodeButtonMarginLeft, verifyCodeButtonMarginTop, verifyCodeButtonWidth, verifyCodeButtonHeight)];
//    self.verifyCodeButton.backgroundColor = RGBCOLOR(237, 237, 237);
//    self.verifyCodeButton.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(15.0f)];
//    [self.verifyCodeButton setTitleColor:I_COLOR_GRAY forState:UIControlStateNormal];
//    [self.verifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
//    self.verifyCodeButton.layer.cornerRadius = TRANS_VALUE(40.0f) / 2;
//    self.verifyCodeButton.clipsToBounds = YES;
//    [self.view addSubview:self.verifyCodeButton];
//    
//    self.verifyCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(91.0f), textFieldWidth, textFieldHeight)];
//    self.verifyCodeTextField.borderStyle = UITextBorderStyleNone;
//    self.verifyCodeTextField.borderStyle = UITextBorderStyleNone;
//    self.verifyCodeTextField.clipsToBounds = YES;
//    self.verifyCodeTextField.layer.borderColor = RGBCOLOR(212, 212, 212).CGColor;
//    self.verifyCodeTextField.layer.borderWidth = 1.0f;
//    self.verifyCodeTextField.layer.cornerRadius = TRANS_VALUE(40.0f) / 2;
//    self.verifyCodeTextField.textColor = I_COLOR_BLACK;
//    self.verifyCodeTextField.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(14.0f)];
//    UIImageView *verifyCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(16.0f), TRANS_VALUE(7.0f), TRANS_VALUE(18.0f), TRANS_VALUE(18.0f))];
//    verifyCodeImageView.image = [UIImage imageNamed:@"ic_login_mobile"];
//    verifyCodeImageView.contentMode = UIViewContentModeScaleAspectFit;
//    verifyCodeImageView.backgroundColor = [UIColor clearColor];
//    UIView *verifyCodeLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), TRANS_VALUE(32.0f))];
//    [verifyCodeLeftView addSubview:verifyCodeImageView];
//    UIImageView *smsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(24.0f), TRANS_VALUE(14.0f), TRANS_VALUE(9.0f), TRANS_VALUE(9.0f))];
//    smsImageView.image = [UIImage imageNamed:@"ic_login_verifycode"];
//    smsImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [verifyCodeLeftView addSubview:smsImageView];
//    self.verifyCodeTextField.leftView = verifyCodeLeftView;
//    self.verifyCodeTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.verifyCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: TEXT_COLOR_GRAY}];
//    self.verifyCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.verifyCodeTextField.tintColor = TEXT_COLOR_GRAY;
//    [self.view addSubview:self.verifyCodeTextField];
//    
//    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(150.0f), textFieldWidth, textFieldHeight)];
//    self.passwordTextField.borderStyle = UITextBorderStyleNone;
//    self.passwordTextField.clipsToBounds = YES;
//    self.passwordTextField.layer.borderColor = RGBCOLOR(212, 212, 212).CGColor;
//    self.passwordTextField.layer.borderWidth = 1.0f;
//    self.passwordTextField.layer.cornerRadius = TRANS_VALUE(40.0f) / 2;
//    self.passwordTextField.textColor = I_COLOR_BLACK;
//    self.passwordTextField.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(14.0f)];
//    UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(16.0f), TRANS_VALUE(7.0f), TRANS_VALUE(18.0f), TRANS_VALUE(18.0f))];
//    passwordImageView.image = [UIImage imageNamed:@"ic_login_password_2"];
//    passwordImageView.contentMode = UIViewContentModeScaleAspectFit;
//    passwordImageView.backgroundColor = [UIColor clearColor];
//    UIView *passwordLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), TRANS_VALUE(32.0f))];
//    [passwordLeftView addSubview:passwordImageView];
//    self.passwordTextField.leftView = passwordLeftView;
//    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入6-18位密码" attributes:@{NSForegroundColorAttributeName: TEXT_COLOR_GRAY}];
//    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.passwordTextField.tintColor = TEXT_COLOR_GRAY;
//    [self.passwordTextField setSecureTextEntry:YES];
//    [self.view addSubview:self.passwordTextField];
//    
//    self.retryPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(205.0f), textFieldWidth, textFieldHeight)];
//    self.retryPasswordTextField.borderStyle = UITextBorderStyleNone;
//    self.retryPasswordTextField.borderStyle = UITextBorderStyleNone;
//    self.retryPasswordTextField.clipsToBounds = YES;
//    self.retryPasswordTextField.layer.borderColor = RGBCOLOR(212, 212, 212).CGColor;
//    self.retryPasswordTextField.layer.borderWidth = 1.0f;
//    self.retryPasswordTextField.layer.cornerRadius = TRANS_VALUE(40.0f) / 2;
//    self.retryPasswordTextField.textColor = I_COLOR_BLACK;
//    self.retryPasswordTextField.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(14.0f)];
//    UIImageView *retryPasswordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(16.0f), TRANS_VALUE(7.0f), TRANS_VALUE(18.0f), TRANS_VALUE(18.0f))];
//    retryPasswordImageView.image = [UIImage imageNamed:@"ic_login_password_2"];
//    retryPasswordImageView.contentMode = UIViewContentModeScaleAspectFit;
//    retryPasswordImageView.backgroundColor = [UIColor clearColor];
//    UIView *retryPasswordLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), TRANS_VALUE(32.0f))];
//    [retryPasswordLeftView addSubview:retryPasswordImageView];
//    self.retryPasswordTextField.leftView = retryPasswordLeftView;
//    self.retryPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.retryPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再输入一次密码" attributes:@{NSForegroundColorAttributeName: TEXT_COLOR_GRAY}];
//    self.retryPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.retryPasswordTextField.tintColor = TEXT_COLOR_GRAY;
//    [self.retryPasswordTextField setSecureTextEntry:YES];
//    [self.view addSubview:self.retryPasswordTextField];
//    
//    
//    //注册按钮
//    CGFloat registerButtonMarginTop = TRANS_VALUE(285.0f);
//    CGFloat registerButtonWidth = SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f);
//    CGFloat registerButtonHeight = TRANS_VALUE(40.0f);
//    self.registerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, registerButtonMarginTop, registerButtonWidth, registerButtonHeight)];
//    CGPoint registerButtonCenter = self.registerButton.center;
//    registerButtonCenter.x = CGRectGetMidX(self.view.frame);
//    self.registerButton.center = registerButtonCenter;
//    self.registerButton.backgroundColor = I_COLOR_YELLOW;
//    self.registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(17.0f)];
//    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
//    self.registerButton.layer.cornerRadius = TRANS_VALUE(38.0f) / 2;
//    self.registerButton.clipsToBounds = YES;
//    [self.view addSubview:self.registerButton];
//    
//    CGFloat agreementLabelMarginLeft = (SCREEN_WIDTH - TRANS_VALUE(200.0f))/2;
//    CGFloat agreementLabelMarginTop = TRANS_VALUE(400.0f);
//    CGFloat agreementLabelWidth = TRANS_VALUE(200.0f);
//    CGFloat agreementLabelHeight = TRANS_VALUE(40.0f);
//    self.agreementLabel = [[UILabel alloc] initWithFrame:CGRectMake(agreementLabelMarginLeft, agreementLabelMarginTop, agreementLabelWidth, agreementLabelHeight)];
//    self.agreementLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(14.0f)];
//    self.agreementLabel.textColor = I_COLOR_GRAY;
//    self.agreementLabel.textAlignment = NSTextAlignmentCenter;
//    self.agreementLabel.text = @"用户协议 >>";
//    [self.view addSubview:self.agreementLabel];
    //手机号输入框
    [self.view addSubview:self.mobileTextField];
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(CONVER_VALUE(20.0f));
        make.left.equalTo(self.view.mas_left).with.offset(CONVER_VALUE(10.0f));
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(354.0f), CONVER_VALUE(41.0f)));
    }];
    //获取验证码按钮
    [self.view addSubview:self.verifyCodeButton];
    [self.verifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.verifyCodeTextField.mas_top);
        make.left.equalTo(self.verifyCodeTextField.mas_right).with.offset(CONVER_VALUE(8.0f));
        
//           self.verifyCodeButton.backgroundColor = RGBCOLOR(237, 237, 237);
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(126.0f), CONVER_VALUE(41.0f)));
    }];
    //验证码输入框
    [self.view addSubview:self.verifyCodeTextField];
    [self.verifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mobileTextField.mas_bottom).with.offset(CONVER_VALUE(20.0f));
        make.left.mas_equalTo(self.mobileTextField.mas_left);
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(220.0f), CONVER_VALUE(41.0f)));
    }];
    //录入密码框
    [self.view addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifyCodeTextField.mas_bottom).with.offset(CONVER_VALUE(20.0f));
        make.left.mas_equalTo(self.verifyCodeTextField.mas_left);
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(354.0f), CONVER_VALUE(41.0f)));
    }];
    //再次录入密码框
    [self.view addSubview:self.retryPasswordTextField];
    [self.retryPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).with.offset(CONVER_VALUE(20.0f));
        make.left.mas_equalTo(self.passwordTextField.mas_left);
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(354.0f), CONVER_VALUE(41.0f)));
    }];
    //注册按钮
    _registerButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _registerButton.backgroundColor =I_COLOR_YELLOW;;
    _registerButton.selected =YES;
    _registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.5f];
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerButton setTitle:@"成为熊宝" forState:UIControlStateNormal];
    _registerButton.layer.cornerRadius = CONVER_VALUE(41.0f) / 2;
    _registerButton.clipsToBounds = YES;
    
    [self.view addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.retryPasswordTextField.mas_bottom).with.offset(CONVER_VALUE(20.0f));
        make.left.mas_equalTo(self.retryPasswordTextField.mas_left);
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(354.0f), CONVER_VALUE(41.0f)));
    }];
    //查看用户协议
    
    _agreementBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    _agreementBtn.backgroundColor = [UIColor clearColor];
    _agreementBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_agreementBtn setTitleColor:UIColorFromRGB(0xf0821e) forState:UIControlStateNormal];
    [_agreementBtn setTitle:@"用户协议" forState:UIControlStateNormal];
    _agreementBtn.imageView.frame = CGRectMake(0, 0, 1.0f, 1.0f);
    [_agreementBtn setImage:[UIImage imageNamed:@"Transparent_format"] forState:UIControlStateNormal];//加一张透明的图片  和前面的BUTTON 格式一样
    
    [self.view addSubview:self.agreementBtn];
    [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerButton.mas_bottom).with.offset(CONVER_VALUE(20.0f));
        make.centerX.mas_equalTo(self.registerButton.mas_centerX).with.offset(CONVER_VALUE(60.0f));
    }];

    
    _agreementBtn1 = [[UIButton alloc] initWithFrame:CGRectZero];
    _agreementBtn1.backgroundColor = [UIColor clearColor];
    _agreementBtn1.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_agreementBtn1 setTitleColor:UIColorFromRGB(0x646464) forState:UIControlStateSelected];
    [_agreementBtn1 setTitle:@"我已阅读并同意" forState:UIControlStateNormal];
    
    [_agreementBtn1 setImage:[UIImage imageNamed:@"ic_message_on"] forState:UIControlStateSelected];
    _agreementBtn1.selected =YES;
    [self.view addSubview:self.agreementBtn1];
    [self.agreementBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerButton.mas_bottom).with.offset(CONVER_VALUE(20.0f));
        make.centerX.mas_equalTo(self.registerButton.mas_centerX).with.offset(CONVER_VALUE(-45.0f));
//        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(150.0f), CONVER_VALUE(17.0f)));
    }];
    
}

#pragma mark getter && setter

- (UITextField *)mobileTextField
{
    if (!_mobileTextField) {
        UITextField *tmpTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        tmpTextField.borderStyle = UITextBorderStyleNone;
        tmpTextField.backgroundColor  = I_COLOR_EDITTEXT;
        tmpTextField.clipsToBounds = YES;
        tmpTextField.layer.borderColor = UIColorFromRGB(0xbebebe).CGColor;
        tmpTextField.layer.borderWidth = 1.0f;
        tmpTextField.layer.cornerRadius = CONVER_VALUE(41.0f) / 2;
        tmpTextField.textColor = I_COLOR_33BLACK;
        tmpTextField.font = [UIFont systemFontOfSize:14.0f];
        tmpTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xd2d2d2),NSFontAttributeName: [UIFont systemFontOfSize:14.0]}];
        tmpTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        tmpTextField.tintColor = TEXT_COLOR_GRAY;
        tmpTextField.keyboardType = UIKeyboardTypeNumberPad;
        UIImageView *mobileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CONVER_VALUE(20.0f), CONVER_VALUE(8.0f), CONVER_VALUE(24.0f), CONVER_VALUE(24.0f))];
        mobileImageView.image = [UIImage imageNamed:@"ic_login_mobileNew"];
        mobileImageView.contentMode = UIViewContentModeScaleAspectFit;
        mobileImageView.backgroundColor = [UIColor clearColor];
        UIView *mobileLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CONVER_VALUE(50.0f), CONVER_VALUE(41.0f))];
        [mobileLeftView addSubview:mobileImageView];
        tmpTextField.leftView = mobileLeftView;
        tmpTextField.leftViewMode = UITextFieldViewModeAlways;
        [self.view addSubview:(_mobileTextField = tmpTextField)];
    }
    return _mobileTextField;
}

- (UIButton *)verifyCodeButton {
    if (!_verifyCodeButton) {
        VerifyButton *tmpBtn = [[VerifyButton alloc] initWithFrame:CGRectZero withTitle:@"获取验证码"];
        [self.view addSubview:(_verifyCodeButton = tmpBtn)];
    }
    return _verifyCodeButton;
}

- (UITextField *)verifyCodeTextField {
    if (!_verifyCodeTextField) {
        UITextField *tmpTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        tmpTextField.borderStyle = UITextBorderStyleNone;
        tmpTextField.backgroundColor  = I_COLOR_EDITTEXT;
        tmpTextField.clipsToBounds = YES;
        tmpTextField.layer.borderColor = UIColorFromRGB(0xbebebe).CGColor;
        tmpTextField.layer.borderWidth = 1.0f;
        tmpTextField.layer.cornerRadius = CONVER_VALUE(41.0f) / 2;
        tmpTextField.textColor = I_COLOR_33BLACK;
        tmpTextField.font = [UIFont systemFontOfSize:14.0f];
        tmpTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xd2d2d2),NSFontAttributeName: [UIFont systemFontOfSize:14.0]}];
        tmpTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        tmpTextField.tintColor = TEXT_COLOR_GRAY;
        UIImageView *verifyCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CONVER_VALUE(20.0f), CONVER_VALUE(8.0f), CONVER_VALUE(24.0f), CONVER_VALUE(24.0f))];
        verifyCodeImageView.image = [UIImage imageNamed:@"ic_login_verifycodeNew"];
        verifyCodeImageView.contentMode = UIViewContentModeScaleAspectFit;
        verifyCodeImageView.backgroundColor = [UIColor clearColor];
        UIView *verifyCodeLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CONVER_VALUE(50.0f), CONVER_VALUE(41.0f))];
        [verifyCodeLeftView addSubview:verifyCodeImageView];
        tmpTextField.leftView = verifyCodeLeftView;
        tmpTextField.leftViewMode = UITextFieldViewModeAlways;
        [self.view addSubview:(_verifyCodeTextField = tmpTextField)];
    }
    return _verifyCodeTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        UITextField *tmpTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        tmpTextField.borderStyle = UITextBorderStyleNone;
        tmpTextField.backgroundColor  = I_COLOR_EDITTEXT;
        tmpTextField.clipsToBounds = YES;
        tmpTextField.layer.borderColor = UIColorFromRGB(0xbebebe).CGColor;
        tmpTextField.layer.borderWidth = 1.0f;
        tmpTextField.layer.cornerRadius = CONVER_VALUE(41.0f) / 2;
        tmpTextField.textColor = I_COLOR_33BLACK;
        tmpTextField.font = [UIFont systemFontOfSize:14.0f];
        tmpTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入6-18位密码" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xd2d2d2),NSFontAttributeName: [UIFont systemFontOfSize:14.0]}];
        tmpTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        tmpTextField.tintColor = TEXT_COLOR_GRAY;
        [tmpTextField setSecureTextEntry:YES];
        UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CONVER_VALUE(20.0f), CONVER_VALUE(8.0f), CONVER_VALUE(24.0f), CONVER_VALUE(24.0f))];
        passwordImageView.image = [UIImage imageNamed:@"ic_login_pwdSetNew"];
        passwordImageView.contentMode = UIViewContentModeScaleAspectFit;
        passwordImageView.backgroundColor = [UIColor clearColor];
        UIView *passwordLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CONVER_VALUE(50.0f), CONVER_VALUE(41.0f))];
        [passwordLeftView addSubview:passwordImageView];
        tmpTextField.leftView = passwordLeftView;
        tmpTextField.leftViewMode = UITextFieldViewModeAlways;
        [self.view addSubview:(_passwordTextField = tmpTextField)];
    }
    return _passwordTextField;
}
- (UITextField *)retryPasswordTextField {
    if (!_retryPasswordTextField) {
        UITextField *tmpTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        tmpTextField.borderStyle = UITextBorderStyleNone;
        tmpTextField.backgroundColor  = I_COLOR_EDITTEXT;
        tmpTextField.clipsToBounds = YES;
        tmpTextField.layer.borderColor = UIColorFromRGB(0xbebebe).CGColor;
        tmpTextField.layer.borderWidth = 1.0f;
        tmpTextField.layer.cornerRadius = CONVER_VALUE(41.0f) / 2;
        tmpTextField.textColor = I_COLOR_33BLACK;
        tmpTextField.font = [UIFont systemFontOfSize:14.0f];
        tmpTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再输入一次密码" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xd2d2d2),NSFontAttributeName: [UIFont systemFontOfSize:14.0]}];
        tmpTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        tmpTextField.tintColor = TEXT_COLOR_GRAY;
        [tmpTextField setSecureTextEntry:YES];
        
        UIImageView *retryPasswordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CONVER_VALUE(20.0f), CONVER_VALUE(8.0f), CONVER_VALUE(24.0f), CONVER_VALUE(24.0f))];
        retryPasswordImageView.image = [UIImage imageNamed:@"ic_login_pwdSetNew"];
        retryPasswordImageView.contentMode = UIViewContentModeScaleAspectFit;
        retryPasswordImageView.backgroundColor = [UIColor clearColor];
        UIView *retryPasswordLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CONVER_VALUE(50.0f), CONVER_VALUE(41.0f))];
        [retryPasswordLeftView addSubview:retryPasswordImageView];
        tmpTextField.leftView = retryPasswordLeftView;
        tmpTextField.leftViewMode = UITextFieldViewModeAlways;
        [self.view addSubview:(_retryPasswordTextField = tmpTextField)];
    }
    return _retryPasswordTextField;
}

//- (UIButton *)registerButton {
//    if (!_registerButton) {
//       
////        [self.view addSubview:(_registerButton = tmpBtn)];
//    }
//    return _registerButton;
//}

//- (UIButton *)agreementBtn {
//    if (!_agreementBtn) {
//      
//        [self.view addSubview:(_agreementBtn = tmpBtn)];
//        
//        
//    }
//    return _agreementBtn;
//}


- (void)ChangeState{
    
    if (_agreementBtn1.selected) {
        _agreementBtn1.selected = NO;
         [_agreementBtn1 setImage:[UIImage imageNamed:@"ic_message_off"] forState:UIControlStateNormal];
    [_agreementBtn1 setTitleColor:UIColorFromRGB(0x646464) forState:UIControlStateNormal];
        _registerButton.selected = NO;
        _registerButton.backgroundColor = UIColorFromRGB(0xFCAA6C);
    }
    else{
    
        _agreementBtn1.selected = YES;
         [_agreementBtn1 setImage:[UIImage imageNamed:@"ic_message_on"] forState:UIControlStateSelected];
        [_agreementBtn1 setTitleColor:UIColorFromRGB(0x646464) forState:UIControlStateSelected];
//
        _registerButton.selected = YES;
        _registerButton.backgroundColor = I_COLOR_YELLOW;
    }
    
    
    
}

//- (LoginSucAttentionView *)attentionView {
//    if (!_attentionView) {
//        LoginSucAttentionView *tempView = [[LoginSucAttentionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        tempView.delegate = self;
//        [self.view addSubview:(_attentionView = tempView)];
//    }
//    return _attentionView;
//}

@end
