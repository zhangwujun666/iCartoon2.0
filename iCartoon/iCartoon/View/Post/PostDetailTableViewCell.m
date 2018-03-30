//
//  PostDetailTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/20.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "PostDetailTableViewCell.h"
#import "UIImageView+Webcache.h"

@interface PostDetailTableViewCell()

@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nicknameLabel;
@property (strong, nonatomic) UIButton *collectButton;
@property (strong, nonatomic) UIView *dividerView;
@property (strong, nonatomic) UIScrollView *contentScrollView;

@end

@implementation PostDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        //用户信息
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(5.0f), TRANS_VALUE(30.0f), TRANS_VALUE(30.0f))];
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.layer.cornerRadius = TRANS_VALUE(30.0f) / 2;
        [self.contentView addSubview:self.avatarImageView];
        
        self.nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(50.0f), TRANS_VALUE(5.0f), TRANS_VALUE(120.0f), TRANS_VALUE(30.0f))];
        self.nicknameLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
        self.nicknameLabel.textAlignment = NSTextAlignmentLeft;
        self.nicknameLabel.textColor = I_COLOR_DARKGRAY;
        [self.contentView addSubview:self.nicknameLabel];
        
        self.collectButton = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(200.0f), TRANS_VALUE(5.0f), TRANS_VALUE(80.0f), TRANS_VALUE(20.0f))];
        self.collectButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
        [self.collectButton setTitleColor:I_COLOR_DARKGRAY forState:UIControlStateNormal];
        [self.collectButton setTitle:@"已收藏5" forState:UIControlStateNormal];
        [self.collectButton setEnabled:NO];
        [self.contentView addSubview:self.collectButton];
        
        self.dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(40.0f), SCREEN_WIDTH, TRANS_VALUE(1.0f))];
        self.dividerView.backgroundColor = I_DIVIDER_COLOR;
        [self.contentView addSubview:self.dividerView];
        
        self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(40.0f), SCREEN_WIDTH, TRANS_VALUE(50.0f))];
        self.contentScrollView.backgroundColor = [UIColor clearColor];
        [self.contentScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 50.0f)];
        [self.contentView addSubview:self.contentScrollView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setPostInfo:(PostDetailInfo *)postInfo {
    if(!postInfo) {
        return;
    }
    NSString *nickname = postInfo.author.nickname;
    self.nicknameLabel.text = nickname;
    NSString *avatarUrl = postInfo.author.avatar;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_avatar_default"]];
    //收藏的个数
    NSString *collectedCount = postInfo.favorCount;
    [self.collectButton setTitle:collectedCount forState:UIControlStateNormal];
    NSString *contentStr = postInfo.content != nil ? postInfo.content : @"";
    NSMutableArray *images = postInfo.images;
    CGFloat width = SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f);
    CGFloat height = 0.0f;
    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TRANS_VALUE(14.0f)]} context:nil].size;
    height = size.height + 20.0f;
    height = ceil(height);
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), 0, width, height)];
    contentLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    contentLabel.textColor = I_COLOR_DARKGRAY;
    contentLabel.numberOfLines = 0;
    contentLabel.text = contentStr;
    [self.contentScrollView addSubview:contentLabel];
    
    CGFloat imageX = TRANS_VALUE(10.0f);
    CGFloat imageY = height + TRANS_VALUE(5.0f);
    CGFloat imageWidth = width;
    CGFloat imageHeight = TRANS_VALUE(200.0f);
    for(int i = 0, n = (int)images.count; i < n; i++) {
        PostPictureInfo *imageInfo = (PostPictureInfo *)[images objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageWidth, imageHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFit | UIViewContentModeCenter;
        imageY += (imageHeight + TRANS_VALUE(5.0f));
        [self.contentScrollView addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"bg_topic_pic_1"]];
    }
    height = imageY;
    self.contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height);
    CGRect rect = self.contentScrollView.frame;
    self.contentScrollView.frame = CGRectMake(rect.origin.x, rect.origin.y, SCREEN_WIDTH, height);
}


+ (CGFloat)heightForCell:(PostDetailInfo *)postInfo {
    NSString *contentStr = postInfo.content != nil ? postInfo.content : @"";
    CGFloat width = SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f);
    CGFloat height = 0.0f;
    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TRANS_VALUE(14.0f)]} context:nil].size;
    height = size.height + 20.0f;
    height = ceil(height);
    NSMutableArray *images = postInfo.images;
    if(images.count > 0) {
        height += (images.count * TRANS_VALUE(200.0f) + TRANS_VALUE(5.0f));
    }
    height += TRANS_VALUE(5.0f);
    return height;
}

@end
