//
//  DiscoveryDetailViewController.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostInfo.h"

@interface PostDetailViewController : UIViewController
@property (strong, nonatomic) PostInfo *postInfo;
@property (strong, nonatomic) NSString *postId;
@property (copy,nonatomic) NSString * send;//用来接收帖子页面的“发布”进入该页面进行判断
@property (nonatomic,strong)NSString * fram;
@property (strong, nonatomic) NSString *type;
@property (strong,nonatomic)NSMutableArray * pictureArray;
@property (nonatomic,strong)NSString * fromWhere;

@end
