//
//  LoginSucAttentionView.m
//  iCartoon
//
//  Created by cxl on 16/3/26.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "LoginSucAttentionView.h"
#import "LoginSucCollectionViewCell.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "IndexAPIRequest.h"
#import "AttentionView.h"
@interface LoginSucAttentionView ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) UIView *bottomView;
@property (weak, nonatomic) UIView *displayView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *selectedArr;
@property (strong, nonatomic) NSMutableArray *themeArray;
@end

@implementation LoginSucAttentionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addSubview:self.bottomView];
        [self addSubview:self.displayView];
        UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        testView.backgroundColor = [UIColor redColor];
        [self.displayView addSubview:testView];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,  CGRectGetWidth(self.displayView.bounds), CONVER_VALUE(360.f)) collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.allowsMultipleSelection = YES;
        [self.collectionView registerClass:[LoginSucCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier_LoginSucCollectionViewCell];
        self.collectionView.backgroundColor = I_BACKGROUND_COLOR;
        [self.displayView addSubview:self.collectionView];
        
        UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [tempBtn setBackgroundColor:UIColorFromRGB(0xFCAB6C)];
        [tempBtn setTitle:@"关注" forState:UIControlStateNormal];
        [tempBtn setImage:[UIImage imageNamed:@"ic_login_love"] forState:UIControlStateNormal];
        [tempBtn setImage:[UIImage imageNamed:@"ic_login_love"] forState:UIControlStateSelected];
        [tempBtn setImage:[UIImage imageNamed:@"ic_login_love"] forState:UIControlStateHighlighted];
        tempBtn.layer.cornerRadius = CONVER_VALUE(40.0f) / 2;
        tempBtn.clipsToBounds = YES;
        [tempBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [self.displayView addSubview:tempBtn];
        [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView.mas_bottom).with.offset(CONVER_VALUE(15.0f));
            make.centerX.mas_equalTo(self.collectionView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(CONVER_VALUE(280.0f), CONVER_VALUE(40.0f)));
        }];
            [tempBtn addTarget:self action:@selector(attentAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)show {
    UIViewController *topVC = [self getAppRootViewController];
    [topVC.view addSubview:self];
    [self loadAllTheme];
}

- (void)hidden {
    [self removeFromSuperview];
}


#pragma mark Private Method
- (void)attentAction {
    if (self.selectedArr.count==0) {
        
    }else{
        if ([self.delegate respondsToSelector:@selector(attentItemsArr:)]) {
            [self.delegate attentItemsArr:[self.selectedArr copy]
             ];
        }
    }
}
- (void)delayMethod{
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.2 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
        AttentionView * attention = [[AttentionView alloc]initTitle:@"欢迎加入熊窝！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
     [self addSubview:attention];
}
- (UIViewController *)getAppRootViewController
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    return result;
}

- (void)loadAllTheme {
    if(!self.themeArray) {
        self.themeArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.themeArray removeAllObjects];
    [SVProgressHUD showWithStatus:@"..." maskType:SVProgressHUDMaskTypeClear];
    [[IndexAPIRequest sharedInstance] getAllThemes:nil success:^(NSArray *groupThemes) {
        [SVProgressHUD dismiss];
        if(groupThemes) {
            for(ThemeGroupInfo *group in groupThemes) {
                if(group.list != nil) {
                    [self.themeArray addObjectsFromArray:group.list];
                }
            }
        }
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.collectionView reloadData];
    }];
    
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.themeArray != nil ? self.themeArray.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LoginSucCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_LoginSucCollectionViewCell forIndexPath:indexPath];
    if(indexPath.row < self.themeArray.count) {
        ThemeInfo *themeInfo = (ThemeInfo *)[self.themeArray objectAtIndex:indexPath.row];
        cell.themeInfo = themeInfo;
    }
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CONVER_VALUE(92.0f), CONVER_VALUE(120.0f));
}

//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LoginSucCollectionViewCell *cell = (LoginSucCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell selectedCollectCell];
    ThemeInfo *themeInfo = (ThemeInfo *)[self.themeArray objectAtIndex:indexPath.row];
    [self.selectedArr addObject:themeInfo];
    NSLog(@"didSelectItemAtIndexPath===%@",self.selectedArr);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    LoginSucCollectionViewCell *cell = (LoginSucCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell deselectCollectCell];
    ThemeInfo *themeInfo = (ThemeInfo *)[self.themeArray objectAtIndex:indexPath.row];
    [self.selectedArr removeObject:themeInfo];
    NSLog(@"didDeselectItemAtIndexPath===%@",self.selectedArr);
}

#pragma mark getter && setter
- (UIView *)bottomView {
    if (!_bottomView) {
        UIView *tempView = [[UIView alloc] initWithFrame:self.bounds];
        tempView.backgroundColor = [UIColor blackColor];
        tempView.alpha = 0.8;
        tempView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:(_bottomView = tempView)];
    }
    return _bottomView;
}

- (UIView *)displayView {
    if (!_displayView) {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds)-CONVER_VALUE(300.0f))/2, (CGRectGetHeight(self.bounds)-CONVER_VALUE(430.0f))/2, CONVER_VALUE(300.0f), CONVER_VALUE(430.0f))];;
        tempView.backgroundColor = I_BACKGROUND_COLOR;
        tempView.layer.cornerRadius = 5.0f;
        tempView.clipsToBounds = YES;
        tempView.layer.borderColor = UIColorFromRGB(0xf0f0f0).CGColor;
        [self addSubview:(_displayView = tempView)];
    }
    return _displayView;
}

- (NSMutableArray *)selectedArr {
    if (!_selectedArr) {
        _selectedArr = [NSMutableArray array];
    }
    return _selectedArr;
}


@end
