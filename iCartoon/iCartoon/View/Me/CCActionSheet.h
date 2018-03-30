//
//  CCActionSheet.h
//  CCActionSheet
//
//  Created by maxmoo on 16/1/29.
//  Copyright © 2016年 maxmoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCActionSheet;

@protocol CCActionSheetDelegate <NSObject>

@optional
- (void)cc_actionSheetDidSelectedIndex:(NSInteger)index  AndCCActionSheet:(CCActionSheet *)sheet;

@end



@interface CCActionSheet : UIView

@property (strong, nonatomic) id<CCActionSheetDelegate> delegate;

@property (assign, nonatomic) NSInteger myTag;

+ (instancetype)shareSheet;
/**
 区分取消和选择,使用array
 回调使用协议
 */
- (void)cc_actionSheetWithSelectArray:(NSArray *)array cancelTitle:(NSString *)cancel  selectIndex:(NSInteger ) index   delegate:(id<CCActionSheetDelegate>)delegate;



@end
