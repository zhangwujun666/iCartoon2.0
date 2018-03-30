//
//  ThemePostTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "ThemePostTableViewCell.h"
#import "PostInfo.h"
#import "UIImageView+Webcache.h"
#import "CommonUtils.h"
#import "PostThemeButton.h"
#import "PostActionButton.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "LookBigPicViewController.h"
@interface ThemePostTableViewCell()

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIView *topDivider;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIView *detailView;
@property (strong, nonatomic) UIView *bottomDivider;
@property (strong, nonatomic) PostThemeButton *themeButton;
@property (strong, nonatomic) PostActionButton *commentButton;
@property (strong, nonatomic) PostActionButton *favorButton;
@property (strong, nonatomic) UIImageView *divider01;
@property (strong, nonatomic) UIImageView *divider02;
@property (strong, nonatomic) UIView *topDividerView;
@property (strong, nonatomic) UIView *dividerView;
@property (nonatomic,strong) NSMutableArray * imageArray;

@end

@implementation ThemePostTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(180.0f))];
        
        self.bgView.backgroundColor = I_COLOR_WHITE;
        [self.contentView addSubview:self.bgView];
        
        self.topDividerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5f)];
        self.topDividerView.backgroundColor = I_DIVIDER_COLOR;
        [self.bgView addSubview:self.topDividerView];
        
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(16.0f), TRANS_VALUE(7.5f), TRANS_VALUE(27.5f), TRANS_VALUE(27.5f))];
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
        self.avatarImageView.image = [UIImage imageNamed:@"ic_topic_button_3"];
        [self.bgView addSubview:self.avatarImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(50.0f), TRANS_VALUE(14.5f), TRANS_VALUE(120), TRANS_VALUE(20.0f))];
        self.nameLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.5f)];
        self.nameLabel.textColor = I_COLOR_BLACK;
        self.nameLabel.text = @"Lucy";
        [self.nameLabel sizeToFit];
        [self.bgView addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(200.0f), TRANS_VALUE(11.25f), TRANS_VALUE(110.0f), TRANS_VALUE(20.0f))];
       // self.timeLabel.textColor = UIColorFromRGB(0x979797);
        self.timeLabel.textColor = UIColorFromRGB(0xcccccc);
        self.timeLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(10.5f)];
        self.timeLabel.text = @"3分钟前";
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.bgView addSubview:self.timeLabel];
        
        self.topDivider = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), TRANS_VALUE(42.5f), SCREEN_WIDTH - 2 * TRANS_VALUE(0.0f), 0.5f)];
        
        self.topDivider.backgroundColor = RGBCOLOR(231, 231, 231);
        [self.bgView addSubview:self.topDivider];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(42.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f), TRANS_VALUE(38.0f))];
        self.titleLabel.textColor = I_COLOR_33BLACK;
        self.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.text = @"【置顶】【搬运】画江湖之不良人";
        [self.bgView addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(80.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f), TRANS_VALUE(30.0f))];
         self.contentLabel.textColor = I_COLOR_DARKGRAY;
         self.contentLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
         self.contentLabel.numberOfLines = 0;
        [self.bgView addSubview: self.contentLabel];
        
        self.detailView = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(110.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f), TRANS_VALUE(0.0f))];
        [self.contentView addSubview:self.detailView];
        
        self.bottomDivider = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), TRANS_VALUE(156.0f), SCREEN_WIDTH, 0.5f)];
        self.bottomDivider.backgroundColor = RGBCOLOR(231, 231, 231);
        [self.bgView addSubview:self.bottomDivider];
        
        self.themeButton = [[PostThemeButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(11.0f), TRANS_VALUE(189.0f), TRANS_VALUE(100.0f), TRANS_VALUE(25.0f))];
        [self.themeButton setTitle:@"画江湖之不良人"];
        [self.themeButton setImage:@"ic_action_theme_undo"];
        [self.bgView addSubview:self.themeButton];
        
        self.commentButton = [[PostActionButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(218.0f), TRANS_VALUE(189.0f), TRANS_VALUE(50.0f), TRANS_VALUE(25.0f))];
        [self.commentButton setTitle:@"5"];
        [self.commentButton setImage:@"ic_action_comment_undo"];
        [self.bgView addSubview:self.commentButton];
        
        self.favorButton = [[PostActionButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(270.0f), TRANS_VALUE(189.0f), TRANS_VALUE(50.0f), TRANS_VALUE(25.0f))];
        [self.favorButton setTitle:@"27"];
        [self.favorButton setImage:@"ic_action_favor_undo"];
        [self.bgView addSubview:self.favorButton];
        
        self.divider01 = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(217.0f), TRANS_VALUE(160.0f), 0.5f, TRANS_VALUE(16.0f))];
        self.divider01.backgroundColor = I_DIVIDER_COLOR;
        self.divider01.image = [UIImage imageNamed:@"ic_post_midline"];
        [self.bgView addSubview:self.divider01];
        self.divider02 = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(270.0f), TRANS_VALUE(160.0f),0.5f, TRANS_VALUE(16.0f))];
        self.divider02.image = [UIImage imageNamed:@"ic_post_midline"];
        self.divider02.backgroundColor = I_DIVIDER_COLOR;
        [self.bgView addSubview:self.divider02];
        
//        self.dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bgView.frame.size.height - 0.5f, SCREEN_WIDTH, 0.5f)];
//        self.dividerView.backgroundColor = I_DIVIDER_COLOR;
//        [self.bgView addSubview:self.dividerView];
        
    }
    
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authorTapAction:)];
    self.avatarImageView.userInteractionEnabled = YES;
    [self.avatarImageView addGestureRecognizer:avatarTap];
    
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authorTapAction:)];
    self.nameLabel.userInteractionEnabled = YES;
    [self.nameLabel addGestureRecognizer:nameTap];
    
    [self.themeButton addTarget:self action:@selector(themeTapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.favorButton addTarget:self action:@selector(favorAction) forControlEvents:UIControlEventTouchUpInside];
    self.backgroundColor = I_BACKGROUND_COLOR;
    return self;
}
- (void)setPostItem:(PostInfo *)postItem {
    _postItem = postItem;
    if(!_postItem) {
        return;
    }
    AuthorInfo *userInfo = _postItem.author;
    NSString *avatarUrl = userInfo.avatar;
     NSString *dataGBnickname = [userInfo.nickname stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *nickname = dataGBnickname;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_topic_button_3"]];
    self.nameLabel.text = nickname;
//    NSString *timeStr = _postItem.createTime != nil ? _postItem.createTime : @"未知时间";
//    if(timeStr.length >= 19) {
//        timeStr = [timeStr substringWithRange:NSMakeRange(5, 11)];
//    }
//    self.timeLabel.text = timeStr;
    NSString *timeStr = _postItem.createTime != nil ? _postItem.createTime : @"未知时间";
    if([timeStr isEqualToString:@"未知时间"]) {
        self.timeLabel.text = @"刚刚";
//        self.timeLabel.text = [timeStr substringWithRange:NSMakeRange(5, 11)];
    } else {
        self.timeLabel.text = [CommonUtils prettyDateWithReference:timeStr];
        self.timeLabel.text = [timeStr substringWithRange:NSMakeRange(5, 11)];
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
    [self.favorButton setTitle:favorCount];
    
    NSString *content = _postItem.content != nil ? _postItem.content : @"";
    NSString * mstr = [NSString stringWithString:content];
     mstr = [mstr stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *dataGBK = [mstr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc]initWithData:[dataGBK dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [aAttributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x858585)range:NSMakeRange(0, aAttributedString.length)];
    [aAttributedString addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:TRANS_VALUE(12.0f)]
                              range:NSMakeRange(0, aAttributedString.length)];
    self.contentLabel.text = aAttributedString.string;
    //加载图片
    for(UIView *view in self.detailView.subviews) {
        [view removeFromSuperview];
    }
    NSMutableArray *images = _postItem.images;
//    CGFloat imgWidth = TRANS_VALUE(84.0f);
//    CGFloat imgHeight = TRANS_VALUE(84.0f);
//    CGFloat imgMargin = (SCREEN_WIDTH - 2 * TRANS_VALUE(17.0f) - 3 * imgWidth) / 2;
//    CGFloat x = TRANS_VALUE(7.0f);
//    CGFloat y = 0.0f;
    NSInteger count = images.count;
    for(int i = 1; i <= count ; i++) {
        PostPictureInfo *pictureInfo = (PostPictureInfo *)[images objectAtIndex:i-1];
        if ([[images objectAtIndex:i-1] isKindOfClass:[PostPictureInfo class]]) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.backgroundColor = I_BACKGROUND_COLOR;
            NSString *imagePath = pictureInfo.imageUrl;
//            imagePath = [NSString stringWithFormat:@"%@%@",pictureInfo.thumbnailUrl,@"_500x500"];
            [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
            imageView.contentMode =  UIViewContentModeScaleAspectFill;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            imageView.clipsToBounds  = YES;
            [self.detailView addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@""]];
//            x += (imgWidth + imgMargin);
            imageView.tag = i-1;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
            [imageView addGestureRecognizer:tap];
        }else{
            self.imageArray = [NSMutableArray array];
            UIImageView *imageView = [[UIImageView alloc] init];
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
//            x += (imgWidth + imgMargin);
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
- (void)imageClick:(UITapGestureRecognizer *)sender{
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
    
    self.avatarImageView.frame = CGRectMake(TRANS_VALUE(11.0f), TRANS_VALUE(7.5f), TRANS_VALUE(27.5f), TRANS_VALUE(27.5f));
    self.nameLabel.frame = CGRectMake(TRANS_VALUE(44.0f), TRANS_VALUE(14.5f), TRANS_VALUE(170), TRANS_VALUE(20.0f));
    [self.nameLabel sizeToFit];
    self.timeLabel.frame = CGRectMake(TRANS_VALUE(200.0f), TRANS_VALUE(11.25f), TRANS_VALUE(110.0f), TRANS_VALUE(20.0f));
    self.topDivider.frame = CGRectMake(TRANS_VALUE(0.0f), TRANS_VALUE(42.5f) - 0.5f, SCREEN_WIDTH - 2 * TRANS_VALUE(0.0f), 0.5f);
    self.titleLabel.frame = CGRectMake(TRANS_VALUE(11.0f), TRANS_VALUE(46.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(11.0f), TRANS_VALUE(35.0f));
    self.contentLabel.frame = CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(78.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f), TRANS_VALUE(16.0f));
    //图片布局
//    CGFloat imgWidth = TRANS_VALUE(96.0f);
//    CGFloat imgHeight = TRANS_VALUE(96.0f);
//    CGFloat imgMargin = (SCREEN_WIDTH - 2 * TRANS_VALUE(11.0f) - 3 * imgWidth) / 2;
    CGFloat imgMargin = TRANS_VALUE(1.7f);
    CGFloat imgWidth = (SCREEN_WIDTH-2*TRANS_VALUE(11.0f)-imgMargin*2)/3;
    CGFloat imgHeight = imgWidth;
    CGFloat x = TRANS_VALUE(0.0f);
    CGFloat y = TRANS_VALUE(12.0f);
    NSArray *images = _postItem.images;
    
    for(int i = 1; i <= images.count ; i++) {
        UIImageView *imageView = (UIImageView *)[self.detailView.subviews objectAtIndex:i-1];
        imageView.frame = CGRectMake(x, y, imgWidth, imgHeight);
        if (images.count == 1) {
            imgHeight = (SCREEN_WIDTH - 2*TRANS_VALUE(11.0f))*0.6;
            imgWidth = imgHeight;
             imageView.frame = CGRectMake(x, y, imgWidth, imgHeight);
        }
        if (images.count == 2 ||images.count == 4) {
            imgHeight = (SCREEN_WIDTH - 2*TRANS_VALUE(11.0f)-imgMargin)/2;
            imgWidth = imgHeight;
            imageView.frame = CGRectMake(x, y, imgWidth, imgHeight);
        }else{
            imageView.frame = CGRectMake(x, y, imgWidth, imgHeight);
        }
        if (images.count == 4) {
            if(i % 2 == 0 && i > 0) {
                x = TRANS_VALUE(0.0f);
                y = (imgHeight + imgMargin+TRANS_VALUE(12.0f));
            } else{
                x = (imgHeight + imgMargin);
                y = y;
            }
            
        }else{
            if(i % 3 == 0 && i > 0) {
                x = TRANS_VALUE(0.0f);
                y += (imgHeight + imgMargin);
            } else{
                x += (imgWidth + imgMargin);
                y = y;
            }
        }
    }
    CGFloat detailHeight = y + imgHeight + TRANS_VALUE(7.0f)+TRANS_VALUE(1.5f)+imgMargin;
    if(images.count == 0) {
        detailHeight = detailHeight - imgHeight-TRANS_VALUE(8.5f);
    }
    if (images.count == 9 ) {
        detailHeight = y + TRANS_VALUE(7.0f)+TRANS_VALUE(1.5f);
    }
    CGFloat marginTop = TRANS_VALUE(90.0f);
    CGFloat bottomMarginTop = marginTop + detailHeight - TRANS_VALUE(5.0f);
    if (images.count == 3 || images.count == 6) {
        bottomMarginTop = marginTop + detailHeight - imgHeight-imgMargin*3;
    }
    self.detailView.frame = CGRectMake(TRANS_VALUE(11.0f), marginTop, SCREEN_WIDTH - 2 * TRANS_VALUE(11.0f), detailHeight-TRANS_VALUE(11.0f));
    self.bottomDivider.frame = CGRectMake(TRANS_VALUE(0.0f), bottomMarginTop, SCREEN_WIDTH, 0.5f);
    self.themeButton.frame = CGRectMake(TRANS_VALUE(12.0f), bottomMarginTop + 0.5f, TRANS_VALUE(160.0f), TRANS_VALUE(24.0f));
    self.commentButton.frame = CGRectMake(TRANS_VALUE(190.0f), bottomMarginTop + 0.5f, TRANS_VALUE(50.0f), TRANS_VALUE(24.0f));
    self.favorButton.frame = CGRectMake(TRANS_VALUE(260.0f), bottomMarginTop + 0.5f, TRANS_VALUE(50.0f), TRANS_VALUE(24.0f));
    self.divider01.frame = CGRectMake(TRANS_VALUE(180.0f), bottomMarginTop + TRANS_VALUE(4.0f), 0.5f, TRANS_VALUE(16.0f));
    
    self.divider02.frame = CGRectMake(TRANS_VALUE(251.0f), bottomMarginTop + TRANS_VALUE(4.0f), self.divider01.frame.size.width, TRANS_VALUE(16.0f));
    
    CGFloat bgHeight = bottomMarginTop +  2 * 0.5f + TRANS_VALUE(24.0f);
       self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, bgHeight);
//    self.dividerView.frame = CGRectMake(0, self.bgView.frame.size.height - 1.0f, SCREEN_WIDTH, 0.5f);
//    self.dividerView.backgroundColor = [UIColor redColor];
}

+ (CGFloat)heightForCell:(NSIndexPath *)indexPath withCommentInfo:(PostInfo *)postInfo {
    //    CGFloat height = TRANS_VALUE(62.0f);
    //    if(postInfo.content) {
    //        CGFloat width = SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f);
    //        NSString *contentStr = postInfo.content;
    //        CGFloat fontSize = TRANS_VALUE(12.0f);
    //        CGFloat labelHeight = [PostTableViewCell labelHeight:contentStr width:width fontSize:fontSize];
    //        height += labelHeight;
    //    }
//    CGFloat height = TRANS_VALUE(90.0f);
//    CGFloat imgWidth = TRANS_VALUE(96.0f);
//    CGFloat imgHeight = TRANS_VALUE(96.0f);
//    CGFloat imgMargin = (SCREEN_WIDTH - 2 * TRANS_VALUE(17.0f) - 3 * imgWidth) / 2;
    CGFloat height = TRANS_VALUE(90.0f);
    CGFloat imgMargin = TRANS_VALUE(1.7f);
    CGFloat imgWidth = (SCREEN_WIDTH - 2*TRANS_VALUE(11.0f)-2*imgMargin)/3;
    CGFloat imgHeight = imgWidth;
    CGFloat x = TRANS_VALUE(0.0f);
    CGFloat y = imgMargin;
//    NSLog(@"\npostInfo ++++++ %@",postInfo);
    NSArray *images = postInfo.images;
    if (images.count == 1) {
        imgHeight = (SCREEN_WIDTH - 2*TRANS_VALUE(11.0f))*0.6;
        imgWidth = imgHeight;
    }
    if (images.count == 2 ||images.count == 4) {
        imgHeight = (SCREEN_WIDTH - 2*TRANS_VALUE(11.0f)-imgMargin)/2;
        imgWidth = imgHeight;
    }
    for(int i = 0; i < images.count ; i++) {
        if (images.count == 4) {
            if(i % 2 == 0 && i > 0) {
                x = TRANS_VALUE(0.0f);
                y = (imgHeight + imgMargin*6.5);
            } else{
                x = (imgHeight + imgMargin);
                y = y;
            }
            
        }else{
            if(i % 3 == 0 && i > 0) {
                x = TRANS_VALUE(0.0f);
                y += (imgHeight + imgMargin);
            } else{
                
                x += (imgWidth + imgMargin);
                y = y;
    
            }
            
        }
    }
    CGFloat detailHeight = y + imgHeight;
    
    if(images.count == 0) {
        detailHeight = detailHeight - imgHeight-TRANS_VALUE(8.0f);
    }
    if(images.count == 4) {
        detailHeight = y + imgHeight-TRANS_VALUE(10.0f);
    }
    height += detailHeight;
    
    height += TRANS_VALUE(49.0f);
    
    return height;
}

+ (CGFloat)labelHeight:(NSString *)contentStr width:(CGFloat)width fontSize:(CGFloat)fontSize {
    CGFloat height = 0.0f;
    if(contentStr) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil];
        CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        CGFloat labelHeight = floor(rect.size.height + 1);
        if(labelHeight < TRANS_VALUE(30.0f)) {
            labelHeight = TRANS_VALUE(30.0f);
        } else {
            labelHeight += TRANS_VALUE(15.0f);
        }
        //TODO -- 只显示一行文字
        labelHeight = TRANS_VALUE(22.0f);
        height += labelHeight;
    } else {
        height += TRANS_VALUE(0.0f);
    }
    return height;
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
- (void)authorTapAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(clickAuthorAtItem:indexPath:)]) {
        [self.delegate clickAuthorAtItem:self.postItem indexPath:self.indexPath];
    }
}

- (void)themeTapAction:(id)sender {
//    if([self.delegate respondsToSelector:@selector(clickThemeAtItem:indexPath:)]) {
//        [self.delegate clickThemeAtItem:self.postItem indexPath:self.indexPath];
//    }
}

@end
