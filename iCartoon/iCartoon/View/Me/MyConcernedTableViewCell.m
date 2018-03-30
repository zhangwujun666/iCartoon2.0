//
//  MyConcernedTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "MyConcernedTableViewCell.h"
#import "UIImageView+Webcache.h"

@interface MyConcernedTableViewCell()

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *actionButton;
@property (strong, nonatomic) UIImageView *backImageView;

@end

@implementation MyConcernedTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CONVER_VALUE(15.0f), CONVER_VALUE(13.5f), CONVER_VALUE(78.5f), CONVER_VALUE(78.5f))];
        self.backImageView.clipsToBounds = YES;
        self.iconImageView.layer.cornerRadius = self.backImageView.frame.size.width / 2;
        //        self.backImageView.layer.borderWidth = 1.0f;
        self.backImageView.layer.borderColor = I_DIVIDER_COLOR.CGColor;
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.image = [UIImage imageNamed:@"ic_my_backring"];

        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CONVER_VALUE(16.0f), CONVER_VALUE(15.0f), CONVER_VALUE(75.0f), CONVER_VALUE(75.0f))];
        self.iconImageView.clipsToBounds = YES;
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width / 2;
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.iconImageView.layer.borderColor = I_DIVIDER_COLOR.CGColor;
//        self.iconImageView.layer.borderWidth = 1.0f;
        self.iconImageView.image = [UIImage imageNamed:@"ic_avatar_default"];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONVER_VALUE(113.0f), CONVER_VALUE(44.5f), CONVER_VALUE(150.0f), CONVER_VALUE(16.0f))];
        self.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
        self.titleLabel.textColor = [UIColor darkTextColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.text = @"海贼王";
        
        self.actionButton = [[UIButton alloc] initWithFrame:CGRectMake(CONVER_VALUE(270.0f), CONVER_VALUE(30.5f), CONVER_VALUE(100.0f), CONVER_VALUE(44.0f))];
        self.actionButton.backgroundColor = [UIColor clearColor];
        self.actionButton.titleLabel.font = [UIFont systemFontOfSize:CONVER_VALUE(13.0f)];
        [self.actionButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.actionButton setTitleColor:UIColorFromRGB(0xc8c8c8) forState:UIControlStateNormal];
        [self.contentView addSubview:self.backImageView];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.actionButton];
    }
    self.backgroundColor = I_COLOR_WHITE;
    
    return self;
}

- (void)setConcernedItem:(ThemeInfo *)concernedItem {
    if(concernedItem) {
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        NSString *imageUrl = concernedItem.imageUrl;
        if(![imageUrl hasPrefix:@"http://"] && ![imageUrl hasPrefix:@"https://"]) {
            imageUrl = [NSString stringWithFormat:@"http://139.196.84.154/%@", imageUrl];
        }
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"ic_theme_default"]];
        self.titleLabel.text = concernedItem.title;
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
