//
//  MyShareTableViewCell.m
//  iCartoon
//
//  Created by cxl on 16/3/27.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "MyShareTableViewCell.h"

@interface MyShareTableViewCell ()

@property (weak, nonatomic) UIImageView *iconImgView;
@property (weak, nonatomic) UILabel *titleLbl;
@property (weak, nonatomic) UILabel *detailLbl;
@end

@implementation MyShareTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.titleLbl];
        [self addSubview:self.detailLbl];
    }
    return self;
}

- (void)setImgName:(NSString *)imgName
             title:(NSString *)titleName status:(NSString *)statusType {
    self.iconImgView.image = [UIImage imageNamed:imgName];
    self.titleLbl.text = [NSString stringWithFormat:@"%@",titleName];
//    NSLog(@"statusType ============= %@",statusType);
    if ([statusType isEqualToString:@"0"]) {
        self.detailLbl.textColor = [UIColor redColor];
        self.detailLbl.text = @"未绑定";
    }else{
        self.detailLbl.textColor = [UIColor grayColor];
        self.detailLbl.text = @"已绑定";
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(CONVER_VALUE(15.0f));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(30.0f), CONVER_VALUE(30.0f)));
    }];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).with.offset(CONVER_VALUE(10.0f));
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-CONVER_VALUE(20.0f));
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:(_iconImgView = iconImgView)];
    }
    _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    return _iconImgView;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.font = [UIFont systemFontOfSize:CONVER_VALUE(15.0f)];
        tempLbl.textColor = [UIColor blackColor];
        [self addSubview:(_titleLbl = tempLbl)];
    }
    return _titleLbl;
}

- (UILabel *)detailLbl {
    if (!_detailLbl) {
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.font = [UIFont systemFontOfSize:CONVER_VALUE(14.0f)];
        tempLbl.textColor = [UIColor grayColor];
        [self addSubview:(_detailLbl = tempLbl)];
    }
    return _detailLbl;
}

@end
