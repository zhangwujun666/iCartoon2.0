//
//  PublishTaskViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "PublishTaskViewController.h"
#import <TSMessages/TSMessage.h>
#import "CommonUtils.h"
#import "NSString+Utils.h"
#import "UIImage+AssetUrl.h"
#import "ThemeSelectionView.h"
#import "DNImagePickerController.h"
#import "PlaceHolderTextView.h"
#import "AppDelegate.h"
#import "IndexAPIRequest.h"
#import "CustomImagePickerController.h"
#import "PostDetailViewController.h"
#import "TZImagePickerController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>

#import "Context.h"
#import "ThemeInfo.h"
#import <Base64/MF_Base64Additions.h>
#import <GTMBase64/GTMBase64.h>
#import "DraftPostInfo.h"
#import "DraftThemeInfo.h"
#import "DraftInfoDao.h"
#import "AttentionView.h"

#import "LookBigPicViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DNAsset.h"
#import "NSURL+DNIMagePickerUrlEqual.h"

@interface PublishTaskViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, DNImagePickerControllerDelegate,UITextViewDelegate, CustomImagePickerControllerDelegate,TZImagePickerControllerDelegate>

@property (strong, nonatomic) UIScrollView *mScrollView;
@property (strong, nonatomic) UIBarButtonItem *postButton;          //发布按钮
@property (strong, nonatomic) UITextField *maskIDTextField;         //显示ID
@property (strong, nonatomic) UITextField *mobileTextField;         //联系方式
@property (strong, nonatomic) UITextField *titleTextField;          //标题
@property (strong, nonatomic) PlaceHolderTextView *contentTextView; //内容
@property (strong, nonatomic) UIButton *themeButton;                //主题(熊巢)按钮
@property (strong, nonatomic) UIButton *selectionButton;            //选择按钮
@property (strong, nonatomic) UIView *picScrollView;                //图片列表
@property (strong, nonatomic) UITextField *contentTextField;          //内容占位符
//@property (strong, nonatomic) ThemeSelectionView *selectionView;    //主题选择

@property (strong, nonatomic) NSMutableArray *pictureArray;         //图拍数组
@property (strong, nonatomic) NSMutableArray *imageArray;           //图片数组(UIImage)
@property (assign, nonatomic) NSInteger selectPictureIndex;         //被选中的图片index
@property (assign, nonatomic) NSInteger removedPictureIndex;        //被选中的图片index
@property (strong, nonatomic) NSString *titleStr;                   //标题(内容)
@property (strong, nonatomic) NSString *contentStr;                 //内容(内容)
@property (strong, nonatomic) ThemeInfo *selectedTheme;             //主题(内容)
@property (assign, nonatomic) BOOL showSelection;

@end

@implementation PublishTaskViewController{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:149/255.0 blue:47/255.0 alpha:1];
    [self setBackNavgationItem];
    UIButton *publishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), 44.0f)];
    publishButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    publishButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [publishButton setTitleColor:I_COLOR_WHITE forState:UIControlStateNormal];
    [publishButton setTitleColor:I_COLOR_WHITE forState:UIControlStateSelected];
    [publishButton setTitleColor:I_COLOR_WHITE forState:UIControlStateHighlighted];
    [publishButton setTitle:@"投稿" forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(postButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.postButton = [[UIBarButtonItem alloc] initWithCustomView:publishButton];
    self.navigationItem.rightBarButtonItem = self.postButton;
    
    [self createUI];
    if(!self.pictureArray) {
        self.pictureArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.pictureArray removeAllObjects];
    if(self.type == PostTaskSourceTypeDraft) {
        //来自草稿箱的帖子
        self.navigationItem.title = @"编辑投稿";
        self.selectionButton.enabled = YES;
        //填充帖子内容
        NSString *titleStr = self.draftInfo.title;
        NSString *contentStr = self.draftInfo.content;
        NSString * phoneNum = self.draftInfo.phoneNum;
        NSString * name = self.draftInfo.name;
        self.taskId = self.draftInfo.taskId;
        DraftThemeInfo *draftTheme = self.draftInfo.themeInfo;
        if(draftTheme != nil && draftTheme.tid != nil && draftTheme.title != nil) {
            ThemeInfo *themeInfo = [[ThemeInfo alloc] init];
            themeInfo.title = draftTheme.title;
            themeInfo.tid = draftTheme.tid;
            themeInfo.imageUrl = draftTheme.imageUrl;
            [Context sharedInstance].selectThemeInfo = themeInfo;
            self.selectedTheme = themeInfo;
        } else {
            [Context sharedInstance].selectThemeInfo = nil;
        }
        self.mobileTextField.text = phoneNum;
        self.titleTextField.text = titleStr;
        self.contentTextView.text = contentStr;
        self.maskIDTextField.text = name;
        NSArray *imageStrArray = self.draftInfo.images;
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
        for(NSString *imageStr in imageStrArray) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithBase64String:imageStr]];
            [imageArray addObject:image];
        }
        [self.pictureArray addObjectsFromArray:imageArray];
        
    } else {
        //新建帖子
        self.navigationItem.title = @"编辑投稿";
        self.selectionButton.enabled = YES;
        self.draftInfo = nil;
        [Context sharedInstance].selectThemeInfo = nil;
    }
    if([Context sharedInstance].selectThemeInfo) {
        NSString *selectedTitle = [Context sharedInstance].selectThemeInfo.title;
        [self.selectionButton setTitle:selectedTitle forState:UIControlStateNormal];
        self.selectedTheme = [Context sharedInstance].selectThemeInfo;
    } else {
        [self.selectionButton setTitle:@"请选择熊窝" forState:UIControlStateNormal];
    }
    //加载图片
    [self reloadPictures];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - 返回
- (void)popBack {
    [self.titleTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
    self.titleStr = self.titleTextField.text;
    self.contentStr = self.contentTextView.text;
    if(![NSString isBlankString:self.titleStr] || self.imageArray.count > 0 || ![NSString isBlankString:self.contentStr]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"不保存" otherButtonTitles:@"保存为草稿", nil];
        actionSheet.tag = 10003;
        [actionSheet showInView:self.view];
        return;
    }
    if(self.draftInfo != nil) {
        [[DraftInfoDao sharedInstance] deleteMsgWithDraftInfo:self.draftInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshDrafts object:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapAction {
    [self.titleTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    self.isdifferent = textView.text;
    return YES;
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
- (void)postButtonAction {
    [self.titleTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
    //TODO -- 发布投稿
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
        [[AppDelegate sharedDelegate] showLoginViewController:YES];
        return;

    }
    self.titleStr = self.titleTextField.text;
    if ([NSString isBlankString:self.maskIDTextField.text]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"请输入显示作者"];
        [self.view addSubview:attention];
        return;
    }
    if ([NSString isBlankString:self.mobileTextField.text]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"请输入联系方式"];
        [self.view addSubview:attention];
        return;
    }
    if([NSString isBlankString:self.titleStr]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"请输入投稿标题"];
        [self.view addSubview:attention];
        return;
    }
    self.contentStr = self.contentTextView.text;
    if([NSString isBlankString:self.contentStr]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"请输入投稿内容"];
        [self.view addSubview:attention];
        return;
    }
    if (self.imageArray.count == 0) {
        AttentionView *attention = [[AttentionView alloc]initTitle:@"请上传投稿图片"];
        [self.view addSubview:attention];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在发布投稿..." maskType:SVProgressHUDMaskTypeClear];
    //TODO -- 添加参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.titleStr, @"title", self.taskId, @"taskId",self.mobileTextField.text,@"phone",self.maskIDTextField.text,@"name",nil];
    if(self.contentStr) {
        [params setObject:self.contentStr forKey:@"content"];
    }
    if(self.imageArray.count > 0) {
        UIImage *picImage = (UIImage *)[self.imageArray objectAtIndex:0];
        NSData *imgData = UIImageJPEGRepresentation(picImage, 0.25);
        NSString *base64Str = [imgData base64EncodedStringWithOptions:0];
        NSString *imageStr = [NSString stringWithFormat:@"data:image/jpeg;base64,%@", base64Str];
        [params setObject:imageStr forKey:@"image"];
    }
//    NSLog(@"params ========= %@",params);
    [[IndexAPIRequest sharedInstance] userContribute:params success:^(CommonInfo *resultInfo) {
        [SVProgressHUD dismiss];
        if([resultInfo isSuccess]) {
            if(self.type == PostTaskSourceTypeDraft) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"remove" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshTaskDrafts object:nil];
            }
            AttentionView * attention = [[AttentionView alloc]initTitle:@"投稿成功！" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
            self.titleTextField.text = nil;
            self.contentTextView.text = nil;
            [self.imageArray removeAllObjects];
            //TODO -- 刷新任务详情页面
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshTaskContribute object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshTaskDrafts object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"投稿失败！" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        AttentionView * attention = [[AttentionView alloc]initTitle:@"投稿失败,内容不能有表情符号!" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
    }];
}

//获取上层界面
- (void)backToViewController {
    self.titleStr = nil;
    self.contentStr = nil;
    [self.imageArray removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.titleStr = textField.text;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTextField) name:@"hide" object:nil];
}
- (void)hideTextField{
    [self.contentTextView resignFirstResponder];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.contentStr = textView.text;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //从界面，从上往下看，依次为0,1,2
    NSInteger tag = actionSheet.tag;
    if(tag == 10003) {
        if(buttonIndex == 1) {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"你的投稿已传送至“我的草稿”" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
        } else if(buttonIndex == 0) {
            //不保存
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            
        }
    }
}

- (void)delayMethod{
    NSString *title = self.titleStr;
    NSString *content = self.contentStr;
    NSString *phoneNum = self.mobileTextField.text;
    NSMutableArray *imageArray = self.imageArray;
    NSString *themeId = self.selectedTheme.tid;
    NSString *themeTitle = self.selectedTheme.title;
     NSString *name = self.maskIDTextField.text;
      NSString *taskId = self.taskId;
    [self saveDraftDataWithTitle:title content:content imgsArr:imageArray themeId:themeId themeTitle:themeTitle phoneNum:phoneNum name : name taskId:taskId];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - CustomImagePickerControllerDelegate
- (void)imagePickerController:(CustomImagePickerController *)imagePickerController selectedImages:(NSArray *)selectedImages soureType:(CustomImagePickerControllerSourceType)type {
    if(type == CustomImagePickerControllerSourceTypePhotoLibrary) {
        //相册
        [self.pictureArray removeAllObjects];
        if(selectedImages != nil && selectedImages.count > 0) {
            [self.pictureArray addObjectsFromArray:selectedImages];
        }
        [self reloadPictures];
    } else {
        //拍照
        [self.pictureArray removeAllObjects];
        if(selectedImages != nil && selectedImages.count > 0) {
            [self.pictureArray addObjectsFromArray:selectedImages];
        }
        [self reloadPictures];
    }
}

#pragma mark - Private Method
- (void)loadData {
    if(!self.pictureArray) {
        self.pictureArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.pictureArray removeAllObjects];
    [self reloadPictures];
}

- (void)createUI {
    
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f)];
    self.mScrollView.showsHorizontalScrollIndicator = NO;
    self.mScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mScrollView];
    UILabel * author = [[UILabel alloc]initWithFrame:CGRectMake(TRANS_VALUE(12.0f), 0, TRANS_VALUE(60), TRANS_VALUE(31.1f))];
    author.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    author.text = @"显示作者";
    author.numberOfLines = 1;
    author.textColor = [UIColor blackColor];
//    [author adjustsFontSizeToFitWidth];
    [self.mScrollView addSubview:author];
    
    self.maskIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(author.frame)+5, 0, SCREEN_WIDTH - 2 * TRANS_VALUE(12.0f), TRANS_VALUE(31.1f))];
    self.maskIDTextField.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
    self.maskIDTextField.textAlignment = NSTextAlignmentLeft;
    self.maskIDTextField.textColor=[UIColor blackColor];
    self.maskIDTextField.tintColor = I_COLOR_DARKGRAY;
   
    NSString *maskIDPlaceHolder = @"( 想披马甲就填哟 )";
    NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString:maskIDPlaceHolder];
    [attributedStr01 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:TRANS_VALUE(14.0f)] range:NSMakeRange(0, maskIDPlaceHolder.length)];
    [attributedStr01 addAttribute:NSForegroundColorAttributeName value:I_COLOR_GRAY range:NSMakeRange(0, maskIDPlaceHolder.length)];
    self.maskIDTextField.attributedPlaceholder = attributedStr01;
    [self.mScrollView addSubview:self.maskIDTextField];
    
    UIView *divider01 = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(33.0f), SCREEN_WIDTH, 0.5f)];
    divider01.backgroundColor = I_DIVIDER_COLOR;
    [self.mScrollView addSubview:divider01];

    
    UILabel * mobile = [[UILabel alloc]initWithFrame:CGRectMake(TRANS_VALUE(12.0f), TRANS_VALUE(33.0f), TRANS_VALUE(60), TRANS_VALUE(31.1f))];
    mobile.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    mobile.text = @"联系方式";
    mobile.numberOfLines = 1;
    mobile.textColor = [UIColor blackColor];
    [self.mScrollView addSubview:mobile];
    
    self.mobileTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(mobile.frame)+5, TRANS_VALUE(33.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(12.0f), TRANS_VALUE(31.1f))];
    self.mobileTextField.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
    self.mobileTextField.textAlignment = NSTextAlignmentLeft;
    self.mobileTextField.textColor=[UIColor blackColor];
    self.mobileTextField.tintColor = I_COLOR_DARKGRAY;
    NSString *mobilePlaceHolder = @"( 手机号 )";
    NSMutableAttributedString *attributedStr02 = [[NSMutableAttributedString alloc] initWithString:mobilePlaceHolder];
    [attributedStr02 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:TRANS_VALUE(14.0f)] range:NSMakeRange(0, mobilePlaceHolder.length)];
//    [attributedStr02 addAttribute:NSForegroundColorAttributeName value:I_COLOR_33BLACK range:NSMakeRange(0, 4)];
    [attributedStr02 addAttribute:NSForegroundColorAttributeName value:I_COLOR_GRAY range:NSMakeRange(0, mobilePlaceHolder.length)];
    //self.mobileTextField.attributedText = attributedStr02;
    self.mobileTextField.attributedPlaceholder = attributedStr02;
//    self.mobileTextField.placeholder = mobilePlaceHolder;
    [self.mScrollView addSubview:self.mobileTextField];
    
    UIView *divider02 = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(66.0f), SCREEN_WIDTH, 0.5f)];
    divider02.backgroundColor = I_DIVIDER_COLOR;
    [self.mScrollView addSubview:divider02];
    
     NSString *placeHolder = @"作品名称";
    UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake(TRANS_VALUE(12.0f), TRANS_VALUE(71.6f), TRANS_VALUE(60), TRANS_VALUE(31.1f))];
    name.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    name.text = placeHolder;
    name.numberOfLines = 1;
    name.textColor = [UIColor blackColor];
    [self.mScrollView addSubview:name];
    
    self.titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(name.frame)+5, TRANS_VALUE(71.6f), SCREEN_WIDTH - 2 * TRANS_VALUE(12.0f), TRANS_VALUE(31.1f))];
    self.titleTextField.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
    self.titleTextField.textAlignment = NSTextAlignmentLeft;
    self.titleTextField.textColor=[UIColor blackColor];
    self.titleTextField.tintColor = I_COLOR_DARKGRAY;
    [self.mScrollView addSubview:self.titleTextField];
    
    UIView *divider03 = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(102.7f), SCREEN_WIDTH, 0.5f)];
    divider03.backgroundColor = I_DIVIDER_COLOR;
    [self.mScrollView addSubview:divider03];
//    
    self.titleTextField.delegate = self;
    [self.titleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIView *dividerSection = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(66.0f) + 0.5f, SCREEN_WIDTH, TRANS_VALUE(5.1f))];
    dividerSection.backgroundColor = I_BACKGROUND_COLOR;
    [self.mScrollView addSubview:dividerSection];
    NSString *contentPlaceHolder = @"设计理念";
    UILabel * content = [[UILabel alloc]initWithFrame:CGRectMake(TRANS_VALUE(12.0f), TRANS_VALUE(105.0f), TRANS_VALUE(60), TRANS_VALUE(28.1f))];
    content.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    content.text = contentPlaceHolder;
    content.numberOfLines = 1;
    content.textColor = [UIColor blackColor];
    [self.mScrollView addSubview:content];
    self.contentTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(TRANS_VALUE(8.0f), TRANS_VALUE(132.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(6.0f), TRANS_VALUE(200.0f))];
    self.contentTextView.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
    self.contentTextView.textColor = I_COLOR_33BLACK;
    self.contentTextView.delegate = self;
    [self.mScrollView addSubview:self.contentTextView];
    self.contentTextView.delegate = self;
    self.contentTextField.userInteractionEnabled = YES;
    self.contentTextView.scrollEnabled = YES;
//    self.contentTextView.backgroundColor = [UIColor redColor];
    [self.contentTextView addSubview:self.contentTextField];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(352.0f), SCREEN_WIDTH, 0)];
    bottomView.backgroundColor = I_BACKGROUND_COLOR;
    [self.mScrollView addSubview:bottomView];
    //白色背景
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), TRANS_VALUE(5.1f), SCREEN_WIDTH - 2 * TRANS_VALUE(0.0f), SCREEN_HEIGHT- TRANS_VALUE(352.0f))];
    bgView.backgroundColor = I_COLOR_WHITE;
    [bottomView addSubview:bgView];
    
    //图片容器
    self.picScrollView = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(8.0f), TRANS_VALUE(8.0f), (SCREEN_WIDTH - 2 * TRANS_VALUE(8.0f)), SCREEN_HEIGHT- 64 - TRANS_VALUE(422.0f) -  4 *TRANS_VALUE(8.0f))];
    self.picScrollView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:self.picScrollView];
    
    [self reloadPictures];
}
- (void)textViewDidChange:(UITextView *)textView{
    if (self.contentTextView.text.length!=0) {
        self.contentTextField.hidden=YES;
    }else{
        self.contentTextField.hidden=NO;
    }
    if (textView.text.length != 0) {
        if (textView.text.length >=300) {
                        textView.text = [textView.text substringWithRange:NSMakeRange(0, 300)];
        }
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([[[UIApplication sharedApplication] textInputMode].primaryLanguage isEqualToString:@"emoji"]) {
        return NO;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
    if ([[[UIApplication sharedApplication] textInputMode].primaryLanguage isEqualToString:@"emoji"]) {
        return NO;
    }
    return YES;
}
- (BOOL)textFieldDidChange:(UITextField *)textField{
    NSString *toBeString = textField.text;
    NSArray *langs = [UITextInputMode activeInputModes];
    UITextInputMode *inputMode = (UITextInputMode *)[langs firstObject];
    NSString *lang = [inputMode primaryLanguage];
    if([lang isEqualToString:@"zh-Hans"]) {//当前为中文输入
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if(!position) {
            if (toBeString.length > 11) {
                textField.text = [toBeString substringToIndex:11];
            }
        } else{
            
        }
    }else{//其他输入的情况
        if (toBeString.length > 15) {
            textField.text = [toBeString substringToIndex:15];
            
        }
    }
    textField.textColor=[UIColor blackColor];
    textField.tintColor = I_COLOR_DARKGRAY;

        return YES;
}
- (void)reloadPictures {
    for(int i = 0, n = (int)self.pictureArray.count + 10; i < n; i++) {
        UIView *view = [self.picScrollView viewWithTag:(10000 + i)];
        if(view != nil) {
            [view removeFromSuperview];
            view = nil;
        }
    }
    
    int n = (int)self.pictureArray.count;
    if(self.imageArray != nil) {
        [self.imageArray removeAllObjects];
    } else {
        self.imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    CGFloat width = (SCREEN_WIDTH - 4 * TRANS_VALUE(8.0f)) / 3;
    CGFloat height = TRANS_VALUE(76.0f);
    CGFloat margin = TRANS_VALUE(8.0f);
    CGFloat x = 0;
    CGFloat y = 0;
    for(int i = 0; i < n; i++) {
        UIImage *tempImage = [[UIImage alloc] init];
        [self.imageArray addObject:tempImage];
        UIImageView *imageView = [self pictureImageView];
        imageView.frame = CGRectMake(x, y, width, height);
        NSLog(@"%.0lf, %.0lf, %.0lf, %.0lf", x, y, width, height);
        [self.picScrollView addSubview:imageView];
        if([[self.pictureArray objectAtIndex:i] isKindOfClass:[UIImage class]]) {
            imageView.image = [self.pictureArray objectAtIndex:i];
            [self.imageArray replaceObjectAtIndex:i withObject:[self.pictureArray objectAtIndex:i]];
        } else if([[self.pictureArray objectAtIndex:i] isKindOfClass:[NSString class]]) {
            NSString *urlStr = (NSString *)[self.pictureArray objectAtIndex:i];
            [UIImage imageForAssetUrl:urlStr success:^(UIImage * mImage) {
                // 使用本地图片
                imageView.image = mImage;
//                NSLog(@"mImage = %@",urlStr);
                [self.imageArray replaceObjectAtIndex:i withObject:mImage];
            } fail: ^{// 使用app内置图片
                UIImage *image = [UIImage imageNamed:@"ic_picture_add"];
                if(!image) {// 使用默认图片
                    image = [UIImage imageNamed: @"ic_picture_add"];
                }
                imageView.image = image;
                [self.imageArray replaceObjectAtIndex:i withObject:image];
            }];
        }
        [imageView setTag:(10000 + i)];
        imageView.userInteractionEnabled = YES;
        UIImageView *deleteImageView = (UIImageView *)[imageView viewWithTag:3333];
        deleteImageView.userInteractionEnabled = YES;
        if(deleteImageView) {
            deleteImageView.hidden = NO;
        }
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapAction:)];
         UITapGestureRecognizer *singleTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapAction:)];
        [imageView addGestureRecognizer:singleTap];
        [deleteImageView addGestureRecognizer:singleTap1];
        //位置设置
        if((i + 1) % 3 == 0) {
            x = 0;
            y += (height + margin);
        } else {
            x += (width + margin);
            y = y;
        }
    }
    if(n <= 0) {
        UIImageView *imageView = [self pictureImageView];
        imageView.frame = CGRectMake(x, y, width, height);
//         NSLog(@"%.0lf, %.0lf, %.0lf, %.0lf", x, y, width, height);
        [imageView setImage:[UIImage imageNamed: @"ic_picture_add"]];
        [self.picScrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        UIImageView *deleteImageView = (UIImageView *)[imageView viewWithTag:3333];
        if(deleteImageView) {
            deleteImageView.hidden = YES;
        }
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapAction:)];
        [imageView addGestureRecognizer:singleTap];
        [imageView setTag:(10000 + self.pictureArray.count)];
        x += (width + margin);
        y = y;
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(x + margin, y, 2 * width, height)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
        tipLabel.textColor = I_COLOR_BLACK;
        tipLabel.numberOfLines = 0;
        [self.picScrollView addSubview:tipLabel];
        NSString *tipStr = @"上传我的设计稿";
        tipLabel.text = tipStr;
        [tipLabel setTag:(10000 + self.pictureArray.count + 1)];
        
    }
    [self.picScrollView layoutSubviews];
    CGFloat contentWidth = width * 3 + 2 * margin;
    CGFloat contentHeight = y + height;
    if(n > 0 && n % 3 == 0) {
        contentHeight = contentHeight - height - margin;
    }
    CGFloat bottomHeight = contentHeight + 4 * TRANS_VALUE(8.0f);
    if(contentHeight + 4 * TRANS_VALUE(8.0f) < SCREEN_HEIGHT- 64 - TRANS_VALUE(392.0f)) {
        bottomHeight = SCREEN_HEIGHT- 64 - TRANS_VALUE(392.0f);
    }
    
    self.picScrollView.frame = CGRectMake(self.picScrollView.frame.origin.x, self.picScrollView.frame.origin.y, contentWidth, contentHeight);
    UIView *bgView = (UIView *)self.picScrollView.superview;
    bgView.frame = CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y, bgView.frame.size.width, contentHeight + 2 * TRANS_VALUE(8.0f));
    UIView *bottomView = (UIView *)[bgView superview];
    bottomView.frame = CGRectMake(bottomView.frame.origin.x, bottomView.frame.origin.y, bottomView.frame.size.width, bottomHeight+64);
    CGFloat mHeight = bottomView.frame.origin.y + bottomView.frame.size.height;
    self.mScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, mHeight);
    
}

//图片点击事件
- (void)imageTapAction:(UITapGestureRecognizer *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
    if([self.titleTextField isFirstResponder]) {
        [self.titleTextField resignFirstResponder];
    }
    if([self.contentTextView isFirstResponder]) {
        [self.contentTextView resignFirstResponder];
    }
    
    UIImageView *imageView = (UIImageView *)((UITapGestureRecognizer *)sender).view;
    NSInteger index = imageView.tag - 10000;
    self.selectPictureIndex = index;
    //图片删除或者添加操作
    if(self.pictureArray.count == 0) {
        //TODO －－ 显示图片选择器
//        CustomImagePickerController *imagePickerController =  [[CustomImagePickerController alloc] init];
//        imagePickerController.selectedPictureArray = [NSMutableArray arrayWithArray:[self.pictureArray copy]];
//        imagePickerController.maxNumOfPictures = 1;
//        imagePickerController.delegate = self;
//        [self.navigationController pushViewController:imagePickerController animated:YES];
          [self pickPhotoButtonClick];
        
    } else if(self.pictureArray.count == 1){
        //TODO -- 删除操作
        if (sender.view.tag == 10000) {
            NSMutableArray *photoArray = [[NSMutableArray alloc] init];
            for (int i = 0;i< self.imageArray.count; i ++) {
                UIImage *image = self.imageArray[i];
                MJPhoto *photo = [MJPhoto new];
                photo.image = image;
                photo.srcImageView =imageView;
                [photoArray addObject:photo];
            }
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.currentPhotoIndex = index;
            browser.photos = photoArray;
            [browser show];        }else{
            self.removedPictureIndex = index;
                [self.pictureArray removeObjectAtIndex:0];
                [self reloadPictures];
        }
    }
}
- (void)pickPhotoButtonClick {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    // imagePickerVc.allowTakePicture = NO; // 隐藏拍照按钮
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    //    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
    //
    //    }];
    
    // Set the appearance
    // 在这里设置imagePickerVc的外观
    imagePickerVc.navigationBar.barTintColor = I_COLOR_YELLOW;
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    imagePickerVc.oKButtonTitleColorNormal = I_COLOR_YELLOW;
    
    // Set allow picking video & photo & originalPhoto or not
    // 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    // imagePickerVc.allowPickingImage = NO;
    // imagePickerVc.allowPickingOriginalPhoto = NO;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

/// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    //TOOD -- 刷新数据
    [self.pictureArray removeAllObjects];
    if(_selectedPhotos != nil && _selectedPhotos.count > 0) {
        [self.pictureArray addObjectsFromArray:_selectedPhotos];
    }
    [self reloadPictures];
}

/// User finish picking video,
/// 用户选择好了视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    //    _layout.itemCount = _selectedPhotos.count;
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    //TODO -- 刷新数据
    //    [_collectionView reloadData];
}

//图片选择按钮
- (UIImageView *)pictureImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(96.0f), TRANS_VALUE(76.0f))];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.tag = 10001;
    imageView.backgroundColor = I_BACKGROUND_COLOR;
    imageView.image = [UIImage imageNamed:@"ic_picture_default"];
    
    UIImageView *deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(80.0f), TRANS_VALUE(2), TRANS_VALUE(14.0f), TRANS_VALUE(15.0f))];
    deleteImageView.contentMode = UIViewContentModeScaleAspectFit;
    deleteImageView.backgroundColor = [UIColor clearColor];
    deleteImageView.image = [UIImage imageNamed:@"ic_picture_delete"];
    [deleteImageView setTag:3333];
    [imageView addSubview:deleteImageView];
    
    return imageView;
}

#pragma mark 临时方法-草稿箱数据保存 && 查看
//草稿箱保存数据
- (void)saveDraftDataWithTitle:(NSString *)title
                       content:(NSString *)content
                       imgsArr:(NSArray *)imgsArr
                       themeId:(NSString *)themeId
                    themeTitle:(NSString *)themeTitle phoneNum:(NSString *)phoneNum name:(NSString *)name taskId:(NSString *)taskId{
    NSMutableArray *tempImgsArr = [NSMutableArray array];
    for(NSInteger i = 0; i < imgsArr.count; i++) {
        UIImage *picImage = (UIImage *)[self.imageArray objectAtIndex:i];
        NSData *imgData = UIImageJPEGRepresentation(picImage, 1.0f);
        NSString *base64Str = [imgData base64EncodedStringWithOptions:0];
        [tempImgsArr addObject:base64Str];
    }
    NSString *timeStr = [self getCurrentTime];
    DraftThemeInfo *myThemeInfo = [[DraftThemeInfo alloc] init];
    myThemeInfo.tid = themeId;
    myThemeInfo.title = themeTitle;
    myThemeInfo.createTime = timeStr;
    DraftPostInfo *myInfo = [[DraftPostInfo alloc] init];
    myInfo.title = title;
    myInfo.phoneNum = phoneNum;
     myInfo.name = name;
    myInfo.content = content;
    myInfo.taskId = taskId;
    myInfo.themeInfo = myThemeInfo;
    myInfo.createTime = timeStr;
    myInfo.images = tempImgsArr;
    myInfo.type = 1;
    BOOL isSuccess = [[DraftInfoDao sharedInstance] insertMsgWithDraftInfo:myInfo];
    if (!isSuccess) {
//        NSLog(@"草稿数据存储失败");
    }
    //删除原有草稿
    if(self.draftInfo != nil) {
        [[DraftInfoDao sharedInstance] deleteMsgWithDraftInfo:self.draftInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshDrafts object:nil];
    }
}

//获取当前时间
- (NSString *)getCurrentTime {
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr =  [formatter stringFromDate:[NSDate date]];
    return timeStr;
}

@end

