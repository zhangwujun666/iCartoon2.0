//
//  MoreThemeTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "MoreThemeTableViewCell.h"
#import "UIImageView+Webcache.h"

@interface MoreThemeTableViewCell()

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *actionButton;

@end

@implementation MoreThemeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(9.0f), TRANS_VALUE(46.0f), TRANS_VALUE(46.0f))];
        self.iconImageView.clipsToBounds = YES;
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width / 2;
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
//        self.iconImageView.backgroundColor = I_COLOR_YELLOW;
        self.iconImageView.image = [UIImage imageNamed:@"ic_topic_button_3"];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(70.0f), TRANS_VALUE(20.0f), TRANS_VALUE(180.0f), TRANS_VALUE(24.0f))];
        self.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
        self.titleLabel.textColor = [UIColor darkTextColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.text = @"海贼王";
        
        self.actionButton = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(250.0f), TRANS_VALUE(12.0f), TRANS_VALUE(70.0f), TRANS_VALUE(40.0f))];
        self.actionButton.backgroundColor = [UIColor clearColor];
        self.actionButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(13.0f)];
        [self.actionButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.actionButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.actionButton];
    }
    self.backgroundColor = I_COLOR_WHITE;
    
    return self;
}

- (void)setConcernedItem:(ThemeInfo *)concernedItem {
    if(concernedItem) {
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:concernedItem.imageUrl] placeholderImage:[UIImage imageNamed:@"ic_topic_button_3"]];
        self.titleLabel.text = concernedItem.title;
        [self.actionButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.actionButton addTarget:self action:@selector(concernAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)concernAction {
    if([self.delegate respondsToSelector:@selector(concernAtIndexPath:)]) {
        if(self.indexPath) {
            [self.delegate concernAtIndexPath:self.indexPath];
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
