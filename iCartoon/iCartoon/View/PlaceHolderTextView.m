//
//  PlaceHolderTextView.m
//  iCartoon
//
//  Created by 许成雄 on 16/4/7.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "PlaceHolderTextView.h"

@interface PlaceHolderTextView()

@end

@implementation PlaceHolderTextView

@synthesize placeHolderLabel;
@synthesize placeHolder;
@synthesize placeHolderColor;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    placeHolderLabel = nil;
    placeHolderColor = nil;
    placeHolder = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setPlaceHolder:@""];
    [self setPlaceHolderColor:I_COLOR_GRAY];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setPlaceHolder:@""];
        [self setPlaceHolderColor:I_COLOR_GRAY];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    
    self.tintColor = I_COLOR_DARKGRAY;
    
    return self;
}

- (void)textChanged:(NSNotification *)notification {
    if([[self placeHolder] length] == 0) {
        return;
    }
    
    if([[self text] length] == 0) {
        [[self viewWithTag:999] setAlpha:1];
    } else {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}
- (void)drawRect:(CGRect)rect {
    if([self.placeHolder length] > 0) {
        if(placeHolderLabel == nil) {
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width - 8, 0)];
            placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = self.placeHolderColor;
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = 999;
            [self addSubview:placeHolderLabel];
        }
//        placeHolderLabel.text = self.placeHolder;
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.placeHolder];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:TRANS_VALUE(5.0f)];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.placeHolder length])];
        [placeHolderLabel setAttributedText:attributedString];
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
    }
    if(self.text.length == 0 && [self.placeHolder length] > 0) {
        [[self viewWithTag:999] setAlpha:1];
    }
    [super drawRect:rect];
}

@end
