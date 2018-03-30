//
//  SignatureViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/14.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "SignatureViewController.h"
#import "Context.h"
#import "PlaceHolderTextView.h"
#import "CommonUtils.h"
#import <TSMessages/TSMessage.h>
#import "AttentionView.h"
@interface SignatureViewController () <UITextViewDelegate>

@property (strong, nonatomic) PlaceHolderTextView *signatureTextView;
@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (nonatomic,strong)UILabel * placeHolderLabel;
@property (nonatomic,strong)UIButton *clearBtn;

@end

@implementation SignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = I_BACKGROUND_COLOR;
    self.navigationItem.title = @"个性签名";
    
    [self setBackNavgationItem];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), 44.0f)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, CONVER_VALUE(10.0f), 0, CONVER_VALUE(-10.0f))];

    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(13)];
    [button addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = self.saveButton;
//    self.saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction)];
//    self.navigationItem.rightBarButtonItem = self.saveButton;
    
    [self createUI];
    [self loadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)saveButtonAction {
    [self.signatureTextView resignFirstResponder];
    self.signature = self.signatureTextView.text;
    NSInteger count = [CommonUtils mixedLengthOfString:self.signature];
    if(count > 40) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"昵称最多不超过15个字符！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }
    [Context sharedInstance].signature = self.signature;
    
     _block();
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.signature = textView.text;
}
- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.clearBtn.hidden=YES;
    }else{
        self.clearBtn.hidden=NO;
    }
    if (textView.markedTextRange == nil &&textView.text.length >20) {
         textView.editable = NO;
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 20)];
        textView.editable = YES;
    }
    if ([textView.text isEqualToString:@""]) {
        [self.placeHolderLabel removeFromSuperview];
         self.placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.signatureTextView.bounds.size.width-5, self.signatureTextView.bounds.size.height)];
        self.placeHolderLabel.font = [UIFont systemFontOfSize:16];
        self.placeHolderLabel.text = @"请输入您的个性签名（不超过20个字符）";
        self.placeHolderLabel.textColor = [UIColor grayColor];
        [self.signatureTextView addSubview:self.placeHolderLabel];
    }else{
        [self.placeHolderLabel removeFromSuperview];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    if([text isEqualToString:@"\n"]  ) {
        [self.signatureTextView resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma mark - Private Method
- (void)createUI {
    self.signatureTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(0, 4, SCREEN_WIDTH, TRANS_VALUE(30.0f))];
    self.signatureTextView.backgroundColor = [UIColor clearColor];
    self.signatureTextView.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    self.signatureTextView.textColor = I_COLOR_33BLACK;
    self.signatureTextView.scrollEnabled = NO;
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    [view1 addSubview:self.signatureTextView];
    self.clearBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.signatureTextView.frame.size.width-TRANS_VALUE(30.0f), TRANS_VALUE(0.0f), TRANS_VALUE(30.0f), self.signatureTextView.frame.size.height)];
    [self.clearBtn setImage:[UIImage imageNamed:@"ic_me_fork"] forState:UIControlStateNormal];
    [self.signatureTextView addSubview:self.clearBtn];
    if ([self.signature isEqualToString:@""]||self.signature == nil) {
        self.clearBtn.hidden=YES;
    }else{
        self.clearBtn.hidden=NO;
    }
    [self.clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
    if ([self.signature isEqualToString:@""]||self.signature == nil) {
        UILabel * placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.signatureTextView.bounds.size.width-5, self.signatureTextView.bounds.size.height)];
        placeHolderLabel.text = @"请输入您的个性签名（不超过20个字符）";
        self.placeHolderLabel = placeHolderLabel;
        self.placeHolderLabel.font = [UIFont systemFontOfSize:16];
        self.placeHolderLabel.textColor = [UIColor grayColor];
        [self.signatureTextView addSubview:self.placeHolderLabel];
    }
    self.signatureTextView.backgroundColor = [UIColor whiteColor];
    self.signatureTextView.delegate = self;
    self.signatureTextView.returnKeyType = UIReturnKeyDone;
}
-(void)clearBtnClick{
    self.signatureTextView.text=@"";
    self.clearBtn.hidden=YES;
    UILabel * placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.signatureTextView.bounds.size.width-5, self.signatureTextView.bounds.size.height)];
    placeHolderLabel.text = @"请输入您的个性签名（不超过20个字符）";
    self.placeHolderLabel = placeHolderLabel;
    self.placeHolderLabel.font = [UIFont systemFontOfSize:16];
    self.placeHolderLabel.textColor = [UIColor grayColor];
    [self.signatureTextView addSubview:self.placeHolderLabel];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    if ([self.signatureTextView.text isEqualToString:@""]) {
        self.clearBtn.hidden=YES;
    }else{
        self.clearBtn.hidden=NO;
    }
    return YES;
}

- (void)loadData {
    if(self.signature) {
        self.signatureTextView.text = self.signature;
    }
}

@end
