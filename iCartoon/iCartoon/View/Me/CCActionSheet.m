//
//  CCActionSheet.m
//  CCActionSheet
//
//  Created by maxmoo on 16/1/29.
//  Copyright © 2016年 maxmoo. All rights reserved.
//

#import "CCActionSheet.h"

#define CC_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define CC_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define cellHeight  TRANS_VALUE(40.0f)

@interface CCActionSheet()

@property (nonatomic, strong) UIWindow *sheetWindow;
@property (nonatomic, strong) NSArray *selectArray;
@property (nonatomic, strong) NSString *cancelString;
@property (nonatomic, strong) UIView *sheetView;
@property (nonatomic, strong) UIView *sheetView1;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation CCActionSheet

+ (instancetype)shareSheet{
    static id shareSheet;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareSheet = [[[self class] alloc] init];
    });
    return shareSheet;
}

- (void)cc_actionSheetWithSelectArray:(NSArray *)array cancelTitle:(NSString *)cancel selectIndex:(NSInteger)index delegate:(id<CCActionSheetDelegate>)delegate{
    
    self.selectArray = [NSArray arrayWithArray:array];
    self.cancelString = cancel;
    self.delegate = delegate;
    
    if (!_sheetWindow) {
        [self initSheetWindow:index];
    }
    _sheetWindow.hidden = NO;
    
    [self showSheetWithAnimation];
}

- (void)initSheetWindow:(NSInteger)index{
    _sheetWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, CC_SCREEN_WIDTH, CC_SCREEN_HEIGHT)];
    _sheetWindow.windowLevel = UIWindowLevelStatusBar;
    _sheetWindow.backgroundColor = [UIColor clearColor];
    
    _sheetWindow.hidden = YES;

    //遮罩（黑色半透明背景）
    _backView = [[UIView alloc] initWithFrame:_sheetWindow.bounds];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.0;
    [_sheetWindow addSubview:_backView];
    
    _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
    _tapGesture.numberOfTapsRequired = 1;
    [_backView addGestureRecognizer:_tapGesture];
    
    UIView *selectView = [self creatSelectButton:index];
    
    [_sheetWindow addSubview:selectView];
}


- (void)showSheetWithAnimation{
    CGFloat viewHeight = cellHeight * (self.selectArray.count+1) + TRANS_VALUE(7.5f) + (self.selectArray.count - 2) * 2;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _sheetView.frame = CGRectMake(TRANS_VALUE(15.0f), CC_SCREEN_HEIGHT - viewHeight- TRANS_VALUE(20.0f), CC_SCREEN_WIDTH -TRANS_VALUE(30.0f), viewHeight);
        _backView.alpha = 0.2;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hidSheetWithAnimation{
    CGFloat viewHeight = cellHeight * (self.selectArray.count+1) + TRANS_VALUE(7.5f) + (self.selectArray.count - 2) * 2;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _sheetView.frame = CGRectMake(TRANS_VALUE(15.0f), CC_SCREEN_HEIGHT, CC_SCREEN_WIDTH - TRANS_VALUE(30.0f), viewHeight);
        _backView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self hidActionSheet];
    }];
}

- (UIView *)creatSelectButton:(NSInteger)index{
    CGFloat viewHeight = cellHeight * (self.selectArray.count+1) + TRANS_VALUE(7.5f) + (self.selectArray.count - 2) * 2;
    _sheetView = [[UIView alloc] initWithFrame:CGRectMake(TRANS_VALUE(15.0f), CC_SCREEN_HEIGHT, CC_SCREEN_WIDTH-TRANS_VALUE(30.0f), viewHeight)];
    _sheetView.backgroundColor = [UIColor  clearColor];
    
    
    UIView * sheetView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CC_SCREEN_WIDTH - TRANS_VALUE(30.0f),cellHeight * (self.selectArray.count))];
    sheetView1.backgroundColor = [UIColor whiteColor];
    sheetView1.layer.cornerRadius = TRANS_VALUE(5.0f);
    [_sheetView  addSubview: sheetView1];
    
    
    for (int i = 0; i < self.selectArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, i * (cellHeight+1), CC_SCREEN_WIDTH - TRANS_VALUE(30.0f), cellHeight);
        [button setTitle:[NSString stringWithFormat:@"%@",self.selectArray[i]] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        
         button.titleLabel.font = [UIFont  systemFontOfSize:TRANS_VALUE(14.0f)];
        
        if (i == 0) {
            
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            
        }else{
            
            if ( i == index) {
                [button setTitleColor:  I_COLOR_YELLOW   forState:UIControlStateNormal];
            }else{
                 [button setTitleColor:I_COLOR_GRAY forState:UIControlStateNormal];
            }
            
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(buttonSelectAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            //分割线
            UIView * lineView = [[UIView alloc]initWithFrame: CGRectMake(TRANS_VALUE(15.0f), i * (cellHeight+1), CC_SCREEN_WIDTH - TRANS_VALUE(60.0f),  TRANS_VALUE(0.5f))];
            
            lineView.backgroundColor = I_BACKGROUND_COLOR;
            [_sheetView  addSubview:lineView];
            
        }

         button.tag = 1001+i;
        [_sheetView addSubview:button];
    }
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, viewHeight - cellHeight, CC_SCREEN_WIDTH- TRANS_VALUE(30.0f), cellHeight);
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.layer.cornerRadius =  TRANS_VALUE(5.0f);
    [cancelButton setTitle:[NSString stringWithFormat:@"%@",self.cancelString] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(buttonSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = 1000;
     cancelButton.titleLabel.font = [UIFont  systemFontOfSize:TRANS_VALUE(14.0f)];
    [_sheetView addSubview:cancelButton];
    
    return _sheetView;
}

- (void)buttonSelectAction:(UIButton *)btn{
    UIButton *button = (UIButton *)btn;
    NSInteger index = button.tag - 1001;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cc_actionSheetDidSelectedIndex:AndCCActionSheet:)]) {
        [self.delegate cc_actionSheetDidSelectedIndex:index AndCCActionSheet:self];
    }
    [self hidSheetWithAnimation];
}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    [self hidSheetWithAnimation];
}

- (void)hidActionSheet{
    _sheetWindow.hidden = YES;
    _sheetWindow = nil;
}

@end
