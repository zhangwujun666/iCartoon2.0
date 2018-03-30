//
//  FavoriteAuthorTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "FavoriteAuthorTableViewCell.h"
#import "UIImageView+Webcache.h"
#import "RegexKit.h"

@interface FavoriteAuthorTableViewCell()

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *signLabel;
@property (strong, nonatomic) UIButton *actionButton;
@property (strong, nonatomic) UIImageView *imageBackView;

@end

@implementation FavoriteAuthorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.imageBackView=[[UIImageView alloc] initWithFrame:CGRectMake(CONVER_VALUE(15.0f), CONVER_VALUE(11.0f), CONVER_VALUE(83.0f), CONVER_VALUE(83.0f))];
        self.imageBackView.clipsToBounds = YES;
        self.imageBackView.layer.cornerRadius = self.imageBackView.frame.size.width / 2;
        self.imageBackView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageBackView.backgroundColor= UIColorFromRGB(0xf7f7f7);
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CONVER_VALUE(19.0f), CONVER_VALUE(15.0f), CONVER_VALUE(75.0f), CONVER_VALUE(75.0f))];
        self.iconImageView.clipsToBounds = YES;
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width / 2;
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
//        self.iconImageView.backgroundColor = I_COLOR_YELLOW;
        self.iconImageView.image = [UIImage imageNamed:@"ic_topic_button_3"];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONVER_VALUE(111.5f), CONVER_VALUE(35.5f), CONVER_VALUE(180.0f), CONVER_VALUE(14.0f))];
        self.titleLabel.font = [UIFont systemFontOfSize:CONVER_VALUE(14.0f)];
//        self.titleLabel.textColor = I_COLOR_33BLACK;
        self.titleLabel.textColor = UIColorFromRGB(0x191919);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.text = @"海贼王";
        
        self.signLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONVER_VALUE(111.5f), CONVER_VALUE(58.5f), CONVER_VALUE(180.0f), CONVER_VALUE(12.0f))];
        self.signLabel.font = [UIFont systemFontOfSize:CONVER_VALUE(12.0f)];
//        self.signLabel.textColor = I_COLOR_GRAY;
        self.signLabel.textColor =UIColorFromRGB(0x969696);
        self.signLabel.textAlignment = NSTextAlignmentLeft;
        self.signLabel.text = @"海贼王";
        
        self.actionButton = [[UIButton alloc] initWithFrame:CGRectMake(CONVER_VALUE(290.0f), CONVER_VALUE(45.5f), CONVER_VALUE(75.0f), CONVER_VALUE(13.0f))];
        self.actionButton.backgroundColor = [UIColor clearColor];
        self.actionButton.titleLabel.font = [UIFont systemFontOfSize:CONVER_VALUE(13.0f)];
        [self.actionButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.actionButton setTitleColor:UIColorFromRGB(0xc8c8c8) forState:UIControlStateNormal];
        [self.contentView addSubview:self.imageBackView];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.signLabel];
        [self.contentView addSubview:self.actionButton];
    }
    self.backgroundColor = I_COLOR_WHITE;
    
    return self;
}

- (void)setAuthorInfo:(ConcernedAuthorInfo *)authorInfo {
    _authorInfo = authorInfo;
    if(_authorInfo) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_authorInfo.avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_topic_button_3"]];
        NSString *nameStr = _authorInfo.nickname != nil ? _authorInfo.nickname : _authorInfo.account;
        if([RegexKit validateMobile:nameStr]) {
            nameStr = [nameStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        if (_authorInfo.signature.length<=10) {
            self.signLabel.text = _authorInfo.signature;
        }else{
            NSString *signStr=[NSString stringWithFormat:@"%@...",[_authorInfo.signature substringWithRange:NSMakeRange(0,10)]];
        self.signLabel.text = signStr;
        }
        self.titleLabel.text = nameStr;
//        self.signLabel.text = _authorInfo.signature;
        [self.actionButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.actionButton addTarget:self action:@selector(cancelConcernAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)cancelConcernAction {
    if([self.delegate respondsToSelector:@selector(cancelConcernAtIndexPath:)]) {
        if(self.indexPath) {
            [self.delegate cancelConcernAtIndexPath:self.indexPath];
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

@end
