//
//  ProgressBarView.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/27.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressBarView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setRateOfProgress:(NSString *)rate withStatus:(NSInteger)status;

@end
