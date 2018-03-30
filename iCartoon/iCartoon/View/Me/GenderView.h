//
//  GenderView.h
//  iCartoon
//
//  Created by glanway on 16/6/3.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GenderView;

@protocol GenderViewDelegate <NSObject>

@optional

- (void)gender_actionSheetDidSelectedIndex:(NSInteger)index  AndCCActionSheet:(GenderView *)sheet;

@end



@interface GenderView : UIView

@property (strong, nonatomic) id<GenderViewDelegate> delegate;

@property (assign, nonatomic) NSInteger myTag;

+ (instancetype)shareSheet;
/**
 区分取消和选择,使用array
 回调使用协议
 */
- (void)gender_actionSheetWithSelectArray:(NSArray *)array cancelTitle:(NSString *)cancel  selectIndex:(NSInteger ) index   delegate:(id<GenderViewDelegate>)delegate;




@end
