//
//  LoginViewController.h
//  iCartoon
//
//  Created by 寻梦者 on 15/9/1.
//  Copyright (c) 2015年 xuchengxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^upDateBellImgBlock)();

@interface LoginViewController : UIViewController

@property (copy,nonatomic) upDateBellImgBlock block;


@end
