//
//  SearchAuthorTableViewCell.h
//  iCartoon
//
//  Created by 寻梦者 on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorInfo.h"

@protocol SearchAuthorTableViewCellDelegate <NSObject>

@optional
- (void)authorButtonClickedAtItem:(AuthorInfo *)authorInfo;

@end

@interface SearchAuthorTableViewCell : UITableViewCell

@property (assign, nonatomic) id<SearchAuthorTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSArray *authorArray;

@end
