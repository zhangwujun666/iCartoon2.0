//
//  UIViewController+Custom.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "UIViewController+Custom.h"

@implementation UIViewController (Custom)

- (void)setBackNavgationItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_arrow_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popBack)];
}

- (void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
