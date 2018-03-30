//
//  MyConcernedIPViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "ConcernedThemeViewController.h"
#import "MyConcernedTableViewCell.h"
#import "MoreThemeViewController.h"
#import "ThemeDetailViewController.h"

#import "MeAPIRequest.h"
#import "IndexAPIRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
//#import <TSMessages/TSMessage.h>
#import "Context.h"
#import "AppDelegate.h"
#import "MyConcernedItem.h"
#import "AttentionView.h"
#import "ProgressHUD.h"
#import "ThemeDrawerViewController.h"
@interface ConcernedThemeViewController () <UITableViewDataSource, UITableViewDelegate, MyConcernedTableViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *addButton;

@property (strong, nonatomic) NSMutableArray *myConcernedArray;

@property (assign, nonatomic) BOOL viewPoped;

@property (strong, nonatomic)UIImageView *img;
@property (strong, nonatomic)UILabel *lab;
@property (nonatomic,strong) NSString *isfreeze;
@property (nonatomic,strong) NSString *thaw_date;
@property (nonatomic,strong) NSString *thaw_time;
@property (nonatomic,strong)NSString * isshow;
@property (nonatomic,strong)NSString * isshowfree;
@end

@implementation ConcernedThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *isfreeze = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfreeze"];
    NSString *thaw_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_date"];
    NSString *thaw_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_time"];
    NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
    NSString *isshowfree = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshowfree"];
    self.isshowfree = isshowfree;
    //    NSLog(@"%@------%@-----%@",isfreeze,thaw_time,thaw_date);
    self.isfreeze = isfreeze;
    self.thaw_date = thaw_date;
    self.thaw_time = thaw_time;
    self.isshow = isshow;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"关注的熊窝";
    [self setBackNavgationItem];
    [self createUI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //加载数据
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
#pragma mark - Action
- (void)addTopicAction {
    //TODO -- 探索更多的主题
    ThemeDrawerViewController *themeDrawerViewController = [[ThemeDrawerViewController alloc] init];
    themeDrawerViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:themeDrawerViewController animated:YES];
//    MoreThemeViewController *moreThemesViewController = [[MoreThemeViewController alloc] init];
//    [self.navigationController pushViewController:moreThemesViewController animated:YES];
}

#pragma mark - MyCorncernedTableViewCellDelegate
- (void)cancelConcernAtIndexPath:(NSIndexPath *)indexPath {
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
    //TODO -- 取消主题
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

    ThemeInfo *themeInfo = [self.myConcernedArray objectAtIndex:indexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if(themeInfo.tid) {
        [params setObject:@[themeInfo.tid] forKey:@"themeIds"];
    }
    [params setObject:@"0" forKey:@"type"];
//    [SVProgressHUD showWithStatus:@"正在取消关注..." maskType:SVProgressHUDMaskTypeClear];
    [[IndexAPIRequest sharedInstance] followTheme:params success:^(CommonInfo *resultInfo) {
//        [SVProgressHUD dismiss];
        if(resultInfo && [resultInfo isSuccess]) {
//            [TSMessage showNotificationWithTitle:@"取消关注成功" subtitle:nil type:TSMessageNotificationTypeSuccess];
            
            
            AttentionView * attention = [[AttentionView alloc]initTitle:@"知道你要远行，我们会想你的" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];

            
            [self loadData];
        } else {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"取消关注失败！" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
//            [TSMessage showNotificationWithTitle:@"取消关注失败" subtitle:nil type:TSMessageNotificationTypeError];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.myConcernedArray != nil ? self.myConcernedArray.count : 0;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CONVER_VALUE(105.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0f;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    view.backgroundColor = I_BACKGROUND_COLOR;
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MyConcernedTableViewCell";
    MyConcernedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[MyConcernedTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if(indexPath.row < self.myConcernedArray.count) {
        //TOOD -- 我的关注
        ThemeInfo *concernedItem = (ThemeInfo *)[self.myConcernedArray objectAtIndex:indexPath.row];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.concernedItem = concernedItem;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < self.myConcernedArray.count) {
        //TODO--跳转到主题详情
        ThemeDetailViewController *topicDetailViewController = [[ThemeDetailViewController alloc] init];
        ThemeInfo *themeInfo = [self.myConcernedArray objectAtIndex:indexPath.row];
        topicDetailViewController.themeInfo = themeInfo;
        topicDetailViewController.themeId = themeInfo.tid;
        dispatch_async(dispatch_get_main_queue(), ^{
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:topicDetailViewController];
            [self presentViewController:navigationController animated:YES completion:^{
                
            }];
        });
        
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < self.myConcernedArray.count) {
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

#pragma mark - Private Method
- (void)loadData {
    [self.img removeFromSuperview];
    [self.lab removeFromSuperview];

    if(!self.myConcernedArray) {
        self.myConcernedArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.myConcernedArray removeAllObjects];
    if(![Context sharedInstance].token) {
        [self.tableView reloadData];
        return;
    }
    [ProgressHUD show:nil];
    [[IndexAPIRequest sharedInstance] getMyThemes:nil success:^(NSArray *groupThemes) {
        [ProgressHUD dismiss];
        if(groupThemes) {
            for(ThemeGroupInfo *group in groupThemes) {
                if(group.list != nil) {
                    [self.myConcernedArray addObjectsFromArray:group.list];
                }
            }
        }
        if (self.myConcernedArray.count==0) {
            self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(120.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
            self.img.contentMode = UIViewContentModeScaleAspectFit;
            self.img.image = [UIImage imageNamed:@"no_data_hint"];
            [self.tableView addSubview:_img];
            
            self.lab= [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(280.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
            self.lab.textColor = I_COLOR_33BLACK;
            self.lab.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
            self.lab.textAlignment = NSTextAlignmentCenter;
            self.lab.text = @"你还没有关注，快去逛逛吧！";
            [self.tableView addSubview:self.lab];
        }

        [self.tableView reloadData];
    } failure:^(NSError *error) {
        self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(120.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
        self.img.contentMode = UIViewContentModeScaleAspectFit;
        self.img.image = [UIImage imageNamed:@"bg_network"];
        [self.tableView addSubview:_img];
        
        self.lab= [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(280.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
        self.lab.textColor = I_COLOR_33BLACK;
        self.lab.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
        self.lab.textAlignment = NSTextAlignmentCenter;
        self.lab.text = @"页面好像走丢了，刷新试试吧...";
        [self.tableView addSubview:self.lab];
        [ProgressHUD dismiss];
    }];
}

- (void)createUI {
    //实例化表单控件
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - TRANS_VALUE(60.0f)) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = I_DIVIDER_COLOR;
    self.tableView.backgroundColor = I_BACKGROUND_COLOR;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(0.0f))];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - TRANS_VALUE(60.0f), SCREEN_WIDTH, TRANS_VALUE(60.0f))];
    bottomView.backgroundColor = I_COLOR_WHITE;
    [self.view addSubview:bottomView];
    
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), TRANS_VALUE(10.0f), SCREEN_WIDTH - 2 * TRANS_VALUE(10.0f), TRANS_VALUE(40.0f))];
    self.addButton.backgroundColor = I_COLOR_YELLOW;
    self.addButton.clipsToBounds = YES;
    self.addButton.layer.cornerRadius = TRANS_VALUE(20.0f);
    self.addButton.titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(16.0f)];
    self.addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.addButton setTitle:@"搜寻其他熊窝" forState:UIControlStateNormal];
    [self.addButton setImage:[UIImage imageNamed:@"ic_img_search_button"] forState:UIControlStateNormal];
    [self.addButton setImage:[UIImage imageNamed:@"ic_img_search_button"] forState:UIControlStateSelected];
    [self.addButton setImage:[UIImage imageNamed:@"ic_img_search_button"] forState:UIControlStateHighlighted];
    [self.addButton setTitleEdgeInsets:UIEdgeInsetsMake(0, TRANS_VALUE(10.0f), 0, 0)];
    [bottomView addSubview:self.addButton];
    [self.addButton addTarget:self action:@selector(addTopicAction) forControlEvents:UIControlEventTouchUpInside];
    
    //设置tableview分割线
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

@end
