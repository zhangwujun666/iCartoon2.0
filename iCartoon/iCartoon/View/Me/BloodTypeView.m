//
//  BloodTypeView.m
//  iCartoon
//
//  Created by glanway on 16/5/23.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "BloodTypeView.h"


@interface BloodTypeView ()

@property(assign,nonatomic)BOOL  btnSelected;
@property(retain,nonatomic)UIButton * tmpBtn;
@property(strong ,nonatomic)NSMutableArray * bloodArr;

@end

@implementation BloodTypeView



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.layer.cornerRadius =TRANS_VALUE(10.0f);
    _bloodArr = [[NSMutableArray  alloc]initWithObjects:@"A",@"B",@"O",@"AB", nil];
    
    [self  CreatUI];
    
    
    return self;
}

-(void)CreatUI{
//  CGFloat  kWide = [[UIScreen  mainScreen]  bounds].size.width;
//  CGFloat  kHigh =  [[UIScreen  mainScreen]  bounds].size.height;
    
    for (int i = 0; i<_bloodArr.count; i++) {
        
        UIButton  * bloodTypeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, TRANS_VALUE(30.0f)+i*TRANS_VALUE(44.0f),self.frame.size.width,TRANS_VALUE(44.0f))];
        
        [bloodTypeBtn setTitle:[_bloodArr  objectAtIndex:i] forState:UIControlStateNormal];
        bloodTypeBtn.titleLabel.textAlignment =NSTextAlignmentCenter;
        
        [bloodTypeBtn  addTarget:self action:@selector(SelectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bloodTypeBtn];
    }
    
    
    
   
    
    
    
    
}

-(void)SelectBtn:(UIButton*) sender{
    
    
     
    _block(sender.titleLabel.text);
    
    
    
  
    
    [self  removeFromSuperview];
    
    
}


@end
