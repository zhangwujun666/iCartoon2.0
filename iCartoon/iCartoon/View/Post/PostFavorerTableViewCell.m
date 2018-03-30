//
//  PostFavorerTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/20.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "PostFavorerTableViewCell.h"
#import "TopicButton.h"
#import "AuthorInfo.h"
#import "UIButton+Webcache.h"

@interface PostFavorerTableViewCell()

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation PostFavorerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), 0, SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f), TRANS_VALUE(36.0f))];
        self.scrollView.backgroundColor = I_COLOR_WHITE;
        [self.contentView addSubview:self.scrollView];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
    }
    self.backgroundColor = I_COLOR_WHITE;
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAuthorList:(NSMutableArray *)authorList {
    _authorList = authorList;
    
//    //TODO -- 测试代码
//    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
//    for(int i = 0; i < 20; i++) {
//        AuthorInfo *authorInfo = [[AuthorInfo alloc] init];
//        authorInfo.avatar = @"http://www.baidu.com/test.png";
//        [tempArray addObject:authorInfo];
//    }
//    _authorList = tempArray;
//    //TODO -- 测试代码
    
    for(UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    if(_authorList) {
        CGFloat buttonWidth = TRANS_VALUE(26.0f);
        CGFloat buttonHeight = TRANS_VALUE(26.0f);
        CGFloat x = TRANS_VALUE(0.0f);
        CGFloat y = TRANS_VALUE(5.0f);
        CGFloat margin = TRANS_VALUE(10.0f);
        for(int i = 0, n = (int)_authorList.count; i < n; i++) {
            UIButton *topicButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, buttonWidth, buttonHeight)];
            [self.scrollView addSubview:topicButton];
            topicButton.clipsToBounds = YES;
            topicButton.layer.cornerRadius = TRANS_VALUE(26.0f) / 2;
            x += (buttonWidth + margin);
            AuthorInfo *authorInfo = (AuthorInfo *)[_authorList objectAtIndex:i];
            [topicButton setTitle:@"" forState:UIControlStateNormal];
            NSString *imageUrl = authorInfo.avatar;
            [topicButton sd_setBackgroundImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ic_topic_button_3"]];
        }
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        CGFloat contentWidth = ceil(x);
        contentWidth = (contentWidth > SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f)) ? contentWidth : SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f);
        self.scrollView.contentSize = CGSizeMake(contentWidth, TRANS_VALUE(0.0f));
        [self.scrollView setContentOffset:CGPointZero];
    }
}

@end
