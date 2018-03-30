//
//  ThemeCollectionViewCell.m
//  iHealth
//
//  Created by 寻梦者 on 15/9/5.
//  Copyright (c) 2015年 xuchengxiong. All rights reserved.
//

#import "ThemeCollectionViewCell.h"
#import "TopicButton.h"
#import "UIImageView+Webcache.h"

@interface ThemeCollectionViewCell ()

@property (strong, nonatomic) TopicButton *topicButton;

@end

@implementation ThemeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        CGFloat buttonWidth = SCREEN_WIDTH / 3;
        CGFloat buttonHeight = TRANS_VALUE(108.0f);
        self.topicButton = [[TopicButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
        [self.contentView addSubview:self.topicButton];
    }
    [self.topicButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor colorWithRed:236.0f/255 green:236.0f/255 blue:236.0f/255 alpha:1.0f];
    
    return self;
}
- (void)setThemeInfo:(ThemeInfo *)themeInfo {
    _themeInfo = themeInfo;
    if(_themeInfo != nil) {
        [self.topicButton setTitle:_themeInfo.title];
        NSString *imageUrl = [NSString stringWithFormat:@"%@", _themeInfo.imageUrl];
//        if(![imageUrl hasPrefix:@"121.40.102.225:6060/am-demo/"]) {
//            imageUrl = [NSString stringWithFormat:@"121.40.102.225:6060/am-demo/%@", imageUrl];
//        }
        [self.topicButton.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"ic_theme_default"]];
        if(_themeInfo.hasFollowed != nil && [_themeInfo.hasFollowed isEqualToString:@"1"]) {
            [self.topicButton setSelected:YES];
        } else {
            [self.topicButton setSelected:NO];
        }
    }
}

- (void)buttonClickAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(collectionCellClickedAtItem:)]) {
        [self.delegate collectionCellClickedAtItem:_themeInfo];
    }
}

@end
