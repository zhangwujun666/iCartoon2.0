//
//  ShareCustomView.h
//  iCartoon
//
//  Created by 许成雄 on 16/4/21.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShareCustomViewDelegate <NSObject>
@optional
- (void)copyUrl;
@end

@interface ShareCustomView : NSObject
+ (void)shareWithContentString:(NSString *)str : (NSArray *)imageArray : (NSString *) urlString : (NSString *)titlestr;
@property (nonatomic,weak)id<ShareCustomViewDelegate>delegate;
+(void)blackViewClick;

@end

