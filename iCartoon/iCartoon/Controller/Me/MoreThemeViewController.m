//
//  MoreThemeViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "MoreThemeViewController.h"
#import "MoreThemeTableViewCell.h"
#import "ThemeCollectionViewCell.h"
#import "ThemeDetailViewController.h"

#import "PostAPIRequest.h"
#import "IndexAPIRequest.h"
#import <TSMessages/TSMessage.h>
#import "Context.h"
#import "AttentionView.h"
#import "MyConcernedItem.h"

@interface MoreThemeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, ThemeCollectionViewCellDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *themeArray;


@end

@implementation MoreThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"全部熊窝";
    [self setBackNavgationItem];
    
    [self createUI];
}

- (void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - ThemeCollectionViewCellDelegate
- (void)collectionCellClickedAtItem:(ThemeInfo *)themeInfo {
    if(themeInfo != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //跳转界面
            ThemeDetailViewController *topicDetailViewController = [[ThemeDetailViewController alloc] init];
            topicDetailViewController.themeInfo = themeInfo;
            topicDetailViewController.themeId = themeInfo.tid;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:topicDetailViewController];
            [self presentViewController:navigationController animated:YES completion:^{
            }];
        });
    }
//    if(themeInfo != nil) {
//        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
//        if(themeInfo.tid) {
//            [params setObject:@[themeInfo.tid] forKey:@"themeIds"];
//        }
//        [params setObject:@"1" forKey:@"type"];
//        [SVProgressHUD showWithStatus:@"正在关注..." maskType:SVProgressHUDMaskTypeClear];
//        [[IndexAPIRequest sharedInstance] followTheme:params success:^(CommonInfo *resultInfo) {
//            [SVProgressHUD dismiss];
//            if(resultInfo && [resultInfo isSuccess]) {
//                [TSMessage showNotificationWithTitle:@"关注成功" subtitle:nil type:TSMessageNotificationTypeSuccess];
//                [self.navigationController popViewControllerAnimated:YES];
//            } else {
//                [TSMessage showNotificationWithTitle:@"关注失败" subtitle:nil type:TSMessageNotificationTypeError];
//            }
//        } failure:^(NSError *error) {
//            [SVProgressHUD dismiss];
//            [TSMessage showNotificationWithTitle:[error localizedDescription] subtitle:nil type:TSMessageNotificationTypeError];
//        }];
//    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.themeArray != nil ? [self.themeArray count] : 0;
    return count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH / 3-1, TRANS_VALUE(108.0f));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ThemeInfo *themeInfo = nil;
    if(indexPath.row < [self.themeArray count]) {
        themeInfo = [self.themeArray objectAtIndex:indexPath.row];
    }
    
    ThemeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThemeCollectionViewCell" forIndexPath:indexPath];
    if(!cell) {
        cell = [[ThemeCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, TRANS_VALUE(108.0f))];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    if(themeInfo) {
        cell.themeInfo = themeInfo;
    } else {
        cell.hidden = YES;
    }
    cell.delegate = self;
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets inset = UIEdgeInsetsMake(0, TRANS_VALUE(0.0f), TRANS_VALUE(0.0f), TRANS_VALUE(0.0f));
    return inset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return TRANS_VALUE(0.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return TRANS_VALUE(0.0f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //TODO--关注熊巢
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Private Method
- (void)loadData {
    
    
    if(!self.themeArray) {
        self.themeArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.themeArray removeAllObjects];
    [[IndexAPIRequest sharedInstance] getAllThemes:nil success:^(NSArray *groupThemes) {
        if(groupThemes) {
            for(ThemeGroupInfo *group in groupThemes) {
                if(group.list != nil) {
                    [self.themeArray addObjectsFromArray:group.list];
                }
            }
        }
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        //[SVProgressHUD dismiss];
        [self.collectionView reloadData];
    }];
    
    
    
//    if(!self.themeArray) {
//        self.themeArray = [NSMutableArray arrayWithCapacity:0];
//    }
//    [self.themeArray removeAllObjects];
//    if(![Context sharedInstance].token) {
//        [self.collectionView reloadData];
//        return;
//    }
//    NSDictionary *params = @{};
//    [[PostAPIRequest sharedInstance] searchThemes:params success:^(NSArray *themeList) {
//        [SVProgressHUD dismiss];
//        if(themeList) {
//            [self.themeArray addObjectsFromArray:themeList];
//        }
//        [self.collectionView reloadData];
//    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
////        [TSMessage showNotificationWithTitle:[error localizedDescription] subtitle:nil type:TSMessageNotificationTypeError];
////        AttentionView *attention = [[AttentionView alloc]initTitle:[error localizedDescription]];
////        [self.view addSubview:attention];
//    }];
}

- (void)createUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat collectionHeight = SCREEN_HEIGHT - 64.0f;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(0.0f), SCREEN_WIDTH, collectionHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[ThemeCollectionViewCell class] forCellWithReuseIdentifier:@"ThemeCollectionViewCell"];
}

@end
