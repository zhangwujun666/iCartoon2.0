//
//  DraftBoxTableViewCell.m
//  iCartoon
//
//  Created by cxl on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "DraftPostTableViewCell.h"
#import "DraftPostInfo.h"

@interface DraftPostTableViewCell () {
    UIImageView *indicatorImgView;
}

@property (weak, nonatomic) UILabel *titleLbl;
@property (weak, nonatomic) UILabel *dateLbl;
@property (weak, nonatomic) UILabel *contentLbl;
@property (weak, nonatomic) UIImageView *iconImgView;

@end

@implementation DraftPostTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        if (!indicatorImgView) {
            CGRect indicatorFrame = CGRectMake(-30.0f, CONVER_VALUE(18.0f), CONVER_VALUE(15.0f), CONVER_VALUE(15.0f));
            indicatorImgView = [[UIImageView alloc] initWithFrame:indicatorFrame];
            [self.contentView addSubview:indicatorImgView];
        }
        [self addSubview:self.titleLbl];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(CONVER_VALUE(15.0f));
            make.left.mas_equalTo(self.mas_left).with.offset(CONVER_VALUE(30.0f));
            make.height.mas_equalTo(CONVER_VALUE(18.0f));
        }];
        [self addSubview:self.dateLbl];
        [self.dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.titleLbl.mas_bottom);
            make.top.equalTo(self.titleLbl.mas_bottom).with.offset(CONVER_VALUE(0.0f));
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
            make.top.equalTo(self.dateLbl.mas_bottom).with.offset(TRANS_VALUE(0.0f));
            make.left.mas_equalTo(self.dateLbl.mas_left);
            make.width.mas_equalTo(SCREEN_WIDTH - CONVER_VALUE(90.0f));
            make.height.mas_equalTo(CONVER_VALUE(56.0f));
        }];
    }
    
    UIView *selectionView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = I_COLOR_WHITE;
    self.selectedBackgroundView = selectionView;

    return self;
}
- (UILabel *)titleLbl {
    if(!_titleLbl) {
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.font = [UIFont systemFontOfSize:CONVER_VALUE(14.0f)];
        [self addSubview:(_titleLbl = tempLbl)];
    }
    return _titleLbl;
}

- (UILabel *)dateLbl {
    if (!_dateLbl) {
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.font = [UIFont systemFontOfSize:CONVER_VALUE(11.0f)];
        tempLbl.textColor = UIColorFromRGB(0xA6A7A8);
        [self addSubview:(_dateLbl = tempLbl)];
    }
    return _dateLbl;
}

- (UILabel *)contentLbl {
    if(!_contentLbl) {
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.font = [UIFont systemFontOfSize:CONVER_VALUE(14.0f)];
        tempLbl.numberOfLines = 0;
        [self addSubview:(_contentLbl = tempLbl)];
    }
    return _contentLbl;
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        UIImageView *tempImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        tempImgView.image = [UIImage imageNamed:@"ic_draft_edit"];
        [self addSubview:(_iconImgView = tempImgView)];
    }
    return _iconImgView;
}
- (void)setMyDraftInfo:(DraftPostInfo *)myDraftInfo {
    _myDraftInfo = myDraftInfo;
    if (myDraftInfo.type == 1) {
         self.titleLbl.text = @"投稿";
    }else{
        self.titleLbl.text = @"脑洞";
    }
    self.contentLbl.text = myDraftInfo.title;
    self.dateLbl.text = myDraftInfo.createTime;
    NSString * str = [myDraftInfo.createTime substringWithRange:NSMakeRange(11, 8)];
    self.dateLbl.text = str;
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
    } else{
        self.iconImgView.hidden = NO;
    }
    [UIView commitAnimations];
}

@end
