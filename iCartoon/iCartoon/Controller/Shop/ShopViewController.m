//
//  ShopViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopCollectionViewCell.h"
#import "UIColor+Random.h"
#import "BWaterflowLayout.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "BShop.h"

@interface ShopViewController ()<UICollectionViewDataSource,BWaterflowLayoutDelegate,UICollectionViewDelegate>
@property (weak, nonatomic) UICollectionView *myCollectionView;
@property (strong, nonatomic) NSMutableArray *myCollectArr;
@end

@implementation ShopViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    self.navigationItem.title = @"聚叶城";
//    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 20)];
//    topView.backgroundColor = [UIColor colorWithRed:240/255.0 green:130/255.0 blue:30/255.0 alpha:1.0];
//    [self.navigationController.navigationBar addSubview:topView];
    [self createUI];
//    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Private Method 
- (void)createUI {
    [self.view addSubview:self.myCollectionView];
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    self.myCollectionView.hidden = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(120.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"no_data_hint"];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(280.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
    label.textColor = I_COLOR_33BLACK;
    label.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"功能尚未开放, 敬请期待...";
    [self.view addSubview:label];
}

- (void)loadData {
    self.myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    
    [self.myCollectionView.mj_header beginRefreshing];
    
    self.myCollectionView.mj_footer.hidden = YES;
    
    self.myCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
}

- (void)loadNewShops {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [BShop objectArrayWithFilename:@"testData.plist"];
        [self.myCollectArr removeAllObjects];
        [self.myCollectArr addObjectsFromArray:shops];
        //加载数据
        [self.myCollectionView reloadData];
        [self.myCollectionView.mj_header endRefreshing];
    });
}
- (void)loadMoreShops {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [BShop objectArrayWithFilename:@"testData.plist"];
        [self.myCollectArr addObjectsFromArray:shops];
        
        //加载数据
        [self.myCollectionView reloadData];
        
        [self.myCollectionView.mj_footer endRefreshing];
    });
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.myCollectArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_ShopCollectionViewCell forIndexPath:indexPath];
    cell.selectedBackgroundView = [UIView new];
//    [cell setCollectionView];
    cell.shop = self.myCollectArr[indexPath.item];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"didSelectItemAtIndexPath:%ld",indexPath.row);
}

#pragma mark BWaterflowLayoutDelegate
-(CGFloat)waterflowLayout:(BWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    return CONVER_VALUE(230.0f);
}
//瀑布流列数
- (CGFloat)columnCountInWaterflowLayout:(BWaterflowLayout *)waterflowLayout {
    return 2;
}

- (CGFloat)columnMarginInWaterflowLayout:(BWaterflowLayout *)waterflowLayout {
    return CONVER_VALUE(10.0f);
}

- (CGFloat)rowMarginInWaterflowLayout:(BWaterflowLayout *)waterflowLayout {
    return 0;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(BWaterflowLayout *)waterflowLayout {
    return UIEdgeInsetsMake(CONVER_VALUE(16.0f), CONVER_VALUE(10.0f), 0, CONVER_VALUE(10.0f));
}

#pragma mark getter && setter
- (UICollectionView *)myCollectionView {
    if (!_myCollectionView) {
        BWaterflowLayout * layout = [[BWaterflowLayout alloc]init];
        layout.delegate = self;
        UICollectionView *tempCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        tempCollectView.dataSource = self;
        tempCollectView.delegate = self;
//        tempCollectView.allowsMultipleSelection = YES;
        [tempCollectView registerClass:[ShopCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier_ShopCollectionViewCell];
        tempCollectView.backgroundColor = I_BACKGROUND_COLOR;
        [self.view addSubview:(_myCollectionView = tempCollectView)];
    }
    return _myCollectionView;
}

- (NSMutableArray *)myCollectArr {
    if (!_myCollectArr) {
        _myCollectArr = [NSMutableArray array];
    }
    return _myCollectArr;
}

//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(120.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    imageView.image = [UIImage imageNamed:@"bg_loading"];
//    [self.view addSubview:imageView];
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(280.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
//    label.textColor = I_COLOR_33BLACK;
//    label.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = @"功能尚未开放, 敬请期待...";
//    [self.view addSubview:label];

@end
