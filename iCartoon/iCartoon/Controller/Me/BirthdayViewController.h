//
//  BirthdayViewController.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/14.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SaveBlock)();

@interface BirthdayViewController : UIViewController
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) NSString *birthday;

@property (nonatomic,copy)  SaveBlock block;

@end
