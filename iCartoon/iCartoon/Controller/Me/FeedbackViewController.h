//
//  FeedbackViewController.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TipBlock) ();

@interface FeedbackViewController : UIViewController

@property(copy,nonatomic)TipBlock block;

@end
