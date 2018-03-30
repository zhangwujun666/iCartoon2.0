//
//  SignatureViewController.h
//  iCartoon
//
//  Created by 寻梦者 on 16/1/14.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SaveBlock)();

@interface SignatureViewController : UIViewController

@property (strong, nonatomic) NSString *signature;
@property (copy, nonatomic) SaveBlock  block;

@end
