//
//  AuthorDetailViewController.h
//  iCartoon
//
//  Created by 寻梦者 on 15/12/30.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorInfo.h"

@interface AuthorDetailViewController : UIViewController

@property (strong, nonatomic) AuthorInfo *authorInfo;
@property (strong, nonatomic) NSString *authorUid;

@end
