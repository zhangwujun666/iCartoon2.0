//
//  ReplyCommentTableViewCell.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/20.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMessageInfo.h"

@interface ReplyCommentTableViewCell : UITableViewCell

@property (strong, nonatomic) MyMessageInfo *messageInfo;
@property (assign, nonatomic) int type;

@end
