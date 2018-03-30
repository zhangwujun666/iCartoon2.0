//
//  MyCommentTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/20.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "MyCommentTableViewCell.h"
#import "UIImageView+Webcache.h"
#import "PostThemeButton.h"
#import "PostActionButton.h"

@interface MyCommentTableViewCell(){
    UIImageView *indicatorImgView;
}

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *replyLabel;
@property (strong, nonatomic) UILabel *postLabel;
@property (strong ,nonatomic)UIButton * btn;//当管理时   cell上出现的遮罩
@property (strong, nonatomic) PostThemeButton *topicButton;
@property (strong, nonatomic) PostActionButton *commentButton;

@end


@implementation MyCommentTableViewCell
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
    
 
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        if (!indicatorImgView) {
            CGRect indicatorFrame = CGRectMake(-30.0f, CONVER_VALUE(18.0f), CONVER_VALUE(15.0f), CONVER_VALUE(15.0f));
            indicatorImgView = [[UIImageView alloc] initWithFrame:indicatorFrame];
            [self.contentView addSubview:indicatorImgView];
        }
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changPicture) name:@"changPicture1" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changPictureBack) name:@"changPictureBack1" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideBox) name:@"hideBox1" object:nil];
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(132.0f))];
        self.bgView.backgroundColor = I_COLOR_WHITE;
        [self.contentView addSubview:self.bgView];
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
        
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(12.0f), TRANS_VALUE(12.0f), TRANS_VALUE(27.5f), TRANS_VALUE(27.5f))];
//        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.bgView.mas_left).offset(11.0f);
//            make.size.mas_equalTo(CGSizeMake(TRANS_VALUE(27.5f), TRANS_VALUE(27.5f)));
//            make.top.mas_equalTo(self.bgView.mas_top).offset(TRANS_VALUE(7.5));
//        }];
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
        self.avatarImageView.image = [UIImage imageNamed:@"ic_avatar_default"];
        [self.bgView addSubview:self.avatarImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(50.0f), TRANS_VALUE(12.0f), TRANS_VALUE(120), TRANS_VALUE(20.0f))];
//        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.avatarImageView.mas_right).offset(15);
//            make.top.mas_equalTo(self.bgView.mas_top).offset(TRANS_VALUE(14.5f));
//        }];
        self.nameLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
        self.nameLabel.textColor = I_COLOR_33BLACK;
        self.nameLabel.text = @"Lucy";
        [self.bgView addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(200.0f), TRANS_VALUE(17.0f), TRANS_VALUE(110.0f), TRANS_VALUE(20.0f))];
//        self.timeLabel.textColor = RGBACOLOR(212, 212, 212, 1.0f);
       self.timeLabel.textColor= UIColorFromRGB(0xcccccc);
        self.timeLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        self.timeLabel.text = @"3分钟前";
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.bgView addSubview:self.timeLabel];
        
        self.replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(41.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f), TRANS_VALUE(26.0f))];
        self.replyLabel.backgroundColor = I_COLOR_WHITE;
        self.replyLabel.textColor = I_COLOR_DARKGRAY;


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
        
        self.topicButton = [[PostThemeButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(12.0f), TRANS_VALUE(106.0f), TRANS_VALUE(160.0f), TRANS_VALUE(24.0f))];
        [self.topicButton setTitle:@"画江湖之不良人"];
        [self.topicButton setImage:@"ic_action_theme_undo"];
        [self.bgView addSubview:self.topicButton];
        [self.topicButton setUserInteractionEnabled:NO];
        
        self.commentButton = [[PostActionButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(260.0f), TRANS_VALUE(106.0f), TRANS_VALUE(50.0f), TRANS_VALUE(24.0f))];
        [self.commentButton setTitle:@"回复"];
        [self.commentButton setImage:@"ic_action_comment_undo"];
        [self.bgView addSubview:self.commentButton];
        [self.commentButton setUserInteractionEnabled:NO];
        
        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(250.0f), TRANS_VALUE(110.0f), 0.5f, TRANS_VALUE(16.0f))];
        divider.backgroundColor = I_DIVIDER_COLOR;
        [self.bgView addSubview:divider];
        _btn  = [[UIButton  alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        [_btn  addTarget:self action:@selector(checkBoxItemSelected:) forControlEvents:UIControlEventTouchUpInside];
        _btn.userInteractionEnabled = NO;
        _btn.hidden = YES;
        [self.contentView addSubview:_btn];

    }
    self.backgroundColor = I_BACKGROUND_COLOR;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}
- (void)checkBoxItemSelected:(UIButton *)btn {
    if(self.checkBox.selected == NO) {
        [self.checkBox setImage:[UIImage imageNamed:@"ic_message_on"] forState:UIControlStateNormal];
        [self.delegate clickCheckboxAtItem:self.messageInfo indexPath:self.indexPath tag:self.tag];
        self.checkBox.selected = YES;
    }else {
        [self.checkBox setImage:[UIImage imageNamed:@"ic_message_off"] forState:UIControlStateNormal];
        [self.delegate unclickCheckboxAtItem:self.messageInfo indexPath:self.indexPath tag:self.tag];
        self.checkBox.selected = NO;
    }
}
- (void)changPictureBack{
    //[self changeState];
    [self.checkBox setImage:[UIImage imageNamed:@"ic_message_off"] forState:UIControlStateNormal];
    self.checkBox.selected = NO;
}
- (void)changPicture{
    [self changeState];
    self.checkBox.hidden = NO;
    [self.checkBox setImage:[UIImage imageNamed:@"ic_message_on"] forState:UIControlStateNormal];
    self.checkBox.selected = YES;
}
- (void)hideBox{
    self.checkBox.hidden = YES;
    [self backState];
}
//管理
- (void)changeState{
    [self.avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(44.0f);
        make.size.mas_equalTo(CGSizeMake(TRANS_VALUE(27.5f), TRANS_VALUE(27.5)));
        make.top.mas_equalTo(self.bgView.mas_top).offset(TRANS_VALUE(7.5));
    }];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(90.0f);
        make.size.mas_equalTo(CGSizeMake(TRANS_VALUE(120.0f), TRANS_VALUE(20.0)));
        make.top.mas_equalTo(self.bgView.mas_top).offset(TRANS_VALUE(11.5));
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
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(54.0f);
        make.size.mas_equalTo(CGSizeMake(TRANS_VALUE(120.0f), TRANS_VALUE(20.0)));
        make.top.mas_equalTo(self.bgView.mas_top).offset(TRANS_VALUE(11.5));
    }];
    self.checkBox.hidden = YES;
    [self.checkBox setImage:[UIImage imageNamed:@"ic_message_off"] forState:UIControlStateNormal];
    //
    
    _btn.userInteractionEnabled = NO;
    _btn.hidden = YES;
    //    [_btn  removeFromSuperview];
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
    NSString *timeStr = _messageInfo.createTime != nil ? _messageInfo.createTime : @"未知时间";
    if(timeStr.length >= 19) {
        timeStr = [timeStr substringWithRange:NSMakeRange(5, 11)];
    }
    self.timeLabel.text = timeStr;
    NSString *replyStr = _messageInfo.content != nil ? _messageInfo.content : @"";
      NSString *dataGBKtitle = [replyStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dataGBKtitle = [dataGBKtitle stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    dataGBKtitle = [dataGBKtitle stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    if(![replyStr isEqualToString:@""]) {
        NSString *tempStr = [NSString stringWithFormat:@"回复: %@", dataGBKtitle];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:tempStr];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(212, 212, 212, 1.0f) range:NSMakeRange(0, 3)];
            [attributedStr addAttribute:NSForegroundColorAttributeName value: UIColorFromRGB(0xcccccc) range:NSMakeRange(0, 3)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_33BLACK range:NSMakeRange(3, tempStr.length - 3)];
        self.replyLabel.attributedText = attributedStr;
    } else {
        self.replyLabel.text = [NSString stringWithFormat:@"%@", dataGBKtitle];
    }
    NSString *postStr = _messageInfo.postInfo.title != nil ? _messageInfo.postInfo.title : @"";
    self.postLabel.text = [NSString stringWithFormat:@"  %@", postStr];
    
    NSString *themeStr = _messageInfo.themeInfo.title != nil ? _messageInfo.themeInfo.title : @"";
    [self.topicButton setTitle:themeStr forState:UIControlStateNormal];
}

@end
