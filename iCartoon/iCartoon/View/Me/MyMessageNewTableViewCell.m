//
//  MyMessageNewTableViewCell.m
//  iCartoon
//
//  Created by cxl on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "MyMessageNewTableViewCell.h"
#import "DraftPostInfo.h"

@interface MyMessageNewTableViewCell () {
    UIImageView *indicatorImgView;
}

@property (weak, nonatomic) UILabel *titleLabel;

@end

@implementation MyMessageNewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!indicatorImgView) {
            CGRect indicatorFrame = CGRectMake(-30.0f, CONVER_VALUE(14.0f), CONVER_VALUE(15.0f), CONVER_VALUE(15.0f));
            indicatorImgView = [[UIImageView alloc] initWithFrame:indicatorFrame];
            [self.contentView addSubview:indicatorImgView];
        }
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).with.offset(CONVER_VALUE(7.0f));
            make.left.mas_equalTo(self.mas_left).with.offset(CONVER_VALUE(30.0f));
            make.width.mas_equalTo(SCREEN_WIDTH - CONVER_VALUE(40.0f));
            make.height.mas_equalTo(CONVER_VALUE(30.0f));
        }];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.text = @"系统消息:我是系统消息, 请不要删除我";
    }

    UIView *selectionView = [[UIView alloc] initWithFrame:self.frame];
    selectionView.backgroundColor = I_COLOR_WHITE;
    self.selectedBackgroundView = selectionView;
    
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        tempLbl.font = [UIFont systemFontOfSize:CONVER_VALUE(15.0f)];
        [self addSubview:(_titleLabel = tempLbl)];
    }
    return _titleLabel;
}

- (void)setMessageInfo:(MessageInfo *)messageInfo {
    _messageInfo = messageInfo;
    self.titleLabel.text = _messageInfo.title;
    if ([_messageInfo.status isEqualToString:@"1"]) {
        self.titleLabel.textColor = [UIColor grayColor];
    }else{
         self.titleLabel.textColor = [UIColor blackColor];
    }
}

- (void)changeImageon{
    _mSelected = 1;
}
- (void)changeImageoff{
    _mSelected = 0;
}
- (void)layoutSubviews {
     [super layoutSubviews];
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeImageon) name:@"AllSelect" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeImageoff) name:@"AllCancel" object:nil];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    if(self.isEditing) {
        if (_mSelected) {
            [indicatorImgView setImage:[UIImage imageNamed:@"ic_message_on"]];
        } else{
            [indicatorImgView setImage:[UIImage imageNamed:@"ic_message_off"]];
        }
    }
    [UIView commitAnimations];
}

@end
