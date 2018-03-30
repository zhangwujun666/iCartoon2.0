//
//  MyTipView.m
//  iCartoon
//
//  Created by glanway on 16/4/21.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "MyTipView.h"



@implementation MyTipView


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    CGFloat  kWidth = self.bounds.size.width;
    CGFloat  kHight = self.bounds.size.height;
    
    if (self) {
        
        self.backgroundColor = [UIColor  colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
        
        _myView = [[UIView  alloc]initWithFrame:CGRectMake(kWidth/8, kHight*9/24, kWidth*3/4, kHight/3)];
        _myView.layer.cornerRadius = 10;
        _myView.backgroundColor = [UIColor  whiteColor];
        [self   addSubview:_myView];
        
        
        _tipLab = [[UILabel   alloc]initWithFrame:CGRectMake(0, kHight/18, kWidth*3/4, kHight/18)];
//        _tipLab.backgroundColor = [UIColor redColor];
        _tipLab.text = @"真的……不要人家了?";
        _tipLab.textAlignment = NSTextAlignmentCenter;
        [_myView  addSubview:_tipLab];
        
        
        _tipLab1 = [[UILabel   alloc]initWithFrame:CGRectMake(0, kHight/9, kWidth*3/4, kHight/18)];
//        _tipLab1.backgroundColor = [UIColor grayColor];
        _tipLab1.text = @"(´•̥ ̯ •̥`) ꉂ";
        _tipLab1.textAlignment = NSTextAlignmentCenter;
        [_myView  addSubview:_tipLab1];
        
        
        
        
        
        _okBtn = [[UIButton  alloc]initWithFrame:CGRectMake(kWidth*3/40, kHight*2/9, kWidth*21/80, kHight*2/27)];
        [_okBtn addTarget:self action:@selector(determinePerform) forControlEvents:UIControlEventTouchUpInside];
        _okBtn.layer.cornerRadius =   kHight/27;
        [_okBtn setTitle:@"狠心删除" forState:UIControlStateNormal];
        _okBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _okBtn.backgroundColor= [UIColor  redColor];
        [_myView  addSubview:_okBtn];
        

        
        _cancelBtn = [[UIButton  alloc]initWithFrame:CGRectMake(kWidth*33/80, kHight*2/9, kWidth*21/80, kHight*2/27)];
        [_cancelBtn addTarget:self action:@selector(cancaelPerform) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.layer.cornerRadius =  kHight/27;
        [_cancelBtn  setTitle:@"怎么会呢" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _cancelBtn.backgroundColor= [UIColor  grayColor];
        [_myView  addSubview:_cancelBtn];
        
        
        
        
        
   
    }
    
    return self;
    
}


-(void)determinePerform{
    
       _block();
    
}

-(void)cancaelPerform{

       _block1();
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
