//
//  DraftBoxTableViewCell.m
//  iCartoon
//
//  Created by cxl on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "DraftBoxTableViewCell.h"
#import "DraftInfo.h"

@interface DraftBoxTableViewCell ()
{
    UIImageView *indicatorImgView;
}
@property (weak, nonatomic) UILabel *titleLbl;
@property (weak, nonatomic) UILabel *dateLbl;
@property (weak, nonatomic) UILabel *contentLbl;

@property (weak, nonatomic) UIImageView *iconImgView;
@end

@implementation DraftBoxTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!indicatorImgView) {
//            UIImageView *m_imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_msg"]];
//            CGRect indicatorFrame = CGRectMake(-CGRectGetWidth(m_imgView.bounds), fabs(self.frame.size.height-CGRectGetHeight(m_imgView.bounds))/2, CGRectGetWidth(m_imgView.bounds), CGRectGetHeight(m_imgView.bounds));
            CGRect indicatorFrame = CGRectMake(-30.0f, CONVER_VALUE(18.0f), CONVER_VALUE(15.0f), CONVER_VALUE(15.0f));
            indicatorImgView = [[UIImageView alloc] initWithFrame:indicatorFrame];
            [self.contentView addSubview:indicatorImgView];
        }
        [self addSubview:self.titleLbl];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(CONVER_VALUE(15.0f));
            make.left.mas_equalTo(self.mas_left).with.offset(CONVER_VALUE(30.0f));
        }];
        [self addSubview:self.dateLbl];
        [self.dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLbl.mas_bottom);
            make.left.mas_equalTo(self.titleLbl.mas_left);
        }];
        [self addSubview:self.iconImgView];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-CONVER_VALUE(20.0f));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(25.0f), CONVER_VALUE(25.0f)));
        }];
        
        [self addSubview:self.contentLbl];
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateLbl.mas_bottom).with.offset(5);
            make.left.mas_equalTo(self.dateLbl.mas_left);
            make.width.mas_equalTo(SCREEN_WIDTH - CONVER_VALUE(90.0f));
        }];
        self.titleLbl.text = @"摸摸鱼";
        self.dateLbl.text = @"03-04 15:35:00";
        self.contentLbl.text = @"草稿箱是用来存放暂时性的文件，待修改内容的编辑文件或存放草稿的地方。草稿箱有实际的和虚拟的，实物就是一个箱子，只是它的用途决定的。";        
    }
    return self;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:(_titleLbl = tempLbl)];
    }
    return _titleLbl;
}

- (UILabel *)dateLbl {
    if (!_dateLbl) {
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.font = [UIFont systemFontOfSize:12.0f];
        tempLbl.textColor = [UIColor grayColor];
        [self addSubview:(_dateLbl = tempLbl)];
    }
    return _dateLbl;
}

- (UILabel *)contentLbl {
    if (!_contentLbl) {
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.font = [UIFont systemFontOfSize:15.0f];
        tempLbl.numberOfLines = 0;
        [self addSubview:(_contentLbl = tempLbl)];
    }
    return _contentLbl;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        UIImageView *tempImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        tempImgView.image = [UIImage imageNamed:@"ic_draft_edit"];
        [self addSubview:(_iconImgView = tempImgView)];
    }
    return _iconImgView;
}


- (void)setMyDraftInfo:(DraftInfo *)myDraftInfo {
    _myDraftInfo = myDraftInfo;
    self.titleLbl.text = myDraftInfo.title;
    self.contentLbl.text = myDraftInfo.content;
    self.dateLbl.text = [NSString stringWithFormat:@"%@-%@ %@:%@:%@",
                         [myDraftInfo.createTime substringWithRange:NSMakeRange(4, 2)],
                         [myDraftInfo.createTime substringWithRange:NSMakeRange(6, 2)],
                         [myDraftInfo.createTime substringWithRange:NSMakeRange(8, 2)],
                         [myDraftInfo.createTime substringWithRange:NSMakeRange(10, 2)],
                         [myDraftInfo.createTime substringWithRange:NSMakeRange(12, 2)]
                         ];
//    myDraftInfo.createTime;//03-04 15:35:00 //2016 03 30 02 17 00
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    if (self.isEditing) {
        self.iconImgView.hidden = YES;
        if (_mSelected) {
            [indicatorImgView setImage:[UIImage imageNamed:@"ic_message_on"]];
        }else{
            [indicatorImgView setImage:[UIImage imageNamed:@"ic_message_off"]];
        }
    }else{
        self.iconImgView.hidden = NO;
    }
    [UIView commitAnimations];
}

@end
