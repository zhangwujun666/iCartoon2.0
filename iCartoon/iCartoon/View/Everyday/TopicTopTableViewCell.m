//
//  TopicTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "TopicTopTableViewCell.h"
#import "UIImageView+Webcache.h"
#import "UIImage+Color.h"

@interface TopicTopTableViewCell()

@property (strong, nonatomic) UIImageView *pictureImageView;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *speakLabel;
@property (strong, nonatomic) UILabel *userLabel;
@property (strong, nonatomic) UILabel *descLabel;

@property (strong, nonatomic) UIButton *attentionButton;

@property (strong, nonatomic) UIView *bottomView;



@end

@implementation TopicTopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        UIView * bacView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(168.0f))];
        bacView.backgroundColor = UIColorFromRGB(0xcccccc);
        [self.contentView addSubview:bacView];
        
        self.pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.0f, SCREEN_WIDTH, TRANS_VALUE(168.0f))];
        self.pictureImageView.contentMode = UIViewContentModeScaleToFill;
        self.pictureImageView.image = [UIImage imageNamed:@"bg_topic_detail_top"];
       // self.pictureImageView.backgroundColor = RGBCOLOR(231, 231, 231);
        self.pictureImageView.backgroundColor = UIColorFromRGB(0xcccccc);
        [bacView addSubview:self.pictureImageView];
        
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(0.0f), SCREEN_WIDTH, TRANS_VALUE(168.0f))];
        self.bottomView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.bottomView];
        
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - TRANS_VALUE(64.0f)) / 2, TRANS_VALUE(8.0f), TRANS_VALUE(64.0f), TRANS_VALUE(64.0f))];
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImageView.image = [UIImage imageNamed:@"ic_avatar_default"];
        self.avatarImageView.backgroundColor = I_COLOR_WHITE;
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.layer.borderWidth = 1.0f;
        self.avatarImageView.layer.borderColor = I_DIVIDER_COLOR.CGColor;
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height / 2;
        [self.contentView addSubview:self.avatarImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(80.0f), SCREEN_WIDTH, TRANS_VALUE(18.0f))];
        self.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(13.0f)];
        self.titleLabel.textColor = I_COLOR_WHITE;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"发言 120";
        [self.bottomView addSubview:self.titleLabel];
        
        
      UIImageView  * dividerView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, TRANS_VALUE(100.0f), 1.0f, TRANS_VALUE(14.0f))];
        
        dividerView.image = [UIImage imageNamed:@"ic_post_midline"];
        [self.contentView  addSubview:dividerView];
        self.userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(100.0f), TRANS_VALUE(150.0f), TRANS_VALUE(14.0f))];
        self.userLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        self.userLabel.textColor = I_COLOR_WHITE;
        self.userLabel.textAlignment = NSTextAlignmentRight;
        self.userLabel.text = @"用户 280";
        [self.contentView addSubview:self.userLabel];
        
        self.speakLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - TRANS_VALUE(150.0f), TRANS_VALUE(100.0f), TRANS_VALUE(150.0f), TRANS_VALUE(14.0f))];
        self.speakLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        self.speakLabel.textColor = I_COLOR_WHITE;
        self.speakLabel.textAlignment = NSTextAlignmentLeft;
        self.speakLabel.text = @"发言 120";
        [self.contentView addSubview:self.speakLabel];
        
        self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), TRANS_VALUE(115.0f), SCREEN_WIDTH, TRANS_VALUE(24.0f))];
        self.descLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        self.descLabel.textColor = I_COLOR_WHITE;
        self.descLabel.textAlignment = NSTextAlignmentCenter;
        self.descLabel.text = @"用户 280";
        [self.bottomView addSubview:self.descLabel];
        
        self.attentionButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - TRANS_VALUE(50.0f)) / 2, TRANS_VALUE(140.0f), TRANS_VALUE(50.0f), CONVER_VALUE(20.0f))];
        [self.attentionButton setBackgroundImage:[UIImage imageWithColor:I_COLOR_YELLOW] forState:UIControlStateNormal];
        [self.attentionButton setBackgroundImage:[UIImage imageWithColor:I_COLOR_GRAY] forState:UIControlStateSelected];
        self.attentionButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(8.0f)];
        [self.attentionButton setTitleColor:I_COLOR_WHITE forState:UIControlStateNormal];
        [self.attentionButton setTitleColor:I_COLOR_WHITE forState:UIControlStateSelected];
        [self.attentionButton setTitleColor:I_COLOR_WHITE forState:UIControlStateHighlighted];
        [self.attentionButton setTitle:@"＋ 关注" forState:UIControlStateNormal];
        [self.attentionButton setTitle:@"已关注" forState:UIControlStateSelected];
//        [self.attentionButton setImage:nil forState:UIControlStateNormal];
        [self.attentionButton setImage:[UIImage imageNamed:@"ic_follow_check"] forState:UIControlStateSelected];
//        [self.attentionButton  setImage:[UIImage imageNamed:@"collection_no"] forState:UIControlStateNormal];

        [self.bottomView addSubview:self.attentionButton];
        self.attentionButton.clipsToBounds = YES;
        self.attentionButton.layer.cornerRadius = TRANS_VALUE(2.0f);
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.backgroundColor = I_BACKGROUND_COLOR;
    [self.attentionButton addTarget:self action:@selector(attentionButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)attentionButtonAction {
    if([self.delegate respondsToSelector:@selector(followActionForTheme:)]) {
        if(_themeInfo) {
            [self.delegate followActionForTheme:_themeInfo];
        }
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setThemeInfo:(ThemeDetailInfo *)themeInfo {
    _themeInfo = themeInfo;
    if(_themeInfo) {
        NSString *backgroundURL = _themeInfo.backgroundUrl != nil ? _themeInfo.backgroundUrl : @"";
        [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:backgroundURL] placeholderImage:[UIImage imageNamed:@"bg_topic_detail_top"]];
//        NSLog(@"backgroundURL ==== %@",backgroundURL);
        NSString *avatarURL = _themeInfo.avatarUrl != nil ? _themeInfo.avatarUrl : @"";
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarURL] placeholderImage:[UIImage imageNamed:@"ic_theme_default"]];
        NSString *postNum = _themeInfo.postNum != nil ? _themeInfo.postNum : @"0";
        self.speakLabel.text = [NSString stringWithFormat:@"帖子 %@", postNum];
        NSString *followNum = _themeInfo.followNum != nil ? _themeInfo.followNum : @"0";
        self.userLabel.text = [NSString stringWithFormat:@"熊宝 %@", followNum];
        NSString *followStatus = _themeInfo.followStatus != nil ? _themeInfo.followStatus : @"0";  //0未关注， 1已关注
        self.titleLabel.text = themeInfo.title;
        self.descLabel.text = themeInfo.desc;
        if([followStatus isEqualToString:@"1"]) {
            [self.attentionButton setSelected:YES];
            self.attentionButton.layer.borderColor = I_COLOR_WHITE.CGColor;
            self.attentionButton.layer.borderWidth = 1.0f;
            [self.attentionButton setTitleEdgeInsets:UIEdgeInsetsMake(0, TRANS_VALUE(4.0f), 0, 0)];
        } else {
            [self.attentionButton setSelected:NO];
            self.attentionButton.layer.borderColor = I_COLOR_WHITE.CGColor;
            self.attentionButton.layer.borderWidth = 1.0f;
        }
    }
}

@end
