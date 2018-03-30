//
//  ShopCollectionViewCell.m
//  iCartoon
//
//  Created by cxl on 16/3/27.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "ShopCollectionViewCell.h"
#import "UIColor+Random.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BShop.h"

@interface ShopCollectionViewCell ()
@property(weak, nonatomic) UIImageView *imgView;
@property(weak, nonatomic) UILabel *titleLbl;
@property(weak, nonatomic) UILabel *priceLbl;//价格
@property(weak, nonatomic) UILabel *amountLbl;//数量
@end

@implementation ShopCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.bounds), CONVER_VALUE(155.0f)));
        }];
        [self addSubview:self.titleLbl];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).with.offset(CONVER_VALUE(5.0f));
            make.left.mas_equalTo(self.mas_left);
            make.width.mas_equalTo(CONVER_VALUE(175.0));
        }];
        [self addSubview:self.priceLbl];
        [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLbl.mas_bottom).with.offset(CONVER_VALUE(10.0f));
            make.left.mas_equalTo(self.mas_left);
        }];
        [self addSubview:self.amountLbl];
        [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLbl.mas_bottom).with.offset(CONVER_VALUE(10.0f));
            make.right.mas_equalTo(self.mas_right);
        }];
    }
    return self;
}

- (void)setCollectionView {
    self.titleLbl.text = @"【现货】七点官方授权全职高手立绘亚克力人形立牌";
    self.priceLbl.text = @"¥99";
    self.amountLbl.text = @"34人付款";
    self.imgView.backgroundColor = [UIColor RandomColor];
}

- (void)setShop:(BShop *)shop
{
    _shop = shop;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    self.priceLbl.text = [NSString stringWithFormat:@"%@",shop.price];
    self.titleLbl.text = @"【现货】七点官方授权全职高手立绘亚克力人形立牌";
    self.amountLbl.text = @"34人付款";
}


#pragma mark getter
- (UIImageView *)imgView {
    if (!_imgView) {
        UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CONVER_VALUE(72.0), CONVER_VALUE(72.0))];
        [self addSubview:(_imgView = tempView)];
    }
    return _imgView;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.font = [UIFont systemFontOfSize:CONVER_VALUE(13.0f)];
        tempLbl.numberOfLines = 2;
        [self addSubview:(_titleLbl = tempLbl)];
    }
    return _titleLbl;
}

- (UILabel *)priceLbl {
    if (!_priceLbl) {
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.font = [UIFont systemFontOfSize:CONVER_VALUE(15.0f)];
        tempLbl.textColor = I_COLOR_YELLOW;
        [self addSubview:(_priceLbl = tempLbl)];
    }
    return _priceLbl;
}

- (UILabel *)amountLbl {
    if (!_amountLbl) {
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.textColor = UIColorFromRGB(0x9C9C9C);
        tempLbl.font = [UIFont systemFontOfSize:CONVER_VALUE(12.0f)];
        [self addSubview:(_amountLbl = tempLbl)];
    }
    return _amountLbl;
}

@end
