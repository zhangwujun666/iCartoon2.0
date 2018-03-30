//
//  SearchAuthorTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "SearchAuthorTableViewCell.h"
#import "SearchAuthorButton.h"
#import "ThemeInfo.h"
#import "UIImageView+Webcache.h"

@interface SearchAuthorTableViewCell()

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation SearchAuthorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(0.0f), SCREEN_WIDTH, TRANS_VALUE(74.0f))];
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

- (void)setAuthorArray:(NSArray *)authorArray {
    _authorArray = authorArray;
    if(_authorArray != nil) {
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        CGFloat buttonWidth = SCREEN_WIDTH / 5;
        CGFloat buttonHeight = TRANS_VALUE(74.0f);
        CGFloat x = 0.0f;
        CGFloat y = 0.0f;
        for(int i = 0, n = (int)_authorArray.count; i < n; i++) {
            SearchAuthorButton *authorButton = [[SearchAuthorButton alloc] initWithFrame:CGRectMake(x, y, buttonWidth, buttonHeight)];
            [self.scrollView addSubview:authorButton];
            x = x + buttonWidth;
            AuthorInfo *authorInfo = (AuthorInfo *)[_authorArray objectAtIndex:i];
            [authorButton setTitle:authorInfo.nickname];
            NSString *imageUrl = [NSString stringWithFormat:@"%@", authorInfo.avatar];
            [authorButton.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"ic_avatar_default"]];
            authorButton.tag = i + 4000;
            [authorButton addTarget:self action:@selector(authorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        CGFloat contentWidth = ceil(x);
        self.scrollView.contentSize = CGSizeMake(contentWidth, TRANS_VALUE(0.0f));
        [self.scrollView setContentOffset:CGPointZero];
    }
}

//主题button点击事件
- (void)authorButtonAction:(id)sender {
    NSInteger index = ((SearchAuthorButton *)sender).tag - 4000;
    if(index < 0 || index > _authorArray.count) {
        return;
    }
    if([self.delegate respondsToSelector:@selector(authorButtonClickedAtItem:)]) {
        AuthorInfo *authorInfo = (AuthorInfo *)[_authorArray objectAtIndex:index];
        [self.delegate authorButtonClickedAtItem:authorInfo];
    }
}

@end
