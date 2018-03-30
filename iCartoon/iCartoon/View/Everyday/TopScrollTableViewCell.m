//
//  TopScrollTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/27.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "TopScrollTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface TopScrollTableViewCell() <XLCycleScrollViewDatasource,XLCycleScrollViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (strong, nonatomic) NSMutableArray *mutableArray;

@end

@implementation TopScrollTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.scrollView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(160.0f)) animationDuration:5.0f];
        [self.contentView addSubview:self.scrollView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(160.0f))];
        self.titleLabel.backgroundColor = [UIColor colorWithRed:235.0f/255 green:235.0f/255 blue:235.0f/255 alpha:1.0f];
        self.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
        self.titleLabel.textColor = [UIColor colorWithRed:153.0f/255 green:118.0f/255 blue:0.0f/255 alpha:1.0f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"暂无数据";
        self.titleLabel.layer.borderWidth = 0.5f;
        self.titleLabel.layer.borderColor = [UIColor colorWithRed:212.0f/255 green:212.0f/255 blue:212.0f/255 alpha:1.0f].CGColor;
        [self addSubview:self.titleLabel];

    }
    self.titleLabel.hidden = YES;
    self.backgroundColor = RGBCOLOR(247, 247, 247);
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTopList:(NSArray *)topList {
    _topList = topList;
    if(!_topList) {
        _topList = [NSArray array];
    }
    
    if(_topList.count == 0) {
        self.scrollView.hidden = YES;
        self.titleLabel.hidden = NO;
        return;
    } else {
        self.scrollView.hidden = NO;
        self.titleLabel.hidden = YES;
    }
    
//    CGFloat width = [[UIScreen mainScreen] bounds].size.width;  //这里使用屏幕宽度保险
//    for (int i = 0; i < _topList.count; i++) {
//        HomeBannerInfo *bannerInfo = (HomeBannerInfo *)[_topList objectAtIndex:i];
//        NSString  *imagePath = bannerInfo.imageUrl;
//        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, CGRectGetHeight(self.frame))];
//        imgV.contentMode = UIViewContentModeScaleAspectFill;
//        imgV.clipsToBounds = YES;
//        imgV.backgroundColor = [UIColor colorWithRed:235.0f/255 green:235.0f/255 blue:235.0f/255 alpha:1.0f];
//        imgV.clipsToBounds = YES;
//        [imgV sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"bg_top_topic_1"]];
//        
//        //图片底部bar
//        UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, floorf(0.85 *CGRectGetHeight(self.frame)), width, ceilf(0.15 *CGRectGetHeight(self.frame)))];
//        bottomBar.backgroundColor = [UIColor colorWithRed:212.0f/255 green:212.0f/255 blue:212.0f/255 alpha:0.8f];
//        [imgV addSubview:bottomBar];
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, bottomBar.frame.size.width - 20, bottomBar.frame.size.height)];
//        titleLabel.font = [UIFont systemFontOfSize:14.0f];
//        titleLabel.textColor = [UIColor whiteColor];
//        [bottomBar addSubview:titleLabel];
//        NSString *title = bannerInfo.title != nil ? bannerInfo.title : @"";
//        titleLabel.text = title;
//    }
    self.scrollView.delegate = self;
    self.scrollView.datasource = self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //    _scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

#pragma mark - XLCycleScrollViewDatasource && XLCycleScrollViewDelegate
- (NSInteger)numberOfPages {
    NSInteger count = self.topList != nil ? [self.topList count] : 0;
    return count;
}

- (UIView *)pageAtIndex:(NSInteger)index {
    if (self.topList.count == 0) {
        return 0;
    }
    HomeBannerInfo *bannerInfo = (HomeBannerInfo *)[self.topList objectAtIndex:index];
    NSString  *imagePath = bannerInfo.imageUrl;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(160.0f))];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"bg_top_topic_1"]];
    
    //图片底部bar
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, floorf(0.85 * TRANS_VALUE(160.0f)), SCREEN_WIDTH, ceilf(0.15 * TRANS_VALUE(160.0f)))];
    bottomBar.backgroundColor = [UIColor colorWithRed:212.0f/255 green:212.0f/255 blue:212.0f/255 alpha:0.8f];
    [imageView addSubview:bottomBar];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, bottomBar.frame.size.width - 20, bottomBar.frame.size.height)];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textColor = [UIColor whiteColor];
    [bottomBar addSubview:titleLabel];
    NSString *title = bannerInfo.title != nil ? bannerInfo.title : @"";
    titleLabel.text = title;
    
    //隐藏轮播标题
    bottomBar.hidden = YES;
    
    return imageView;
}

- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index {
    if (index < _topList.count && [self.delegate respondsToSelector:@selector(didClickTopBannerInfo:)]) {
        HomeBannerInfo *bannerInfo = (HomeBannerInfo *)[self.topList objectAtIndex:index];
        if(!bannerInfo.imageUrl) {
            return;
        }
        [_delegate didClickTopBannerInfo:bannerInfo];
    }
}


@end
