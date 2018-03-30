//
//  AttentionTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "AttentionTableViewCell.h"
#import "PostInfo.h"
#import "UIImageView+Webcache.h"

@interface AttentionTableViewCell()

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *levelLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *moreButton;
@property (strong, nonatomic) UIView *detailView;
@property (strong, nonatomic) UIView *bottomDivider;
@property (strong, nonatomic) UIButton *topicButton;
@property (strong, nonatomic) UIButton *commentButton;
@property (strong, nonatomic) UIButton *favorButton;
@property (strong, nonatomic) UIButton *disfavorButton;


@end

@implementation AttentionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(186.0f))];
        self.bgView.backgroundColor = I_COLOR_WHITE;
        [self.contentView addSubview:self.bgView];
        
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(10.0f), TRANS_VALUE(32.0f), TRANS_VALUE(32.0f))];
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
        self.avatarImageView.image = [UIImage imageNamed:@"ic_topic_button_3"];
        [self.bgView addSubview:self.avatarImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(50.0f), TRANS_VALUE(10.0f), TRANS_VALUE(200), TRANS_VALUE(14.0f))];
        self.nameLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        self.nameLabel.textColor = I_COLOR_33BLACK;
        self.nameLabel.text = @"Lucy";
        [self.bgView addSubview:self.nameLabel];
        
        self.levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(110.0f), TRANS_VALUE(10.0f), TRANS_VALUE(50.0f), TRANS_VALUE(14.0f))];
        self.levelLabel.backgroundColor = I_COLOR_YELLOW;
        self.levelLabel.textColor = I_COLOR_WHITE;
        self.levelLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        self.levelLabel.clipsToBounds = YES;
        self.levelLabel.layer.cornerRadius = TRANS_VALUE(3.0f);
        self.levelLabel.text = @"清洁工";
        self.levelLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:self.levelLabel];
        self.levelLabel.hidden = YES;
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(50.0f), TRANS_VALUE(26.0f), TRANS_VALUE(50.0f), TRANS_VALUE(12.0f))];
        self.timeLabel.textColor = [UIColor grayColor];
        self.timeLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(10.0f)];
        self.timeLabel.text = @"3分钟前";
        [self.bgView addSubview:self.timeLabel];
    
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(42.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f), TRANS_VALUE(38.0f))];
        self.titleLabel.textColor = I_COLOR_DARKGRAY;
        self.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.text = @"【置顶】【搬运】画江湖之不良人";
        [self.bgView addSubview:self.titleLabel];
        
        self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(284.0f), TRANS_VALUE(22.0f), TRANS_VALUE(24.0f), TRANS_VALUE(24.0f))];
        self.moreButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        [self.moreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.moreButton setImage:[UIImage imageNamed:@"ic_img_more"] forState:UIControlStateNormal];
        self.moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.bgView addSubview:self.moreButton];
        
        self.detailView = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(80.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f), TRANS_VALUE(76.0f))];
        [self.contentView addSubview:self.detailView];
        
        self.bottomDivider = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), TRANS_VALUE(156.0f), SCREEN_WIDTH, 1.0f)];
        self.bottomDivider.backgroundColor = RGBCOLOR(231, 231, 231);
        [self.bgView addSubview:self.bottomDivider];
        
        self.topicButton = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(12.0f), TRANS_VALUE(157.0f), TRANS_VALUE(160.0f), TRANS_VALUE(24.0f))];
        self.topicButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.topicButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        [self.topicButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.topicButton setTitle:@"画江湖之不良人" forState:UIControlStateNormal];
        [self.topicButton setImage:[UIImage imageNamed:@"ic_img_topic"] forState:UIControlStateNormal];
        [self.bgView addSubview:self.topicButton];
        
        self.commentButton = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(170.0f), TRANS_VALUE(157.0f), TRANS_VALUE(50.0f), TRANS_VALUE(24.0f))];
        self.commentButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        [self.commentButton setTitleColor:I_COLOR_GRAY forState:UIControlStateNormal];
        [self.commentButton setTitle:@"5" forState:UIControlStateNormal];
        [self.commentButton setImage:[UIImage imageNamed:@"ic_img_comment"] forState:UIControlStateNormal];
        [self.commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0, TRANS_VALUE(5.0f), 0, 0)];
        [self.bgView addSubview:self.commentButton];
        
        self.favorButton = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(220.0f), TRANS_VALUE(157.0f), TRANS_VALUE(50.0f), TRANS_VALUE(24.0f))];
        self.favorButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        [self.favorButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.favorButton setTitle:@"27" forState:UIControlStateNormal];
        [self.favorButton setImage:[UIImage imageNamed:@"ic_img_favor"] forState:UIControlStateNormal];
        [self.favorButton setTitleEdgeInsets:UIEdgeInsetsMake(0, TRANS_VALUE(5.0f), 0, 0)];
        [self.bgView addSubview:self.favorButton];
        
        self.disfavorButton = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(270.0f), TRANS_VALUE(157.0f), TRANS_VALUE(50.0f), TRANS_VALUE(24.0f))];
        self.disfavorButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        [self.disfavorButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.disfavorButton setTitle:@"0" forState:UIControlStateNormal];
        [self.disfavorButton setImage:[UIImage imageNamed:@"ic_img_disfavor"] forState:UIControlStateNormal];
        [self.disfavorButton setTitleEdgeInsets:UIEdgeInsetsMake(0, TRANS_VALUE(5.0f), 0, 0)];
        [self.bgView addSubview:self.disfavorButton];
        
    }
    
    [self.moreButton addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundColor = RGBCOLOR(247, 247, 247);
    
    return self;
}

- (void)moreButtonAction {
    if([self.delegate respondsToSelector:@selector(moreClickedForCell:)]) {
        if(_postItem) {
            [self.delegate moreClickedForCell:_postItem];
        }
    }
}

- (void)setPostItem:(PostInfo *)postItem {
    _postItem = postItem;
    if(!_postItem) {
        return;
    }
    AuthorInfo *userInfo = _postItem.author;
    NSString *avatarUrl = userInfo.avatar;
    NSString *nickname = userInfo.nickname;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_topic_button_3"]];
    self.nameLabel.text = nickname != nil ? nickname : @"未知用户";
    NSString *timeStr = _postItem.createTime != nil ? _postItem.createTime : @"未知时间";
    self.timeLabel.text = timeStr;
    NSString *title = _postItem.title != nil ? _postItem.title : @"";
    self.titleLabel.text = title;
    NSString *theme = @"画江湖之不良人";
    theme = _postItem.theme.title != nil ? _postItem.theme.title : @"";
    [self.topicButton setTitle:theme forState:UIControlStateNormal];
    NSString *commentCount = _postItem.commentCount != nil ? _postItem.commentCount : @"0";
    [self.commentButton setTitle:commentCount forState:UIControlStateNormal];
    NSString *favorCount = _postItem.favorCount != nil ? _postItem.favorCount : @"0";
    [self.favorButton setTitle:favorCount forState:UIControlStateNormal];
    NSString *disfavorCount = @"0";
    [self.disfavorButton setTitle:disfavorCount forState:UIControlStateNormal];
    
    NSMutableArray *images = postItem.images;
    for(UIView *view in self.detailView.subviews) {
        [view removeFromSuperview];
    }
    //加载图片
    CGFloat imgWidth = TRANS_VALUE(84.0f);
    CGFloat imgHeight = TRANS_VALUE(64.0f);
    CGFloat imgMargin = (SCREEN_WIDTH - 2 * TRANS_VALUE(17.0f) - 3 * imgWidth) / 2;
    CGFloat x = TRANS_VALUE(7.0f);
    CGFloat y = 0.0f;
    if(images.count >= 2) {
        NSInteger count = images.count >= 3 ? 3 : 2;
        for(int i = 0; i < count ; i++) {
            PostPictureInfo *pictureInfo = (PostPictureInfo *)[images objectAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imgWidth, imgHeight)];
            imageView.backgroundColor = [UIColor clearColor];
            NSString *imagePath = pictureInfo.imageUrl;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.detailView addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"bg_topic_pic_1"]];
            x += (imgWidth + imgMargin);
        }
    } else {
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:self.detailView.bounds];
        contentLabel.textColor = I_COLOR_DARKGRAY;
        contentLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
        contentLabel.numberOfLines = 0;
        [self.detailView addSubview:contentLabel];
        NSString *content = _postItem.content != nil ? _postItem.content : @"";
        contentLabel.text = content;
    }
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
