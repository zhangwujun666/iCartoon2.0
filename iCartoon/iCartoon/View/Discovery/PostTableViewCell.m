//
//  DiscoveryTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "PostTableViewCell.h"
#import "PostInfo.h"
#import "UIImageView+Webcache.h"
#import "CommonUtils.h"
#import "PostThemeButton.h"
#import "PostActionButton.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "LookBigPicViewController.h"
#import "Context.h"
@interface PostTableViewCell(){ UIImageView *indicatorImgView;}

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIView *topDivider;
//@property (strong, nonatomic) UILabel *titleLabel;
//@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIView *detailView;
@property (strong, nonatomic) UIView *bottomDivider;
@property (strong, nonatomic) PostThemeButton *themeButton;
@property (strong, nonatomic) PostActionButton *commentButton;
@property (strong, nonatomic) PostActionButton *favorButton;
@property (strong, nonatomic) UIImageView *divider01;
@property (strong, nonatomic) UIImageView *divider02;
@property (strong, nonatomic) UIView *divider03;
@property (strong, nonatomic) UIView *topDividerView;
@property (strong, nonatomic) UIView *dividerView;
@property (strong ,nonatomic)UIButton * btn;//当管理时   cell上出现的遮罩
@property (strong,nonatomic)NSMutableArray *imageArray;
@end

@implementation PostTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        if (!indicatorImgView) {
            CGRect indicatorFrame = CGRectMake(-30.0f, CONVER_VALUE(18.0f), CONVER_VALUE(15.0f), CONVER_VALUE(15.0f));
            indicatorImgView = [[UIImageView alloc] initWithFrame:indicatorFrame];
            [self.contentView addSubview:indicatorImgView];
        }
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changPicture) name:@"changPicture" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changPictureBack) name:@"changPictureBack" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideBox) name:@"hideBox" object:nil];
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(214.0f))];
        self.bgView.backgroundColor = I_COLOR_WHITE;
            [self.contentView addSubview:self.bgView];
        self.topDividerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5f)];
        self.topDividerView.backgroundColor = I_DIVIDER_COLOR;
        [self.bgView addSubview:self.topDividerView];
        self.topDividerView.hidden = YES;
        //选择框
         self.checkBox = [[UIButton alloc] init];
        [self.bgView addSubview:self.checkBox];
        [self.checkBox setImage:[UIImage imageNamed:@"ic_message_off"] forState:UIControlStateNormal];
        [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bgView.mas_left).offset(CONVER_VALUE(3.5f));
            make.size.mas_equalTo(CGSizeMake(TRANS_VALUE(30.0f), TRANS_VALUE(30.0f)));
            make.top.mas_equalTo(self.bgView.mas_top).offset(11.25f);
        }];
        self.checkBox.hidden = YES;
        [self.checkBox addTarget:self action:@selector(checkBoxItemSelected:) forControlEvents:UIControlEventTouchUpInside];
        self.avatarImageView = [[UIImageView alloc]init];
         [self.bgView addSubview:self.avatarImageView];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bgView.mas_left).offset(11.0f);
            make.size.mas_equalTo(CGSizeMake(TRANS_VALUE(27.5f), TRANS_VALUE(27.5f)));
            make.top.mas_equalTo(self.bgView.mas_top).offset(TRANS_VALUE(7.5));
        }];
//        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImageView.clipsToBounds = YES;
           self.avatarImageView.layer.cornerRadius =TRANS_VALUE(27.5f)/2;
        self.avatarImageView.image = [UIImage imageNamed:@"ic_topic_button_3"];
        self.avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarClick:)];
        [self.avatarImageView addGestureRecognizer:tap];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(44.0f), TRANS_VALUE(14.5f), TRANS_VALUE(166), TRANS_VALUE(20.0f))];
        [self.nameLabel sizeToFit];
        [self.bgView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarImageView.mas_right).offset(15);
            make.top.mas_equalTo(self.bgView.mas_top).offset(TRANS_VALUE(14.5f));
        }];
        self.nameLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.5f)];
        self.nameLabel.textColor = I_COLOR_BLACK;
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(200.0f), TRANS_VALUE(11.25f), TRANS_VALUE(110.0f), TRANS_VALUE(20.0f))];
        self.timeLabel.textColor = UIColorFromRGB(0x979797);
        self.timeLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(10.5f)];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.bgView addSubview:self.timeLabel];
        
        self.topDivider = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), TRANS_VALUE(42.5f), SCREEN_WIDTH - 2 * TRANS_VALUE(0.0f), 0.5f)];
        self.topDivider.backgroundColor = RGBCOLOR(231, 231, 231);
//        self.topDivider.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:self.topDivider];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(11.0f), TRANS_VALUE(44.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(11.0f), TRANS_VALUE(22.0f))];
        self.titleLabel.textColor = I_COLOR_33BLACK;
        self.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
        self.titleLabel.numberOfLines = 1;
//        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingHead;
        
        self.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
        [self.bgView addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(61.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f), TRANS_VALUE(23.0f))];
         self.contentLabel.textColor = I_COLOR_DARKGRAY;
         self.contentLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
         self.contentLabel.numberOfLines = 3;
        [self.bgView addSubview: self.contentLabel];
        
        self.detailView = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(84.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(11.0f), TRANS_VALUE(0.0f))];
        [self.contentView addSubview:self.detailView];
        
        self.bottomDivider = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), TRANS_VALUE(189.0f), SCREEN_WIDTH, 0.5f)];
        self.bottomDivider.backgroundColor = RGBCOLOR(231, 231, 231);
        [self.bgView addSubview:self.bottomDivider];
        self.themeButton = [[PostThemeButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(11.0f), TRANS_VALUE(189.0f), TRANS_VALUE(130.0f), TRANS_VALUE(25.0f))];
        [self.themeButton setTitle:@"画江湖之不良人"];
        [self.themeButton setImage:@"ic_action_theme_undo"];
        [self.bgView addSubview:self.themeButton];
        self.themeButton.titleLabel.font=[UIFont systemFontOfSize:TRANS_VALUE(10.0f)];
        self.themeButton.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
        //[self.themeButton setUserInteractionEnabled:NO];
        
        self.commentButton = [[PostActionButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(218.0f), TRANS_VALUE(189.0f), TRANS_VALUE(50.0f), TRANS_VALUE(25.0f))];
      
        [self.commentButton setTitle:@"5"];
        [self.commentButton setImage:@"ic_action_comment_undo"];
        self.commentButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(10.0f)];
        [self.bgView addSubview:self.commentButton];
        //[self.commentButton setUserInteractionEnabled:NO];
        self.favorButton = [[PostActionButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(270.0f), TRANS_VALUE(189.0f), TRANS_VALUE(50.0f), TRANS_VALUE(25.0f))];
       // self.favorButton = [[PostActionButton alloc]init];
        [self.favorButton setTitle:@"27"];
        self.favorButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(10.0f)];
        [self.favorButton setImage:@"ic_action_favor_undo"];
        [self.bgView addSubview:self.favorButton];
        
        self.divider01 = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(217.0f), TRANS_VALUE(192.0f), 1.0f, TRANS_VALUE(17.0f))];
//        self.divider01.backgroundColor = I_DIVIDER_COLOR;
        
        _divider01.image = [UIImage imageNamed:@"ic_post_midline"];
        [self.bgView addSubview:self.divider01];
        
        self.divider02 = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(270.0f), TRANS_VALUE(192.0f), 1.0f, TRANS_VALUE(17.0f))];
        
         _divider02.image = [UIImage imageNamed:@"ic_post_midline"];
//        self.divider02.backgroundColor = I_DIVIDER_COLOR;
        [self.bgView addSubview:self.divider02];
        
        self.dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bgView.frame.size.height - 0.5f, SCREEN_WIDTH, 0.5f)];
        self.dividerView.backgroundColor = I_DIVIDER_COLOR;
        [self.bgView addSubview:self.dividerView];
        
        _btn  = [[UIButton  alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        [_btn  addTarget:self action:@selector(checkBoxItemSelected:) forControlEvents:UIControlEventTouchUpInside];
        _btn.userInteractionEnabled = NO;
        _btn.hidden = YES;
        [self.contentView addSubview:_btn];
    }
  [self.themeButton addTarget:self action:@selector(themeTapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.favorButton addTarget:self action:@selector(favorAction) forControlEvents:UIControlEventTouchUpInside];

    
    self.backgroundColor = I_BACKGROUND_COLOR;
    
    return self;
}
- (void)avatarClick:(UITapGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(clickAuthorAtItem:indexPath:)]) {
        [self.delegate clickAuthorAtItem:self.postItem indexPath:self.indexPath];
    }
}
- (void)hideBox{
    self.checkBox.hidden = YES;
    [self backState];
}
- (void)setPostItem:(PostInfo *)postItem {
    _postItem = postItem;
    if(!_postItem) {
        return;
    }
    self.tag = [self.postItem.pid integerValue];
    AuthorInfo *userInfo = _postItem.author;
    NSString *avatarUrl = userInfo.avatar;
      NSString *nickname = nil;
    if (userInfo.nickname) {
         nickname = userInfo.nickname;
    }else{
        nickname = [Context sharedInstance].userInfo.nickname;
    }
    [self  showNickname:nickname];//限制昵称15个字
    self.nameLabel.text = [NSString  stringWithFormat:@"%@",nickname];
    if (avatarUrl) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_avatar_default"]];
    }else{
        NSString * avatar = [Context sharedInstance].userInfo.avatar;
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"ic_avatar_default"]];
    }
    NSString *timeStr = _postItem.createTime != nil ? _postItem.createTime : @"刚刚";
    if([timeStr isEqualToString:@"刚刚"]) {
        self.timeLabel.text = timeStr;
//        self.timeLabel.text = [timeStr substringWithRange:NSMakeRange(5, 11)];
    } else {
        if ([[CommonUtils prettyDateWithReference:timeStr] isEqualToString:@"CommonUtils"]) {
            self.timeLabel.text = [timeStr substringWithRange:NSMakeRange(5, 11)];
        }else{
             self.timeLabel.text = [CommonUtils prettyDateWithReference:timeStr];
        }
}
    NSString *title = _postItem.title != nil ? _postItem.title : @"";
    NSString *dataGBKtitle = [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.titleLabel.text = dataGBKtitle;
    NSString *theme = @"画江湖之不良人";
    theme = _postItem.theme.title != nil ? _postItem.theme.title : @"";
    [self.themeButton setTitle:theme];
    NSString *commentCount = _postItem.commentCount != nil ? _postItem.commentCount : @"0";
    [self.commentButton setTitle:commentCount];
    if([_postItem.favorStatus isEqualToString:@"1"]) {
        [self.favorButton setImage:@"ic_action_favor_done"];
    } else {
        [self.favorButton setImage:@"ic_action_favor_undo"];
    }
    NSString *favorCount = _postItem.favorCount != nil ? _postItem.favorCount : @"0";
    
    [_favorButton   setTitle:favorCount];
//    [self  showTitleNum:favorCount];
    
    NSString *content = _postItem.content != nil ? _postItem.content : @"";
//    NSLog(@"content ====== %@",content);
    NSString * mstr = [NSString stringWithString:content];
    mstr = [mstr stringByReplacingOccurrencesOfString:@"+" withString:@""];
      NSString *dataGBK = [mstr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableString * str = nil;
    dataGBK = [dataGBK stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    dataGBK = [dataGBK stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    dataGBK = [dataGBK stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    dataGBK = [dataGBK stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    dataGBK = [dataGBK stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    dataGBK = [dataGBK stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    if (dataGBK) {
        str = [NSMutableString stringWithString:dataGBK];
    }
    for (int i = 0;  i < str.length; i++) {
        if ([str characterAtIndex:i] == '<' && i+1 < str.length) {
            if ([str characterAtIndex:i+1] == 'b' && i+2 < str.length) {
                if ([str characterAtIndex:i+2] == 'r' && i+4<str.length) {
                    [str replaceCharactersInRange:NSMakeRange(i, 5) withString:@"\n"];
                }
            }
        }
    }
    for (int i = 0;  i < str.length; i++) {
        if ([str characterAtIndex:i] == '<' && i+1<str.length) {
            if ([str characterAtIndex:i+1] == '/'&& i+2<str.length) {
                if ([str characterAtIndex:i+2] == 'p' && i+3<str.length) {
                    [str replaceCharactersInRange:NSMakeRange(i, 4) withString:@"\n"];
                }
            }
        }
    }

//    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc]initWithData:[dataGBK dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//    [aAttributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x858585)range:NSMakeRange(0, aAttributedString.length)];
//    [aAttributedString addAttribute:NSFontAttributeName
//                              value:[UIFont systemFontOfSize:TRANS_VALUE(12.0f)]
//                              range:NSMakeRange(0, aAttributedString.length)];
//    NSLog(@"aAttributedString ======= %@",aAttributedString);
     NSString * mstrq = [self filterHTML:dataGBK];
        self.contentLabel.text = mstrq;
    //加载图片
    for(UIView *view in self.detailView.subviews) {
        [view removeFromSuperview];
    }
    NSMutableArray *images = _postItem.images;
    CGFloat imgWidth = TRANS_VALUE(96.0f);
    CGFloat imgHeight = TRANS_VALUE(96.0f);
    CGFloat imgMargin = (SCREEN_WIDTH - 2 * TRANS_VALUE(11.0f) - 3 * imgWidth) / 2;
    CGFloat x = TRANS_VALUE(11.0f);
    CGFloat y = 0.0f;
    NSInteger count = images.count;
        for(int i = 1; i <= count ; i++) {
            PostPictureInfo *pictureInfo = (PostPictureInfo *)[images objectAtIndex:i-1];
            if ([[images objectAtIndex:i-1] isKindOfClass:[PostPictureInfo class]]) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imgWidth, imgHeight)];
                imageView.backgroundColor = I_BACKGROUND_COLOR;
                NSString *imagePath = pictureInfo.imageUrl;
//                imagePath = [NSString stringWithFormat:@"%@%@",imagePath,@"_500x500"];
                [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
                imageView.contentMode =  UIViewContentModeScaleAspectFill;
                imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                imageView.clipsToBounds  = YES;
                [self.detailView addSubview:imageView];
                [imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@""]];
                x += (imgWidth + imgMargin);
                imageView.tag = i-1;
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapclick:)];
                [imageView addGestureRecognizer:tap];
            }else{
                self.imageArray = [NSMutableArray array];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imgWidth, imgHeight)];
                imageView.backgroundColor = I_BACKGROUND_COLOR;
                NSData *imagePath = images[i-1];
                [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
                imageView.contentMode =  UIViewContentModeScaleAspectFill;
                imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                imageView.clipsToBounds  = YES;
                [self.detailView addSubview:imageView];
                imageView.image = [UIImage imageWithData: imagePath];
                [self.imageArray addObject:imageView.image];
                //            [imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@""]];
                x += (imgWidth + imgMargin);
                imageView.tag = i-1;
                //             self.userInteractionEnabled = NO;
                self.selectionStyle = UITableViewCellSelectionStyleNone;
                imageView.userInteractionEnabled = YES;
                
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick1:)];
                [imageView addGestureRecognizer:tap];
            }
        }
        [self layoutSubviews];
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

- (void)imageClick1:(UITapGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)((UITapGestureRecognizer *)sender).view;
    NSInteger index = imageView.tag;
    NSMutableArray *photoArray = [[NSMutableArray alloc] init];
    for (int i = 0;i< _postItem.images.count; i ++) {
        UIImage *image = [UIImage imageWithData:_postItem.images[i]];
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

-(void)showNickname:(NSString*)nickName{
    
    if (nickName.length > 15) {
        
        nickName = [nickName substringToIndex:15];
        NSString *nickNameStr = nickName;
        self.nameLabel.text = [NSString  stringWithFormat:@"%@",nickNameStr];
        
    }else{
     
        
    }
 
    
}
- (void)tapclick:(UITapGestureRecognizer *)sender{
    LookBigPicViewController *picVC = [[LookBigPicViewController alloc] init];
    NSMutableArray *thumbnailArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *pictureArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
    for(PostPictureInfo *pictureInfo in self.postItem.images) {
        [thumbnailArray addObject:pictureInfo.imageUrl];
        [pictureArray addObject:pictureInfo.imageUrl];
        [titleArray addObject:@""];
    }
    [picVC initWithAllBigUrlArray:pictureArray andSmallUrlArray:thumbnailArray andTargets:self andIndex:sender.view.tag];
    [picVC bigPicDescribe:titleArray];
    [picVC pushChildViewControllerFromCenter];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
  
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        if (self.isEditing) {
          //  self.avatarImageView.hidden = YES;
            if (_mSelected) {
                [indicatorImgView setImage:[UIImage imageNamed:@"ic_message_on"]];
            }else{
                [indicatorImgView setImage:[UIImage imageNamed:@"ic_message_off"]];
            }
        } else{
           // self.avatarImageView.hidden = NO;
        }
        [UIView commitAnimations];
    
    _btn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.avatarImageView.frame = CGRectMake(TRANS_VALUE(11.0f), TRANS_VALUE(6.0f), TRANS_VALUE(27.5f), TRANS_VALUE(27.5f));
    self.nameLabel.frame = CGRectMake(TRANS_VALUE(44.0f), TRANS_VALUE(14.5f), TRANS_VALUE(190), TRANS_VALUE(20.0f));
    self.timeLabel.frame = CGRectMake(TRANS_VALUE(200.0f), TRANS_VALUE(11.25f), TRANS_VALUE(110.0f), TRANS_VALUE(20.0f));
    self.topDivider.frame = CGRectMake(TRANS_VALUE(0.0f), TRANS_VALUE(42.5f), SCREEN_WIDTH - 2 * TRANS_VALUE(0.0f), 0.5f);
    self.titleLabel.frame = CGRectMake(TRANS_VALUE(11.0f), TRANS_VALUE(46.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(11.0f), TRANS_VALUE(35.0f));
    CGFloat width = SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f);
    NSString *contentStr = _postItem.content;
    CGFloat fontSize = TRANS_VALUE(12.0f);
    CGFloat labelHeight = [PostTableViewCell labelHeight:contentStr width:width fontSize:fontSize];
    self.contentLabel.frame = CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(72.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f), labelHeight);
    //图片布局
//    CGFloat imgWidth = TRANS_VALUE(96.0f);
//    CGFloat imgHeight = TRANS_VALUE(96.0f);
//    CGFloat imgMargin = (SCREEN_WIDTH - 2 * TRANS_VALUE(11.0f) - 3 * imgWidth) / 2;
    CGFloat imgMargin = TRANS_VALUE(1.7f);
    CGFloat imgWidth = (SCREEN_WIDTH - 2 *TRANS_VALUE(11.0f)-TRANS_VALUE(1.7f) * 2)/3;
    CGFloat imgHeight = imgWidth;
    CGFloat x = TRANS_VALUE(0.0f);
    CGFloat y = TRANS_VALUE(12.0f);
    NSArray *images = _postItem.images;
    for(int i = 1; i <= images.count; i++) {
        UIImageView *imageView = (UIImageView *)[self.detailView.subviews objectAtIndex:i-1];
        if (images.count == 1) {
            imgHeight = (SCREEN_WIDTH-2*TRANS_VALUE(11.0f))*0.6;
            imgWidth = imgHeight*0.6;
            imageView.frame = CGRectMake(x, y, (SCREEN_WIDTH-2*TRANS_VALUE(11.0f))*0.6, (SCREEN_WIDTH-2*TRANS_VALUE(11.0f))*0.6);
        }else if (images.count == 2){
             imgHeight =  (SCREEN_WIDTH-2*TRANS_VALUE(11.0f)-imgMargin)/2;
             imgWidth = imgHeight;
         imageView.frame = CGRectMake((SCREEN_WIDTH / 2-TRANS_VALUE(10.0f))*(i-1), y, imgHeight, imgHeight);
            
        }else if (images.count == 4){
            imgHeight =  (SCREEN_WIDTH-2*TRANS_VALUE(11.0f)-imgMargin)/2;
             imgWidth = imgHeight;
            imageView.frame = CGRectMake(x, y, imgHeight, imgHeight);
        }else{
            imgHeight = imgHeight;
             imgWidth = imgHeight;
            imageView.frame = CGRectMake(x, y, imgWidth, imgHeight);
        }
        if (images.count == 4) {
            if(i % 2 == 0 && i > 0) {
                x = TRANS_VALUE(0.0f);
                y += (imgHeight + imgMargin);
            } else {
                x += (imgWidth + imgMargin);
                y = y;
            }
        }else{
            if(i % 3 == 0 && i > 0) {
                x = TRANS_VALUE(0.0f);
                y += (imgHeight + imgMargin);
            } else {
                x += (imgWidth + imgMargin);
                y = y;
            }
        }
 }
    CGFloat detailHeight = y + imgHeight + TRANS_VALUE(7.0f)+labelHeight+imgMargin+TRANS_VALUE(8.5f);
    if (images.count == 3 || images.count == 4 ||images.count == 6||images.count == 9) {
        detailHeight = y + TRANS_VALUE(7.0f)+labelHeight+TRANS_VALUE(8.5f);
    }
    
    if(images.count == 0) {
        detailHeight = detailHeight - imgHeight-TRANS_VALUE(8.5f);
    }
    CGFloat marginTop = TRANS_VALUE(62.0f);
    self.detailView.frame = CGRectMake(TRANS_VALUE(11.0f), marginTop+labelHeight+TRANS_VALUE(1.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(11.0f), detailHeight-labelHeight-TRANS_VALUE(15.0f));
    CGFloat bottomMarginTop = marginTop + detailHeight - TRANS_VALUE(9.0f);
    self.bottomDivider.frame = CGRectMake(TRANS_VALUE(0.0f), bottomMarginTop, SCREEN_WIDTH, 0.5f);
    self.themeButton.frame = CGRectMake(TRANS_VALUE(12.0f), bottomMarginTop + TRANS_VALUE(1.0f), TRANS_VALUE(150.0f), TRANS_VALUE(24.0f));
    self.commentButton.frame = CGRectMake(TRANS_VALUE(190.0f), bottomMarginTop + TRANS_VALUE(1.0f), TRANS_VALUE(50.0f), TRANS_VALUE(24.0f));
    self.favorButton.frame = CGRectMake(TRANS_VALUE(260.0f), bottomMarginTop + TRANS_VALUE(1.0f), TRANS_VALUE(50.0f), TRANS_VALUE(24.0f));

    self.divider01.frame = CGRectMake(TRANS_VALUE(180.0f), bottomMarginTop + TRANS_VALUE(4.0f), TRANS_VALUE(0.5f), TRANS_VALUE(19.0f));
    self.divider02.frame = CGRectMake(TRANS_VALUE(250.0f), bottomMarginTop + TRANS_VALUE(4.0f), TRANS_VALUE(0.5f), TRANS_VALUE(19.0f));
    
    CGFloat bgHeight = bottomMarginTop +  2 * TRANS_VALUE(1.0f) + TRANS_VALUE(24.0f);
    self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, bgHeight);
    self.dividerView.frame = CGRectMake(0, self.bgView.frame.size.height - 1.0f, SCREEN_WIDTH, 1.0f);
}



+ (CGFloat)heightForCell:(NSIndexPath *)indexPath withCommentInfo:(PostInfo *)postInfo {
    CGFloat height = TRANS_VALUE(62.0f);
    if(postInfo.content) {
        CGFloat width = SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f);
        NSString *contentStr = postInfo.content;
        CGFloat fontSize = TRANS_VALUE(12.0f);
        CGFloat labelHeight = [PostTableViewCell labelHeight:contentStr width:width fontSize:fontSize];
        height += labelHeight;
    }
    CGFloat imgMargin = TRANS_VALUE(3.0f);
    CGFloat imgWidth = (SCREEN_WIDTH - 2 *TRANS_VALUE(11.0f)-imgMargin* 2)/3;
    CGFloat imgHeight = imgWidth;
    CGFloat x = TRANS_VALUE(0.0f);
    CGFloat y = 0.0f;
    NSArray *images = postInfo.images;
    for(int i = 0; i < images.count; i++) {

        if (images.count == 1) {
            //imgHeight = TRANS_VALUE(224.0f);
            imgHeight =(SCREEN_WIDTH-2*TRANS_VALUE(11.0f))*0.6;
            
        }else if (images.count == 2 ||images.count == 4){
            
            imgHeight =  (SCREEN_WIDTH-2*TRANS_VALUE(11.0f)-imgMargin)/2;
            
        }else{
        
        }
    }
    
    for(int i = 0; i < images.count ; i++) {
        if (images.count == 4) {
            if(i % 2 == 0 && i > 0) {
                x = TRANS_VALUE(0.0f);
                y += (imgHeight + imgMargin);
            } else {
                x += (imgWidth + imgMargin);
                y = y;
            }
        }else{
            if(i % 3 == 0 && i > 0) {
                x = TRANS_VALUE(0.0f);
                y += (imgHeight + imgMargin);
            } else {
                x += (imgWidth + imgMargin);
                y = y;
            }
        }
    }
    CGFloat detailHeight = y + imgHeight + TRANS_VALUE(7.0f);
    if(images.count == 0) {
        detailHeight = detailHeight - imgHeight-TRANS_VALUE(8.5f);
    }
    height += detailHeight;
    
    height += TRANS_VALUE(50.0f);
    
    
    return height;
}

+ (CGFloat)labelHeight:(NSString *)contentStr width:(CGFloat)width fontSize:(CGFloat)fontSize {
    CGFloat height = 0.0f;
     NSString *dataGBK = [contentStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if(contentStr) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil];
        CGRect rect = [dataGBK boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        CGFloat labelHeight = floor(rect.size.height + 1);
        if(labelHeight < TRANS_VALUE(25.0f)) {
            labelHeight = TRANS_VALUE(25.0f);
        }
        else if (labelHeight > 45) {
             labelHeight = TRANS_VALUE(55.0f);
        } else{
            labelHeight += TRANS_VALUE(10.0f);
        }
 
        height += labelHeight;
    } else {
        height += TRANS_VALUE(0.0f);
    }
    return height;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat titleMarginLeft = TRANS_VALUE(18.0f);
    CGFloat titleMarginTop = (height - TRANS_VALUE(20.0f)) / 2;
    CGFloat titleWidth = width - TRANS_VALUE(32.0f);
    CGFloat titleHeight = TRANS_VALUE(20.0f);
    return CGRectMake(titleMarginLeft, titleMarginTop, titleWidth, titleHeight);
}

//管理
- (void)changeState{
    [self.avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(44.0f);
        make.size.mas_equalTo(CGSizeMake(TRANS_VALUE(27.5f), TRANS_VALUE(27.5)));
        make.top.mas_equalTo(self.bgView.mas_top).offset(TRANS_VALUE(7.5));
    }];
    self.checkBox.hidden = NO;
    _btn.userInteractionEnabled = YES;
    _btn.hidden = NO;
    
    
    
}
//取消
- (void)backState{
    [self.avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(11.0f);
        make.size.mas_equalTo(CGSizeMake(TRANS_VALUE(27.5f), TRANS_VALUE(27.5f)));
        make.top.mas_equalTo(self.bgView.mas_top).offset(TRANS_VALUE(7.5));
    }];
    self.checkBox.hidden = YES;
    [self.checkBox setImage:[UIImage imageNamed:@"ic_message_off"] forState:UIControlStateNormal];
//
    
    _btn.userInteractionEnabled = NO;
    _btn.hidden = YES;
//    [_btn  removeFromSuperview];
}
#pragma mark - Action
- (void)commentAction {
    
    if([self.delegate respondsToSelector:@selector(commentPostForItem:indexPath:)]) {
        [self.delegate commentPostForItem:self.postItem indexPath:self.indexPath];
    }
}
- (void)favorAction {
    if([self.delegate respondsToSelector:@selector(favorPostForItem:indexPath:)]) {
        [self.delegate favorPostForItem:self.postItem indexPath:self.indexPath];
    }
}

//- (void)authorTapAction:(id)sender {
//    if([self.delegate respondsToSelector:@selector(clickAuthorAtItem:indexPath:)]) {
//        [self.delegate clickAuthorAtItem:self.postItem indexPath:self.indexPath];
//    }
//}

- (void)themeTapAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(clickThemeAtItem:indexPath:)]) {
        [self.delegate clickThemeAtItem:self.postItem indexPath:self.indexPath];
    }
}
- (void)changPictureBack{
    //[self changeState];
     [self.checkBox setImage:[UIImage imageNamed:@"ic_message_off"] forState:UIControlStateNormal];
}
- (void)changPicture{
    [self changeState];
    self.checkBox.hidden = NO;
    [self.checkBox setImage:[UIImage imageNamed:@"ic_message_on"] forState:UIControlStateNormal];
}
- (void)checkBoxItemSelected:(UIButton *)btn {
    if(btn.selected == NO) {
        [self.checkBox setImage:[UIImage imageNamed:@"ic_message_on"] forState:UIControlStateNormal];
        [self.delegate clickCheckboxAtItem:self.postItem indexPath:self.indexPath tag:self.tag];
        btn.selected = YES;
    }else {
        [self.checkBox setImage:[UIImage imageNamed:@"ic_message_off"] forState:UIControlStateNormal];
        [self.delegate unclickCheckboxAtItem:self.postItem indexPath:self.indexPath tag:self.tag];
        btn.selected = NO;
    }
}
//- (void)showTitleNum:(NSString  *)TitleNum{
//    if (TitleNum.length>4) {
//           [self.favorButton setTitle:TitleNum];
//    }else{
//         [self.favorButton setTitle:TitleNum];
//    }
//}




@end
