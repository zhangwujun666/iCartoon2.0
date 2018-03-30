//
//  LoginSucAttentionView.h
//  iCartoon
//
//  Created by cxl on 16/3/26.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol LoginSucAttentionViewDelegate <NSObject>

- (void)attentItemsArr:(NSArray *)itemsArr;

@end

@interface LoginSucAttentionView : UIView
@property (weak, nonatomic) id<LoginSucAttentionViewDelegate> delegate;
- (void)show;
- (void)hidden;
@end
