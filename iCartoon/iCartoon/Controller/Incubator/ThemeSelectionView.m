//
//  ThemeSelectionView.m
//  iCartoon
//
//  Created by 许成雄 on 16/4/2.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "ThemeSelectionView.h"
#import "ThemeInfo.h"
#import "PostAPIRequest.h"
#import "IndexAPIRequest.h"
@interface ThemeSelectionView()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) UIButton *searchButton;

@property (strong, nonatomic) NSString *searchKeyword;
@property (strong, nonatomic) NSMutableArray *themeArray;
@property (strong, nonatomic) ThemeInfo *selectedThemeInfo;

@property (assign, nonatomic) CGRect rect;
@property (assign, nonatomic) CGFloat mButtonHeight;

@end

@implementation ThemeSelectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame withSelectTheme:(ThemeInfo *)themeInfo {
    
    self = [super initWithFrame:frame];
    self.rect = frame;
    if(self) {
        self.backgroundColor = [UIColor magentaColor];
        CGFloat height = frame.size.height - CONVER_VALUE(60.0f);
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(TRANS_VALUE(7.0f), TRANS_VALUE(0.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(7.0f), height - TRANS_VALUE(1.0f))];
        self.scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollView];
        CGFloat marginTop = frame.size.height - CONVER_VALUE(60.0f);
        UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, SCREEN_WIDTH, 0.5f)];
        dividerView.backgroundColor = I_DIVIDER_COLOR;
        [self addSubview:dividerView];
        
        UIView *dividerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop-0.5f, SCREEN_WIDTH, 0.5f)];
        dividerView1.backgroundColor = [UIColor  colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1.0];
        [self addSubview:dividerView1];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, SCREEN_WIDTH, CONVER_VALUE(60.0f))];
        bottomView.backgroundColor = [UIColor clearColor];
        [self addSubview:bottomView];
        
        self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(TRANS_VALUE(7.0f), CONVER_VALUE(10.0f), TRANS_VALUE(186.0f), CONVER_VALUE(40.0f))];
        self.searchTextField.clipsToBounds = YES;
        self.searchTextField.backgroundColor = I_COLOR_WHITE;
        self.searchTextField.layer.cornerRadius = CONVER_VALUE(40.0f) / 2;
        self.searchTextField.font = [UIFont systemFontOfSize:CONVER_VALUE(14.0f)];
        self.searchTextField.textColor = I_COLOR_DARKGRAY;
        self.searchTextField.layer.borderWidth = CONVER_VALUE(1.0f);
        self.searchTextField.layer.borderColor=UIColorFromRGB(0xbebebe).CGColor;
        self.searchTextField.placeholder = @"输入你想搜索的熊窝";
        self.searchTextField.textAlignment = NSTextAlignmentLeft;
        [bottomView addSubview:self.searchTextField];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,CONVER_VALUE(20.0f), CONVER_VALUE(20.0f))];
        self.searchTextField.leftView = leftView;
        self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
        
        self.searchButton = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(202.0f), CONVER_VALUE(10.0f), TRANS_VALUE(110.0f), CONVER_VALUE(40.0f))];
        self.searchButton.clipsToBounds = YES;
        self.searchButton.layer.cornerRadius = CONVER_VALUE(40.0f) / 2;
        self.searchButton.backgroundColor = I_COLOR_YELLOW;
        self.searchButton.titleLabel.font = [UIFont systemFontOfSize:CONVER_VALUE(16.0f)];
        [self.searchButton setTitleColor:I_COLOR_WHITE forState:UIControlStateNormal];
        [self.searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [bottomView addSubview:self.searchButton];
    }
    
    self.selectedThemeInfo = themeInfo;
    
//    self.backgroundColor = [UIColor colorWithRed:0.0f/255 green:0.0f/255 blue:0.0f/255 alpha:0.4f];
    self.backgroundColor=UIColorFromRGB(0x333333);
    self.searchKeyword = nil;
    [self.searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)show {
    self.hidden = NO;
    self.frame = self.rect;
    self.searchKeyword = nil;
    [self loadThemeData];
    
//    CATransition *animation = [CATransition animation];
//    //设置运动时间
//    animation.duration = 0.8f;
//    //设置运动type
//    animation.type = kCATransitionMoveIn;
//    //设置子类
//    animation.subtype = kCATransitionFromTop;
//    //设置运动速度
//    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
//    [self.layer addAnimation:animation forKey:@"animation"];
    
//    self.searchKeyword = nil;
//    [self loadThemeData];
//    self.hidden = NO;
//    self.frame = CGRectMake(self.rect.origin.x, self.rect.origin.y, self.rect.size.width, 0);
//    [UIView animateWithDuration:0.8f animations:^{
//        self.frame = self.rect;
//    } completion:^(BOOL finished) {
//        [self.superview bringSubviewToFront:self];
//        self.frame = self.rect;
//    }];

}

- (void)hide {
//    [UIView animateWithDuration:0.5f animations:^{
//        self.transform = CGAffineTransformTranslate(self.transform, 0, self.rect.size.height); //实现的是平移
//    } completion:^(BOOL finished) {
        for(UIView *view in self.scrollView.subviews) {
            [view removeFromSuperview];
        }
        self.hidden = YES;
        if([self respondsToSelector:@selector(removeFromSuperview)]) {
            [self removeFromSuperview];
        }
//    }];
}

- (void)loadThemeData {
    if(!self.themeArray) {
        self.themeArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.themeArray removeAllObjects];
    for(UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *keyword = self.searchKeyword;
    if(keyword && ![keyword isEqualToString:@""]) {
        [params setObject:keyword forKey:@"keyword"];
    }
    [[IndexAPIRequest sharedInstance] getAllThemes:nil success:^(NSArray *groupThemes) {
        NSMutableArray * arr = [NSMutableArray array];
        if(groupThemes) {
            for (ThemeGroupInfo * info in groupThemes) {
                for (int i = 0; i < info.list.count; i++) {
                     [arr addObject:info.list[i]];
                }
            }
        }
        for (int i= 0 ; i < arr.count; i++) {
            [self.themeArray addObject:arr[i]];
        }
        
//        NSLog(@"self.themeArray.count === %ld",groupThemes.count);
        [self loadSelectionLabels];
    } failure:^(NSError *error) {
        
        [self loadSelectionLabels];
    }];
}
- (void)loadSelectionLabels {
    for(int i = 0, n = (int)[self.themeArray count]; i < n; i++) {
        ThemeInfo *themeInfo = (ThemeInfo *)[self.themeArray objectAtIndex:i];
        NSString *titleStr = themeInfo.title;
        titleStr = [NSString stringWithFormat:@"%@%@%@", @"  ", titleStr, @"  "];
        NSInteger tagValue = 3000 + i;
        UIButton *tagButton = [self tagButtonWithTitle:titleStr tag:tagValue];
        if(self.selectedThemeInfo != nil && [self.selectedThemeInfo.tid isEqualToString:themeInfo.tid] && [self.selectedThemeInfo.title isEqualToString:themeInfo.title]) {
            [tagButton setSelected:YES];
            tagButton.layer.borderColor = I_COLOR_YELLOW.CGColor;
        } else {
            [tagButton setSelected:NO];
            tagButton.layer.borderColor = I_COLOR_GRAY.CGColor;
        }
       
        
        [self.scrollView addSubview:tagButton];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self layoutViewsInScrollView];
    });
}

- (void)tagButtonAction:(id)sender {
    NSInteger count = [self.themeArray count];
    for(int i = 0; i < count; i++) {
        UIButton *button = (UIButton *)[self.scrollView viewWithTag:(3000 + i)];
        [button setSelected:NO];
        button.layer.borderColor = I_COLOR_GRAY.CGColor;
    }
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag - 3000;
    ThemeInfo *themeInfo = (ThemeInfo *)[self.themeArray objectAtIndex:index];
    button.selected = !button.selected;
    if(button.selected) {
        button.layer.borderColor = I_COLOR_YELLOW.CGColor;
    } else {
        button.layer.borderColor = I_COLOR_GRAY.CGColor;
    }
    if([self.delegate respondsToSelector:@selector(didSelectAtItem:)]) {
        [self.delegate didSelectAtItem:themeInfo];
    }
}

- (UIButton *)tagButtonWithTitle:(NSString *)title tag:(NSInteger)tag {
    UIButton *tagButton = [[UIButton alloc] init];
    tagButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
    [tagButton setTitleColor:I_COLOR_GRAY forState:UIControlStateNormal];
    [tagButton setTitleColor:I_COLOR_YELLOW forState:UIControlStateSelected];
    [tagButton setTitleColor:I_COLOR_YELLOW forState:UIControlStateHighlighted];
    [tagButton setTitle:title forState:UIControlStateNormal];
    [tagButton setTitle:title forState:UIControlStateHighlighted];
    [tagButton setTitle:title forState:UIControlStateSelected];
    tagButton.tag = tag;
    [tagButton sizeToFit];
    tagButton.clipsToBounds = YES;
    tagButton.layer.cornerRadius = TRANS_VALUE(8.0f);
    tagButton.layer.borderColor = I_COLOR_GRAY.CGColor;
    tagButton.layer.borderWidth = 0.5f;
    tagButton.backgroundColor = I_COLOR_WHITE;
    [tagButton addTarget:self action:@selector(tagButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return tagButton;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self loadThemeData];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.searchKeyword = textField.text;
}

#pragma mark - Aciton
- (void)searchButtonAction {
    [self.searchTextField resignFirstResponder];
    self.searchKeyword = self.searchTextField.text;
    if(!self.themeArray) {
        self.themeArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.themeArray removeAllObjects];
    for(UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *keyword = self.searchKeyword;
    if(keyword && ![keyword isEqualToString:@""]) {
        [params setObject:keyword forKey:@"keyword"];
    }
    [[PostAPIRequest sharedInstance] searchThemes:params success:^(NSArray *themeList) {
        if(themeList) {
            [self.themeArray addObjectsFromArray:themeList];
        }
        [self loadSelectionLabels];
    } failure:^(NSError *error) {
        
        [self loadSelectionLabels];
    }];
}

- (void)layoutViewsInScrollView {
    CGFloat margin = TRANS_VALUE(7.0f);
    CGFloat marginBetween = TRANS_VALUE(7.0f);
    CGFloat x = margin;
    CGFloat y = TRANS_VALUE(5.0f);
    for(int i = 0, n = (int)[self.scrollView.subviews count]; i < n; i++) {
        UIButton *button = (UIButton *)[self.scrollView viewWithTag:(3000 + i)];
        CGRect rect = button.frame;
        CGFloat buttonWidth = rect.size.width;
        CGFloat buttonHeight = rect.size.height;
        self.mButtonHeight = buttonHeight;
        if(x + buttonWidth + marginBetween > SCREEN_WIDTH - 2 * TRANS_VALUE(5.0f)) {
            x = margin;
            y += (margin + buttonHeight);
        } else {
            x = x;
            y = y;
        }
        rect = CGRectMake(x, y, buttonWidth, buttonHeight);
        button.frame = rect;
        x += (marginBetween + buttonWidth);
    }
    
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH - 2 * TRANS_VALUE(7.0f), y + margin + self.mButtonHeight + TRANS_VALUE(7.0f))];
    [self.scrollView setContentOffset:CGPointZero];
}



@end
