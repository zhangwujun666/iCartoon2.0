//
//  BloodTypeView.h
//  iCartoon
//
//  Created by glanway on 16/5/23.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BloodTypeBlock)(NSString *);

@interface BloodTypeView : UIView

@property(strong ,nonatomic) UIButton * cancelBtn;

@property(strong ,nonatomic) UILabel * titleLab;

@property(copy ,nonatomic)  BloodTypeBlock   block;

@end
