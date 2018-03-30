//
//  MyMessageNewTableViewCell.m
//  iCartoon
//
//  Created by cxl on 16/3/27.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "MyMessageTableViewCell.h"

@interface MyMessageTableViewCell ()
@property (weak, nonatomic) UILabel *titleLbl;
@property (strong, nonatomic) UIButton *headBtn;
@property (weak, nonatomic) UIImageView *iconImgView;
@property (weak, nonatomic) UILabel *msgLbl;
@property (weak, nonatomic) UIImageView *arrowImgView;
@property (assign, nonatomic) BOOL isShowDetail;
@end

@implementation MyMessageTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.headBtn];
        [self.headBtn addSubview:self.iconImgView];
        [self.headBtn addSubview:self.msgLbl];
        [self.headBtn addSubview:self.arrowImgView];
        [self addSubview:self.titleLbl];
        [self.headBtn addTarget:self action:@selector(headBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *selectionView = [[UIView alloc] initWithFrame:self.frame];
    selectionView.backgroundColor = I_COLOR_WHITE;
    self.selectedBackgroundView = selectionView;
    
    return self;
}

- (void)setTitle:(NSString *)titleName content:(NSString *)contentStr isShow:(BOOL)isShow {
    self.msgLbl.text = titleName;
    self.titleLbl.text = contentStr;
    self.isShowDetail = isShow;
    if (isShow) {
        self.titleLbl.numberOfLines = 0;
    }else{
        self.titleLbl.numberOfLines = 1;
    }
    [self startAnimation:self.arrowImgView Up:isShow complete:^{
        
    }];
}

- (void)headBtnAction {
    if (self.headBtnTapAction) {
        self.headBtnTapAction(self.isShowDetail);
    }
}

- (void)startAnimation:(UIImageView *)view Up:(BOOL)up complete:(void(^)())block
{
    if (up) {
        [UIView animateWithDuration:0.2 animations:^{
            view.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            if (block) {
                block();
            }
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            view.transform = CGAffineTransformMakeRotation(0);
        } completion:^(BOOL finished) {
            if (block) {
                block();
            }
        }];
    }
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, CONVER_VALUE(43.0f)));
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headBtn.mas_left).with.offset(CONVER_VALUE(10.0f));
        make.centerY.mas_equalTo(self.headBtn.mas_centerY);
    }];
    [self.msgLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).with.offset(CONVER_VALUE(5.0f));
        make.centerY.mas_equalTo(self.headBtn.mas_centerY);
    }];
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headBtn.mas_right).with.offset(-CONVER_VALUE(15.0f));
        make.centerY.mas_equalTo(self.headBtn.mas_centerY);
    }];

    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headBtn.mas_bottom).with.offset(CONVER_VALUE(15.0f));
        make.left.equalTo(self.mas_left).with.offset(CONVER_VALUE(15.0f));
        make.width.mas_equalTo(SCREEN_WIDTH- CONVER_VALUE(30.0f));
    }];
    if(_isShowDetail) {
        self.titleLbl.hidden = NO;
    } else {
        self.titleLbl.hidden = YES;
    }
}

- (UIButton *)headBtn {
    if (!_headBtn) {
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];//[[UIButton alloc] initWithFrame:CGRectZero];
        tempBtn.backgroundColor = [UIColor whiteColor];
        tempBtn.layer.borderColor = UIColorFromRGB(0xDCDCDC).CGColor;
        tempBtn.layer.borderWidth = 0.5;
        [self addSubview:(_headBtn = tempBtn)];
    }
    return _headBtn;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        iconImgView.image = [UIImage imageNamed:@"ic_me_bell"];
        [self addSubview:(_iconImgView = iconImgView)];
    }
    return _iconImgView;
}

- (UILabel *)msgLbl {
    if (!_msgLbl) {
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.text = @"系统通知";
        tempLbl.font = [UIFont systemFontOfSize:TRANS_VALUE(15.0f)];
        tempLbl.textColor = [UIColor blackColor];
        [self addSubview:(_msgLbl = tempLbl)];
    }
    return _msgLbl;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        arrowImgView.image = [UIImage imageNamed:@"ic_me_arrow"];
        [self addSubview:(_arrowImgView = arrowImgView)];
    }
    return _arrowImgView;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.font = [UIFont systemFontOfSize:TRANS_VALUE(13.0f)];
        tempLbl.textColor = I_COLOR_33BLACK;//UIColorFromRGB(0x00a0e9);
        [self addSubview:(_titleLbl = tempLbl)];
    }
    return _titleLbl;
}



@end
