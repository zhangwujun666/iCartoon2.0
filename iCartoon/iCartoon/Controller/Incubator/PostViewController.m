//
//  PostViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "PostViewController.h"
#import <TSMessages/TSMessage.h>
#import "CommonUtils.h"
#import "NSString+Utils.h"
#import "UIImage+AssetUrl.h"
#import "ThemeSelectionView.h"
#import "DNImagePickerController.h"
#import "PlaceHolderTextView.h"
#import "AppDelegate.h"
#import "PostAPIRequest.h"
#import "CustomImagePickerController.h"
#import "PostDetailViewController.h"

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

#import <AssetsLibrary/AssetsLibrary.h>
#import "DNAsset.h"
#import "NSURL+DNIMagePickerUrlEqual.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"

@interface PostViewController () <ThemeSelectionViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate, DNImagePickerControllerDelegate, CustomImagePickerControllerDelegate, TZImagePickerControllerDelegate> {
    
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
}

@property (strong, nonatomic) UIScrollView *mScrollView;
@property (strong, nonatomic) UIBarButtonItem *postButton;          //发布按钮
@property (strong, nonatomic) UITextField *titleTextField;          //标题
@property (strong, nonatomic) PlaceHolderTextView *contentTextView; //内容
@property (strong, nonatomic) UIButton *themeButton;                //主题(熊巢)按钮
@property (strong, nonatomic) UIButton *selectionButton;            //选择按钮
@property (strong, nonatomic) UIView *picScrollView;                //图片列表
@property (strong, nonatomic) ThemeSelectionView *selectionView;    //主题选择

@property (strong, nonatomic) NSMutableArray *pictureArray;         //图拍数组
@property (strong, nonatomic) NSMutableArray *imageArray;           //图片数组(UIImage)
@property (assign, nonatomic) NSInteger selectPictureIndex;         //被选中的图片index
@property (assign, nonatomic) NSInteger removedPictureIndex;        //被选中的图片index
@property (strong, nonatomic) NSString *titleStr;                   //标题(内容)
@property (strong, nonatomic) NSString *contentStr;                 //内容(内容)
@property (strong, nonatomic) ThemeInfo *selectedTheme;             //主题(内容)
@property (assign, nonatomic) BOOL showSelection;
@property (nonatomic,assign)BOOL isEdit;
@property (nonatomic,strong)NSString * isdifference;
@property (nonatomic,strong)NSMutableArray * imageDataArray;
@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:149/255.0 blue:47/255.0 alpha:1];
    [self setBackNavgationItem];
    UIButton *publishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), 44.0f)];
    [publishButton setTitleEdgeInsets:UIEdgeInsetsMake(0, CONVER_VALUE(3.0f), 0, CONVER_VALUE(-3.0f))];
    publishButton.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(13)];
    publishButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [publishButton setTitleColor:I_COLOR_WHITE forState:UIControlStateNormal];
    [publishButton setTitleColor:I_COLOR_WHITE forState:UIControlStateSelected];
    [publishButton setTitleColor:I_COLOR_WHITE forState:UIControlStateHighlighted];
    [publishButton setTitle:@"发布" forState:UIControlStateNormal];
    
    [publishButton addTarget:self action:@selector(postButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.postButton = [[UIBarButtonItem alloc] initWithCustomView:publishButton];
    self.navigationItem.rightBarButtonItem = self.postButton;
   
    
    [self createUI];
    
    if(!self.pictureArray) {
        self.pictureArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.pictureArray removeAllObjects];
    
    if(self.type == PostSourceTypeTheme) {
        //来自主题的帖子
        self.navigationItem.title = @"编辑内容";
        self.selectionButton.enabled = NO;
        self.selectedTheme = nil;
        self.draftInfo = nil;
        [Context sharedInstance].selectThemeInfo = self.themeInfo;
        
    } else if(self.type == PostSourceTypeDraft) {
        //来自草稿箱的帖子
        self.navigationItem.title = @"编辑内容";
        self.selectionButton.enabled = YES;
        self.themeInfo = nil;
        //填充帖子内容
        NSString *titleStr = self.draftInfo.title;
        NSString *contentStr = self.draftInfo.content;
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
        
        self.titleTextField.text = titleStr;
        self.contentTextView.text = contentStr;
        NSArray *imageStrArray = self.draftInfo.images;
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
        for(NSString *imageStr in imageStrArray) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithBase64String:imageStr]];
            [imageArray addObject:image];
        }
        [self.pictureArray addObjectsFromArray:imageArray];
        
    } else {
        //新建帖子
        self.navigationItem.title = @"编辑内容";
        self.selectionButton.enabled = YES;
        self.themeInfo = nil;
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
    if(self.themeInfo) {
        self.selectedTheme = self.themeInfo;
        [Context sharedInstance].selectThemeInfo = self.themeInfo;
    }
    if([Context sharedInstance].selectThemeInfo) {
        NSString *selectedTitle = [Context sharedInstance].selectThemeInfo.title;
        [self.selectionButton setTitle:selectedTitle forState:UIControlStateNormal];
        self.selectedTheme = [Context sharedInstance].selectThemeInfo;
    } else {
        [self.selectionButton setTitle:@"请选择熊窝" forState:UIControlStateNormal];
    }
}
#pragma mark - 返回
- (void)popBack {
    [self.titleTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
    self.titleStr = self.titleTextField.text;
    self.contentStr = self.contentTextView.text;
    if(self.draftInfo.content==NULL){
        self.draftInfo.content=@"";
    }
    if (self.draftInfo.title==NULL) {
        self.draftInfo.title=@"";
    }
    if (self.isEdit) {

        if(self.type == PostSourceTypeDraft){
            if([self.contentStr isEqualToString:self.draftInfo.content] && [self.titleStr isEqualToString:self.draftInfo.title]){
               
            }else{
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"不保存" otherButtonTitles:@"保存为草稿", nil];
                    actionSheet.tag = 10003;
                    [actionSheet showInView:self.view];
                    return;
                
            }

        }else{
            if(self.titleStr.length != 0 || self.imageArray.count > 0 || self.contentStr.length != 0) {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"不保存" otherButtonTitles:@"保存为草稿", nil];
                actionSheet.tag = 10003;
                [actionSheet showInView:self.view];
                return;
            }
            
        }
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
    self.isdifference = textView.text;
    return YES;
}
//主题选择按钮
- (void)selectionButtonAction {
    [self.titleTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
    if(self.showSelection) {
        [self hideSelectionView];
    } else {
        [self showSelectionView];
    }
    self.showSelection = !self.showSelection;
}

- (void)showSelectionView {
    [self.selectionButton setImage:[UIImage imageNamed:@"ic_arrow_up"] forState:UIControlStateNormal];
    CGFloat height = self.mScrollView.contentSize.height - TRANS_VALUE(343.3f);
    self.selectionView = [[ThemeSelectionView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(344.3f), SCREEN_WIDTH, height) withSelectTheme:self.selectedTheme];
    self.selectionView.backgroundColor = [UIColor colorWithRed:0.0f/255 green:0.0f/255 blue:0.0f/255 alpha:0.35f];
    [self.mScrollView addSubview:self.selectionView];
    self.selectionView.delegate = self;
    [self.selectionView show];
}

- (void)hideSelectionView {
    [self.selectionButton setImage:[UIImage imageNamed:@"ic_arrow_down"] forState:UIControlStateNormal];
    if(self.selectionView != nil) {
        self.selectionView.delegate = nil;
        [self.selectionView hide];
    }
}

#pragma mark - ThemeSelectionViewDelegate
- (void)didSelectAtItem:(ThemeInfo *)themeInfo {
    if(themeInfo != nil) {
        self.selectedTheme = themeInfo;
        [Context sharedInstance].selectThemeInfo = self.selectedTheme;
        NSString *themeTitle = self.selectedTheme.title;
        [self.selectionButton setTitle:themeTitle forState:UIControlStateNormal];
        [self hideSelectionView];
        self.showSelection = !self.showSelection;
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
- (void)postButtonAction {
    [self.titleTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
       //TODO -- 发布帖子
    if(![Context sharedInstance].userInfo || ![Context sharedInstance].token) {
        [[AppDelegate sharedDelegate] showLoginViewController:YES];
        return;
    }
    self.titleStr = self.titleTextField.text;
//     NSString * goodMsgtitleStr = [self.titleStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if([NSString isBlankString:self.titleStr]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"请输入帖子标题" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }
    BOOL Emoji = [PostViewController stringContainsEmoji:self.titleStr];
    if (Emoji) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"发帖失败,标题不能有表情符号!"];
        [self.view addSubview:attention];
        return;
    }
    self.contentStr = self.contentTextView.text;
    for (int i = 0; i < self.contentStr.length; i++) {
        if ([self.contentStr characterAtIndex:i] == '<') {
            self.contentStr = [self.contentStr stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
        }
    }
    for (int i = 0; i < self.contentStr.length; i++) {
        if ([self.contentStr characterAtIndex:i] == '>') {
            self.contentStr = [self.contentStr stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
        }
    }
   NSString * goodMsg = [self.contentStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    goodMsg = [goodMsg stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    if([NSString isBlankString:goodMsg]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"请添加帖子内容" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);

        [self.view addSubview:attention];
        return;
    }
    if(!self.selectedTheme) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"请选择帖子熊窝" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }
        
    //TODO -- 添加参数
    self.imageDataArray = [NSMutableArray array];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.titleStr, @"title", self.selectedTheme.tid, @"themeId", nil];
    if(self.contentStr) {
        [params setObject:goodMsg forKey:@"content"];
    }
    [self.navigationController popViewControllerAnimated:YES];
    if(self.imageArray.count > 0) {
        NSMutableArray *postImages = [NSMutableArray arrayWithCapacity:0];
        for(int i = 0, n = (int)self.imageArray.count; i < n; i++) {
            UIImage *picImage = (UIImage *)[self.imageArray objectAtIndex:i];
            if (picImage.imageOrientation == UIImageOrientationUp) {
                
            }else{
                    CGAffineTransform transform = CGAffineTransformIdentity;
                    switch (picImage.imageOrientation) {
                        case UIImageOrientationDown:
                        case UIImageOrientationDownMirrored:
                            transform = CGAffineTransformTranslate(transform, picImage.size.width, picImage.size.height);
                            transform = CGAffineTransformRotate(transform, M_PI);
                            break;
                            
                        case UIImageOrientationLeft:
                        case UIImageOrientationLeftMirrored:
                            transform = CGAffineTransformTranslate(transform, picImage.size.width, 0);
                            transform = CGAffineTransformRotate(transform, M_PI_2);
                            break;
                            
                        case UIImageOrientationRight:
                        case UIImageOrientationRightMirrored:
                            transform = CGAffineTransformTranslate(transform, 0, picImage.size.height);
                            transform = CGAffineTransformRotate(transform, -M_PI_2);
                            break;
                        default:
                            break;
                    }
                    
                    switch (picImage.imageOrientation) {
                        case UIImageOrientationUpMirrored:
                        case UIImageOrientationDownMirrored:
                            transform = CGAffineTransformTranslate(transform, picImage.size.width, 0);
                            transform = CGAffineTransformScale(transform, -1, 1);
                            break;
                            
                        case UIImageOrientationLeftMirrored:
                        case UIImageOrientationRightMirrored:
                            transform = CGAffineTransformTranslate(transform, picImage.size.height, 0);
                            transform = CGAffineTransformScale(transform, -1, 1);
                            break;
                        default:
                            break;
                    }
                    CGContextRef ctx = CGBitmapContextCreate(NULL, picImage.size.width, picImage.size.height,CGImageGetBitsPerComponent(picImage.CGImage), 0,
                                                             CGImageGetColorSpace(picImage.CGImage),
                                                             CGImageGetBitmapInfo(picImage.CGImage));
                    CGContextConcatCTM(ctx, transform);
                    switch (picImage.imageOrientation) {
                        case UIImageOrientationLeft:
                        case UIImageOrientationLeftMirrored:
                        case UIImageOrientationRight:
                        case UIImageOrientationRightMirrored:
                            CGContextDrawImage(ctx, CGRectMake(0,0,picImage.size.height,picImage.size.width), picImage.CGImage);
                            break;
                            
                        default:
                            CGContextDrawImage(ctx, CGRectMake(0,0,picImage.size.width,picImage.size.height), picImage.CGImage);
                            break;
                    }
                    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
                    UIImage *img = [UIImage imageWithCGImage:cgimg];
                    CGContextRelease(ctx);
                    CGImageRelease(cgimg);
                  picImage = img;
            }
            
            NSData *imgData = UIImageJPEGRepresentation(picImage, 0.8f);
            [self.imageDataArray addObject:imgData];
            NSString *base64Str = [imgData base64EncodedStringWithOptions:0];
            NSString *imageStr = [NSString stringWithFormat:@"data:image/jpeg;base64,%@", base64Str];
            NSDictionary *dict = @{@"image" : imageStr};
            [postImages addObject:dict];
        }
        [params setObject:postImages forKey:@"images"];
    }
    if (self.type == 0) {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:self.titleStr,@"titleStr",self.contentStr,@"contentStr",self.selectedTheme,@"selectedTheme",self.imageDataArray,@"pictureArray" ,nil];
        NSNotification * noti = [[NSNotification alloc]initWithName:@"addPost" object:nil userInfo:dic];
        [[NSNotificationCenter defaultCenter]postNotification:noti];
    }
    if (self.type == 1) {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:self.titleStr,@"titleStr",self.contentStr,@"contentStr",self.selectedTheme,@"selectedTheme",self.imageDataArray,@"pictureArray" ,nil];
        NSNotification * noti = [[NSNotification alloc]initWithName:@"postBack" object:nil userInfo:dic];
        [[NSNotificationCenter defaultCenter]postNotification:noti];
    }
    [[PostAPIRequest sharedInstance] publishPost:params success:^(NSString *postId) {
//        [SVProgressHUD dismiss];
        if (self.type == 0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"haveFinishedPost" object:nil];
        }
        if (self.type == 1) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"finish" object:nil];
        }
        if(postId != nil) {
            if (self.type == 2) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"remove" object:nil];
            }
        } else {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"发帖失败"];
            [self.view addSubview:attention];
        }
    } failure:^(NSError *error) {
         [[NSNotificationCenter defaultCenter]postNotificationName:@"removepost" object:nil];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"postfailure" object:nil];
        AttentionView * attention = [[AttentionView alloc]initTitle:@"发帖失败,已保存到草稿箱!"];
        [window addSubview:attention];
        NSString *title = self.titleStr;
        NSString *content = self.contentStr;
        NSMutableArray *imageArray = self.imageArray;
        NSString *themeId = self.themeInfo.tid;
        NSString *themeTitle = self.themeInfo.title;
        [self saveDraftDataWithTitle:title content:content imgsArr:imageArray themeId:themeId themeTitle:themeTitle];
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
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.isEdit = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.titleStr = textField.text;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.isEdit = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTextField) name:@"hide" object:nil];
}
- (void)hideTextField{
    [self.contentTextView resignFirstResponder];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.contentStr = textView.text;
}

#pragma mark - UIAlertView 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 101) {
        if(buttonIndex == 1) {
//            if(self.removedPictureIndex < [self.pictureArray count]) {
//                [self.pictureArray removeObjectAtIndex:self.removedPictureIndex];
//                [self reloadPictures];
//            }
        }
    } else if(alertView.tag == 102) {
        if(buttonIndex == 2) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            //保存草稿
            NSString *title = self.titleStr;
            NSString *content = self.contentStr;
            NSMutableArray *imageArray = self.imageArray;
            NSString *themeId = self.themeInfo.tid;
            NSString *themeTitle = self.themeInfo.title;
            [self saveDraftDataWithTitle:title content:content imgsArr:imageArray themeId:themeId themeTitle:themeTitle];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //从界面，从上往下看，依次为0,1,2
    NSInteger tag = actionSheet.tag;
    if(tag == 10003) {
        if(buttonIndex == 1) {
           
            AttentionView * attention = [[AttentionView alloc]initTitle:@"你的帖子已传送至“我的草稿”" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
            //保存
//            NSString *title = self.titleStr;
//            NSString *content = self.contentStr;
//            NSMutableArray *imageArray = self.imageArray;
//            NSString *themeId = self.selectedTheme.tid;
//            NSString *themeTitle = self.selectedTheme.title;
//            [self saveDraftDataWithTitle:title content:content imgsArr:imageArray themeId:themeId themeTitle:themeTitle];
//            [self.navigationController popViewControllerAnimated:YES];
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
    NSMutableArray *imageArray = self.imageArray;
    NSString *themeId = self.selectedTheme.tid;
    NSString *themeTitle = self.selectedTheme.title;
    [self saveDraftDataWithTitle:title content:content imgsArr:imageArray themeId:themeId themeTitle:themeTitle];
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
    
    self.titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(TRANS_VALUE(12.0f), 0, SCREEN_WIDTH - 2 * TRANS_VALUE(12.0f), TRANS_VALUE(30))];
    self.titleTextField.font = [UIFont systemFontOfSize:TRANS_VALUE(13.0f)];
    self.titleTextField.textAlignment = NSTextAlignmentLeft;
    self.titleTextField.textColor=[UIColor blackColor];
    self.titleTextField.tintColor = I_COLOR_DARKGRAY;
    NSString *placeHolder = @"标题 (必填)";
    //NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:placeHolder];
   // [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:TRANS_VALUE(14.0f)] range:NSMakeRange(0, placeHolder.length)];
   // [attributedStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_33BLACK range:NSMakeRange(0, 3)];
    //[attributedStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_GRAY range:NSMakeRange(3, placeHolder.length - 3)];
    //self.titleTextField.attributedPlaceholder = attributedStr;
//    self.titleTextField.textColor = [UIColor grayColor];
    self.titleTextField.placeholder = placeHolder;
    self.titleTextField.font = [UIFont systemFontOfSize:TRANS_VALUE(13.0f)];
    [self.mScrollView addSubview:self.titleTextField];
    self.titleTextField.delegate = self;
    [self.titleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
   // UIView *divider01 = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(40.0f), SCREEN_WIDTH, 0.5f)];
    UIView *divider01 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleTextField.frame)+1, SCREEN_WIDTH, 0.5f)];
    divider01.backgroundColor = I_DIVIDER_COLOR;
    [self.mScrollView addSubview:divider01];
    self.contentTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(TRANS_VALUE(7.0f), CGRectGetMaxY(divider01.frame), SCREEN_WIDTH - 2 * TRANS_VALUE(7.0f), TRANS_VALUE(280.0f))];
    self.contentTextView.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    self.contentTextView.textColor = I_COLOR_33BLACK;
    self.contentTextView.backgroundColor = I_COLOR_WHITE;
    self.contentTextView.text = @"";
    self.contentTextView.delegate = self;
    self.contentTextView.placeHolderColor = UIColorFromRGB(0xcccccc);
    self.contentTextView.tag = 111111;
    self.contentTextView.placeHolder = @"亲爱的熊宝SAMA,请在此详细告诉我们，您伟大的设想吧！！\n只要您的创意足够精彩，就有机会成为现实哦~";
    [self.mScrollView addSubview:self.contentTextView];
    self.contentTextView.delegate = self;
    
    UIView *divider02 = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(321.0f), SCREEN_WIDTH, 1.0f)];
    divider02.backgroundColor = I_DIVIDER_COLOR;
    [self.mScrollView addSubview:divider02];
    
    self.themeButton = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(7.0f), TRANS_VALUE(322.0f), TRANS_VALUE(237.0f), CONVER_VALUE(25.0f))];
    self.themeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.themeButton.titleEdgeInsets = UIEdgeInsetsMake(0, TRANS_VALUE(5.0f), 0, 0);
    self.themeButton.titleLabel.font = [UIFont systemFontOfSize:CONVER_VALUE(15.0f)];
    [self.themeButton setTitleColor:I_COLOR_33BLACK forState:UIControlStateNormal];
    NSString *titleStr = @"熊窝  (必选)";
    NSMutableAttributedString *attributedTitleStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [attributedTitleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:CONVER_VALUE(15.0f)] range:NSMakeRange(0, titleStr.length)];
    [attributedTitleStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_33BLACK range:NSMakeRange(0, 4)];
    [attributedTitleStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_GRAY range:NSMakeRange(4, titleStr.length - 4)];
    [self.themeButton setAttributedTitle:attributedTitleStr forState:UIControlStateNormal];
    [self.themeButton setImage:[UIImage imageNamed:@"ic_theme"] forState:UIControlStateNormal];
//    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, TRANS_VALUE(30.0f), TRANS_VALUE(30.0f)) ];
//    imgView.image=[UIImage imageNamed:@"ic_theme"];
//    self.themeButton.imageView  setImage:[[UIImage alloc]initWithFrame:CGRectMake(0, 0, TRANS_VALUE(30.0f), TRANS_VALUE(30.0f))];
//    [self.themeButton.imageView addSubview:imgView];
//    self.themeButton.imageView.contentMode=UIControlStateNormal;
    self.themeButton.enabled = YES;
    [self.mScrollView addSubview:self.themeButton];
    
    UIImageView *divider03 = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(222.0f), TRANS_VALUE(326.0f), CONVER_VALUE(1.0f), TRANS_VALUE(20.0f))];
    divider03.image = [UIImage imageNamed:@"ic_post_midline"];
    // divider03.backgroundColor = I_DIVIDER_COLOR;
    [self.mScrollView addSubview:divider03];
    
    self.selectionButton = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(230.0f), TRANS_VALUE(322.0f), TRANS_VALUE(90.0f), CONVER_VALUE(25.0f))];
    self.selectionButton.titleLabel.font = [UIFont systemFontOfSize:CONVER_VALUE(15.0f)];
    self.selectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.selectionButton setTitleColor:I_COLOR_DARKGRAY forState:UIControlStateNormal];
    [self.selectionButton setTitle:@"海贼王" forState:UIControlStateNormal];
    [self.selectionButton setImage:[UIImage imageNamed:@"ic_arrow_down"] forState:UIControlStateNormal];
    [self.selectionButton setImageEdgeInsets:UIEdgeInsetsMake(4, 2, 4, 2)];
    self.selectionButton.titleEdgeInsets = UIEdgeInsetsMake(0, TRANS_VALUE(4.0f), 0, 0);
    [self.mScrollView addSubview:self.selectionButton];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(352.0f), SCREEN_WIDTH, SCREEN_HEIGHT  - 64 - TRANS_VALUE(352.0f))];
    bottomView.backgroundColor = I_BACKGROUND_COLOR;
    [self.mScrollView addSubview:bottomView];
    
    UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1.0f)];
    dividerView.backgroundColor = I_DIVIDER_COLOR;
    [bottomView addSubview:dividerView];
    UIView *divderView2 = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(-8.7f), SCREEN_WIDTH, TRANS_VALUE(10.0f))];
    divderView2.backgroundColor=I_BACKGROUND_COLOR;
    [bottomView addSubview:divderView2];
    
    //白色背景
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), TRANS_VALUE(0.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(0.0f), SCREEN_HEIGHT- 64 - TRANS_VALUE(352.0f) - TRANS_VALUE(8.0f))];
    bgView.backgroundColor = I_COLOR_WHITE;
    [bottomView addSubview:bgView];
//
    //图片容器
    self.picScrollView = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(8.0f), TRANS_VALUE(8.0f), (SCREEN_WIDTH - 2 * TRANS_VALUE(8.0f)), SCREEN_HEIGHT- 64 - TRANS_VALUE(352.0f) -  4 *TRANS_VALUE(8.0f))];
    self.picScrollView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:self.picScrollView];
    
    //TODO -- 按钮点击事件
    [self.selectionButton addTarget:self action:@selector(selectionButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self reloadPictures];
}
- (void)textViewDidChange:(UITextView *)textView{
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([[[UIApplication sharedApplication] textInputMode].primaryLanguage isEqualToString:@"emoji"]) {
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
+ (BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}
- (BOOL)textFieldDidChange:(UITextField *)textField{
    NSString *toBeString = textField.text;
    NSArray *langs = [UITextInputMode activeInputModes];
    UITextInputMode *inputMode = (UITextInputMode *)[langs firstObject];
    NSString *lang = [inputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {//当前为中文输入
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length > 30) {
                textField.text = [toBeString substringToIndex:30];
                
            }
        }else{
            
        }
    }else{//其他输入的情况
        if (toBeString.length > 20) {
            textField.text = [toBeString substringToIndex:20];
            
        }
    }
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
        [self.picScrollView addSubview:imageView];
        if([[self.pictureArray objectAtIndex:i] isKindOfClass:[UIImage class]]) {
            imageView.image = [self.pictureArray objectAtIndex:i];
            [self.imageArray replaceObjectAtIndex:i withObject:[self.pictureArray objectAtIndex:i]];
        } else if([[self.pictureArray objectAtIndex:i] isKindOfClass:[NSString class]]) {
            NSString *urlStr = (NSString *)[self.pictureArray objectAtIndex:i];
            [UIImage imageForAssetUrl:urlStr success:^(UIImage * mImage) {
                // 使用本地图片
                imageView.image = mImage;
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
        if(deleteImageView) {
            deleteImageView.hidden = NO;
        }
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapAction:)];
        [imageView addGestureRecognizer:singleTap];
        //位置设置
        if((i + 1) % 3 == 0) {
//            NSLog(@"换行换行换行。。。。");
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
        tipLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(10.0f)];
        tipLabel.textColor = I_COLOR_BLACK;
        tipLabel.numberOfLines = 0;
        [self.picScrollView addSubview:tipLabel];
        NSString *tipStr = @"上传图片(最多可选择9张)";
        NSMutableAttributedString *attributedTipStr = [[NSMutableAttributedString alloc] initWithString:tipStr];
        [attributedTipStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:TRANS_VALUE(14.0f)] range:NSMakeRange(0, tipStr.length)];
        [attributedTipStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_33BLACK range:NSMakeRange(0, 4)];
        [attributedTipStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_GRAY range:NSMakeRange(4, tipStr.length - 4)];
        tipLabel.attributedText = attributedTipStr;
        [tipLabel setTag:(10000 + self.pictureArray.count + 1)];
        
    } else if(n <= 8) {
        UIImageView *imageView = [self pictureImageView];
        imageView.frame = CGRectMake(x, y, width, height);
//         NSLog(@"%.0lf, %.0lf, %.0lf, %.0lf", x, y, width, height);
        [imageView setImage:[UIImage imageNamed: @"ic_picture_add"]];
        [self.picScrollView addSubview:imageView];
        UIImageView *deleteImageView = (UIImageView *)[imageView viewWithTag:3333];
        if(deleteImageView) {
            deleteImageView.hidden = YES;
        }
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapAction:)];
        [imageView addGestureRecognizer:singleTap];
        [imageView setTag:(10000 + n)];
        if(n % 3 == 0) {
//            NSLog(@"换行换行换行。。。。");
            x = 0;
            y += (height + margin);
        } else {
            x += (width + margin);
            y = y;
        }
    }
    [self.picScrollView layoutSubviews];
    CGFloat contentWidth = width * 3 + 2 * margin;
    CGFloat contentHeight = y + height;
    if(n > 0 && n % 3 == 0) {
        contentHeight = contentHeight - height - margin;
    }
    CGFloat bottomHeight = contentHeight + 4 * TRANS_VALUE(8.0f);
    if(contentHeight + 4 * TRANS_VALUE(8.0f) < SCREEN_HEIGHT- 64 - TRANS_VALUE(352.0f)) {
        bottomHeight = SCREEN_HEIGHT- 64 - TRANS_VALUE(352.0f);
    }
//    if(contentHeight < SCREEN_HEIGHT- 64 - TRANS_VALUE(352.0f) -  4 *TRANS_VALUE(8.0f)) {
//        contentHeight = SCREEN_HEIGHT- 64 - TRANS_VALUE(352.0f) -  4 *TRANS_VALUE(8.0f);
//    }
     self.picScrollView.frame = CGRectMake(self.picScrollView.frame.origin.x, self.picScrollView.frame.origin.y, contentWidth, contentHeight);
    UIView *bgView = (UIView *)self.picScrollView.superview;
    bgView.frame = CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y, bgView.frame.size.width, contentHeight + 2 * TRANS_VALUE(8.0f));
    UIView *bottomView = (UIView *)[bgView superview];
    bottomView.frame = CGRectMake(bottomView.frame.origin.x, bottomView.frame.origin.y, bottomView.frame.size.width, bottomHeight);
    CGFloat mHeight = bottomView.frame.origin.y + bottomView.frame.size.height;
    self.mScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, mHeight);
    CGFloat offSetY = mHeight - (SCREEN_HEIGHT - 64.0f);
    if(offSetY > 0) {
        [self.mScrollView setContentOffset:CGPointMake(0, offSetY)];
    }
    
}

//图片点击事件
- (void)imageTapAction:(id)sender {
    UIImageView *imageView = (UIImageView *)((UITapGestureRecognizer *)sender).view;
    NSInteger index = imageView.tag - 10000;
    self.selectPictureIndex = index;
    //图片删除或者添加操作
    if(index >= self.pictureArray.count && index < 9) {
        //TODO －－ 显示图片选择器
        [self pickPhotoButtonClick];
//        CustomImagePickerController *imagePickerController = [[CustomImagePickerController alloc] init];
//        imagePickerController.selectedPictureArray = [NSMutableArray arrayWithArray:[self.pictureArray copy]];
//        imagePickerController.delegate = self;
//        [self.navigationController pushViewController:imagePickerController animated:YES];
    } else if(index < self.pictureArray.count && index < 9){
        //TODO -- 删除操作
        self.removedPictureIndex = index;
        if(self.removedPictureIndex < [self.pictureArray count]) {
           // [self.pictureArray removeObjectAtIndex:self.removedPictureIndex];
            //[self reloadPictures];
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
             [browser show];
        }
            }
}


//图片选择按钮
- (UIImageView *)pictureImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(96.0f), TRANS_VALUE(76.0f))];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = I_BACKGROUND_COLOR;
    imageView.image = [UIImage imageNamed:@"ic_picture_default"];
    
    UIImageView *deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(80.0f), TRANS_VALUE(2), TRANS_VALUE(14.0f), TRANS_VALUE(15.0f))];
    deleteImageView.contentMode = UIViewContentModeScaleToFill;
    deleteImageView.backgroundColor = [UIColor clearColor];
    deleteImageView.image = [UIImage imageNamed:@"ic_picture_delete"];
    [deleteImageView setTag:3333];
    [imageView addSubview:deleteImageView];
    deleteImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [deleteImageView addGestureRecognizer:tap];
    return imageView;
}
- (void)tapClick:(UITapGestureRecognizer *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
    if([self.titleTextField isFirstResponder]) {
        [self.titleTextField resignFirstResponder];
    }
    if([self.contentTextView isFirstResponder]) {
        [self.contentTextView resignFirstResponder];
    }
    UIImageView *imageView = (UIImageView *)((UITapGestureRecognizer *)sender).view;
    NSInteger index = imageView.superview.tag - 10000;
    self.selectPictureIndex = index;
        self.removedPictureIndex = index;
        [self.pictureArray removeObjectAtIndex:self.removedPictureIndex];
    //TODO -- 删除图片
    [_selectedPhotos removeObjectAtIndex:self.removedPictureIndex];
    [_selectedAssets removeObjectAtIndex:self.removedPictureIndex];
        [self reloadPictures];
}
#pragma mark 临时方法-草稿箱数据保存 && 查看
//草稿箱保存数据
- (void)saveDraftDataWithTitle:(NSString *)title
                       content:(NSString *)content
                       imgsArr:(NSArray *)imgsArr
                       themeId:(NSString *)themeId
                    themeTitle:(NSString *)themeTitle {
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
    myInfo.content = content;
    myInfo.themeInfo = myThemeInfo;
    myInfo.createTime = timeStr;
    myInfo.images = tempImgsArr;
    BOOL isSuccess = [[DraftInfoDao sharedInstance] insertMsgWithDraftInfo:myInfo];
    if (!isSuccess) {
        NSLog(@"草稿数据存储失败");
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

- (void)pickPhotoButtonClick {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
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
//    _layout.itemCount = _selectedPhotos.count;
//    [_collectionView reloadData];
//    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
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

@end

@implementation PostImage

@end
