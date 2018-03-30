//
//  ForgetPasswordViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/9/3.
//  Copyright (c) 2015年 xuchengxiong. All rights reserved.
//

#import "ForgetPasswordViewController.h"

#import <TSMessages/TSMessage.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "VerifyButton.h"

#import "RegexKit.h"
#import "NSString+Utils.h"
#import "MD5File.h"

#import "UserAPIRequest.h"
#import "AttentionView.h"

@interface ForgetPasswordViewController ()
@property (weak, nonatomic) UITextField *mobileTextField;
@property (weak, nonatomic) UITextField *passwordTextField;
@property (weak, nonatomic) UITextField *retryPasswordTextField;
@property (weak, nonatomic) UITextField *verifyCodeTextField;
@property (weak, nonatomic) VerifyButton *verifyCodeButton;
@property (weak, nonatomic) UIButton *submitButton;
@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = I_BACKGROUND_COLOR;
    self.navigationItem.title = @"找回密码";
    
    [self setBackNavgationItem];
    
    //添加view, 初始化界面控件
    [self addViews];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlankView)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tapGesture];
    
    [self.submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.verifyCodeButton addTarget:self action:@selector(verifyCodeAction) forControlEvents:UIControlEventTouchUpInside];
    
    //TODO -- 测试代码
//    self.mobileTextField.text = @"18521508353";
//    self.passwordTextField.text = @"123456";
//    self.retryPasswordTextField.text = @"123456";
//    self.verifyCodeTextField.text = @"123456";
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

#pragma mark - Private Method
//点击输入框以外的空白处
- (void)tapBlankView {
    [self.view endEditing:YES];
}

//提交按钮点击事件
- (void)submitAction {
    NSString *mobile = self.mobileTextField.text;
    if([NSString isBlankString:mobile]) {

        AttentionView * attention = [[AttentionView alloc]initTitle:@"用户手机号码不能为空！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    } else if(![RegexKit validateMobile:mobile]) {

        AttentionView * attention = [[AttentionView alloc]initTitle:@"用户不存在！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }
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

        AttentionView * attention = [[AttentionView alloc]initTitle:@"两次输入的密码不一致, 请重新输入！" andtitle2:@""];
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
    
    NSDictionary *params = @{
                             @"account" : mobile,
                             @"newMd5Password" : password,
                             @"captcha" : verifyCode
                             };

    [[UserAPIRequest sharedInstance] findPassword:params success:^(CommonInfo *commonInfo) {
         if(commonInfo) {
             AttentionView * attention = [[AttentionView alloc]initTitle:@"找回密码成功, 请重新登录！" andtitle2:@""];
             attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
             attention.label1.frame=CGRectMake(5, 15, 220, 40);
             [self.view addSubview:attention];
             [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:2.0f];
         } else {
             AttentionView * attention = [[AttentionView alloc]initTitle:@"找回密码失败, 请稍后再试！" andtitle2:@""];
             attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
             attention.label1.frame=CGRectMake(5, 15, 220, 40);
             [self.view addSubview:attention];
         }
     } failure:^(NSError *error) {
         [SVProgressHUD dismiss];
         AttentionView * attention = [[AttentionView alloc]initTitle:@"验证码错误！"];
         [self.view addSubview:attention];
         
     }];
}

- (void)dismissViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

//获取验证码按钮点击事件
- (void)verifyCodeAction {
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
    //检测手机号是否已注册
    [self checkAccountExist:mobile];
}

//检查手机号是否已经注册
- (void)checkAccountExist:(NSString *)mobile {
    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeClear];
    [[UserAPIRequest sharedInstance] checkAccountExist:mobile success:^(AccountExistInfo *existInfo) {
        [SVProgressHUD dismiss];
        if(existInfo != nil && [existInfo.isExist isEqualToString:@"true"]) {
            [self sendVerifyCode:mobile];
        } else {
            //用户手机号未注册
            AttentionView * attention = [[AttentionView alloc]initTitle:@"该手机号未注册, 请先注册！" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}

- (void)sendVerifyCode:(NSString *)mobile {
    //获取手机验证码
    [self.verifyCodeButton start];
//    [SVProgressHUD showWithStatus:@"正在获取验证码，请稍等..." maskType:SVProgressHUDMaskTypeClear];
    [[UserAPIRequest sharedInstance] sendSMSCodeWithMobile:mobile success:^(CommonInfo *commonInfo) {
//        [SVProgressHUD dismiss];
        if(commonInfo) {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"验证码已发送, 请查看手机短信！" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        } else {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"获取验证码失败, 请稍后再试...！" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}

- (void)addViews {
    
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
//    //提交按钮
//    CGFloat submitButtonMarginTop = TRANS_VALUE(285.0f);
//    CGFloat submitButtonWidth = SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f);
//    CGFloat submitButtonHeight = TRANS_VALUE(40.0f);
//    self.submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, submitButtonMarginTop, submitButtonWidth, submitButtonHeight)];
//    CGPoint submitButtonCenter = self.submitButton.center;
//    submitButtonCenter.x = CGRectGetMidX(self.view.frame);
//    self.submitButton.center = submitButtonCenter;
//    self.submitButton.backgroundColor = I_COLOR_YELLOW;
//    self.submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(17.0f)];
//    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.submitButton setTitle:@"" forState:UIControlStateNormal];
//    self.submitButton.layer.cornerRadius = TRANS_VALUE(38.0f) / 2;
//    self.submitButton.clipsToBounds = YES;
//    [self.view addSubview:self.submitButton];
    //手机号输入框
    [self.view addSubview:self.mobileTextField];
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(CONVER_VALUE(20.0f));
        make.left.equalTo(self.view.mas_left).with.offset(CONVER_VALUE(10.0f));
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(354.0f), CONVER_VALUE(41.0f)));
    }];
       //验证码输入框
    [self.view addSubview:self.verifyCodeTextField];
    [self.verifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mobileTextField.mas_bottom).with.offset(CONVER_VALUE(20.0f));
        make.left.mas_equalTo(self.mobileTextField.mas_left);
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(220.0f), CONVER_VALUE(41.0f)));
 
    }];
    
    //获取验证码按钮
    [self.view addSubview:self.verifyCodeButton];
    [self.verifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.verifyCodeTextField.mas_top);
        make.left.equalTo(self.verifyCodeTextField.mas_right).with.offset(CONVER_VALUE(8.0f));
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(126.0f), CONVER_VALUE(41.0f)));
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
    //提交
    //再次录入密码框
    [self.view addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.retryPasswordTextField.mas_bottom).with.offset(CONVER_VALUE(20.0f));
        make.left.mas_equalTo(self.passwordTextField.mas_left);
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(354.0f), CONVER_VALUE(41.0f)));
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
        tmpTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xd2d2d2),NSFontAttributeName: [UIFont systemFontOfSize:14.0]}];
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
        tmpTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入6-18位新密码" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xd2d2d2),NSFontAttributeName: [UIFont systemFontOfSize:14.0]}];
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
        tmpTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再输入一次新密码" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xd2d2d2),NSFontAttributeName: [UIFont systemFontOfSize:14.0]}];
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

- (UIButton *)submitButton {
    if (!_submitButton) {
        UIButton *tmpBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        tmpBtn.backgroundColor = UIColorFromRGB(0xf0821e);
        tmpBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.5f];
        [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tmpBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        tmpBtn.layer.cornerRadius = CONVER_VALUE(41.0f) / 2;
        tmpBtn.clipsToBounds = YES;
        [self.view addSubview:(_submitButton = tmpBtn)];
    }
    return _submitButton;
}


@end
