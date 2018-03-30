//
//  ThemeTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "ThemeTableViewCell.h"
#import "HomeThemeButton.h"
#import "ThemeInfo.h"
#import "UIImageView+Webcache.h"

@interface ThemeTableViewCell()

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation ThemeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(0.0f), SCREEN_WIDTH, TRANS_VALUE(106.0f))];
        self.scrollView.backgroundColor = I_COLOR_WHITE;
        self.scrollView.contentSize = CGSizeMake(2 * SCREEN_WIDTH, TRANS_VALUE(0.0f));
        [self.contentView addSubview:self.scrollView];
    }
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setThemeArray:(NSArray *)themeArray {
    _themeArray = themeArray;
    if(_themeArray != nil) {
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        CGFloat buttonWidth = SCREEN_WIDTH / 3;
        CGFloat buttonHeight = TRANS_VALUE(108.0f);
        CGFloat x = 0.0f;
        CGFloat y = 0.0f;
        for(int i = 0, n = (int)_themeArray.count; i < n; i++) {
            HomeThemeButton *topicButton = [[HomeThemeButton alloc] initWithFrame:CGRectMake(x, y, buttonWidth, buttonHeight)];
            [self.scrollView addSubview:topicButton];
            x = x + buttonWidth;
            ThemeInfo *themeInfo = (ThemeInfo *)[_themeArray objectAtIndex:i];
            [topicButton setTitle:themeInfo.title];
            NSString *imageUrl = [NSString stringWithFormat:@"%@", themeInfo.imageUrl];
            [topicButton.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"ic_avatar_default"]];
            if(themeInfo.hasFollowed != nil && [themeInfo.hasFollowed isEqualToString:@"1"]) {
                [topicButton setSelected:YES];
            } else {
                [topicButton setSelected:NO];
            }
            topicButton.tag = i + 4000;
            [topicButton addTarget:self action:@selector(themeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        CGFloat contentWidth = ceil(x);
        self.scrollView.contentSize = CGSizeMake(contentWidth, TRANS_VALUE(0.0f));
        [self.scrollView setContentOffset:CGPointZero];
    }
}

//主题button点击事件
- (void)themeButtonAction:(id)sender {
    NSInteger index = ((HomeThemeButton *)sender).tag - 4000;
    if(index < 0 || index > _themeArray.count) {
        return;
    }
    if([self.delegate respondsToSelector:@selector(themeButtonClickedAtItem:)]) {
        ThemeInfo *themeInfo = (ThemeInfo *)[_themeArray objectAtIndex:index];
        [self.delegate themeButtonClickedAtItem:themeInfo];
    }
}

@end
