//
//  PostDetailTableViewCell.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/20.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostDetailInfo.h"

@interface PostDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) PostDetailInfo *postInfo;

+ (CGFloat)heightForCell:(PostDetailInfo *)postInfo;

@end
