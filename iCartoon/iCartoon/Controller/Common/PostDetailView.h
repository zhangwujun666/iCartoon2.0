//
//  PostDetailView.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/23.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostDetailInfo.h"
#import "PPLabel.h"
@class PostDetailView;

@protocol PostDetailViewDelegate <NSObject>

@optional
- (void)authorClickAtItem:(AuthorInfo *)authorInfo;

- (void)themeClickAtItem:(ThemeInfo *)themeInfo;

- (void)pictureClickAtIndex:(NSInteger)index forImages:(NSArray *)images;

@end

@interface PostDetailView : UIView<PPLabelDelegate>
@property (nonatomic,strong)NSMutableArray * pictureArray;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (assign, nonatomic) id<PostDetailViewDelegate> delegate;

- (instancetype)initWithPostInfo:(PostDetailInfo *)detaiInfo andDataArray:(NSMutableArray *)dataArray;


@end
