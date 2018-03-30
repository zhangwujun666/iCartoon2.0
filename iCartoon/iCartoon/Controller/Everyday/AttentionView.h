//
//  AttentionView.h
//  iCartoon
//
//  Created by besture on 16/4/21.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttentionView : UIView
@property (nonatomic,strong)UILabel * label2;
@property (nonatomic,strong)UILabel * label1;
- (instancetype)initTitle:(NSString *)title andtitle2 :(NSString *)title2;
- (instancetype)initTitle:(NSString *)title;
- (instancetype)initTitlestr:(NSString *)title;
- (void)show;
@end
