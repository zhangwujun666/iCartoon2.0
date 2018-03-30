//
//  ThemeDrawerViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 16/3/25.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "ThemeDrawerViewController.h"
#import "SmallThemeCollectionViewCell.h"
#import "ThemeDetailViewController.h"

#import "NSString+Utils.h"
#import "Context.h"
#import "ThemeCategory.h"
#import "ThemeInfo.h"
#import "ThemeGroupInfo.h"
#import "MeAPIRequest.h"
#import "IndexAPIRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "AttentionView.h"
#import "APIConfig.h"
#import "ProgressHUD.h"

#import <AFNetworking.h>

@interface ThemeDrawerViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SmallThemeCollectionViewCellDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) UIBarButtonItem *searchButton;           //搜索按钮

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) NSMutableArray *themeArray;

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *keyword;
@property (nonatomic,strong)NSIndexPath * index;


@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;

@end

@implementation ThemeDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = I_BACKGROUND_COLOR;
    self.navigationItem.title = @"熊窝抽屉";
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 7, TRANS_VALUE(240.0f), 30)];
    self.searchTextField.borderStyle = UITextBorderStyleNone;
    self.searchTextField.backgroundColor = I_COLOR_WHITE;
    self.searchTextField.clipsToBounds = YES;
    self.searchTextField.layer.cornerRadius = 4.0f;
    self.searchTextField.textColor = I_COLOR_33BLACK;
    self.searchTextField.font = [UIFont systemFontOfSize:14.0f];
    self.searchTextField.placeholder = @"找找看有没有喜欢的熊窝ヽ(•ω• )ゝ";
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.tintColor = I_COLOR_DARKGRAY;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeColor) name:@"changeColor" object:nil];
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 10, 20)];
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    self.searchTextField.leftView = leftView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.navigationItem.titleView = self.searchTextField;
    
    self.searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_theme_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonAction)];
    self.navigationItem.rightBarButtonItem = self.searchButton;
    
    [self setBackNavgationItem];
    
    [self createUI];
    self.type = @"2";     //全部熊巢
    [self loadData];
}
- (void)changeColor{
//    NSLog(@"self.type -------------------- %@",self.type);
//         [self loadAllTheme];
    [self tableView:self.tableView didSelectRowAtIndexPath:self.index];
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
#pragma mark - Action
- (void)searchButtonAction {
    //搜索按钮点击事件
    [self.searchTextField resignFirstResponder];
    self.searchTextField.text = self.keyword;
    if([NSString isBlankString:self.keyword]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"输入你想要搜索的内容关键字！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }
    [self searchTheme:self.keyword];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchTextField resignFirstResponder];
    //TODO -- 搜索相关熊巢
    [self searchTheme:self.keyword];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.keyword = textField.text;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.keyword = textField.text;
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSLog(@"string = %@",string);
    return YES;
}
#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.categoryArray != nil ? [self.categoryArray count] : 0;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRANS_VALUE(50.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0f;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    view.backgroundColor = RGBCOLOR(247, 247, 247);
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CategoryTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = I_COLOR_33BLACK;
    cell.textLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(13.0f)];
    
    if(indexPath.row < self.categoryArray.count) {
        ThemeCategory *category = (ThemeCategory *)[self.categoryArray objectAtIndex:indexPath.row];
        cell.textLabel.text = category.categoryName;
    }
//    if ([Context sharedInstance].token) {
//        if (indexPath.row == 1) {
//             cell.textLabel.textColor = [UIColor blackColor];
//        }else{
//             cell.textLabel.textColor = [UIColor blackColor];
//        }
//       
//    }else{
//        cell.textLabel.textColor = [UIColor blackColor];
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(85.0f), TRANS_VALUE(50.0f))];
    selectedBackgroundView.backgroundColor = I_COLOR_WHITE;
    cell.selectedBackgroundView = selectedBackgroundView;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (self.index) {
//        UITableViewCell * cell1 = [tableView cellForRowAtIndexPath:self.index];
//        cell1.textLabel.textColor = [UIColor blackColor];
//        UITableViewCell * cell2 = [tableView cellForRowAtIndexPath:indexPath];
//        cell2.textLabel.textColor = [UIColor orangeColor];
//         self.index = indexPath;
//    }else{
//        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//        cell.textLabel.textColor = [UIColor orangeColor];
//        self.index = indexPath;
//    }
    self.index = indexPath;
    if(![Context sharedInstance].token || ![Context sharedInstance].uid) {

        if(indexPath.row == 0) {
            [self loadAllTheme];
        }else {
            ThemeCategory *category = self.categoryArray[indexPath.row];
            [self loadcategory:category.categoryId];
        }

    } else {
        if(indexPath.row == 0) {
           // [self loadMyTheme];
            [self loadAllTheme];
        }else {
            
            if (indexPath.row == self.categoryArray.count-1) {
                [self loadMyTheme];
            }else{
                self.type = [NSString stringWithFormat:@"%ld",indexPath.row-1];
                ThemeCategory *category = self.categoryArray[indexPath.row];
                [self loadcategory:category.categoryId];
            }
        }
    }
}
- (void)loadcategory:(NSString *)categoryId{
     [ProgressHUD show:nil];
    if(!self.themeArray) {
        self.themeArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.themeArray removeAllObjects];
    self.requestManager = [AFHTTPRequestOperationManager manager];
    self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableDictionary * paramaDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString * mainurl = [APIConfig mainURL];
    NSString * str1 = [NSString stringWithFormat:@"%ld",[categoryId integerValue] -1];
    NSString * str = nil;
    if ([Context sharedInstance].token) {
        str = [NSString stringWithFormat:@"%@/%@/%@/%@",mainurl,@"GetThemeByType_v2",str1,[Context sharedInstance].token];
    } else {
        str = [NSString stringWithFormat:@"%@/%@/%@",mainurl,@"GetThemeByType_v2",str1];
    }
//    if ([Context sharedInstance].token]) {
//        str = [NSString stringWithFormat:@"%@/%@/%@/%@",mainurl,@"GetThemeByType_v2",str1,[Context sharedInstance].token];
//    }
   
    [self.requestManager GET:str parameters:paramaDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [ProgressHUD dismiss];
        NSArray *themeList = [MTLJSONAdapter modelsOfClass:[ThemeGroupInfo class] fromJSONArray:responseObject[@"response"][@"result"] error:nil];
        if(themeList) {
            for(ThemeGroupInfo *group in themeList) {
                if(group.list != nil) {
                    [self.themeArray addObjectsFromArray:group.list];
                }
            }
        }
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
          [ProgressHUD dismiss];
    }];

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
    return CGSizeMake((SCREEN_WIDTH - TRANS_VALUE(86.0f) - 2 * TRANS_VALUE(8.0f))/ 3, TRANS_VALUE(100.0f));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ThemeInfo *themeInfo = nil;
    if(indexPath.row < [self.themeArray count]) {
        themeInfo = [self.themeArray objectAtIndex:indexPath.row];
    }
    
    SmallThemeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThemeCollectionViewCell" forIndexPath:indexPath];
    if(!cell) {
        cell = [[SmallThemeCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - TRANS_VALUE(86.0f) - 2 * TRANS_VALUE(8.0f)) / 3, TRANS_VALUE(100.0f))];
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
    UIEdgeInsets inset = UIEdgeInsetsMake(0, TRANS_VALUE(8.0f), TRANS_VALUE(0.0f), TRANS_VALUE(8.0f));
    return inset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return TRANS_VALUE(0.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return TRANS_VALUE(0.0f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //TODO--跳转到主题详情
    ThemeDetailViewController *topicDetailViewController = [[ThemeDetailViewController alloc] init];
    ThemeInfo *themeInfo = [self.themeArray objectAtIndex:indexPath.row];
    topicDetailViewController.themeInfo = themeInfo;
    topicDetailViewController.themeId = themeInfo.tid;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:topicDetailViewController];
    [self presentViewController:navigationController animated:YES completion:^{
        
    }];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - ThemeCollectionViewCellDelegate
- (void)collectionCellClickedAtItem:(ThemeInfo *)themeInfo {
    if(themeInfo != nil) {
        ThemeDetailViewController *topicDetailViewController = [[ThemeDetailViewController alloc] init];
        topicDetailViewController.themeInfo = themeInfo;
        topicDetailViewController.themeId = themeInfo.tid;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:topicDetailViewController];
        [self presentViewController:navigationController animated:YES completion:^{
            
        }];
    }
}

#pragma mark - Private Method
- (void)createUI {
    //实例化表单控件
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(86.0f), SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = I_COLOR_WHITE;
    self.tableView.backgroundColor = I_BACKGROUND_COLOR;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - TRANS_VALUE(86.0f), TRANS_VALUE(0.0f))];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - TRANS_VALUE(86.0f), 1.0f)];
    footerView.backgroundColor = I_COLOR_WHITE;
    self.tableView.tableFooterView = footerView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat collectionHeight = SCREEN_HEIGHT - 64.0f;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(TRANS_VALUE(86.0f), TRANS_VALUE(0.0f), SCREEN_WIDTH - TRANS_VALUE(86.0f), collectionHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = I_COLOR_WHITE;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[SmallThemeCollectionViewCell class] forCellWithReuseIdentifier:@"ThemeCollectionViewCell"];
}

- (void)loadData {
    self.requestManager = [AFHTTPRequestOperationManager manager];
    self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableDictionary * paramaDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString * mainurl = [APIConfig mainURL];
    NSString * path = [NSString stringWithFormat:@"%@/%@",mainurl,@"GetThemeType"];
    [self.requestManager GET:path parameters:paramaDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray * arr = responseObject[@"response"][@"result"];
        
        
        if(!self.categoryArray) {
            self.categoryArray = [NSMutableArray arrayWithCapacity:0];
        }
        [self.categoryArray removeAllObjects];
//        if([Context sharedInstance].token != nil && [Context sharedInstance].uid != nil) {
            ThemeCategory *category0 = [[ThemeCategory alloc] init];
            category0.categoryId = @"1";
            category0.categoryName = @"全部熊窝";
            [self.categoryArray addObject:category0];
//            self.type = @"1";
//        } else {
//            self.type = @"2";
//        }
       
        for (int i = 0;  i < arr.count; i++) {
            ThemeCategory *category = [[ThemeCategory alloc] init];
            category.categoryId = [NSString stringWithFormat:@"%ld",[arr[i][@"id"] integerValue]+1];
            category.categoryName = arr[i][@"title"];
            [self.categoryArray addObject:category];
        }
        
        if ([Context sharedInstance].token != nil && [Context sharedInstance].uid != nil) {
            
            ThemeCategory *category1 = [[ThemeCategory alloc] init];
            category1.categoryId = [NSString stringWithFormat:@"%ld",self.categoryArray.count+2];
            category1.categoryName = @"我的熊窝";
             [self.categoryArray addObject:category1];
        }else{
//            category1.categoryName = @"我的熊窝";
        }
       
        [self.tableView reloadData];

        if(self.categoryArray.count > 0) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];//设置选中第一行（默认有蓝色背景）
            [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];//实现点击第一行所调用的方法
        }

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];

}
//获取我的熊巢
- (void)loadMyTheme {
      [ProgressHUD show:nil];
    if(!self.themeArray) {
        self.themeArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.themeArray removeAllObjects];
    [[IndexAPIRequest sharedInstance] getMyThemes:nil success:^(NSArray *groupThemes) {
          [ProgressHUD dismiss];
            if(groupThemes) {
            for(ThemeGroupInfo *group in groupThemes) {
                if(group.list != nil) {
                    [self.themeArray addObjectsFromArray:group.list];
                }
            }
        }
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
         [ProgressHUD dismiss];
    }];
}

//获取全部熊巢
- (void)loadAllTheme {
      [ProgressHUD show:nil];
    if(!self.themeArray) {
        self.themeArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.themeArray removeAllObjects];
    
    [[IndexAPIRequest sharedInstance] getAllThemes:nil success:^(NSArray *groupThemes) {
          [ProgressHUD dismiss];
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
          [ProgressHUD dismiss];
        [self.collectionView reloadData];
    }];

}

- (void)searchTheme:(NSString *)keyword {
    if(!self.themeArray) {
        self.themeArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.themeArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    //[params setObject:self.type forKey:@"type"];
    if (self.index.row == 0) {
          [params setObject:@"2" forKey:@"type"];
    }else{
          [params setObject:@"1" forKey:@"type"];
    }
    
    if(self.keyword != nil) {
        [params setObject:self.keyword forKey:@"keyword"];
    }
    [[IndexAPIRequest sharedInstance] searchThemes:params success:^(NSArray *themeList) {
       // [SVProgressHUD dismiss];
        if(themeList) {
            [self.themeArray addObjectsFromArray:themeList];
        }
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        //[SVProgressHUD dismiss];
        [self.collectionView reloadData];
    }];
}

@end
