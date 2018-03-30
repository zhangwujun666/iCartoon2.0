//
//  PublishCommentViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "PublishCommentViewController.h"
#import "PostAPIRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "Context.h"
#import "PlaceHolderTextView.h"
#import "NSString+Utils.h"
#import "CommentDraftDao.h"
#import "AppDelegate.h"
#import "AttentionView.h"
#import "TZImagePickerController.h"
#import "LookBigPicViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DNAsset.h"
#import "NSURL+DNIMagePickerUrlEqual.h"
#import "CustomImagePickerController.h"
#import "DNImagePickerController.h"
#import "UIImage+AssetUrl.h"
@interface PublishCommentViewController () <UITextViewDelegate, UIActionSheetDelegate,TZImagePickerControllerDelegate>

@property (strong, nonatomic) UIBarButtonItem *publishButton;
@property (strong, nonatomic) PlaceHolderTextView *commentTextView;
@property (strong, nonatomic) NSString *comment;
@property (strong,nonatomic)NSString * isDifferent;
@property (nonatomic,strong)UILabel * centerLabel;
@property (nonatomic,strong)UIView *countView;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)UIScrollView * mScrollView;
@property (nonatomic,strong)PlaceHolderTextView * contentTextView;
@property (nonatomic,strong)UIView * picScrollView;
@property (strong, nonatomic) NSMutableArray *pictureArray;         //图拍数组
@property (strong, nonatomic) NSMutableArray *imageArray;           //图片数组(UIImage)
@property (assign, nonatomic) NSInteger selectPictureIndex;         //被选中的图片index
@property (assign, nonatomic) NSInteger removedPictureIndex;

@end

@implementation PublishCommentViewController{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = I_BACKGROUND_COLOR;
    [self setBackNavgationItem];
     _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), 44.0f)];
    [ _button setTitleEdgeInsets:UIEdgeInsetsMake(0, CONVER_VALUE(10.0f), 0, CONVER_VALUE(-10.0f))];
        [ _button setTitle:@"发送" forState:UIControlStateNormal];
         _button.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(13)];
        [ _button addTarget:self action:@selector(publishButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4] forState:UIControlStateNormal];
    _button.userInteractionEnabled = NO;
    _button.alpha = 0.4;
    _countView.hidden = YES;
    self.publishButton = [[UIBarButtonItem alloc]initWithCustomView: _button];
    self.navigationItem.rightBarButtonItem = self.publishButton;
    [self createUI];
    
    if(self.type == CommentSourceTypeNew) {
        if(!self.replyCommentInfo) {
            self.navigationItem.title = @"发布评论";
        } else {
            self.navigationItem.title = @"回复评论";
        }
    } else {
        if(!self.draftCommentInfo.replierId) {
            self.navigationItem.title = @"发布评论";
        } else {
            self.navigationItem.title = @"回复评论";
        }
        if(self.draftCommentInfo.comment != nil) {
            self.commentTextView.text = self.draftCommentInfo.comment;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 返回
- (void)popBack {
    [self.commentTextView resignFirstResponder];
    self.comment = self.commentTextView.text;
    if (self.isEdit) {
        if(self.comment.length !=0&& ![self.isDifference isEqualToString:self.comment]) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"不保存" otherButtonTitles:@"保存为草稿", nil];
            [actionSheet showInView:self.view];
            return;
        }    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //从界面，从上往下看，依次为0,1,2
    if(buttonIndex == 1) {
        //保存
        NSString *commentStr = self.comment;
        PostDetailInfo *postDetailInfo = self.postDetailInfo;
        PostCommentInfo *commentInfo = self.replyCommentInfo;
        
        [self saveCommentDraftInfo:commentStr postInfo:postDetailInfo postCommentInfo:commentInfo];
        
//        _block2();
        

        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"showAlert" object:nil];
           } else if(buttonIndex == 0) {
        //不保存
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        
    }
}

- (void)saveCommentDraftInfo:(NSString *)commentStr postInfo:(PostDetailInfo *)postDetailInfo postCommentInfo:(PostCommentInfo *)commentInfo {
    DraftCommentInfo *draftInfo = [[DraftCommentInfo alloc] init];
    draftInfo.comment = commentStr;
    draftInfo.postId = postDetailInfo.pid;
    draftInfo.postTitle = postDetailInfo.title;
    draftInfo.postContent = postDetailInfo.content;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr = [formatter stringFromDate:[NSDate date]];
    draftInfo.createTime = timeStr;
    draftInfo.authorId = postDetailInfo.author.uid;
    draftInfo.authorName = postDetailInfo.author.nickname;
    draftInfo.postImageUrl = nil;
    if(postDetailInfo.images != nil && postDetailInfo.images.count > 0) {
        PostPictureInfo *pictureInfo = (PostPictureInfo *)[postDetailInfo.images objectAtIndex:0];
        draftInfo.postImageUrl = pictureInfo.imageUrl;
    }
    if(commentInfo != nil) {
        draftInfo.replierId = commentInfo.author.uid;
        draftInfo.replierName = commentInfo.author.nickname;
        draftInfo.commentId = commentInfo.cid;
    } else {
        draftInfo.replierId = nil;
        draftInfo.replierName = nil;
        draftInfo.commentId = nil;
    }
    [[CommentDraftDao sharedInstance] insertCommentDraftInfo:draftInfo];
    if(self.draftCommentInfo != nil) {
        [[CommentDraftDao sharedInstance] deleteCommentDraftInfo:self.draftCommentInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshDrafts object:nil];
    }
}

#pragma mark - Action
- (void)publishButtonAction {
    if(![Context sharedInstance].token) {
        return;
    }
    [self.commentTextView resignFirstResponder];
    self.comment = self.commentTextView.text;
    //提交评论
    [self commentPost:self.comment ];
}

- (void)commentPost:(NSString *)commentStr{

    if(![Context sharedInstance].userInfo ||
       ![Context sharedInstance].token) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"用户登录后才能评论帖子, 请先登录！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        
        [[AppDelegate sharedDelegate] showLoginViewController:YES];
        return;
    }
    if(!commentStr || [commentStr isEqualToString:@""]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"请添加评论！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    } else if(commentStr.length > 200){
        AttentionView * attention = [[AttentionView alloc]initTitle:@"评论不能超过200个字！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if(self.type == CommentSourceTypeNew) {
        if(!self.postDetailInfo.pid) {
            return;
        } else {
            [params setObject:self.postDetailInfo.pid forKey:@"topicId"];
        }
        if(self.replyCommentInfo) {
            NSString *replyUserId = self.replyCommentInfo.author.uid;
            NSString *replyCommentId = self.replyCommentInfo.cid;
            if(replyUserId) {
                [params setObject:replyUserId forKey:@"replyUserId"];
            }
            if(replyCommentId) {
                [params setObject:replyCommentId forKey:@"replyCommentId"];
            }
        }
    } else {
        [params setObject:self.draftCommentInfo.postId forKey:@"topicId"];
        if(self.draftCommentInfo.replierId != nil) {
            NSString *replyUserId = self.draftCommentInfo.replierId;
            NSString *replyCommentId = self.draftCommentInfo.commentId;
            if(replyUserId) {
                [params setObject:replyUserId forKey:@"replyUserId"];
            }
            if(replyCommentId) {
                [params setObject:replyCommentId forKey:@"replyCommentId"];
            }
        }
    }
    for (int i = 0; i < commentStr.length; i++) {
        if ([commentStr characterAtIndex:i] == '<') {
            commentStr = [commentStr stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
        }
    }
    for (int i = 0; i < commentStr.length; i++) {
        if ([commentStr characterAtIndex:i] == '>') {
            commentStr = [commentStr stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
        }
    }
     NSString * goodMsg = [commentStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     goodMsg = [goodMsg stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [params setObject:goodMsg forKey:@"content"];
    if(self.pictureArray.count > 0) {
        UIImage *picImage = (UIImage *)[self.imageArray objectAtIndex:0];
        NSData *imgData = UIImageJPEGRepresentation(picImage, 0.25);
        NSString *base64Str = [imgData base64EncodedStringWithOptions:0];
        NSString *imageStr = [NSString stringWithFormat:@"data:image/jpeg;base64,%@", base64Str];
        [params setObject:imageStr forKey:@"image"];
        [params setObject:[NSString stringWithFormat:@"%d",(int)picImage.size.width] forKey:@"imageWidth"];
        [params setObject:[NSString stringWithFormat:@"%d",(int)picImage.size.height] forKey:@"imageHeight"];
    }
//    NSLog(@"params ======== %@",params);
    [SVProgressHUD showWithStatus:@"正在提交评论..." maskType:SVProgressHUDMaskTypeClear];
    [[PostAPIRequest sharedInstance] commentPost:params success:^(CommonInfo *resultInfo) {
        [SVProgressHUD dismiss];
        if(resultInfo && [resultInfo isSuccess]) {
            //TODO -- 刷新数据
            self.commentTextView.text = @"";
            if(self.draftCommentInfo != nil) {
                [[CommentDraftDao sharedInstance] deleteCommentDraftInfo:self.draftCommentInfo];
            }
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            if (self.postDetailInfo.pid) {
                [dic setObject:self.postDetailInfo.pid forKey:@"postId"];
            }
            [dic setObject:@"2" forKey:@"isRefrese"];
            NSNotification * noti = [NSNotification notificationWithName:kNotificationRefreshPosts object:nil userInfo:dic];
            [[NSNotificationCenter defaultCenter] postNotification:noti];
            //获取帖子列表
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshComments object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshDrafts object:nil];
            if ([_strTag isEqualToString:@"PostDetailView"]){
                
                _block();
                
            }else if ([_strTag isEqualToString:@"PostDetailView2"]){
                
              _block();
                
            }else if ([_strTag isEqualToString:@"PostDetailView3"]){
                
                _block();
                
            } else{
                
//              _block();
                
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            AttentionView *attention = [[AttentionView alloc]initTitle:@"添加评论失败"];
            [self.view addSubview:attention];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
       
        NSString * str = [NSString stringWithFormat:@"%@",error.localizedDescription];
        AttentionView * attention = [[AttentionView alloc]initTitle:str andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return ;
    }];
}


#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.comment = textView.text;
}
- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isEqualToString:self.isDifference]) {
        self.isEdit = NO;
    }else{
        self.isEdit =YES;
        
    }
    NSUInteger lenth = 200 - textView.text.length;
    self.centerLabel.text = [NSString stringWithFormat:@"%ld",lenth];
    if (textView.text.length != 0) {
        if (textView.text.length >=200) {
//            textView.text = [textView.text substringWithRange:NSMakeRange(0, 200)];
//            NSUInteger lenth = 200 - textView.text.length;
//            self.centerLabel.text = [NSString stringWithFormat:@"%ld",lenth];
        }
        _button.userInteractionEnabled = YES;
         [_button setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
//        _button.alpha =1;
        _countView.hidden = NO;
    }else{
        
        _button.userInteractionEnabled = NO;
        [_button setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4] forState:UIControlStateNormal];
//        _button.alpha = 0.4;
        _countView.hidden = YES;
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
//    if([text isEqualToString:@"\n"]) {
//        [self.commentTextView resignFirstResponder];
//        return NO;
//    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.isDifference = textView.text;
    self.isDifferent = textView.text;
            _button.userInteractionEnabled = NO;
//        _button.alpha = 0.4;
        _countView.hidden = YES;
    return YES;
}
#pragma mark - Private Method
- (void)createUI {
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(358.0f))];
//    bgView.backgroundColor = I_COLOR_WHITE;
//    [self.view addSubview:bgView];
//    self.commentTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(TRANS_VALUE(5.0f), TRANS_VALUE(5.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(5.0f), TRANS_VALUE(320.0f))];
//   
//    _countView.hidden = YES;
//    self.commentTextView.inputAccessoryView = self.countView;
//    self.commentTextView.textColor = I_COLOR_33BLACK;
//    self.commentTextView.backgroundColor = I_COLOR_WHITE;
//    self.commentTextView.userInteractionEnabled = YES;
//    self.commentTextView.alpha = 1.0f;
//    self.commentTextView.tag = 10001;
//    [bgView addSubview:self.commentTextView];
//    self.commentTextView.delegate = self;
//    self.commentTextView.returnKeyType = UIReturnKeyDone;
    
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f)];
    self.mScrollView.showsHorizontalScrollIndicator = NO;
    self.mScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mScrollView];
    self.commentTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(TRANS_VALUE(8.0f), TRANS_VALUE(0.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(8.0f), TRANS_VALUE(180.0f))];
    self.commentTextView.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
    self.commentTextView.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    if (self.isComment) {
        self.commentTextView.placeHolder = @"写评论(不超过200字)...";
    }else{
        self.commentTextView.placeHolder = @"写回复(不超过200字)...";
    }
    self.countView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(30.0f))];
    UILabel * leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-TRANS_VALUE(140.0f), 5, TRANS_VALUE(30.0f), TRANS_VALUE(30.0f))];
    leftLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(15.0f)];
    leftLabel.textColor = [UIColor grayColor];
    leftLabel.text = @"还可输入";
    [leftLabel sizeToFit];
    [self.countView addSubview:leftLabel];
    
    UILabel * centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLabel.frame), 5, TRANS_VALUE(30.0f), TRANS_VALUE(30.0f))];
    centerLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(15.0f)];
    centerLabel.textAlignment = NSTextAlignmentCenter;
    centerLabel.textColor = [UIColor orangeColor];
    centerLabel.text = @"200";
    [centerLabel sizeToFit];
    self.centerLabel = centerLabel;
    [self.countView addSubview:self.centerLabel];
    
    UILabel * rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(centerLabel.frame), 5, TRANS_VALUE(30.0f), TRANS_VALUE(30.0f))];
    rightLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(15.0f)];
    rightLabel.textColor = [UIColor grayColor];
    rightLabel.text = @"个字";
    [rightLabel sizeToFit];
    [self.countView addSubview:rightLabel];
        _countView.hidden = YES;
        self.commentTextView.inputAccessoryView = self.countView;
    self.commentTextView.textColor = I_COLOR_33BLACK;
    self.commentTextView.delegate = self;
    [self.mScrollView addSubview:self.commentTextView];
    self.commentTextView.delegate = self;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(182.0f), SCREEN_WIDTH, 0)];
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
//    if([self.titleTextField isFirstResponder]) {
//        [self.titleTextField resignFirstResponder];
//    }
    if([self.contentTextView isFirstResponder]) {
        [self.contentTextView resignFirstResponder];
    }
    
    UIImageView *imageView = (UIImageView *)((UITapGestureRecognizer *)sender).view;
    NSInteger index = imageView.tag - 10000;
    self.selectPictureIndex = index;
    //图片删除或者添加操作
    if(self.pictureArray.count == 0) {
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
- (NSMutableArray *)pictureArray{
    if (!_pictureArray) {
        _pictureArray = [NSMutableArray array];
    }
    return _pictureArray;
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

@end
