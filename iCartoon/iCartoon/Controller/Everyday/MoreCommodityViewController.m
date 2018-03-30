//
//  MoreCommodityViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "MoreCommodityViewController.h"

@interface MoreCommodityViewController ()

@end

@implementation MoreCommodityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    self.navigationItem.title = @"全部商品";
    
    [self setBackNavgationItem];
    
    [self createUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private Method
- (void)createUI {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(120.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"no_data_hint"];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(280.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
    label.textColor = I_COLOR_33BLACK;
    label.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"暂时没有更多商品...";
    [self.view addSubview:label];
}

- (void)loadData {
    
}

@end
