//
//  SmallThemeCollectionViewCell.m
//  iHealth
//
//  Created by 寻梦者 on 15/9/5.
//  Copyright (c) 2015年 xuchengxiong. All rights reserved.
//

#import "SmallThemeCollectionViewCell.h"
#import <UIButton+WebCache.h>
#import "SmallTopicButton.h"
#import "UIImageView+Webcache.h"

@interface SmallThemeCollectionViewCell ()

@property (strong, nonatomic) SmallTopicButton *topicButton;

@end

@implementation SmallThemeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        CGFloat buttonWidth = (SCREEN_WIDTH - TRANS_VALUE(86.0f) - 2 * TRANS_VALUE(8.0f)) / 3;
        CGFloat buttonHeight = TRANS_VALUE(80.0f);
        self.topicButton = [[SmallTopicButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
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
        if (_themeInfo.title.length<=7) {
             [self.topicButton setTitle:_themeInfo.title];
        }else{
            NSString *str=[_themeInfo.title substringToIndex:7];
            NSString *str1=[_themeInfo.title substringFromIndex:7];
            if (str1.length>7) {
               NSString *newStr1=[str1 substringToIndex:7];
                NSMutableString *newStr=[NSMutableString stringWithFormat:@"%@\n%@...",str,newStr1];
            
                 [self.topicButton setTitle:newStr];
            }else{
                NSMutableString *newStr=[NSMutableString stringWithFormat:@"%@\n%@",str,str1];
                [self.topicButton setTitle:newStr];
            }
        }
        self.topicButton.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.topicButton.iconImageView sd_setImageWithURL:[NSURL URLWithString:_themeInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"ic_theme_default"]];
//        NSLog(@"---------------%@",_themeInfo.hasFollowed);
        if([_themeInfo.hasFollowed isEqualToString:@"1"] || _themeInfo.hasFollowed == nil) {
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
