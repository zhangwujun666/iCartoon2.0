//
//  NewSearchViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/16.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "NewSearchViewController.h"
#import "SearchAuthorTableViewCell.h"
#import "SearchThemeTableViewCell.h"
#import "PostTableViewCell.h"
#import "PostDetailViewController.h"
#import "TopTabButton.h"
#import "LoginViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "SearchTableViewCell.h"
#import "SearchHistoryInfo.h"
#import "ThemeDetailViewController.h"
#import "AuthorDetailViewController.h"

#import "SearchHistoryDao.h"
#import "Context.h"
#import "NSString+Utils.h"
#import "IncubatorAPIRequest.h"
#import "PostAPIRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
//下拉刷新，上拉加载
#import <MJRefresh/MJRefresh.h>
//#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import "BWaterflowLayout.h"
#import "ShopCollectionViewCell.h"
#import "AttentionView.h"

@interface NewSearchViewController () <UITableViewDataSource, UITableViewDelegate, PostTableViewCellDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, BWaterflowLayoutDelegate, SearchAuthorTableViewCellDelegate>
@property (weak, nonatomic) UICollectionView *myCollectionView;
@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *searchButton;

@property (strong, nonatomic) TopTabButton *incubatorButton;
@property (strong, nonatomic) TopTabButton *shopButton;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITableView *historyTableView;

@property (strong, nonatomic) NSMutableArray *historyArray;
@property (strong, nonatomic) NSMutableArray *authorArray;
@property (strong, nonatomic) NSMutableArray *themeArray;
@property (strong, nonatomic) NSMutableArray *postArray;

@property (assign, nonatomic) BOOL isIncubatorSelected;
@property (assign, nonatomic) BOOL showSearchHistory;

//显示更多历史
@property (assign, nonatomic) BOOL showMoreHistory;

@property (strong, nonatomic) PostInfo *selectedPostInfo;

@property (assign, nonatomic) NSInteger pageNo;
@property (assign, nonatomic) NSInteger pageSize;
@property (strong, nonatomic) NSString *refreshTime;
@property (strong, nonatomic) NSString *loadTime;
@property (strong, nonatomic) NSString *prePostId;
@property (strong, nonatomic) NSString *keyword;

@property (strong, nonatomic)UIImageView *img;
@property (strong, nonatomic)UILabel *lab;
@property (strong, nonatomic)UIView * view1;
@property (nonatomic,strong) NSString *isfreeze;
@property (nonatomic,strong) NSString *thaw_date;
@property (nonatomic,strong) NSString *thaw_time;
@property (nonatomic,strong)NSString * isshow;
@property (nonatomic,strong)NSString * isshowfree;
@end

@implementation NewSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"搜索";
    
    [self createUI];
    
    self.selectedPostInfo = nil;
    self.pageNo = 1;
    self.pageSize = 15;
    self.refreshTime = @"";
    self.prePostId = @"";
    self.loadTime = @"";

    self.showSearchHistory = YES;
    self.isIncubatorSelected = YES;
    [self.incubatorButton setSelected:YES];
    [self.shopButton setSelected:NO];
    self.showMoreHistory = NO;
    [self getSearchHistory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.keyword = self.searchTextField.text;
    if([NSString isBlankString:self.keyword]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"请输入查询关键字！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return YES;
    }
    //搜索按钮点击事件
    if(![self hasRecord:self.keyword]) {
        [self saveSearchHistory:self.keyword];
    }
    self.showSearchHistory = NO;
    self.historyTableView.hidden = YES;
    self.tableView.hidden = NO;
    
    [self.themeArray removeAllObjects];
    [self.authorArray removeAllObjects];
    [self.postArray removeAllObjects];
    
    [self loadNewData];
   
    return YES;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.keyword = textField.text;
}

#pragma mark - Private Method
- (void)loadNewData {
    [self.img removeFromSuperview];
    [self.lab removeFromSuperview];
    [_view1  removeFromSuperview];
    
    self.refreshTime = @"";
    self.pageNo = 1;
    [self.tableView.mj_footer resetNoMoreData];
    if(self.isIncubatorSelected) {
        self.tableView.hidden = NO;
        self.myCollectionView.hidden = YES;
        //刷新设计师帖子列表
        if(!self.postArray) {
            self.postArray = [NSMutableArray arrayWithCapacity:0];
//            [self.postArray removeAllObjects];
        }
        [self.postArray removeAllObjects];
        //TODO -- 主题
        if(!self.themeArray) {
            self.themeArray = [NSMutableArray arrayWithCapacity:0];
//            [self.themeArray removeAllObjects];
        }
        [self.themeArray removeAllObjects];
        //TODO -- 熊宝
        if(!self.authorArray) {
            self.authorArray = [NSMutableArray arrayWithCapacity:0];
//            [self.authorArray removeAllObjects];
        }
        [self.authorArray removeAllObjects];
        [self.tableView.mj_footer resetNoMoreData];
//        [SVProgressHUD showWithStatus:@"正在获取搜索结果..." maskType:SVProgressHUDMaskTypeClear];
        NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
        NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
        [params setObject:pageNo forKey:@"pageNo"];
        [params setObject:pageSize forKey:@"pageSize"];
        [params setObject:ACTION_TYPE_REFRESH forKey:@"actionType"];
        [params setObject:self.refreshTime forKey:@"refreshTime"];
        [params setObject:self.prePostId forKey:@"postId"];
        [params setObject:self.keyword forKey:@"keyword"];
        [[IncubatorAPIRequest sharedInstance] searchPosts:params success:^(SearchResultInfo *resultInfo) {
//            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            if(resultInfo.postList && resultInfo.postList.count > 0) {
                NSSortDescriptor *creatTimeDesc = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO];
                NSArray *descs = [NSArray arrayWithObjects:creatTimeDesc, nil];
                NSArray *sortedArray = [resultInfo.postList sortedArrayUsingDescriptors:descs];
                PostInfo *firstPost = [sortedArray firstObject];
                self.refreshTime = firstPost.createTime;
                if(self.postArray.count == 0) {
                    [self.postArray addObjectsFromArray:sortedArray];
                } else {
                    [self.postArray insertObjects:sortedArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, sortedArray.count)]];
                }
                
                PostInfo *lastPost = [self.postArray lastObject];
                self.loadTime = lastPost.createTime;
                if(resultInfo.postList.count >= self.pageSize) {
                    self.pageNo ++;
                }
            } else {
                PostInfo *lastPost = [self.postArray lastObject];
                self.loadTime = lastPost.createTime;
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if(resultInfo.themeList && resultInfo.themeList.count > 0) {
                [self.themeArray addObjectsFromArray:resultInfo.themeList];
            }
            if(resultInfo.userList && resultInfo.userList.count > 0) {
                [self.authorArray addObjectsFromArray:resultInfo.userList];
            }
                       //刷新tableview
            [self.tableView reloadData];
            
            if (self.postArray.count <= 0 && self.authorArray.count<=0 && self.themeArray.count <=0) {
                
                
                   _view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]  bounds].size.width,  [[UIScreen mainScreen]  bounds].size.height)];
                
                _view1.backgroundColor = [UIColor whiteColor];
                [self.tableView  addSubview:_view1];
                
                self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(120.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
                self.img.contentMode = UIViewContentModeScaleAspectFit;
                self.img.image = [UIImage imageNamed:@"no_data_hint"];
                [_view1 addSubview:_img];
                
                self.lab= [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(280.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
                self.lab.textColor = I_COLOR_33BLACK;
                self.lab.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
                self.lab.textAlignment = NSTextAlignmentCenter;
                self.lab.text = @"未搜到您想要的结果…";
                [_view1 addSubview:self.lab];
                
            }

        } failure:^(NSError *error) {

            PostInfo *lastPost = [self.postArray lastObject];
            self.loadTime = lastPost.createTime;

            //刷新tableview
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }];
    } else {
        self.tableView.hidden = YES;
        self.myCollectionView.hidden = NO;
    }
}

- (void)loadMoreData {
    if(self.isIncubatorSelected) {
        //加载更多设计师帖子列表

        //TODO -- 主题
        if(!self.themeArray) {
            self.themeArray = [NSMutableArray arrayWithCapacity:0];
        }
        [self.themeArray removeAllObjects];
        //TODO -- 熊宝
        if(!self.authorArray) {
            self.authorArray = [NSMutableArray arrayWithCapacity:0];
        }
        [self.authorArray removeAllObjects];
        NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
        NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
        [params setObject:pageNo forKey:@"pageNo"];
        [params setObject:pageSize forKey:@"pageSize"];
        [params setObject:ACTION_TYPE_LOAD_MORE forKey:@"actionType"];
        [params setObject:self.loadTime forKey:@"refreshTime"];
        [params setObject:self.prePostId forKey:@"postId"];
        [params setObject:self.keyword forKey:@"keyword"];
        [[IncubatorAPIRequest sharedInstance] searchPosts:params success:^(SearchResultInfo *resultInfo) {
//            [SVProgressHUD dismiss];
            if(resultInfo.postList && resultInfo.postList.count > 0) {
                NSSortDescriptor *creatTimeDesc = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO];
                NSArray *descs = [NSArray arrayWithObjects:creatTimeDesc, nil];
                NSArray *sortedArray = [resultInfo.postList sortedArrayUsingDescriptors:descs];
                PostInfo *lastestPost = [sortedArray lastObject];
                self.prePostId = lastestPost.pid;
                self.loadTime = lastestPost.createTime;
                [self.postArray addObjectsFromArray:sortedArray];
                if(resultInfo.postList.count >= self.pageSize) {
                    self.pageNo ++;
                    [self.tableView.mj_footer endRefreshing];
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if(resultInfo.themeList && resultInfo.themeList.count > 0) {
                [self.themeArray addObjectsFromArray:resultInfo.themeList];
            }
            if(resultInfo.userList && resultInfo.userList.count > 0) {
                [self.authorArray addObjectsFromArray:resultInfo.userList];
            }
            //刷新tableview
            [self.tableView reloadData];
        } failure:^(NSError *error) {

            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView reloadData];
        }];
    } else {
        
    }
}

- (void)tapAction {
    [self.searchTextField resignFirstResponder];
}

//判断是否有历史记录
- (BOOL)hasRecord:(NSString *)keyword {
    BOOL exist = NO;
    for(SearchHistoryInfo *info in self.historyArray) {
        if([info.keyword isEqualToString:keyword]) {
            exist = YES;
            break;
        }
    }
    return exist;
}

//保存查询纪录
- (void)saveSearchHistory:(NSString *)keyword {
    SearchHistoryInfo *historyInfo = [[SearchHistoryInfo alloc] init];
    historyInfo.keyword = keyword;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    historyInfo.time = dateStr;
    historyInfo.uid = [Context sharedInstance].uid;
    [self.historyArray addObject:historyInfo];
    [[SearchHistoryDao sharedInstance] insertWithSearchHistoryInfo:historyInfo];
}

//获取查询记录
- (void)getSearchHistory {
    self.historyArray = [[SearchHistoryDao sharedInstance] getSearchHistroyList];
    if(self.historyArray.count < 5) {
        self.showMoreHistory = YES;
    } else {
        self.showMoreHistory = NO;
    }
    [self.historyTableView reloadData];
}

- (void)moreHistory {
    self.showMoreHistory = YES;
    [self.historyTableView reloadData];
}

//删除某条查询记录
- (void)deleteSearchHistory:(SearchHistoryInfo *)info {
    BOOL isSuccess = [[SearchHistoryDao sharedInstance] deleteSearchHistoryInfo:info];
    if (!isSuccess) {
        NSLog(@"删除失败");
    }
    [self getSearchHistory];
}

//删除全部查询记录
- (void)clearHistory{
    [[SearchHistoryDao sharedInstance] clear];
    [self getSearchHistory];
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        if([self.searchTextField isFirstResponder]) {
            [self.searchTextField resignFirstResponder];
            return YES;
        } else {
            return NO;
        }
    }
    return  YES;
}

- (void)cancelButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchButtonAction:(id)sender {
    [self.searchTextField resignFirstResponder];
    self.keyword = self.searchTextField.text;
    if([NSString isBlankString:self.keyword]) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"请输入查询关键字！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }
    //搜索按钮点击事件
    if(![self hasRecord:self.keyword]) {
        [self saveSearchHistory:self.keyword];
    }
    self.showSearchHistory = NO;
    self.historyTableView.hidden = YES;
    self.tableView.hidden = NO;
    
    [self.themeArray removeAllObjects];
    [self.authorArray removeAllObjects];
    [self.postArray removeAllObjects];

    [self loadNewData];
}


- (void)tabButtonAction:(id)sender {
    TopTabButton *button = (TopTabButton *)sender;
    if(!button.isSelected) {
        if(button == self.incubatorButton) {
            [self.incubatorButton setSelected:YES];
            [self.shopButton setSelected:NO];
            self.isIncubatorSelected = YES;
                self.refreshTime = @"";
                [self.themeArray removeAllObjects];
                [self.authorArray removeAllObjects];
                [self.postArray removeAllObjects];

                [self loadNewData];
         //   }
        } else {
            self.isIncubatorSelected = NO;
            [self.incubatorButton setSelected:NO];
            [self.shopButton setSelected:YES];
                [self loadNewData];
        }
    }
    
}

#pragma mark - SearchAuthorTableViewCellDelegate
- (void)authorButtonClickedAtItem:(AuthorInfo *)authorInfo {
    if(authorInfo != nil) {
        AuthorDetailViewController *authorDetailViewController = [[AuthorDetailViewController alloc] init];
        authorDetailViewController.authorInfo = authorInfo;
        [self.navigationController pushViewController:authorDetailViewController animated:YES];
    }
}

#pragma mark - UIAlertVeiwDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        //TODO -- 用户登录
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:navigationController animated:YES completion:^{
            
        }];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(!self.showSearchHistory) {
        return 3;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!self.showSearchHistory) {
        if(section == 0) {
            NSInteger count = self.authorArray != nil ? [self.authorArray count] : 0;
            return count > 0 ? 1 : 0;
        } else if(section == 1) {
            NSInteger count = self.themeArray != nil ? [self.themeArray count] : 0;
            return count;
        } else {
            NSInteger count = self.postArray != nil ? [self.postArray count] : 1;
            return count;
        }
    } else {
        if(self.showMoreHistory) {
            NSInteger count = self.historyArray.count != 0 ? [self.historyArray count] + 1 : 1;
            return count;
        } else {
            NSInteger count = self.historyArray.count != 0 ? [self.historyArray count] + 1: 1;
            if(count >= 6) {
                count = 6;
            }
            return count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!self.showSearchHistory) {
        if(indexPath.section == 0) {
            return TRANS_VALUE(74.0f);
        } else if(indexPath.section == 1) {
            return TRANS_VALUE(80.0f);
        } else {
            if(indexPath.row < self.postArray.count) {
                PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
                CGFloat height = [PostTableViewCell heightForCell:indexPath withCommentInfo:postInfo];
                return height;
            } else {
                return 0.0f;
            }
        }
    } else {
        return CONVER_VALUE(44.0f);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(!self.showSearchHistory) {
        if(section == 0) {
            NSInteger count = self.authorArray != nil ? [self.authorArray count] : 0;
            return count > 0 ? TRANS_VALUE(26.0f) : TRANS_VALUE(0.0f);
        } else if(section == 1) {
            NSInteger count = self.themeArray != nil ? [self.themeArray count] : 0;
            return count > 0 ? TRANS_VALUE(26.0f) : TRANS_VALUE(0.0f);
        } else {
            return TRANS_VALUE(0.0f);
        }
    } else {
        return CONVER_VALUE(5.0f);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(!self.showSearchHistory) {
        if(section == 0) {
            CGFloat height = TRANS_VALUE(26.0f);
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
            view.backgroundColor = I_COLOR_WHITE;
            NSInteger count = self.authorArray != nil ? [self.authorArray count] : 0;
            if(count > 0) {
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(11.0f), 0, SCREEN_WIDTH - 2 * TRANS_VALUE(16.0f), height)];
                titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
                titleLabel.textColor = I_COLOR_GRAY;
                NSString *titleStr = [NSString stringWithFormat:@"熊宝  (%ld)", (long)count];
                titleLabel.text = titleStr;
                [view addSubview:titleLabel];
                UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 1.0f, SCREEN_WIDTH, 1.0f)];
                dividerView.backgroundColor = I_DIVIDER_COLOR;
                [view addSubview:dividerView];
            } else {
                view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
            }
            return view;
        } else if(section == 1) {
            CGFloat height = TRANS_VALUE(26.0f);
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
            view.backgroundColor = I_COLOR_WHITE;
            NSInteger count = self.themeArray != nil ? [self.themeArray count] : 0;
            if(count > 0) {
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(11.0f), 0, SCREEN_WIDTH - 2 * TRANS_VALUE(16.0f), height)];
                titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(12.0f)];
                titleLabel.textColor = I_COLOR_GRAY;
                NSString *titleStr = [NSString stringWithFormat:@"熊窝"];
                titleLabel.text = titleStr;
                [view addSubview:titleLabel];
                UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 1.0f, SCREEN_WIDTH, 1.0f)];
                dividerView.backgroundColor = I_DIVIDER_COLOR;
                [view addSubview:dividerView];
            } else {
                view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
            }
            return view;
        } else {
            CGFloat height = TRANS_VALUE(0.0f);
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
            view.backgroundColor = I_COLOR_WHITE;
            return view;
        }
    } else {
        CGFloat height = TRANS_VALUE(0.0f);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        view.backgroundColor = RGBCOLOR(247, 247, 247);
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(!self.showSearchHistory) {
        if(section == 0) {
            NSInteger count = self.authorArray != nil ? [self.authorArray count] : 0;
            return count > 0 ? TRANS_VALUE(8.0f) : TRANS_VALUE(0.0f);
        } else if(section == 1) {
            NSInteger count = self.themeArray != nil ? [self.themeArray count] : 0;
            return count > 0 ? TRANS_VALUE(8.0f) : TRANS_VALUE(0.0f);
        } else {
            return TRANS_VALUE(0.0f);
        }
    } else {
        return CONVER_VALUE(0.0f);
    }

    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(!self.showSearchHistory) {
        CGFloat height = TRANS_VALUE(0.0f);
        if(section == 1  || section ==0 ) {
            height = TRANS_VALUE(8.0f);
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(8.0f))];
        view.backgroundColor = I_BACKGROUND_COLOR;
        return view;
    } else {
        CGFloat height = TRANS_VALUE(0.0f);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        view.backgroundColor = I_BACKGROUND_COLOR;
        return view;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakSelf = self;
    if(!_showSearchHistory) {
        if(indexPath.section == 0) {
            static NSString *identifier = @"SearchAuthorTableViewCell";
            SearchAuthorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell) {
                cell = [[SearchAuthorTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            }
            if(self.authorArray != nil) {
                cell.authorArray = self.authorArray;
            }
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if(indexPath.section == 1) {
            static NSString *identifier = @"SearchThemeTableViewCell";
            SearchThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
           
            if(!cell) {
                cell = [[SearchThemeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            }
            if(indexPath.row < self.themeArray.count) {
                ThemeInfo *themeInfo = (ThemeInfo *)[self.themeArray objectAtIndex:indexPath.row];
                cell.themeInfo = themeInfo;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([_searchTextField.text isEqual:@""]||[_searchTextField.text isEqual:nil]) {
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                [self with:attStr and:self.keyword andSecondString:cell.titleLabel.text];
                cell.titleLabel.attributedText =attStr;
            }else{
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
        [self with:attStr and:_searchTextField.text andSecondString:cell.titleLabel.text];
         cell.titleLabel.attributedText =attStr;
            }
            return cell;
        } else {
            static NSString *identifier = @"PostTableViewCell";
            PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell) {
                cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            }
            if(indexPath.row < self.postArray.count) {
                PostInfo *designerPostInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
                cell.postItem = designerPostInfo;
            }
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([_searchTextField.text isEqual:@""]||[_searchTextField.text isEqual:nil]) {
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                [self with:attStr and:self.keyword andSecondString:cell.titleLabel.text];
                cell.titleLabel.attributedText =attStr;
                NSMutableAttributedString *attstr1 =[[NSMutableAttributedString alloc]init];
                [self with:attstr1 and:self.keyword andSecondString:cell.contentLabel.text];
                cell.contentLabel.attributedText = attstr1;
                
            }else{
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
                [self with:attStr and:_searchTextField.text andSecondString:cell.titleLabel.text];
                cell.titleLabel.attributedText = attStr;
                NSMutableAttributedString *attstr1 =[[NSMutableAttributedString alloc]init];
                [self with:attstr1 and:_searchTextField.text andSecondString:cell.contentLabel.text];
                cell.contentLabel.attributedText = attstr1;
                
            }

            return cell;
        }
    } else {
        //搜索历史
        if(self.showMoreHistory) {
            //显示更多搜索历史
            static NSString *identifier = @"SearchTableViewCell";
            if(indexPath.row < self.historyArray.count) {
                SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if(!cell) {
                    cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                }
                cell.deleteBtnTapAction = ^(){
                    [weakSelf deleteSearchHistory:(SearchHistoryInfo *)[self.historyArray objectAtIndex:indexPath.row]];
                };
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //TOOD -- 我的关注
                SearchHistoryInfo *resultInfo = [self.historyArray objectAtIndex:indexPath.row];
                cell.indexLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
                cell.item = resultInfo;
                return cell;
            } else {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchDeleteTableViewCell"];
                UILabel *titleL = [[UILabel alloc] init];
                if (self.historyArray.count==0) {
                    titleL.text = @"暂无历史记录";
                }else{
                    titleL.text = @"清除历史记录";}
                titleL.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
                titleL.textColor = I_COLOR_YELLOW;
                [cell addSubview:titleL];
                [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(cell);
                }];
                return cell;
            }
        } else {
            //不显示更多搜索历史, 默认最多5条
            if(self.historyArray.count >= 5) {
                static NSString *identifier = @"SearchTableViewCell";
                if(indexPath.row < 5) {
                    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if(!cell) {
                        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                    }
                    cell.deleteBtnTapAction = ^(){
                        [weakSelf deleteSearchHistory:(SearchHistoryInfo *)[self.historyArray objectAtIndex:indexPath.row]];
                    };
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //TOOD -- 我的关注
                    SearchHistoryInfo *resultInfo = [self.historyArray objectAtIndex:indexPath.row];
                    cell.indexLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
                    cell.item = resultInfo;
                    return cell;
                } else {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchDeleteTableViewCell"];
                    UILabel *titleL = [[UILabel alloc] init];
                    titleL.text = @"更多历史记录";
                    titleL.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
                    titleL.textColor = I_COLOR_YELLOW;
                    [cell addSubview:titleL];
                    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(cell);
                    }];
                    return cell;
                }
            } else {
                static NSString *identifier = @"SearchTableViewCell";
                if(indexPath.row < self.historyArray.count) {
                    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if(!cell) {
                        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                    }
                    cell.deleteBtnTapAction = ^(){
                        [weakSelf deleteSearchHistory:(SearchHistoryInfo *)[self.historyArray objectAtIndex:indexPath.row]];
                    };
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //TOOD -- 我的关注
                    SearchHistoryInfo *resultInfo = [self.historyArray objectAtIndex:indexPath.row];
                    cell.indexLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
                    cell.item = resultInfo;
                    return cell;
                } else {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchDeleteTableViewCell"];
                    UILabel *titleL = [[UILabel alloc] init];
                    titleL.text = @"更多历史记录";
                    titleL.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
                    titleL.textColor = I_COLOR_YELLOW;
                    [cell addSubview:titleL];
                    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(cell);
                    }];
                    return cell;
                }
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.showSearchHistory) {
        if(self.showMoreHistory) {
            if(indexPath.row < self.historyArray.count) {
                //TODO搜索
                self.keyword = ((SearchHistoryInfo *)[self.historyArray objectAtIndex:indexPath.row]).keyword;
                self.showSearchHistory = NO;
                self.historyTableView.hidden = YES;
                self.tableView.hidden = NO;
                [self loadNewData];
            } else {
                //删除历史记录
                [self clearHistory];
            }
        } else {
            if(self.historyArray.count >= 5) {
                if(indexPath.row < 5) {
                    //TODO搜索
                    self.keyword = ((SearchHistoryInfo *)[self.historyArray objectAtIndex:indexPath.row]).keyword;
                    self.showSearchHistory = NO;
                    self.historyTableView.hidden = YES;
                    self.tableView.hidden = NO;
                    [self loadNewData];
                } else {
                    //更多历史记录
                    [self moreHistory];
                }

            } else {
                if(indexPath.row < self.historyArray.count) {
                    //TODO搜索
                    self.keyword = ((SearchHistoryInfo *)[self.historyArray objectAtIndex:indexPath.row]).keyword;
                    self.showSearchHistory = NO;
                    self.historyTableView.hidden = YES;
                    self.tableView.hidden = NO;
                    [self loadNewData];
                } else {
                    //更多历史记录
                    [self moreHistory];
                }
            }
        }
    } else {
        if(indexPath.section == 1) {
            ThemeInfo *themeInfo = (ThemeInfo *)[self.themeArray objectAtIndex:indexPath.row];
            if(!themeInfo) {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //跳转界面
                ThemeDetailViewController *topicDetailViewController = [[ThemeDetailViewController alloc] init];
                topicDetailViewController.themeInfo = themeInfo;
                topicDetailViewController.themeId = themeInfo.tid;
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:topicDetailViewController];
                [self presentViewController:navigationController animated:YES completion:^{
                }];
            });
        } else if(indexPath.section == 2) {
            PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
            PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
            postDetailViewController.postId = postInfo.pid;
            [self.navigationController pushViewController:postDetailViewController animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.showSearchHistory) {
        if(indexPath.row < self.historyArray.count) {
            if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        } else {
            if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
            }
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
            }
        }
    } else {
        if(indexPath.section == 0) {
            if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
            }
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
            }
        } else if(indexPath.section == 1) {
            if(indexPath.row < self.themeArray.count) {
                if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                    [cell setSeparatorInset:UIEdgeInsetsZero];
                }
                if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                    [cell setLayoutMargins:UIEdgeInsetsZero];
                }
            } else {
                if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                    [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
                }
                if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                    [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
                }
            }
        } else {
            if(indexPath.row < self.postArray.count) {
                if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                    [cell setSeparatorInset:UIEdgeInsetsZero];
                }
                if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                    [cell setLayoutMargins:UIEdgeInsetsZero];
                }
            } else {
                if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                    [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
                }
                if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                    [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
                }
            }
        }
    }
}

#pragma mark - PostTableViewCellDelegate
- (void)commentPostForItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath {
    
    if(![Context sharedInstance].token) {
        PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
        PostInfo *postInfo = [self.postArray objectAtIndex:indexPath.row];
        postDetailViewController.postId = postInfo.pid;
        postDetailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:postDetailViewController animated:YES];
        return;
    }
    if(postInfo != nil && postInfo.pid != nil) {
        PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
        postDetailViewController.postId = postInfo.pid;
        postDetailViewController.hidesBottomBarWhenPushed = YES;
        postDetailViewController.type = @"fromComment";
        [self.navigationController pushViewController:postDetailViewController animated:YES];
    }
}

- (void)favorPostForItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath {
    NSString *isfreeze = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfreeze"];
    NSString *thaw_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_date"];
    NSString *thaw_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_time"];
    NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
    NSString *isshowfree = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshowfree"];
  
    //    NSLog(@"%@------%@-----%@",isfreeze,thaw_time,thaw_date);
    self.isfreeze = isfreeze;
    self.thaw_date = thaw_date;
    self.thaw_time = thaw_time;
    self.isshow = isshow;
    self.isshowfree = isshowfree;
    
    if ([self.isshow isEqualToString:@"1"]) {
        if ([self.isfreeze isEqualToString:@"1"]) {
            return;
        }
    }else{
        if ([self.isfreeze isEqualToString:@"1"]) {
                        int time = [thaw_time intValue];
                         int day = time/24/60/60;
                        NSString * attentionstr = nil;
                        if (day > 7) {
                             attentionstr = @"萌热娘说了，屡教不改的熊宝要严惩！罚你永远关进小黑屋\no(￣ヘ￣o＃)";
                        }else{
                            attentionstr = [NSString stringWithFormat:@"萌热娘说了，犯了错还屡教不改的熊宝要严惩！罚你关进小黑屋%d天\no(≧口≦)o",day];
                        }
            AttentionView * attention = [[AttentionView alloc]initTitlestr:attentionstr];
            [self.view addSubview:attention];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isshow"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return;
        }
    }
//    if (![self.isshowfree isEqualToString:@"1"]&&![self.isfreeze isEqualToString:@"1"]) {
//        AttentionView * attention = [[AttentionView alloc]initTitlestr:@"账号被解冻啦o(*￣▽￣*)ゞ 下次不要再犯错咯！"];
//        [self.view addSubview:attention];
//        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isshowfree"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }

    if(![Context sharedInstance].token) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"点赞是熊宝哒特权！" andtitle2:@"*/ω＼*)"];
        [self.view addSubview:attention];
        return;
    }
    if(postInfo != nil && postInfo.pid != nil) {
        [self favorPost:postInfo atIndexPath:indexPath];
    }
}

- (void)clickAuthorAtItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath {
    AuthorDetailViewController *authorDetailViewController = [[AuthorDetailViewController alloc] init];
    authorDetailViewController.authorInfo = postInfo.author;
    authorDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:authorDetailViewController animated:YES];
}

- (void)clickThemeAtItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath {
    if(!postInfo.theme) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //跳转界面
        ThemeDetailViewController *topicDetailViewController = [[ThemeDetailViewController alloc] init];
        topicDetailViewController.themeInfo = postInfo.theme;
        topicDetailViewController.themeId = postInfo.theme.tid;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:topicDetailViewController];
        [self presentViewController:navigationController animated:YES completion:^{
        }];
    });
}

//为帖子点赞
- (void)favorPost:(PostInfo *)postInfo atIndexPath:(NSIndexPath *)indexPath {
    NSString *type = @"1";
    if([postInfo.favorStatus isEqualToString:@"1"]) {
        type = @"3";
    }
    [self actPostWithType:type withPostId:postInfo.pid atIndexPath:indexPath];
}

- (void)actPostWithType:(NSString *)type withPostId:(NSString *)postId atIndexPath:(NSIndexPath *)indexPath {
    //    [SVProgressHUD showWithStatus:@"正在为帖子点赞或者加踩..." maskType:SVProgressHUDMaskTypeClear];
    NSDictionary *params = @{
                             @"postId": postId,
                             @"favorType" : type
                             };
    [[PostAPIRequest sharedInstance] favorPost:params success:^(CommonInfo *resultInfo) {
        //        [SVProgressHUD dismiss];
        if(resultInfo && [resultInfo isSuccess]) {
            if(indexPath.row < self.postArray.count) {
                PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
                postInfo.favorStatus = [postInfo.favorStatus isEqualToString:@"1"] ? @"0" : @"1";
                if([postInfo.favorStatus isEqualToString:@"1"]) {
                    postInfo.favorCount = [NSString stringWithFormat:@"%ld", [postInfo.favorCount integerValue] + 1];
                    
                    AttentionView * attention = [[AttentionView alloc]initTitle:@"阿里嘎多！" andtitle2:@""];
                    attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
                    attention.label1.frame=CGRectMake(5, 15, 220, 40);
                    [self.view addSubview:attention];
                } else {
                    postInfo.favorCount = [NSString stringWithFormat:@"%ld", [postInfo.favorCount integerValue] - 1];
                    AttentionView * attention = [[AttentionView alloc]initTitle:@"啊嘞？" andtitle2:@""];
                    attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
                    attention.label1.frame=CGRectMake(5, 15, 220, 40);
                    
                    [self.view addSubview:attention];
                }
                [self.postArray replaceObjectAtIndex:indexPath.row withObject:postInfo];
            }
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView reloadData];
        } else {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"操作失败！" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        }
    } failure:^(NSError *error) {
       
    }];
}


#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 11;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_ShopCollectionViewCell forIndexPath:indexPath];
    cell.selectedBackgroundView = [UIView new];
    [cell setCollectionView];
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


- (void)tapBlankView {
    [self.searchTextField resignFirstResponder];
    [self.view endEditing:YES];
}
- (NSMutableAttributedString *)with:(NSMutableAttributedString *)attStr and:(NSString *)strFirst andSecondString:(NSString *)strSecond{
//    NSLog(@"attStr-----%@strFirst=====%@strSecond=======%@",attStr,strFirst,strSecond);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:strFirst];
    [str addAttribute:NSForegroundColorAttributeName value:I_COLOR_YELLOW range:NSMakeRange(0,strFirst.length)];
    NSRange range = [strSecond rangeOfString:strFirst];
    NSInteger location = range.location;
    NSInteger leight = range.length;
    if (leight==0) {
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:strSecond];
        [attStr appendAttributedString:str1];
        return attStr;
    }
    NSString *string = [strSecond substringToIndex:location];
    NSString *string1 = [strSecond substringFromIndex:location+range.length];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:string1];
    [attStr appendAttributedString:str1];
    [attStr appendAttributedString:str];
    [attStr appendAttributedString:str2];
    return attStr ;
}

#pragma mark - Private Method
- (void)createUI {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(50.0f) + 20)];
    topView.backgroundColor = I_COLOR_YELLOW;
    [self.view addSubview:topView];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), TRANS_VALUE(0.0f) + 20, TRANS_VALUE(30.0f), TRANS_VALUE(50.0f))];
    [self.backButton setImage:[UIImage imageNamed:@"ic_arrow_back"] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"ic_arrow_back"] forState:UIControlStateHighlighted];
    [self.backButton setImage:[UIImage imageNamed:@"ic_arrow_back"] forState:UIControlStateSelected];
    [topView addSubview:self.backButton];
    [self.backButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(TRANS_VALUE(32.0f), TRANS_VALUE(10.0f) + 20, CONVER_VALUE(289.0f), TRANS_VALUE(30.0f))];
    //self.searchTextField.borderStyle = UITextBorderStyleNone;
    self.searchTextField.font = [UIFont systemFontOfSize:TRANS_VALUE(13.0f)];
    self.searchTextField.clipsToBounds = YES;
    self.searchTextField.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.searchTextField.layer.borderWidth = 0.0f;
    self.searchTextField.layer.cornerRadius = TRANS_VALUE(4.0f);
    self.searchTextField.backgroundColor = I_COLOR_WHITE;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.textColor = I_COLOR_33BLACK;
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"可以搜索社区和商城哟ヽ(•ω•)ゝ" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    self.searchTextField.tintColor = I_COLOR_GRAY;
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(30.0f), TRANS_VALUE(30.0f))];
    leftView.contentMode = UIViewContentModeScaleAspectFill;
    self.searchTextField.leftView = leftView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *leftNewView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(9.0f),TRANS_VALUE(9.0f),TRANS_VALUE(12.0f), TRANS_VALUE(12.0f))];
    leftNewView.image = [UIImage imageNamed:@"ic_search_gay"];
    leftNewView.contentMode = UIViewContentModeScaleAspectFit;
    [self.searchTextField.leftView addSubview:leftNewView];

    [topView addSubview:self.searchTextField];
    self.searchTextField.delegate = self;
    
    self.searchButton = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(270.0f), TRANS_VALUE(0.0f) + 20, TRANS_VALUE(60.0f), TRANS_VALUE(50.0f))];
    [self.searchButton setImage:[UIImage imageNamed:@"ic_theme_search"] forState:UIControlStateNormal];
    [self.searchButton setImage:[UIImage imageNamed:@"ic_theme_search"] forState:UIControlStateHighlighted];
    [self.searchButton setImage:[UIImage imageNamed:@"ic_theme_search"] forState:UIControlStateSelected];
    [self.searchButton setTitleColor:I_COLOR_WHITE forState:UIControlStateNormal];
    [topView addSubview:self.searchButton];
    
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat buttonWidth = (SCREEN_WIDTH - 2 * TRANS_VALUE(0.0f)) / 2;
    CGFloat buttonHeight = TRANS_VALUE(35.0f);
    self.incubatorButton = [[TopTabButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), TRANS_VALUE(50.0f) + 20, buttonWidth, buttonHeight)];
    [self.incubatorButton setTitle:@"孵化箱"];
    self.incubatorButton.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:self.incubatorButton];
    self.shopButton = [[TopTabButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f) + buttonWidth, TRANS_VALUE(50.0f) + 20, buttonWidth, buttonHeight)];
    [self.shopButton setTitle:@"聚叶城"];
    self.shopButton.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.shopButton setUserInteractionEnabled:NO];
    [self.view addSubview:self.shopButton];
    
    //实例化表单控件
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(50.0f) + 20 + buttonHeight, SCREEN_WIDTH, SCREEN_HEIGHT - TRANS_VALUE(50.0f) - 20 - buttonHeight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollsToTop = NO;
//    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = I_BACKGROUND_COLOR;
    self.tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
//    MyRefreshHeader *header = [MyRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    self.tableView.mj_header = header;
//    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MyRefreshFooter *footer = [MyRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    
    [self.incubatorButton addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shopButton addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView registerClass:[PostTableViewCell class] forCellReuseIdentifier:@"PostTableViewCell"];
    
    [self.incubatorButton setSelected:YES];
    [self.shopButton setSelected:NO];
    [self.tableView reloadData];
    //添加CollectionView
    [self.view addSubview:self.myCollectionView];
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView).with.insets(UIEdgeInsetsZero);
    }];
    self.myCollectionView.hidden = YES;
    
    //实例化表单控件
    self.historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(50.0f) + 20, SCREEN_WIDTH, SCREEN_HEIGHT - TRANS_VALUE(50.0f) - 20) style:UITableViewStylePlain];
    self.historyTableView.dataSource = self;
    self.historyTableView.delegate = self;
    self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.historyTableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.historyTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.historyTableView];
    self.historyTableView.showsVerticalScrollIndicator = NO;
    self.historyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //设置tableview分割线
    if([self.historyTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.historyTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.historyTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.historyTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.historyTableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:@"SearchTableViewCell"];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    self.placeHolderLabel.hidden = YES;
//    self.searchTextField.background=nil;
}


#pragma mark getter && setter
- (UICollectionView *)myCollectionView {
    if (!_myCollectionView) {
        BWaterflowLayout * layout = [[BWaterflowLayout alloc]init];
        layout.delegate = self;
        UICollectionView *tempCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        tempCollectView.dataSource = self;
        tempCollectView.delegate = self;
        [tempCollectView registerClass:[ShopCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier_ShopCollectionViewCell];
        tempCollectView.backgroundColor = I_BACKGROUND_COLOR;
        [self.view addSubview:(_myCollectionView = tempCollectView)];
    }
    return _myCollectionView;
}

@end
