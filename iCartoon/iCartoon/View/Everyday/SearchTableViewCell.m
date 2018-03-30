//
//  SearchTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "SearchTableViewCell.h"

@interface SearchTableViewCell() 

@property (strong, nonatomic) UILabel *taskLabel;
@property (strong, nonatomic) UIButton *deleteBtn;
@end

@implementation SearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        self.indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(9.0f), TRANS_VALUE(22.0f), TRANS_VALUE(22.0f))];
        self.indexLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
        self.indexLabel.textColor = I_COLOR_WHITE;
        self.indexLabel.textAlignment = NSTextAlignmentCenter;
        self.indexLabel.backgroundColor = UIColorFromRGB(0xFCAA6C);
        self.indexLabel.clipsToBounds = YES;
        self.indexLabel.layer.cornerRadius = TRANS_VALUE(4.0f);
        self.indexLabel.text = @"1";
        self.indexLabel.hidden = YES;

        self.taskLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(9.0f), TRANS_VALUE(280.0f), TRANS_VALUE(22.0f))];
        self.taskLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
        self.taskLabel.textColor = I_COLOR_DARKGRAY;
        self.taskLabel.textAlignment = NSTextAlignmentLeft;
        self.taskLabel.numberOfLines = 1;
        self.taskLabel.text = @"【投票】《画江湖之不良人》你说什么就是什么...";
 
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteBtn.frame = CGRectZero;
        self.deleteBtn.backgroundColor = [UIColor clearColor];
        [self.deleteBtn addTarget:self action:@selector(deleteBTnAction) forControlEvents:UIControlEventTouchUpInside];
    
        [self.contentView addSubview:self.indexLabel];
        [self.contentView addSubview:self.taskLabel];
        [self.contentView addSubview:self.deleteBtn];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(TRANS_VALUE(22.0f), TRANS_VALUE(22.0f)));
        }];
        UILabel *deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(22.0f), TRANS_VALUE(22.0f))];
        deleteLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(18.0f)];
        deleteLabel.textAlignment = NSTextAlignmentCenter;
        deleteLabel.textColor = I_COLOR_GRAY;
        deleteLabel.text = @"×";
        [self.deleteBtn addSubview:deleteLabel];
    }
    self.backgroundColor = I_COLOR_WHITE;
    
    return self;
}

- (void)setItem:(SearchHistoryInfo *)item {
    _item = item;
    if(_item) {
        NSString *taskStr = [NSString stringWithFormat:@"%@",_item.keyword];
        self.taskLabel.text = taskStr;
    }
}

- (void)deleteBTnAction {
    if (self.deleteBtnTapAction) {
        self.deleteBtnTapAction();
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
