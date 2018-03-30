//
//  MyTaskTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "MyTaskTableViewCell.h"

@interface MyTaskTableViewCell()

@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *taskLabel;

@end

@implementation MyTaskTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(12.0f), TRANS_VALUE(14.0f), TRANS_VALUE(296.0f), TRANS_VALUE(24.0f))];
        self.dateLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
        self.dateLabel.textColor = I_COLOR_GRAY;
        self.dateLabel.textAlignment = NSTextAlignmentLeft;
        self.dateLabel.text = @"2015年11月18日";

        self.taskLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(34.0f), TRANS_VALUE(300.0f), TRANS_VALUE(32.0f))];
        self.taskLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
        self.taskLabel.textColor = I_COLOR_33BLACK;
        self.taskLabel.textAlignment = NSTextAlignmentLeft;
        self.taskLabel.text = @"【投票】《画江湖之不良人》你说什么就是什么...";
        
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.taskLabel];
        
    }
    self.backgroundColor = I_COLOR_WHITE;
    
    return self;
}

- (void)setTaskItem:(MyTaskInfo *)taskItem {
    if(taskItem) {
        NSString *timeStr = taskItem.time != nil ? taskItem.time : @"时间未知";
        self.dateLabel.text = timeStr;
        NSString *taskStr = taskItem.title != nil ? taskItem.title : @"";
        self.taskLabel.text = taskStr;
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
