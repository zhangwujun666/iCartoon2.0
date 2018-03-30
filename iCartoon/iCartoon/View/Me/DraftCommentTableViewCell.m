//
//  DraftCommentTableViewCell.m
//  iCartoon
//
//  Created by cxl on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "DraftCommentTableViewCell.h"
#import "DraftPostInfo.h"
#import "UIImageView+Webcache.h"

@interface DraftCommentTableViewCell() {
    UIImageView *indicatorImgView;
}

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIView *postView;
@property (strong, nonatomic) UILabel *postContentLabel;
@property (strong, nonatomic) UIImageView *postImageView;
@property (strong, nonatomic) UIImageView *editImageView;
@property (strong, nonatomic) UIView *dividerView;

@end

@implementation DraftCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!indicatorImgView) {
            CGRect indicatorFrame = CGRectMake(-30.0f, CONVER_VALUE(18.0f), CONVER_VALUE(15.0f), CONVER_VALUE(15.0f));
            indicatorImgView = [[UIImageView alloc] initWithFrame:indicatorFrame];
            [self.contentView addSubview:indicatorImgView];
        }
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(CONVER_VALUE(15.0f));
            make.left.mas_equalTo(self.mas_left).with.offset(CONVER_VALUE(30.0f));
            make.height.mas_equalTo(CONVER_VALUE(18.0f));
        }];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(CONVER_VALUE(0.0f));
//            make.top.mas_equalTo(self.titleLabel.mas_bottom).width.offset(-CONVER_VALUE(5.0f));
            make.left.mas_equalTo(self.titleLabel.mas_left);
        }];
        
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLabel.mas_bottom).with.offset(TRANS_VALUE(8.0f));
            make.left.mas_equalTo(self.timeLabel.mas_left);
            make.width.mas_equalTo(SCREEN_WIDTH - CONVER_VALUE(90.0f));
            make.height.mas_equalTo(CONVER_VALUE(32.0f));
        }];
        
        [self.contentView addSubview:self.editImageView];
        [self.editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(CONVER_VALUE(18.0f));
            make.right.equalTo(self.mas_right).with.offset(-CONVER_VALUE(20.0f));
            make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(25.0f), CONVER_VALUE(25.0f)));
        }];
        
        [self.contentView addSubview:self.postView];
        [self.postView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).with.offset(TRANS_VALUE(0.0f));
            make.left.mas_equalTo(self.contentLabel.mas_left);
            make.width.mas_equalTo(SCREEN_WIDTH - CONVER_VALUE(64.0f));
            make.height.mas_equalTo(CONVER_VALUE(80.0f));
        }];
        
        [self.postView addSubview:self.postImageView];
        [self.postImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.postView.mas_top);
            make.left.mas_equalTo(self.postView.mas_left);
            make.width.mas_equalTo(CONVER_VALUE(80.0f));
            make.height.mas_equalTo(CONVER_VALUE(80.0f));
        }];
        
        [self.postView addSubview:self.postContentLabel];
        [self.postContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.postView.mas_top).with.offset(5);
            make.left.equalTo(self.postImageView.mas_right).with.offset(CONVER_VALUE(10.0f));
            make.width.mas_equalTo(CONVER_VALUE(218.0f));
            make.height.mas_equalTo(CONVER_VALUE(70.0f));
        }];
    
        self.titleLabel.text = @"评论";
        self.timeLabel.text = @"2016-047-1 15:35:00";
        self.contentLabel.text = @"回复:草稿箱是用来存放暂时性的文件，待修改内容的编辑文件或存放草稿的地方。草稿箱有实际的和虚拟的，实物就是一个箱子，只是它的用途决定的。";
        self.postImageView.image = [UIImage imageNamed:@"ic_picture_default"];
        self.postContentLabel.text = @"@隔壁王大爷\n12334555";
        self.postContentLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    UIView *selectionView = [[UIView alloc] initWithFrame:self.frame];
    selectionView.backgroundColor = I_COLOR_WHITE;
    self.selectedBackgroundView = selectionView;
    
    return self;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.font = [UIFont systemFontOfSize:CONVER_VALUE(14.0f)];
        [self addSubview:(_titleLabel = tempLbl)];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.font = [UIFont systemFontOfSize:CONVER_VALUE(11.0f)];
        tempLbl.textColor = UIColorFromRGB(0xA6A7A8);
        [self addSubview:(_timeLabel = tempLbl)];
    }
    return _timeLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.font = [UIFont systemFontOfSize:CONVER_VALUE(14.0f)];
        tempLbl.numberOfLines = 0;
        [self addSubview:(_contentLabel = tempLbl)];
    }
    return _contentLabel;
}

- (UIImageView *)editImageView {
    if (!_editImageView) {
        UIImageView *tempImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        tempImgView.image = [UIImage imageNamed:@"ic_draft_edit"];
        [self addSubview:(_editImageView = tempImgView)];
    }
    return _editImageView;
}

- (UIView *)postView {
    if (!_postView) {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectZero];
        tempView.backgroundColor = I_BACKGROUND_COLOR;
        [self addSubview:(_postView = tempView)];
    }
    return _postView;
}

- (UIImageView *)postImageView {
    if (!_postImageView) {
        UIImageView *tempImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        tempImgView.image = [UIImage imageNamed:@"ic_picture_default"];
        [tempImgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        tempImgView.contentMode = UIViewContentModeScaleAspectFill;
        tempImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        tempImgView.clipsToBounds  = YES;
        [self addSubview:(_postImageView = tempImgView)];
    }
    return _postImageView;
}

- (UILabel *)postContentLabel {
    if (!_postContentLabel) {
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.font = [UIFont systemFontOfSize:CONVER_VALUE(14.0f)];
        tempLbl.numberOfLines = 0;
        tempLbl.textAlignment = NSTextAlignmentLeft;
        [self addSubview:(_postContentLabel = tempLbl)];
    }
    return _postContentLabel;
}


- (void)setCommentDraftInfo:(DraftCommentInfo *)commentDraftInfo {
    _commentDraftInfo = commentDraftInfo;
    self.titleLabel.text = @"评论";
    self.timeLabel.text = _commentDraftInfo.createTime;
    NSMutableString *contentStr = [NSMutableString string];
    if(commentDraftInfo.replierId != nil)  {
        [contentStr appendFormat:@"回复@%@", commentDraftInfo.replierName];
    } else {
        [contentStr appendString:@"回复"];
    }
    [contentStr appendFormat:@":%@", commentDraftInfo.comment];
    
    NSRange range = [contentStr rangeOfString:@":"];
    
    if(range.location > 2) {
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_33BLACK range:NSMakeRange(0, contentStr.length)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_YELLOW range:NSMakeRange(2, range.location - 2)];
        self.contentLabel.attributedText = attributedStr;
    } else {
        self.contentLabel.text = contentStr;
    }

    [self.postImageView sd_setImageWithURL:[NSURL URLWithString:commentDraftInfo.postImageUrl] placeholderImage:[UIImage imageNamed:@"ic_picture_default"]];
    NSString *dataGBKtitle = [commentDraftInfo.postContent stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dataGBKtitle = [dataGBKtitle stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    dataGBKtitle = [dataGBKtitle stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
     NSString * mstrq = [self filterHTML:dataGBKtitle];
    NSMutableString *postContentStr = [NSMutableString string];
    if(commentDraftInfo.authorId != nil)  {
        [postContentStr appendFormat:@"@%@", commentDraftInfo.authorName];
    }
    [postContentStr appendFormat:@"\n%@", mstrq];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:postContentStr];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_33BLACK range:NSMakeRange(0, postContentStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_YELLOW range:NSMakeRange(0, commentDraftInfo.authorName.length + 1)];
    self.postContentLabel.attributedText = attributedStr;
    
}
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //        NSString * regEx = @"<([^>]*)>";
    //        html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    if (self.isEditing) {
        self.editImageView.hidden = YES;
        if (_mSelected) {
            [indicatorImgView setImage:[UIImage imageNamed:@"ic_message_on"]];
        }else{
            [indicatorImgView setImage:[UIImage imageNamed:@"ic_message_off"]];
        }
    }else{
        self.editImageView.hidden = NO;
    }
    [UIView commitAnimations];
}

@end
