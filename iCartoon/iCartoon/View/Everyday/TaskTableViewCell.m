//
//  TaskTableViewCell.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "TaskTableViewCell.h"
#import "ProgressBarView.h"
#import "UIImageView+Webcache.h"
#import "APIConfig.h"
#import "Context.h"

@interface TaskTableViewCell()

@property (strong, nonatomic) UIImageView *pictureImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) ProgressBarView *progressView;
@property (strong, nonatomic) UILabel *finishedLabel;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UIButton *collectButton;

@end

@implementation TaskTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(9.0f), TRANS_VALUE(72.0f), TRANS_VALUE(72.0f))];
        self.pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.pictureImageView.clipsToBounds = YES;
        self.pictureImageView.layer.borderWidth = 0.5f;
        self.pictureImageView.layer.borderColor = I_DIVIDER_COLOR.CGColor;
        self.pictureImageView.backgroundColor = I_BACKGROUND_COLOR;
        [self.pictureImageView setImage:[UIImage imageNamed:@"ic_picture_default"]];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(96.0f), TRANS_VALUE(9.0f), TRANS_VALUE(204.0f), TRANS_VALUE(14.0f))];
        self.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
        self.titleLabel.textColor = I_COLOR_BLACK;
        self.titleLabel.text = @"【投票】《画江湖之不良人》你说什么...";
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(96.0f), TRANS_VALUE(26.0f), TRANS_VALUE(204.0f), TRANS_VALUE(14.0f))];
        self.timeLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        self.timeLabel.textColor = I_COLOR_DARKGRAY;
        self.timeLabel.text = @"2015-11-02至2015-12-02";
        self.timeLabel.textAlignment=NSTextAlignmentCenter;
        self.progressView = [[ProgressBarView alloc] initWithFrame:CGRectMake(TRANS_VALUE(96.0f), TRANS_VALUE(44.0f), TRANS_VALUE(214.0f), TRANS_VALUE(14.0f))];
        
        self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(91.0f), TRANS_VALUE(56.0f), TRANS_VALUE(70.0f), TRANS_VALUE(30.0f))];
        self.progressLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        self.progressLabel.textColor = I_COLOR_YELLOW;
        self.progressLabel.textAlignment = NSTextAlignmentRight;
        self.progressLabel.text = @"80%进行中";
        
        //UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(170.0f), TRANS_VALUE(66.0f), 1.0f, TRANS_VALUE(11.0f))];
//        UIView * dividerView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.progressLabel.frame), TRANS_VALUE(66.0f), 1.0f, TRANS_VALUE(11.0f))];
               UIView * dividerView = [[UIView alloc]initWithFrame:CGRectMake(TRANS_VALUE(166.0f), TRANS_VALUE(66.0f), 1.0f, TRANS_VALUE(11.0f))];
        dividerView.backgroundColor = I_DIVIDER_COLOR;
        [self.contentView addSubview:dividerView];
        
        self.finishedLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(171.0f), TRANS_VALUE(56.0f), TRANS_VALUE(65.0f), TRANS_VALUE(30.0f))];
        self.finishedLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        self.finishedLabel.textColor = I_COLOR_YELLOW;
        self.finishedLabel.text = @"60人已完成";
        
        self.collectButton = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(250.0f), TRANS_VALUE(56.0f), TRANS_VALUE(65.0f), TRANS_VALUE(30.0f))];
        self.collectButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(11.0f)];
        [self.collectButton setTitleColor:I_COLOR_GRAY forState:UIControlStateNormal];
        [self.collectButton setTitle:@"收藏" forState:UIControlStateNormal];
        [self.collectButton setImage:[UIImage imageNamed:@"ic_home_task_collect"] forState:UIControlStateNormal];
        self.collectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [self.contentView addSubview:self.pictureImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.progressView];
        [self.contentView addSubview:self.finishedLabel];
        [self.contentView addSubview:self.progressLabel];
        [self.contentView addSubview:self.collectButton];
    }
    return self;
}

- (void)setTaskItem:(TaskInfo *)taskItem {
    _taskItem = taskItem;
//    NSLog(@"---------------------------%@",taskItem.participants);
    NSString * participants = _taskItem.participants != nil ? _taskItem.participants : @"0";
    if(_taskItem) {
        NSString *titleStr = _taskItem.title != nil ? _taskItem.title : @"";
        self.titleLabel.text = titleStr;
        if(_taskItem.imageUrl) {
            NSString *imageURL = [NSString stringWithFormat:@"%@", _taskItem.imageUrl];
            [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"ic_picture_default"]];
        }
//        NSLog(@"\n_taskItem.type = %d",_taskItem.type);
//        NSString *startTime = _taskItem.startTime;
//        if(startTime.length >= 10) {
//            startTime = [startTime substringToIndex:10];
//        }
//        NSString *endTime = taskItem.endTime;
//        if(endTime.length >= 10) {
//            endTime = [endTime substringToIndex:10];
//        }
//        NSString *timeStr = [NSString stringWithFormat:@"%@至%@", startTime, endTime];
//        self.timeLabel.text = timeStr;
        if (_taskItem.type == 1) {//投票
            NSString *startTime = _taskItem.startTime;
            if(startTime.length >= 10) {
                startTime = [startTime substringToIndex:10];
            }
            NSString *endTime = taskItem.endTime;
            if(endTime.length >= 10) {
                endTime = [endTime substringToIndex:10];
            }
            NSString *timeStr = [NSString stringWithFormat:@"%@至%@", startTime, endTime];
            self.timeLabel.text = timeStr;
            
            NSString *progressStr = _taskItem.progress;
            NSInteger status = [_taskItem.status integerValue];
            [self.progressView setRateOfProgress:progressStr withStatus:status];
            NSString *finishStr = [NSString stringWithFormat:@"%@人已完成", participants];
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:finishStr];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_YELLOW range:NSMakeRange(0, finishStr.length - 3)];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_DARKGRAY range:NSMakeRange(finishStr.length - 3, 3)];
            self.finishedLabel.attributedText = attributedStr;
            NSString *progressString = @"";
            double progressValue = [_taskItem.progress doubleValue];
            if(progressValue >= 0.0f && progressValue < 100.0f) {
                progressString = [NSString stringWithFormat:@"%.lf%%进行中", progressValue];
            } else if(progressValue >= 100.0f) {
                progressValue = 100.0f;
                progressString = [NSString stringWithFormat:@"%.lf%%已结束", progressValue];
            } else {
                progressValue = 0.0f;
                progressString = [NSString stringWithFormat:@"%.lf%%即将开始", progressValue];
            }
            NSMutableAttributedString *attributedStr1 = [[NSMutableAttributedString alloc] initWithString:progressString];
            [attributedStr1 addAttribute:NSForegroundColorAttributeName value:I_COLOR_DARKGRAY range:NSMakeRange(0, progressString.length)];
            [attributedStr1 addAttribute:NSForegroundColorAttributeName value:I_COLOR_YELLOW range:NSMakeRange(0, [NSString stringWithFormat:@"%.01lf%%", progressValue].length-2)];
            self.progressLabel.attributedText = attributedStr1;
        }else{//投稿
            if (_taskItem.draftStatus == 2 ) {//投稿完成
                NSString *startTime = _taskItem.startTime;
                if(startTime.length >= 10) {
                    startTime = [startTime substringToIndex:10];
                }
                NSString *endTime = taskItem.endTime;
                if(endTime.length >= 10) {
                    endTime = [endTime substringToIndex:10];
                }
                NSString *timeStr = [NSString stringWithFormat:@"%@至%@", startTime, endTime];
                self.timeLabel.text = timeStr;
                
                NSString *progressStr = _taskItem.progress;
                NSInteger status = [_taskItem.status integerValue];
                [self.progressView setRateOfProgress:progressStr withStatus:status];
                NSString *finishStr = [NSString stringWithFormat:@"%@人已完成", participants];
                NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:finishStr];
                [attributedStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_YELLOW range:NSMakeRange(0, finishStr.length - 3)];
                [attributedStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_DARKGRAY range:NSMakeRange(finishStr.length - 3, 3)];
                self.finishedLabel.attributedText = attributedStr;
                NSString *progressString = @"";
                double progressValue = [_taskItem.progress doubleValue];
                if(progressValue > 0.0f && progressValue < 100.0f) {
                    progressString = [NSString stringWithFormat:@"%.lf%%进行中", progressValue];
                } else if(progressValue >= 100.0f) {
                    progressValue = 100.0f;
                    progressString = [NSString stringWithFormat:@"%.lf%%已结束", progressValue];
                } else {
                    progressValue = 0.0f;
                    progressString = [NSString stringWithFormat:@"%.lf%%即将开始", progressValue];
                }
                NSMutableAttributedString *attributedStr1 = [[NSMutableAttributedString alloc] initWithString:progressString];
                [attributedStr1 addAttribute:NSForegroundColorAttributeName value:I_COLOR_DARKGRAY range:NSMakeRange(0, progressString.length)];
                [attributedStr1 addAttribute:NSForegroundColorAttributeName value:I_COLOR_YELLOW range:NSMakeRange(0, [NSString stringWithFormat:@"%.01lf%%", progressValue].length-2)];
                self.progressLabel.attributedText = attributedStr1;
            }else{//投稿未完成
                NSString *startTime = _taskItem.draftStartDate;
                if(startTime.length >= 10) {
                    startTime = [startTime substringToIndex:10];
                }
                NSString *endTime = taskItem.draftEndDate;
                if(endTime.length >= 10) {
                    endTime = [endTime substringToIndex:10];
                }
                NSString *timeStr = [NSString stringWithFormat:@"%@至%@", startTime, endTime];
                self.timeLabel.text = timeStr;
    
                NSString *progressStr = _taskItem.draftPercent;
                NSInteger status = _taskItem.draftStatus;
                [self.progressView setRateOfProgress:progressStr withStatus:status];
                NSString *finishStr = [NSString stringWithFormat:@"%@人已完成", _taskItem.draftPersonCount];
                NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:finishStr];
                [attributedStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_YELLOW range:NSMakeRange(0, finishStr.length - 3)];
                [attributedStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_DARKGRAY range:NSMakeRange(finishStr.length - 3, 3)];
                self.finishedLabel.attributedText = attributedStr;
                NSString *progressString = @"";
                double progressValue = [_taskItem.draftPercent doubleValue];
                if((progressValue > 0.0f && progressValue < 100.0f)||_taskItem.draftStatus == 1) {
                    progressString = [NSString stringWithFormat:@"%.lf%%进行中", progressValue];
                } else {
                    progressValue = 0.0f;
                    progressString = [NSString stringWithFormat:@"%.lf%%即将开始", progressValue];
                }
                NSMutableAttributedString *attributedStr1 = [[NSMutableAttributedString alloc] initWithString:progressString];
                [attributedStr1 addAttribute:NSForegroundColorAttributeName value:I_COLOR_DARKGRAY range:NSMakeRange(0, progressString.length)];
                [attributedStr1 addAttribute:NSForegroundColorAttributeName value:I_COLOR_YELLOW range:NSMakeRange(0, [NSString stringWithFormat:@"%.01lf%%", progressValue].length-2)];
                self.progressLabel.attributedText = attributedStr1;

            }
        }

//        NSString *progressStr = _taskItem.progress;
//        NSInteger status = [_taskItem.status integerValue];
//        [self.progressView setRateOfProgress:progressStr withStatus:status];
//        NSString *finishStr = [NSString stringWithFormat:@"%@人完成", _taskItem.participants];
//        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:finishStr];
//        [attributedStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_YELLOW range:NSMakeRange(0, finishStr.length - 2)];
//        [attributedStr addAttribute:NSForegroundColorAttributeName value:I_COLOR_DARKGRAY range:NSMakeRange(finishStr.length - 2, 2)];
//        self.finishedLabel.attributedText = attributedStr;
//        NSString *progressString = @"";
//        double progressValue = [_taskItem.progress doubleValue];
//        if(progressValue > 0.0f && progressValue < 100.0f) {
//            progressString = [NSString stringWithFormat:@"%.lf%%进行中", progressValue];
//        } else if(progressValue >= 100.0f) {
//            progressValue = 100.0f;
//            progressString = [NSString stringWithFormat:@"%.lf%%已结束", progressValue];
//        } else {
//            progressValue = 0.0f;
//            progressString = [NSString stringWithFormat:@"%.lf%%即将开始", progressValue];
//        }
//        NSMutableAttributedString *attributedStr1 = [[NSMutableAttributedString alloc] initWithString:progressString];
//        [attributedStr1 addAttribute:NSForegroundColorAttributeName value:I_COLOR_DARKGRAY range:NSMakeRange(0, progressString.length)];
//        [attributedStr1 addAttribute:NSForegroundColorAttributeName value:I_COLOR_YELLOW range:NSMakeRange(0, [NSString stringWithFormat:@"%.01lf%%", progressValue].length-2)];
//        self.progressLabel.attributedText = attributedStr1;
        
        if([taskItem.collectStatus isEqualToString:@"1"]) {
            [self.collectButton setTitle:@"取消收藏" forState:UIControlStateNormal];
            [self.collectButton setImage:[UIImage imageNamed:@"ic_action_collect_done"] forState:UIControlStateNormal];
        } else {
            [self.collectButton setTitle:@"收藏" forState:UIControlStateNormal];
            [self.collectButton setImage:[UIImage imageNamed:@"ic_action_collect_undo"] forState:UIControlStateNormal];
        }
        [self.collectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, TRANS_VALUE(4.0f), 0, 0)];
        [self.collectButton addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
//        if(![Context sharedInstance].token || [[Context sharedInstance].token isEqualToString:@""]) {
//            self.collectButton.hidden = YES;
//        } else {
//            self.collectButton.hidden = NO;
//        }
    }
}

- (void)collectAction {
    if([self.delegate respondsToSelector:@selector(collectTaskForItem:atIndexPath:)]) {
        if(!self.taskItem) {
            return;
        }
        [self.delegate collectTaskForItem:self.taskItem atIndexPath:self.indexPath];
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
