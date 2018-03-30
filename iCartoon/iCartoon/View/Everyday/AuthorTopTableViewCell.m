//
//  AuthorTopTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "AuthorTopTableViewCell.h"
#import "UIImageView+Webcache.h"
#import "UIImage+Color.h"

@interface AuthorTopTableViewCell()

@property (strong, nonatomic) UIImageView *pictureImageView;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UIImageView *avatarBackImageView;
@property (strong, nonatomic) UIButton *attentionButton;
@property (strong, nonatomic) UILabel *speakLabel;
@property (strong, nonatomic) UILabel *userLabel;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descLabel;

@end

@implementation AuthorTopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(132.0f))];
        self.pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.pictureImageView.image = [UIImage imageNamed:@"bg_author_top"];
        self.pictureImageView.backgroundColor = RGBCOLOR(231, 231, 231);
        [self.contentView addSubview:self.pictureImageView];
        self.avatarBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - TRANS_VALUE(66.0f)) / 2-2, TRANS_VALUE(12.0f), TRANS_VALUE(70.0f), TRANS_VALUE(70.0f))];
        self.avatarBackImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarBackImageView.backgroundColor =UIColorFromRGB(0xf0f0f0);
        self.avatarBackImageView.clipsToBounds = YES;
        self.avatarBackImageView.alpha=0.5;
        self.avatarBackImageView.layer.cornerRadius = self.avatarBackImageView.frame.size.height / 2;
        [self.contentView addSubview:self.avatarBackImageView];
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - TRANS_VALUE(66.0f)) / 2, TRANS_VALUE(14.0f), TRANS_VALUE(66.0f), TRANS_VALUE(66.0f))];
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImageView.image = [UIImage imageNamed:@"ic_avatar_default"];
        self.avatarImageView.backgroundColor = I_COLOR_WHITE;
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height / 2;
//        self.avatarImageView.layer.borderColor = I_DIVIDER_COLOR.CGColor;
//        self.avatarImageView.layer.borderWidth = 2.0f;
        [self.contentView addSubview:self.avatarImageView];
        
        self.speakLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(142.0f), TRANS_VALUE(110.0f), TRANS_VALUE(22.0f))];
        self.speakLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        self.speakLabel.textColor = I_COLOR_33BLACK;
        self.speakLabel.textAlignment = NSTextAlignmentRight;
        self.speakLabel.text = @"发言 120";
        [self.contentView addSubview:self.speakLabel];
        
        self.userLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - TRANS_VALUE(110.0f), TRANS_VALUE(142.0f), TRANS_VALUE(110.0f), TRANS_VALUE(22.0f))];
        self.userLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        self.userLabel.textColor = UIColorFromRGB(0x191919);
        self.userLabel.textAlignment = NSTextAlignmentLeft;
        self.userLabel.text = @"关注 120";
        [self.contentView addSubview:self.userLabel];
        self.speakLabel.hidden = YES;
        self.userLabel.hidden = YES;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(86.0f), SCREEN_WIDTH, TRANS_VALUE(24.0f))];
        self.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
        self.titleLabel.textColor = UIColorFromRGB(0x191919);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"匿名大大";
        [self.contentView addSubview:self.titleLabel];
        
        self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), TRANS_VALUE(106.0f), SCREEN_WIDTH, TRANS_VALUE(18.0f))];
        self.descLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
        self.descLabel.textColor = UIColorFromRGB(0x736441);
        self.descLabel.textAlignment = NSTextAlignmentCenter;
        self.descLabel.text = @"懒癌晚期, 放弃治疗";
        [self.contentView addSubview:self.descLabel];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = I_BACKGROUND_COLOR;
    
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAuthorInfo:(AuthorDetailInfo *)authorInfo {
    _authorInfo = authorInfo;
    if(_authorInfo) {
        NSString *backgroundURL = @"bg_author_top";
        self.pictureImageView.image = [UIImage imageNamed:backgroundURL];
        NSString *avatarURL = _authorInfo.avatar != nil ? _authorInfo.avatar : @"";
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarURL] placeholderImage:[UIImage imageNamed:@"ic_topic_detail_avatar"]];
        NSString *postNum = @"0";
        self.speakLabel.text = [NSString stringWithFormat:@"发言 %@", postNum];
        NSString *followNum = @"0";
        self.userLabel.text = [NSString stringWithFormat:@"熊宝 %@", followNum];
        NSString *followStatus = @"0";  //0未关注， 1已关注
        self.titleLabel.text = authorInfo.nickname;
        self.descLabel.text = authorInfo.signature;
        if([followStatus isEqualToString:@"1"]) {
            [self.attentionButton setSelected:YES];
        } else {
            [self.attentionButton setSelected:NO];
        }
         self.attentionButton.hidden = YES;
    }
}

@end
