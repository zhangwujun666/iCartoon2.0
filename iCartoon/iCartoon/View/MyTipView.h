//
//  MyTipView.h
//  iCartoon
//
//  Created by glanway on 16/4/21.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TipOkBlock)();
typedef void (^TipCancelBlock)();

@interface MyTipView : UIView

@property (strong,nonatomic) UILabel  * tipLab;
@property (strong,nonatomic) UILabel  * tipLab1;
@property (strong,nonatomic) UIButton * cancelBtn;
@property (strong,nonatomic) UIButton * okBtn;
@property (strong,nonatomic) UIView   * myView;

@property (copy,nonatomic) TipOkBlock  block;
@property (copy,nonatomic) TipCancelBlock block1;

@end
