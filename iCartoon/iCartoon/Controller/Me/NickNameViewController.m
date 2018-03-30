//
//  NickNameViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/14.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "NickNameViewController.h"
#import "Context.h"
#import <TSMessages/TSMessage.h>
#import "CommonUtils.h"
#import "AttentionView.h"
#import "UserAPIRequest.h"

#import <AFNetworking.h>

@interface NickNameViewController () <UITextViewDelegate>

@property (strong, nonatomic) UITextView *nicknameTextField;
@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (strong,nonatomic)UILabel * placeHolderLaber;
@property (nonatomic,strong)UIButton *clearButton;
@property (nonatomic,strong)AFHTTPRequestOperationManager*requestManager;
@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = I_BACKGROUND_COLOR;
    self.navigationItem.title = @"修改昵称";
    
    [self setBackNavgationItem];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), 44.0f)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, CONVER_VALUE(10.0f), 0, CONVER_VALUE(-10.0f))];

    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(13)];
    [button addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    [self createUI];
    [self loadData];
    
    
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
+ (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}
#pragma mark - Action
- (void)saveButtonAction {
    [self.nicknameTextField resignFirstResponder];
    self.nickname = self.nicknameTextField.text;
    NSInteger count = [CommonUtils mixedLengthOfString:self.nickname];
    BOOL emojn = [NickNameViewController stringContainsEmoji:self.nickname];
    if (emojn) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"昵称不能有表情符号！"];
        [self.view addSubview:attention];
        return;
    }
    if (!self.nickname.length) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"您的昵称不能为空！"];
        [self.view addSubview:attention];
        return;
    }
    if(count > 40) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"昵称最长不能超过15个字符！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }
    
    if(self.nickname) {
//        [Context sharedInstance].nickname = self.nickname;
        
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
//    NSLog(@"----------------------%@",self.nickname);
    if(self.nickname) {
        [params setObject:self.nicknameTextField.text forKey:@"nickName"];
    }
    NSMutableDictionary * parameters= [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setValue:params forKey:@"request"];
    
     NSString * mainurl = [APIConfig mainURL];
      NSString * token = [Context sharedInstance].token;
    NSString * path = [NSString stringWithFormat:@"%@/%@/%@",mainurl,@"UpdateUser",token];
    self.requestManager = [AFHTTPRequestOperationManager manager];
    self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil]; // 设置content-Type为text/html
    [self.requestManager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    NSLog(@"------\n%@---------\n%@",path,params);
    [self.requestManager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = responseObject[@"response"];
        int a = [dic[@"success"] intValue];
        if (a == 1) {
              [Context sharedInstance].nickname = self.nickname;
            _block();
              [self.navigationController popViewControllerAnimated:YES];
        }else{
            AttentionView *attention = [[AttentionView alloc]initTitle:dic[@"message"]];
            [self.view addSubview:attention];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        AttentionView *attention = [[AttentionView alloc]initTitle:error.localizedDescription];
        [self.view addSubview:attention];
    }];
    
    
    
    
    
//    [[UserAPIRequest sharedInstance] updateUserInfo:params success:^(CommonInfo *resultInfo) {
////        NSLog(@"resultInfo ========= %@",resultInfo);
//        if(resultInfo && [resultInfo isSuccess]) {
//             [Context sharedInstance].nickname = self.nickname;
//        } else {
//            AttentionView * attention = [[AttentionView alloc]initTitle:@"保存失败！" andtitle2:@""];
//            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
//            attention.label1.frame=CGRectMake(5, 15, 220, 40);
//            [self.view addSubview:attention];
//        }
//    } failure:^(NSError *error) {
//        AttentionView * attention = [[AttentionView alloc]initTitle:[NSString stringWithFormat:@"%@",error.localizedDescription] andtitle2:@""];
//        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
//        attention.label1.frame=CGRectMake(5, 15, 220, 40);
//        UIWindow * window = [UIApplication sharedApplication].keyWindow;
//        [window addSubview:attention];
//    }];
    
//    _block();
//    [self.navigationController popViewControllerAnimated:YES];
    
}
//限制textField输入字数的方
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 10)
        {
            [textField.text substringWithRange:NSMakeRange(0, 10)];
            return NO;
        }
             return YES;
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.nickname = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Private Method
- (void)createUI {
    self.nicknameTextField = [[UITextView alloc] initWithFrame:CGRectMake(0, 4, SCREEN_WIDTH, TRANS_VALUE(30.0f))];
    self.nicknameTextField.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    self.nicknameTextField.scrollEnabled = NO;
    self.nicknameTextField.textColor = I_COLOR_33BLACK;
    self.nicknameTextField.backgroundColor = [UIColor whiteColor];
    self.nicknameTextField.scrollEnabled = NO;
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(self.nicknameTextField.frame.size.width-TRANS_VALUE(30.0f), 0, TRANS_VALUE(30.0f),self.nicknameTextField.frame.size.height)];
        
        [button setImage:[UIImage imageNamed:@"ic_me_fork"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonclick) forControlEvents:UIControlEventTouchUpInside];
        self.clearButton = button;
    [self.nicknameTextField addSubview:self.clearButton];
//    if ([self.nicknameTextField.text isEqualToString:@""]) {
//        self.clearButton.hidden = YES;
//    }else{
//        self.clearButton.hidden = NO;
//    }
    if ([[Context sharedInstance].nickname isEqualToString:@""]||[Context sharedInstance].nickname == nil) {
        self.clearButton.hidden = YES;
    }else{
        self.clearButton.hidden = NO;
    }
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    [view1 addSubview:self.nicknameTextField];
    if (self.nickname.length == 0) {
        UILabel * placeHolderLaber = [[UILabel alloc]initWithFrame:CGRectMake(7, 0, self.nicknameTextField.bounds.size.width, self.nicknameTextField.bounds.size.height)];
        placeHolderLaber.text = @"请输入您的昵称（不超过15个字符）";
        placeHolderLaber.textColor = [UIColor grayColor];
        self.placeHolderLaber = placeHolderLaber;
        [self.nicknameTextField addSubview:self.placeHolderLaber];
    }
    self.nicknameTextField.delegate = self;
}
- (void)buttonclick{
    self.nicknameTextField.text = @"";
    self.clearButton.hidden = YES;
//    if (self.nicknameTextField.text.length == 0) {
        UILabel * placeHolderLaber = [[UILabel alloc]initWithFrame:CGRectMake(7, 0, self.nicknameTextField.bounds.size.width, self.nicknameTextField.bounds.size.height)];
        placeHolderLaber.text = @"请输入您的昵称（不超过15个字符）";
        placeHolderLaber.textColor = [UIColor grayColor];
        self.placeHolderLaber = placeHolderLaber;
        [self.nicknameTextField addSubview:self.placeHolderLaber];
//    }
}
- (void)textViewDidChange:(UITextView *)textView{
    if (![textView.text isEqualToString:@""]) {
        self.clearButton.hidden = NO;
    }else{
        self.clearButton.hidden = YES;
    }
      if (textView.markedTextRange == nil &&textView.text.length >10) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 10)];
    };
     [self.placeHolderLaber removeFromSuperview];
    if (textView.text.length == 0) {
        UILabel * placeHolderLaber = [[UILabel alloc]initWithFrame:CGRectMake(7, 0, self.nicknameTextField.bounds.size.width, self.nicknameTextField.bounds.size.height)];
        placeHolderLaber.text = @"请输入您的昵称（不超过15个字符）";
        placeHolderLaber.textColor = [UIColor grayColor];
        self.placeHolderLaber = placeHolderLaber;
        [self.nicknameTextField addSubview:self.placeHolderLaber];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    return YES;
}
- (void)loadData {
    if(self.nickname) {
        self.nicknameTextField.text = self.nickname;
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([self.nicknameTextField.text isEqualToString:@""]) {
        self.clearButton.hidden = YES;
    }else{
        self.clearButton.hidden = NO;
    }
    return YES;
}
@end
