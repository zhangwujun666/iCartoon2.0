//
//  ModifyPasswordViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "ModifyPasswordViewController.h"

#import <TSMessages/TSMessageView.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UserAPIRequest.h"

#import "MD5File.h"
#import "RegexKit.h"
#import "NSString+Utils.h"
#import "Context.h"
#import "AccountInfoDao.h"
#import "UserInfoDao.h"
#import "VerifyButton.h"
#import "AttentionView.h"
@interface ModifyPasswordViewController ()

@property (strong, nonatomic) UITextField *mobileTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *retryPasswordTextField;
@property (strong, nonatomic) UITextField *verifyCodeTextField;
@property (strong, nonatomic) VerifyButton *verifyCodeButton;

@property (strong, nonatomic) UIButton *finishButton;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = I_BACKGROUND_COLOR;
    self.navigationItem.title = @"修改密码";
    [self setBackNavgationItem];
    
    [self createUI];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlankView)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tapGesture];
    
    [self.finishButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    [self.verifyCodeButton addTarget:self action:@selector(verifyCodeAction) forControlEvents:UIControlEventTouchUpInside];
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
- (void)finishAction {
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

        AttentionView * attention = [[AttentionView alloc]initTitle:@"两次输入的密码不一致，请重新输入！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
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
    if (retryPassword.length<6||retryPassword.length>18) {
        AttentionView *attention = [[AttentionView alloc]initTitle:@"请输入6-18位密码！"];
        [self.view addSubview:attention];
        return;
    }
    //旧密码md5加密
   // AccountInfo *accountInfo = [[AccountInfoDao sharedInstance] getAccountInfo];
   // NSString *oldPassword = accountInfo.password;
    //新密码md5加密
    password = [MD5File md5:password];
    NSDictionary *params = @{
                             @"account" : mobile,
                             @"newMd5Password" : password,
                             @"captcha" : verifyCode
                             };
    [[UserAPIRequest sharedInstance] findPassword:params success:^(CommonInfo *commonInfo) {
        if(commonInfo) {
//            [[Context sharedInstance]userLogout];
            AttentionView * attention = [[AttentionView alloc]initTitle:@"修改密码成功" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
            [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:2.0f];
        } else {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"修改密码失败, 请稍后再试！" andtitle2:@""];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//获取验证码按钮点击事件
- (void)verifyCodeAction {
    //调用倒计时
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
        AttentionView * attention = [[AttentionView alloc]initTitle:@"用户不存在！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }
    
    //检查手机号是否已经注册
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
//            [TSMessage showNotificationInViewController:self.navigationController title:@"该手机号未注册, 请先注册" subtitle:nil type:TSMessageNotificationTypeError];
            AttentionView * attention = [[AttentionView alloc]initTitle:@"该手机号未注册，请先注册！" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        }
    } failure:^(NSError *error) {
    
    }];
}

- (void)sendVerifyCode:(NSString *)mobile {
    //获取手机验证码
    [self.verifyCodeButton start];
    [[UserAPIRequest sharedInstance] sendSMSCodeWithMobile:mobile success:^(CommonInfo *commonInfo) {

        if(commonInfo) {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"验证码已发送，请查看手机短信！" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        } else {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"获取验证码失败，请稍后再试！" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        }
    } failure:^(NSError *error) {

        
    }];
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
- (void)createUI {
    CGFloat textFieldWidth = SCREEN_WIDTH - 2 * TRANS_VALUE(9.0f);
    CGFloat textFieldHeight = TRANS_VALUE(35.0f);
    //手机号码
    
    self.mobileTextField = [[UITextField alloc] initWithFrame:CGRectMake(TRANS_VALUE(9.0f), TRANS_VALUE(18.0f),textFieldWidth, textFieldHeight)];
    self.mobileTextField.borderStyle = UITextBorderStyleNone;
    self.mobileTextField.clipsToBounds = YES;
    self.mobileTextField.layer.borderColor = RGBCOLOR(212, 212, 212).CGColor;
    self.mobileTextField.layer.cornerRadius = textFieldHeight / 2;
    self.mobileTextField.layer.borderWidth = 1.0f;
    self.mobileTextField.textColor = I_COLOR_BLACK;
    self.mobileTextField.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    self.mobileTextField.backgroundColor = I_COLOR_EDITTEXT;
    UIImageView *mobileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(13.0f), TRANS_VALUE(8.0f), TRANS_VALUE(20.0f), TRANS_VALUE(20.0f))];
    mobileImageView.image = [UIImage imageNamed:@"ic_login_mobileNew"];
    mobileImageView.contentMode = UIViewContentModeScaleAspectFit;
    mobileImageView.backgroundColor = [UIColor clearColor];
    UIView *mobileLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), TRANS_VALUE(35.0f))];
    [mobileLeftView addSubview:mobileImageView];
    self.mobileTextField.leftView = mobileLeftView;
    self.mobileTextField.leftViewMode = UITextFieldViewModeAlways;
    self.mobileTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName: TEXT_COLOR_GRAY}];
    self.mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.mobileTextField.tintColor = TEXT_COLOR_GRAY;
    [self.view addSubview:self.mobileTextField];
    
    //验证码按钮
    CGFloat verifyCodeButtonMarginTop = TRANS_VALUE(72.0f);
    CGFloat verifyCodeButtonMarginLeft = TRANS_VALUE(205.0f);
    CGFloat verifyCodeButtonWidth = TRANS_VALUE(106.0f);
    CGFloat verifyCodeButtonHeight = textFieldHeight;
    self.verifyCodeButton = [[VerifyButton alloc] initWithFrame:CGRectMake(verifyCodeButtonMarginLeft, verifyCodeButtonMarginTop, verifyCodeButtonWidth, verifyCodeButtonHeight) withTitle:@"获取验证码"];
    [self.view addSubview:self.verifyCodeButton];
    
    self.verifyCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(TRANS_VALUE(9.0f), TRANS_VALUE(72.0f), TRANS_VALUE(190.0f) , textFieldHeight)];
    self.verifyCodeTextField.borderStyle = UITextBorderStyleNone;
    self.verifyCodeTextField.borderStyle = UITextBorderStyleNone;
    self.verifyCodeTextField.clipsToBounds = YES;
    self.verifyCodeTextField.layer.borderColor = RGBCOLOR(212, 212, 212).CGColor;
    self.verifyCodeTextField.layer.borderWidth = 1.0f;
    self.verifyCodeTextField.layer.cornerRadius = textFieldHeight / 2;
    self.verifyCodeTextField.textColor = I_COLOR_BLACK;
    self.verifyCodeTextField.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    self.verifyCodeTextField.backgroundColor = I_COLOR_EDITTEXT;
    UIImageView *verifyCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(13.0f), TRANS_VALUE(8.0f), TRANS_VALUE(20.0f), TRANS_VALUE(20.0f))];
    verifyCodeImageView.image = [UIImage imageNamed:@"ic_login_verifycodeNew"];
    verifyCodeImageView.contentMode = UIViewContentModeScaleAspectFit;
    verifyCodeImageView.backgroundColor = [UIColor clearColor];
    UIView *verifyCodeLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), TRANS_VALUE(35.0f))];
    [verifyCodeLeftView addSubview:verifyCodeImageView];
    self.verifyCodeTextField.leftView = verifyCodeLeftView;
    self.verifyCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    self.verifyCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: TEXT_COLOR_GRAY}];
    self.verifyCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.verifyCodeTextField.tintColor = TEXT_COLOR_GRAY;
    [self.view addSubview:self.verifyCodeTextField];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(TRANS_VALUE(9.0f), TRANS_VALUE(126.0f), textFieldWidth, textFieldHeight)];
    self.passwordTextField.borderStyle = UITextBorderStyleNone;
    self.passwordTextField.clipsToBounds = YES;
    self.passwordTextField.layer.borderColor = RGBCOLOR(212, 212, 212).CGColor;
    self.passwordTextField.layer.cornerRadius = textFieldHeight / 2;
    self.passwordTextField.layer.borderWidth = 1.0f;
    self.passwordTextField.textColor = I_COLOR_BLACK;
    self.passwordTextField.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    self.passwordTextField.backgroundColor = I_COLOR_EDITTEXT;
    UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(13.0f), TRANS_VALUE(8.0f), TRANS_VALUE(20.0f), TRANS_VALUE(20.0f))];
    passwordImageView.image = [UIImage imageNamed:@"ic_login_pwdSetNew"];
    passwordImageView.contentMode = UIViewContentModeScaleAspectFit;
    passwordImageView.backgroundColor = [UIColor clearColor];
    UIView *passwordLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), TRANS_VALUE(35.0f))];
    [passwordLeftView addSubview:passwordImageView];
    self.passwordTextField.leftView = passwordLeftView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入6-18位新密码" attributes:@{NSForegroundColorAttributeName: TEXT_COLOR_GRAY}];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.tintColor = TEXT_COLOR_GRAY;
    [self.passwordTextField setSecureTextEntry:YES];
    [self.view addSubview:self.passwordTextField];
    
    self.retryPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(TRANS_VALUE(9.0f), TRANS_VALUE(180.0f), textFieldWidth, textFieldHeight)];
    self.retryPasswordTextField.borderStyle = UITextBorderStyleNone;
    self.retryPasswordTextField.layer.cornerRadius = textFieldHeight / 2;
    self.retryPasswordTextField.clipsToBounds = YES;
    self.retryPasswordTextField.layer.borderColor = RGBCOLOR(212, 212, 212).CGColor;
    self.retryPasswordTextField.layer.borderWidth = 1.0f;
    self.retryPasswordTextField.textColor = I_COLOR_BLACK;
    self.retryPasswordTextField.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    self.retryPasswordTextField.backgroundColor = I_COLOR_EDITTEXT;
    UIImageView *retryPasswordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(13.0f), TRANS_VALUE(8.0f), TRANS_VALUE(20.0f), TRANS_VALUE(20.0f))];
    retryPasswordImageView.image = [UIImage imageNamed:@"ic_login_pwdSetNew"];
    retryPasswordImageView.contentMode = UIViewContentModeScaleAspectFit;
    retryPasswordImageView.backgroundColor = [UIColor clearColor];
    UIView *retryPasswordLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), TRANS_VALUE(35.0f))];
    [retryPasswordLeftView addSubview:retryPasswordImageView];
    self.retryPasswordTextField.leftView = retryPasswordLeftView;
    self.retryPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.retryPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再输入一次新密码" attributes:@{NSForegroundColorAttributeName: TEXT_COLOR_GRAY}];
    self.retryPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.retryPasswordTextField.tintColor = TEXT_COLOR_GRAY;
    [self.retryPasswordTextField setSecureTextEntry:YES];
    [self.view addSubview:self.retryPasswordTextField];
    
    
    //提交按钮
    CGFloat finishButtonMarginTop = TRANS_VALUE(234.0f);
    CGFloat finishButtonWidth = SCREEN_WIDTH - 2 * TRANS_VALUE(9.0f);
    CGFloat finishButtonHeight = TRANS_VALUE(41.0f);
    self.finishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, finishButtonMarginTop, finishButtonWidth, finishButtonHeight)];
    CGPoint finishButtonCenter = self.finishButton.center;
    finishButtonCenter.x = CGRectGetMidX(self.view.frame);
    self.finishButton.center = finishButtonCenter;
    self.finishButton.backgroundColor = I_COLOR_YELLOW;
    self.finishButton.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(16.0f)];
    [self.finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.finishButton setTitle:@"确认修改" forState:UIControlStateNormal];
    self.finishButton.layer.cornerRadius = TRANS_VALUE(41.0f) / 2;
    self.finishButton.clipsToBounds = YES;
    [self.view addSubview:self.finishButton];
}


@end
