//
//  ReplyCommentTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/20.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "ReplyCommentTableViewCell.h"
#import "UIImageView+Webcache.h"
#import "PostThemeButton.h"
#import "PostActionButton.h"

@interface ReplyCommentTableViewCell()

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *replyLabel;
@property (strong, nonatomic) UILabel *postLabel;

@property (strong, nonatomic) PostThemeButton *topicButton;
@property (strong, nonatomic) PostActionButton *commentButton;

@end


@implementation ReplyCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(132.0f))];
        self.bgView.backgroundColor = I_COLOR_WHITE;
        [self.contentView addSubview:self.bgView];
        
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(12.0f), TRANS_VALUE(12.0f), TRANS_VALUE(27.5f), TRANS_VALUE(27.5f))];
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
        self.avatarImageView.image = [UIImage imageNamed:@"ic_avatar_default"];
        [self.bgView addSubview:self.avatarImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(50.0f), TRANS_VALUE(17.0f), TRANS_VALUE(180), TRANS_VALUE(20.0f))];
        self.nameLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
        self.nameLabel.textColor = I_COLOR_33BLACK;
        self.nameLabel.text = @"Lucy";
        [self.bgView addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(240.0f), TRANS_VALUE(15.0f), TRANS_VALUE(70.0f), TRANS_VALUE(20.0f))];
        self.timeLabel.textColor =   UIColorFromRGB(0xcccccc);;
        self.timeLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        self.timeLabel.text = @"3分钟前";
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.bgView addSubview:self.timeLabel];
        
        self.replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(41.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f), TRANS_VALUE(26.0f))];
        self.replyLabel.backgroundColor = I_COLOR_WHITE;
        self.replyLabel.textColor = UIColorFromRGB(0xcccccc);;
        self.replyLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
        self.replyLabel.text = @"回复: 太可爱了吧, 超喜欢";
        self.replyLabel.textAlignment = NSTextAlignmentLeft;
        [self.bgView addSubview:self.replyLabel];
        
        self.postLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(70.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f), TRANS_VALUE(26.0f))];
        self.postLabel.backgroundColor = I_BACKGROUND_COLOR;
        self.postLabel.clipsToBounds = YES;
        self.postLabel.layer.cornerRadius = TRANS_VALUE(0.0f);
        self.postLabel.textColor = I_COLOR_33BLACK;
        self.postLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(13.0f)];
        self.postLabel.text = @" 《画江湖之不良人》你说什么就是什么吧";
        self.postLabel.textAlignment = NSTextAlignmentLeft;
        [self.bgView addSubview:self.postLabel];
        
        UIView *bottomDivider = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), TRANS_VALUE(104.0f), SCREEN_WIDTH, 0.5f)];
        bottomDivider.backgroundColor = I_DIVIDER_COLOR;
        [self.bgView addSubview:bottomDivider];
        
        self.topicButton = [[PostThemeButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(12.0f), TRANS_VALUE(104.0f), TRANS_VALUE(160.0f), TRANS_VALUE(24.0f))];
        [self.topicButton setTitle:@"画江湖之不良人"];
        [self.topicButton setImage:@"ic_action_theme_undo"];
        [self.bgView addSubview:self.topicButton];
        self.topicButton.userInteractionEnabled = NO;
        
        self.commentButton = [[PostActionButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(260.0f), TRANS_VALUE(104.0f), TRANS_VALUE(50.0f), TRANS_VALUE(24.0f))];
        [self.commentButton setTitle:@"回复"];
        [self.commentButton setImage:@"ic_action_comment_undo"];
        [self.bgView addSubview:self.commentButton];
        self.commentButton.userInteractionEnabled = NO;
        
        UIImageView *divider = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(255.0f), TRANS_VALUE(108.0f), 0.5f, TRANS_VALUE(16.0f))];
        
        divider.image = [UIImage  imageNamed:@"ic_post_midline"];
        
//        divider.backgroundColor = I_DIVIDER_COLOR;
        [self.bgView addSubview:divider];

    }
    self.backgroundColor = I_BACKGROUND_COLOR;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageInfo:(MyMessageInfo *)messageInfo {
    _messageInfo = messageInfo;
    AuthorInfo *user = _messageInfo.user;
    NSString *imageUrl = user.avatar != nil ? user.avatar : @"";
    NSString *nickname = user.nickname != nil ? user.nickname : @"匿名用户";
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"ic_avatar_default"]];
    self.nameLabel.text = nickname;
    
    [self showNickname:self.nameLabel.text];
    
    NSString *timeStr = _messageInfo.createTime != nil ? _messageInfo.createTime : @"未知时间";
    if(timeStr.length >= 19) {
        timeStr = [timeStr substringWithRange:NSMakeRange(5, 11)];
    }
    self.timeLabel.text = timeStr;
    NSString *replyStr = _messageInfo.content != nil ? _messageInfo.content : @"";
     NSString *dataGBKtitle = [replyStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dataGBKtitle = [dataGBKtitle stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    dataGBKtitle = [dataGBKtitle stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    replyStr = dataGBKtitle;
    if(![replyStr isEqualToString:@""]) {
        NSString *tempStr = nil;
        if (self.type == 1) {
           tempStr = [NSString stringWithFormat:@"评论: %@", replyStr];
        }else{
             tempStr = [NSString stringWithFormat:@"回复: %@", replyStr];
        }
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:tempStr];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(212, 212, 212, 1.0f) range:NSMakeRange(0, 3)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_33BLACK range:NSMakeRange(3, tempStr.length - 3)];
        self.replyLabel.attributedText = attributedStr;
    } else {
        self.replyLabel.text = [NSString stringWithFormat:@"%@", replyStr];
    }
    NSString *postStr = _messageInfo.postInfo.title != nil ? _messageInfo.postInfo.title : @"";
    self.postLabel.text = [NSString stringWithFormat:@"  %@", postStr];
    
    NSString *themeStr = _messageInfo.themeInfo.title != nil ? _messageInfo.themeInfo.title : @"";
    [self.topicButton setTitle:themeStr forState:UIControlStateNormal];
}

-(void)showNickname:(NSString*)nickName{
    
    if (nickName.length > 30) {
        
        nickName = [nickName substringToIndex:30];
        NSString *nickNameStr = nickName;
        self.nameLabel.text = [NSString  stringWithFormat:@"%@",nickNameStr];
        
    }else{
        
        
    }
    
    
}

@end
