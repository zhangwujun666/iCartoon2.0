//
//  PlaceHolderTextView.h
//  iCartoon
//
//  Created by 许成雄 on 16/4/7.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceHolderTextView : UITextView {
    NSString *placeHolder;
    UIColor *placeHolderColor;
    
    @private
    UILabel *placeHolderLabel;
}

@property (retain, nonatomic) UILabel *placeHolderLabel;
@property (retain, nonatomic) NSString *placeHolder;
@property (retain, nonatomic) UIColor *placeHolderColor;

- (void)textChanged:(NSNotification *)notification;

@end
