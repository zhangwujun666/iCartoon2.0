//
//  FeedbackViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "FeedbackViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "UserAPIRequest.h"
#import "Context.h"
#import "PlaceHolderTextView.h"
#import "CommonUtils.h"
#import "AttentionView.h"
#import "NSString+Utils.h"

@interface FeedbackViewController () <UITextViewDelegate>

@property (strong, nonatomic) UIBarButtonItem *submitButton;
@property (strong, nonatomic) PlaceHolderTextView *feedbackTextView;
@property (strong, nonatomic) NSString *feedback;
@property (strong,nonatomic) UIButton *button;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = I_BACKGROUND_COLOR;
    self.navigationItem.title = @"意见反馈";
    [self setBackNavgationItem];
    _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), 44.0f)];
    [ _button setTitleEdgeInsets:UIEdgeInsetsMake(0, CONVER_VALUE(10.0f), 0, CONVER_VALUE(-10.0f))];
    [_button setTitle:@"提交" forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(13)];
    [_button addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.submitButton=[[UIBarButtonItem alloc]initWithCustomView:_button];
    self.navigationItem.rightBarButtonItem = self.submitButton;
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:TRANS_VALUE(13)];
//    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
//    [self.submitButton setTitleTextAttributes:attrs forState:UIControlStateNormal];
//    NSMutableDictionary *disabledAttrs = [NSMutableDictionary dictionary];
//    disabledAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize: TRANS_VALUE(13)];
//    disabledAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];;
//    [self.submitButton setTitleTextAttributes:disabledAttrs forState:UIControlStateDisabled];
    [self createUI];
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
#pragma mark - Action
- (void)submitButtonAction {
    
    [self.feedbackTextView resignFirstResponder];
    self.feedback = self.feedbackTextView.text;
    if([NSString isBlankString:self.feedback]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"请输入信息" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }

    if(![Context sharedInstance].token) {
        return;
    }
//    NSInteger count = [CommonUtils mixedLengthOfString:self.feedback];
    if(self.feedback.length > 300) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"反馈意见最多不超过300个中文字符！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在提交用户反馈..." maskType:SVProgressHUDMaskTypeClear];
    NSDictionary *params = @{
                             @"opinion" : self.feedback
                             };
    [[UserAPIRequest sharedInstance] submitFeedback:params success:^(CommonInfo *commonInfo) {
        [SVProgressHUD dismiss];
        if([commonInfo isSuccess]) {
          
             _block();
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"反馈失败" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        AttentionView * attention = [[AttentionView alloc]initTitle:@"反馈失败,内容不能有表情符号!"];
        [self.view addSubview:attention];
    }];
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.feedback = textView.text;

}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>300) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 300)];
    }

//    if (textView.text.length != 0 && textView.text.length <= 300) {
//        _button.userInteractionEnabled =YES;
//        _button.alpha = 1;
//    }else{
//        _button.userInteractionEnabled = NO;
//        _button.alpha = 0.4;
//    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    if([text isEqualToString:@"\n"]) {
        [self.feedbackTextView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - Private Method
- (void)createUI {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(353.0f))];
    bgView.backgroundColor = UIColorFromRGB(0xF4F7FA);
    [self.view addSubview:bgView];
    
    self.feedbackTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(10.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f), TRANS_VALUE(343.0f))];
    self.feedbackTextView.font = [UIFont systemFontOfSize:TRANS_VALUE(15.0f)];
    self.feedbackTextView.textColor = I_COLOR_33BLACK;
    self.feedbackTextView.showsVerticalScrollIndicator = NO;
    self.feedbackTextView.backgroundColor = [UIColor clearColor];
    self.feedbackTextView.placeHolder = @"可以输入对萌热的建议或者意见哟(′•ω•`)\n(可以输入300字)";
    [bgView addSubview:self.feedbackTextView];
    
    self.feedbackTextView.delegate = self;
    self.feedbackTextView.returnKeyType = UIReturnKeyDone;
    UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.feedbackTextView.frame), SCREEN_WIDTH, 1.0f)];
    dividerView.backgroundColor = I_DIVIDER_COLOR;
    [bgView addSubview:dividerView];
    
}


@end
