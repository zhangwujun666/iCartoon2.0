//
//  PostDetailView.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/23.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "PostDetailView.h"
#import "UIImageView+Webcache.h"
#import "CommonUtils.h"
#import "ThemeDetailViewController.h"
#import "CommonUtils.h"
#import "PostDetailThemeBtn.h"
#import "UIImage+AssetUrl.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface PostDetailView()
@property(nonatomic, strong) NSArray* matches;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) PostDetailInfo *detailInfo;

@property (strong, nonatomic) UIImageView *avatarImageView;       //头像
@property (strong, nonatomic) UILabel *nicknameLabel;             //昵称
@property (strong, nonatomic) UIButton *timeButton;               //时间
@property (strong, nonatomic) PostDetailThemeBtn *themeButton;       //主题标签
@property (strong, nonatomic) UILabel *titleLabel;                //标题
@property (strong, nonatomic) PPLabel *contentLabel;              //内容
@property (strong, nonatomic) UIScrollView *contentScrollView;
@property (assign, nonatomic) CGFloat  kTitleX;//标记标签的动态X坐标
@end
@implementation PostDetailView

- (instancetype)initWithPostInfo:(PostDetailInfo *)detaiInfo andDataArray:(NSMutableArray *)dataArray{
    self.detailInfo = detaiInfo;
    if (dataArray.count != 0 || dataArray) {
        self.pictureArray = [dataArray copy];
    }
    self = [super initWithFrame:CGRectZero];
    if(self) {
        UIView *topView = [self topView];
        [self addSubview:topView];
        self.height = topView.frame.size.height;
        
        self.height += TRANS_VALUE(0.0f);
        //加载内容和图片
        UIView *imageContentView = [self imageContentView];
        [self addSubview:imageContentView];
        self.height += imageContentView.frame.size.height;
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
    }
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
    self.backgroundColor = I_BACKGROUND_COLOR;
    
    return self;
}

//加载顶部栏View
- (UIView *)topView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(45.0f))];
    view.backgroundColor = I_COLOR_WHITE;
    //头像
    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(11.0f), TRANS_VALUE(8.25f), TRANS_VALUE(27.5f), TRANS_VALUE(27.5f))];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = TRANS_VALUE(27.5f) / 2;
    self.avatarImageView.backgroundColor = I_COLOR_GRAY;
    [view addSubview:self.avatarImageView];
    NSString *avatarUrl = self.detailInfo.author.avatar;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_avatar_default"]];
    
    //昵称
    self.nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(52.0f), TRANS_VALUE(10.0f), TRANS_VALUE(90.0f), TRANS_VALUE(24.0f))];
    self.nicknameLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.5f)];
    self.nicknameLabel.textColor = I_COLOR_33BLACK;
    self.nicknameLabel.textAlignment = NSTextAlignmentLeft;
    self.nicknameLabel.numberOfLines = 1;
    [view addSubview:self.nicknameLabel];
    NSString *nickname = self.detailInfo.author.nickname != nil ? self.detailInfo.author.nickname : @"未知";
    self.nicknameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.nicknameLabel.text = nickname;
    [self showNickname:nickname];//详细页面名字要求5个字多余的用...表示
    
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authorButtonAction:)];
    self.avatarImageView.userInteractionEnabled = YES;
    [self.avatarImageView addGestureRecognizer:avatarTap];
    
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authorButtonAction:)];
    self.nicknameLabel.userInteractionEnabled = YES;
    [self.nicknameLabel addGestureRecognizer:nameTap];
    

    
    //主题标签
    self.themeButton = [[PostDetailThemeBtn alloc]init];
//                        initWithFrame:CGRectMake(TRANS_VALUE(190.0f), TRANS_VALUE(8.0f), TRANS_VALUE(150.0f), TRANS_VALUE(20.0f))];
    [self.themeButton setTitle:@"画江湖之不良人"];
    [self.themeButton setImage:@"ic_action_theme_undo"];
    self.themeButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(10.5f)];
    
//    _themeButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [view addSubview:self.themeButton];
    NSString *themeStr = self.detailInfo.theme.title != nil ? self.detailInfo.theme.title : @"";
    //TODO -- 主题标签最多显示7个字
    NSString *subThemeStr = themeStr.length >7 ? [NSString stringWithFormat:@"%@...", [themeStr substringWithRange:NSMakeRange(0, 7)]] : themeStr;

    [self showTitleName:subThemeStr];//标签文字超出7个字时出现的效果
    
    [self.themeButton addTarget:self action:@selector(themeButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    //时间
    self.timeButton = [[UIButton alloc] initWithFrame:CGRectMake(_kTitleX-TRANS_VALUE(80.0f), TRANS_VALUE(10.0f), TRANS_VALUE(80.0f), TRANS_VALUE(24.0f))];
    self.timeButton.backgroundColor = [UIColor clearColor];
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(9.0f)];
    [self.timeButton setTitleColor:I_COLOR_GRAY forState:UIControlStateNormal];
    [self.timeButton setTitle:@"3分钟前" forState:UIControlStateNormal];
    //    self.timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//时间居右
    [view addSubview:self.timeButton];
    NSString *timeStr = self.detailInfo.createTime != nil ? self.detailInfo.createTime : @"未知时间";
    if([timeStr isEqualToString:@"未知时间"]) {
        [self.timeButton setTitle:timeStr forState:UIControlStateNormal];
    } else {
        [self.timeButton setTitle:[timeStr substringWithRange:NSMakeRange(0, 11)]forState:UIControlStateNormal];
        
    }
    //分割线
    UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), TRANS_VALUE(44.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(0.0f), TRANS_VALUE(0.5f))];
    dividerView.backgroundColor = I_DIVIDER_COLOR;
    [view addSubview:dividerView];
    
    return view;
}

- (UIView *)imageContentView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = I_COLOR_WHITE;
    //标题
    NSString *titleStr = self.detailInfo.title != nil ? self.detailInfo.title : @"";
     NSString *dataGBKtitleStr = [titleStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CGFloat titleWidth = SCREEN_WIDTH - 2 * TRANS_VALUE(16.0f);
    CGFloat titleHeight = 0.0f;
    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:TRANS_VALUE(14.0f)],NSFontAttributeName, nil];
    CGSize titleSize = [dataGBKtitleStr boundingRectWithSize:CGSizeMake(titleWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil].size;
    titleHeight = titleSize.height + TRANS_VALUE(6.0f);
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(11.0f), TRANS_VALUE(8.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(16.0f), titleHeight)];
    self.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    self.titleLabel.textColor = I_COLOR_BLACK;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = dataGBKtitleStr;
    [view addSubview:self.titleLabel];
    
    CGFloat contentTop = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + TRANS_VALUE(0.0f);
    //加载文字
    NSString *contentStr = self.detailInfo.content != nil ? self.detailInfo.content : @"";
    NSMutableString *mstr = [NSMutableString stringWithString:contentStr];
//    NSLog(@"%@",contentStr);
    NSString *dataGBK1 = [mstr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableString * dataGBK = [NSMutableString stringWithString:dataGBK1];
//        NSLog(@"%@",dataGBK);
    for (int i = 0;  i < dataGBK.length; i++) {
        if ([dataGBK characterAtIndex:i] == '<' && i+1<dataGBK.length) {
            if ([dataGBK characterAtIndex:i+1] == 'b'&&i+2<dataGBK.length) {
                if ([dataGBK characterAtIndex:i+2] == 'r'&&i+4<dataGBK.length) {
                    [dataGBK replaceCharactersInRange:NSMakeRange(i, 5) withString:@"\n"];
                }
            }
        }
    }
    for (int i = 0;  i < dataGBK.length; i++) {
        if ([dataGBK characterAtIndex:i] == '<'&& i+1<dataGBK.length) {
            if ([dataGBK characterAtIndex:i+1] == '/'&&i+2<dataGBK.length) {
                if ([dataGBK characterAtIndex:i+2] == 'p'&&i+3<dataGBK.length) {
                    [dataGBK replaceCharactersInRange:NSMakeRange(i, 4) withString:@"\n"];
                }
            }
        }
    }
//    NSLog(@"----------------%c",[dataGBK characterAtIndex:0]);
    NSString * mstrq = [self filterHTML:dataGBK];
    mstrq = [mstrq stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    mstrq = [mstrq stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    mstrq = [mstrq stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
     mstrq = [mstrq stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    mstrq = [mstrq stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    mstrq = [mstrq stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc]initWithData:[mstrq dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [aAttributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x858585)range:NSMakeRange(0, aAttributedString.length)];
    [aAttributedString addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:TRANS_VALUE(12.0f)]
                              range:NSMakeRange(0, aAttributedString.length)];
    CGFloat labelWidth = SCREEN_WIDTH - 2 * TRANS_VALUE(11.0f);
    CGFloat labelHeight = 0.0f;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:TRANS_VALUE(12.0f)],NSFontAttributeName, nil];
    CGSize size = [mstrq boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    labelHeight = size.height + TRANS_VALUE(6.0f);
    labelHeight = ceil(labelHeight);
    self.contentLabel = [[PPLabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(11.0f), contentTop, labelWidth, labelHeight)];
    self.contentLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
    self.contentLabel.textColor = I_COLOR_DARKGRAY;
//    self.contentLabel.backgroundColor = [UIColor redColor];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = mstrq;
//    self.contentLabel.text = mstr;
    [view addSubview:self.contentLabel];
    self.contentLabel.delegate = self;
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    self.matches = [detector matchesInString:self.contentLabel.text options:0 range:NSMakeRange(0, self.contentLabel.text.length)];
    
    [self highlightLinksWithIndex:NSNotFound];
    CGFloat scrollMarginTop = self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + TRANS_VALUE(1.0f);
   
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    CGFloat scrollHeight = TRANS_VALUE(0.0f);
    //加载图片
    NSMutableArray *imageArray = self.detailInfo.images;
    CGFloat imageX = TRANS_VALUE(0.0f);
    CGFloat imageY = TRANS_VALUE(5.0f);
    CGFloat width = SCREEN_WIDTH - 2 * TRANS_VALUE(11.0f);
    CGFloat imageWidth = SCREEN_WIDTH - 2 * TRANS_VALUE(11.0f);
  __block  CGFloat imageHeight = TRANS_VALUE(0.0f);
    NSInteger imageViewTag = 20000;
    if(imageArray && imageArray.count > 0) {
        for(int i = 0, n = (int)[imageArray count]; i < n; i++) {
            PostPictureInfo *pictureInfo = (PostPictureInfo *)[self.detailInfo.images objectAtIndex:i];
             UIImageView *imageView = [[UIImageView alloc]init];
            NSString *imagePath = pictureInfo.imageUrl;
//            imagePath = [NSString stringWithFormat:@"%@%@",imagePath,@"_500x500"];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
            CGSize size = CGSizeZero;
            if (imageView.image) {
                size = imageView.image.size;
            }
            if (size.width) {
               imageHeight = ceil(size.height / size.width  * width );
            }else{
                if (self.pictureArray || self.pictureArray != 0) {
                    UIImage * image1 = self.pictureArray[i];
                    if (image1.size.width == 0) {
                        return 0;
                    }
                    imageHeight = ceil(image1.size.height / image1.size.width  * width );
                }
                
            }
            imageWidth = width;
             imageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
            imageView.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
            imageView.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1.0f];
            
            imageView.tag = imageViewTag + i;
            [self.contentScrollView addSubview:imageView];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tapGesture];
           
            imageY += (imageHeight + TRANS_VALUE(4.0f));
        }
        scrollHeight = imageY - TRANS_VALUE(8.0f);
    }
    
    self.contentScrollView.frame = CGRectMake(TRANS_VALUE(11.0f), scrollMarginTop, SCREEN_WIDTH - 2 * TRANS_VALUE(11.0f), scrollHeight);
    self.contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH - 2 * TRANS_VALUE(11.0f), scrollHeight);
    self.contentScrollView.scrollEnabled = NO;
    [view addSubview:self.contentScrollView];
    
    CGFloat viewHeight = self.contentScrollView.frame.origin.y + self.contentScrollView.frame.size.height + TRANS_VALUE(8.0f);
    viewHeight = floor(viewHeight + 1);
    view.frame = CGRectMake(0, self.height, SCREEN_WIDTH, viewHeight);
    
    return view;
}
- (void)label:(PPLabel *)label didBeginTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    [self highlightLinksWithIndex:charIndex];
}

- (void)label:(PPLabel *)label didMoveTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    
    [self highlightLinksWithIndex:charIndex];
}

- (void)label:(PPLabel *)label didEndTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    
    [self highlightLinksWithIndex:NSNotFound];
    
    for (NSTextCheckingResult *match in self.matches) {
        
        if ([match resultType] == NSTextCheckingTypeLink) {
            
            NSRange matchRange = [match range];
            
            if ([self isIndex:charIndex inRange:matchRange]) {
                
                [[UIApplication sharedApplication] openURL:match.URL];
                break;
            }
        }
    }
    
}

- (void)label:(PPLabel *)label didCancelTouch:(UITouch *)touch {
    
    [self highlightLinksWithIndex:NSNotFound];
}

#pragma mark -

- (BOOL)isIndex:(CFIndex)index inRange:(NSRange)range {
    return index > range.location && index < range.location+range.length;
}

- (void)highlightLinksWithIndex:(CFIndex)index {
    
    NSMutableAttributedString* attributedString = [self.contentLabel.attributedText mutableCopy];
//     NSLog(@"-------------0----------%@",self.contentLabel.attributedText);
    
    for (NSTextCheckingResult *match in self.matches) {
        
        if ([match resultType] == NSTextCheckingTypeLink) {
            
            NSRange matchRange = [match range];
            
            if ([self isIndex:index inRange:matchRange]) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:matchRange];
            }
            else {
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:matchRange];
            }
            
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:matchRange];
        }
    }
    
    self.contentLabel.attributedText = attributedString;
}

-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
//        NSString * regEx = @"<([^>]*)>";
//        html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//}

#pragma mark - Action
- (void)themeButtonAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(themeClickAtItem:)]) {
        if(!self.detailInfo.theme) {
            return;
        }
        [self.delegate themeClickAtItem:self.detailInfo.theme];
    }
}

- (void)authorButtonAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(authorClickAtItem:)]) {
        if(!self.detailInfo.author) {
            return;
        }
        [self.delegate authorClickAtItem:self.detailInfo.author];
    }
}

- (void)imageTapAction:(UITapGestureRecognizer *)sender {
    UIImageView *view = (UIImageView *)((UITapGestureRecognizer *)sender).view;
    NSInteger index = view.tag - 20000;
    if([self.delegate respondsToSelector:@selector(pictureClickAtIndex:forImages:)]) {
        [self.delegate pictureClickAtIndex:index forImages:self.detailInfo.images];
    }
}


- (void)showNickname:(NSString  *)Nickname{
    
    if (Nickname.length > 8) {
        
        Nickname = [Nickname substringToIndex:8];
        NSString *nickNameStr = Nickname;
        
        self.nicknameLabel.text = [NSString  stringWithFormat:@"%@...",nickNameStr];
        
    }else{
        
        self.nicknameLabel.text = [NSString  stringWithFormat:@"%@",Nickname];
    }
    
}


- (void)showTitleName:(NSString  *)TitleName{
    
    
    //先对字符串长度进行处理  格式化后再算lable的长度
//    if (TitleName.length > 10) {
//        
//        NSString  * a = [TitleName substringToIndex:5];
//        NSString * b = [TitleName  substringFromIndex:TitleName.length-5];
//        
//        
//         TitleName = [NSString  stringWithFormat:@"%@...%@",a,b];
//    if (TitleName.length > 7) {
//        
//        NSString  * a = [TitleName substringToIndex:8];
//
//        
//        
//        TitleName = [NSString  stringWithFormat:@"%@...",a];
//    
//       [self.themeButton setTitle:TitleName forState:UIControlStateNormal];
//  
////          self.themeButton.frame =CGRectMake(TRANS_VALUE(190.0f), TRANS_VALUE(8.0f), TRANS_VALUE(135.0f), TRANS_VALUE(20.0f));
//        
////        _kTitleX = TRANS_VALUE(190.0f);
//        
//    }
//    else{
//    
        [self.themeButton setTitle:TitleName forState:UIControlStateNormal];
//
//       
//
//    }
    
    
    CGSize titleSize = [TitleName sizeWithFont:[UIFont systemFontOfSize:TRANS_VALUE(10.0f)] constrainedToSize:CGSizeMake(MAXFLOAT, TRANS_VALUE(20.0f))];
    
    
    self.themeButton.frame =CGRectMake(TRANS_VALUE(190.0f)+TRANS_VALUE(137.5f)-TRANS_VALUE(30.0f)-TRANS_VALUE(titleSize.width), TRANS_VALUE(8.0f), TRANS_VALUE(titleSize.width)+TRANS_VALUE(43.0f), TRANS_VALUE(20.0f));
    
    
    _kTitleX = TRANS_VALUE(190.0f)+TRANS_VALUE(137.5f)-TRANS_VALUE(30.0f)-TRANS_VALUE(titleSize.width);
    
}


@end
