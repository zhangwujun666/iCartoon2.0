//
//  SearchThemeTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "SearchThemeTableViewCell.h"
#import "UIImageView+Webcache.h"

@interface SearchThemeTableViewCell()

@property (strong, nonatomic) UIImageView *iconImageView;
//@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation SearchThemeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(11.0f), TRANS_VALUE(8.0f), TRANS_VALUE(64.0f), TRANS_VALUE(64.0f))];
        self.iconImageView.clipsToBounds = YES;
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width / 2;
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.iconImageView.layer.borderColor = I_DIVIDER_COLOR.CGColor;
        self.iconImageView.layer.borderWidth = 1.0f;
        self.iconImageView.image = [UIImage imageNamed:@"ic_avatar_default"];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(100.0f), TRANS_VALUE(20.0f), TRANS_VALUE(180.0f), TRANS_VALUE(40.0f))];
        self.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(13.0f)];
        self.titleLabel.textColor = [UIColor darkTextColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.text = @"海贼王";
        
        UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(80.0f) - 0.5f, SCREEN_WIDTH, 0.5f)];
        dividerView.backgroundColor = I_DIVIDER_COLOR;
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:dividerView];
    }
    self.backgroundColor = I_COLOR_WHITE;
    
    return self;
}

- (void)setThemeInfo:(ThemeInfo *)themeInfo {
    _themeInfo = themeInfo;
    if(_themeInfo) {
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        NSString *imageUrl = _themeInfo.imageUrl;
        if(![imageUrl hasPrefix:@"http://"] && ![imageUrl hasPrefix:@"https://"]) {
            imageUrl = [NSString stringWithFormat:@"http://139.196.84.154/%@", imageUrl];
        }
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"ic_avatar_default"]];
        self.titleLabel.text = _themeInfo.title;
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
