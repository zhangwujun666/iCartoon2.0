//
//  MyCollectionViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "TopTabButton.h"
#import "TaskTableViewCell.h"
#import "CollectionPostTableViewCell.h"
#import "TaskDetailViewController.h"
#import "PostDetailViewController.h"
#import "AuthorDetailViewController.h"
#import "ThemeDetailViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "MeAPIRequest.h"
#import "IndexAPIRequest.h"
#import "PostAPIRequest.h"
#import "Context.h"
//下拉刷新，上拉加载
#import <MJRefresh/MJRefresh.h>
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import "AttentionView.h"
#import "ProgressHUD.h"
@interface MyCollectionViewController () <UITableViewDataSource, UITableViewDelegate, TaskTableViewCellDelegate, CollectionPostTableViewCellDelegate>

@property (strong, nonatomic) TopTabButton *postButton;         //帖子
@property (strong, nonatomic) TopTabButton *taskButton;         //任务
@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) BOOL taskSelected;
@property (strong, nonatomic) NSMutableArray *postArray;
@property (strong, nonatomic) NSMutableArray *taskArray;

@property (assign, nonatomic) NSInteger pageNo;
@property (assign, nonatomic) NSInteger pageSize;

@property (strong, nonatomic)UIImageView *img;
@property (strong, nonatomic)UILabel *lab;
@property (nonatomic,strong) NSString *isfreeze;
@property (nonatomic,strong) NSString *thaw_date;
@property (nonatomic,strong) NSString *thaw_time;
@property (nonatomic,strong)NSString * isshow;
@property (nonatomic,strong)NSString * isshowfree;
@end

@implementation MyCollectionViewController

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
    self.navigationItem.title = @"我的收藏";
    [self setBackNavgationItem];
    
    self.pageNo = 1;
    self.pageSize = 10;
    
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - TaskTableViewCellDelegate
- (void)collectTaskForItem:(TaskInfo *)taskItem atIndexPath:(NSIndexPath *)indexPath {
    if(taskItem) {
        [self collectTask:taskItem atIndexPath:indexPath];
    }
}

//(收藏/取消收藏)任务
- (void)collectTask:(TaskInfo *)taskInfo atIndexPath:(NSIndexPath *)indexPath {
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

    if(!taskInfo || !taskInfo.tid) {
        return;
    }
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
    NSString *collectStatus = taskInfo.collectStatus;
    if(!collectStatus) {
//        [TSMessage showNotificationWithTitle:@"该任务不能进行收藏操作" subtitle:nil type:TSMessageNotificationTypeWarning];
        AttentionView * attention = [[AttentionView alloc]initTitle:@"该任务不能进行收藏操作！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:taskInfo.tid forKey:@"taskId"];
    NSString *type = [collectStatus isEqualToString:@"1"] ? @"2" : @"1";
    [params setObject:type forKey:@"type"];
    NSString *tipTitle = @"";
    if([collectStatus isEqualToString:@"1"]) {
        tipTitle = @"取消收藏";
        AttentionView * attention = [[AttentionView alloc]initTitle:@"那，再见啦~" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
//        [self.tableView  reloadData];
        
    } else if([collectStatus isEqualToString:@"0"]) {
        tipTitle = @"收藏";
        AttentionView * attention = [[AttentionView alloc]initTitle:@"(｡･∀･)ﾉﾞ嗨，我在收藏栏等你" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
    }
//    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在%@任务...", tipTitle] maskType:SVProgressHUDMaskTypeClear];
    [[IndexAPIRequest sharedInstance] collectTask:params success:^(CommonInfo *resultInfo) {
//        [SVProgressHUD dismiss];
        if(resultInfo && [resultInfo isSuccess]) {
            if(indexPath.row < self.taskArray.count) {
                TaskInfo *taskInfo = [self.taskArray objectAtIndex:indexPath.row];
                taskInfo.collectStatus = [taskInfo.collectStatus isEqualToString:@"1"] ? @"0" : @"1";
               // [self.taskArray replaceObjectAtIndex:indexPath.row withObject:taskInfo];
                [self.taskArray removeObjectAtIndex:indexPath.row];
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
               
                
            }
        }
[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshHomeTasks object:nil];
         [self.tableView endUpdates];
        
    } failure:^(NSError *error) {
    
    }];
}

#pragma mark - Action
- (void)tabButtonAction:(id)sender {
    TopTabButton *button = (TopTabButton *)sender;
    if(!button.isSelected) {
        if(button == self.postButton) {
            [self.postButton setSelected:YES];
            [self.taskButton setSelected:NO];
            self.tableView.backgroundColor = I_BACKGROUND_COLOR;
            //TODO -- 选中帖子
            self.taskSelected = NO;
            [self loadNewData];
        } else {
            [self.postButton setSelected:NO];
            [self.taskButton setSelected:YES];
            self.tableView.backgroundColor = I_BACKGROUND_COLOR;
            //TODO -- 选中任务
            self.taskSelected = YES;
            [self loadNewData];
        }
    }
}

#pragma mark - CollectionPostTableViewCellDelegate
- (void)commentPostForItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath {
    if(![Context sharedInstance].token) {
        //[TSMessage showNotificationWithTitle:@"请问你愿意做我们熊窝的熊宝吗？*/ω＼*)" subtitle:nil type:TSMessageNotificationTypeWarning];
        AttentionView * attention = [[AttentionView alloc]initTitle:@"请问你愿意做我们熊窝的熊宝吗？" andtitle2:@"*/ω＼*)"];
        [self.view addSubview:attention];
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
    
    if(![Context sharedInstance].token) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"点赞是熊宝哒特权！" andtitle2:@"*/ω＼*)"];
        [self.view addSubview:attention];
        return;
    }
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

    if(postInfo != nil && postInfo.pid != nil) {
        [self favorPost:postInfo atIndexPath:indexPath];
    }
}

- (void)unfavoritePostForItem:(PostInfo *)postInfo indexPath:(NSIndexPath *)indexPath {
    if(![Context sharedInstance].token) {
//        [TSMessage showNotificationWithTitle:@"用户登录后才可以取消收藏帖子" subtitle:nil type:TSMessageNotificationTypeWarning];
        AttentionView * attention = [[AttentionView alloc]initTitle:@"用户登陆后才可以取消收藏帖子！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }
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

    if(postInfo != nil && postInfo.pid != nil) {
        [self disfavoritePost:postInfo atIndexPath:indexPath];
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
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        } else {
//            [TSMessage showNotificationWithTitle:@"操作失败" subtitle:nil type:TSMessageNotificationTypeError];
            AttentionView * attention = [[AttentionView alloc]initTitle:@"操作失败！" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
//        [TSMessage showNotificationWithTitle:[error localizedDescription] subtitle:nil type:TSMessageNotificationTypeError];
//        AttentionView *attention = [[AttentionView alloc]initTitle:[error localizedDescription]];
//        [self.view addSubview:attention];
    }];
}

- (void)disfavoritePost:(PostInfo *)postInfo atIndexPath:(NSIndexPath *)indexPath {
    if(!postInfo || !postInfo.pid) {
        return;
    }
    if(![Context sharedInstance].token) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"用户登陆后才能进行取消收藏帖子！" andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        [self.view addSubview:attention];
        return;
    }
    
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

    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:postInfo.pid forKey:@"postId"];
    [params setObject:@"2" forKey:@"type"];
    NSString *actionStr = @"取消收藏";
//    NSString *messageStr = [NSString stringWithFormat:@"正在%@帖子...", actionStr];
//    [SVProgressHUD showWithStatus:messageStr maskType:SVProgressHUDMaskTypeClear];
    [[PostAPIRequest sharedInstance] collectPost:params success:^(CommonInfo *resultInfo) {
//        [SVProgressHUD dismiss];
        if(resultInfo && [resultInfo isSuccess]) {
                AttentionView * attention = [[AttentionView alloc]initTitle:@"那，再见啦~" andtitle2:@""];
                attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
                attention.label1.frame=CGRectMake(5, 15, 220, 40);
                [self.view addSubview:attention];
//            NSLog(@"%indexPath.row === ld",indexPath.row);
            [self.postArray removeObjectAtIndex:indexPath.row];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        } else {
            AttentionView * attention = [[AttentionView alloc]initTitle:[NSString stringWithFormat:@"%@失败",actionStr] andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            [self.view addSubview:attention];
        }
    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//        [TSMessage showNotificationWithTitle:[error localizedDescription] subtitle:nil type:TSMessageNotificationTypeError];
    }];
    
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.taskSelected) {
        NSInteger count = self.taskArray != nil ? [self.taskArray count] : 0;
        return count;
    } else {
        NSInteger count = self.postArray != nil ? [self.postArray count] : 0;
        return count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.taskSelected) {
        return TRANS_VALUE(91.0f);
    } else {
        if(indexPath.row < self.postArray.count) {
            PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
            CGFloat height = [CollectionPostTableViewCell heightForCell:indexPath withCommentInfo:postInfo];
            return height;
        } else {
            return 0.0f;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0f;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.taskSelected) {
        static NSString *identifier = @"TaskTableViewCell";
        TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell) {
            cell = [[TaskTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        if(indexPath.row < self.taskArray.count) {
            //TOOD -- 我的任务
            TaskInfo *taskInfo = (TaskInfo *)[self.taskArray objectAtIndex:indexPath.row];
            if(!taskInfo.collectStatus || [taskInfo.collectStatus isEqualToString:@""]) {
                taskInfo.collectStatus = @"1";
                [self.taskArray replaceObjectAtIndex:indexPath.row withObject:taskInfo];
            }
            cell.indexPath = indexPath;
            cell.taskItem = taskInfo;
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        static NSString *identifier = @"DiscoveryTableViewCell";
        CollectionPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell) {
            cell = [[CollectionPostTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        if(indexPath.row < self.postArray.count) {
            PostInfo *postInfo = (PostInfo *)[self.postArray objectAtIndex:indexPath.row];
            cell.postItem = postInfo;
            cell.indexPath = indexPath;
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO -- 跳转
    if(self.taskSelected) {
        if(indexPath.row < self.taskArray.count) {
            TaskInfo *taskInfo = [self.taskArray objectAtIndex:indexPath.row];
            TaskDetailViewController *taskDetailViewController = [[TaskDetailViewController alloc] init];
            taskDetailViewController.taskInfo = taskInfo;
            taskDetailViewController.taskId = taskInfo.tid;
            [self.navigationController pushViewController:taskDetailViewController animated:YES];
        }
    } else {
        if(indexPath.row < self.postArray.count) {
            PostInfo *postInfo = [self.postArray objectAtIndex:indexPath.row];
            PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] init];
            postDetailViewController.postId = postInfo.pid;
            [self.navigationController pushViewController:postDetailViewController animated:YES];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.taskSelected) {
        if(indexPath.row < self.taskArray.count) {
            if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        } else {
            if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
    } else {
        if(indexPath.row < self.postArray.count) {
            if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
            }
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2)];
            }
        } else {
            if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
    }
}


#pragma mark - Private Method
- (void)loadData {
    [self.taskButton setSelected:NO];
    [self.postButton setSelected:YES];
    self.taskSelected = NO;
    //获取我收藏的任务列表
    [self loadNewData];
}

- (void)loadNewData {
    self.pageNo = 1;
    [self.tableView.mj_footer resetNoMoreData];
    if(self.taskSelected) {
        //刷新设计师帖子列表
        [self.img removeFromSuperview];
        [self.lab removeFromSuperview];

        if(!self.taskArray) {
            self.taskArray = [NSMutableArray arrayWithCapacity:0];
        }
        [self.taskArray removeAllObjects];
        NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
        NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
        NSDictionary *params = @{
                                 @"pageNo" : pageNo,
                                 @"pageSize" : pageSize
                                 };
        [ProgressHUD show:nil];
        [[MeAPIRequest sharedInstance] getUserCollectedTasks:params success:^(NSArray *taskArray) {
            [ProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            if(taskArray) {
                [self.taskArray addObjectsFromArray:taskArray];
                if(taskArray.count >= self.pageSize) {
                    self.pageNo ++;
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (self.taskArray.count==0) {
                self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(120.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
                self.img.contentMode = UIViewContentModeScaleAspectFit;
                self.img.image = [UIImage imageNamed:@"no_data_hint"];
                [self.tableView addSubview:_img];
                
                self.lab= [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(280.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
                self.lab.textColor = I_COLOR_33BLACK;
                self.lab.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
                self.lab.textAlignment = NSTextAlignmentCenter;
                self.lab.text = @"你还没有收藏，快去逛逛吧！";
                [self.tableView addSubview:self.lab];
                self.tableView.backgroundColor=[UIColor whiteColor];
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
            self.tableView.backgroundColor=[UIColor whiteColor];
            [ProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView reloadData];
        }];
    } else {
        [self.img removeFromSuperview];
        [self.lab removeFromSuperview];

        //我收藏的帖子
        if(!self.postArray) {
            self.postArray = [NSMutableArray arrayWithCapacity:0];
        }
        [self.postArray removeAllObjects];
        NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
        NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
        NSDictionary *params = @{
                                 @"pageNo" : pageNo,
                                 @"pageSize" : pageSize
                                 };
        [SVProgressHUD showWithStatus:@"正在我收藏的帖子..." maskType:SVProgressHUDMaskTypeClear];
        [[MeAPIRequest sharedInstance] getUserCollectedPosts:params success:^(NSArray *postList) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            if(postList) {
                [self.postArray addObjectsFromArray:postList];
                if(postList.count >= self.pageSize) {
                    self.pageNo ++;
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (self.postArray.count==0) {
                self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(120.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
                self.img.contentMode = UIViewContentModeScaleAspectFit;
                self.img.image = [UIImage imageNamed:@"no_data_hint"];
                [self.tableView addSubview:_img];
                
                self.lab= [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(280.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
                self.lab.textColor = I_COLOR_33BLACK;
                self.lab.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
                self.lab.textAlignment = NSTextAlignmentCenter;
                self.lab.text = @"你还没有收藏，快去逛逛吧！";
                [self.tableView addSubview:self.lab];
                self.tableView.backgroundColor=[UIColor whiteColor];
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
            self.tableView.backgroundColor=[UIColor whiteColor];
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            [TSMessage showNotificationWithTitle:[error localizedDescription] subtitle:nil type:TSMessageNotificationTypeError];
//            AttentionView *attention = [[AttentionView alloc]initTitle:[error localizedDescription]];
//            [self.view addSubview:attention];
            [self.tableView reloadData];
        }];
    }
}

- (void)loadMoreData {
    if(self.taskSelected) {
        
        NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
        NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
        NSDictionary *params = @{
                                 @"pageNo" : pageNo,
                                 @"pageSize" : pageSize
                                 };
        [ProgressHUD show:nil];
        [[MeAPIRequest sharedInstance] getUserCollectedTasks:params success:^(NSArray *taskArray) {
            [ProgressHUD dismiss];
            if(taskArray) {
                [self.taskArray addObjectsFromArray:taskArray];
                if(taskArray.count >= self.pageSize) {
                    [self.tableView.mj_footer endRefreshing];
                    self.pageNo ++;
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }

            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [ProgressHUD dismiss];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            [TSMessage showNotificationWithTitle:[error localizedDescription] subtitle:nil type:TSMessageNotificationTypeError];
//            AttentionView *attention = [[AttentionView alloc]initTitle:[error localizedDescription]];
//            [self.view addSubview:attention];
            [self.tableView reloadData];
        }];
    } else {
        //我收藏的帖子
        NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
        NSString *pageSize = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
        NSDictionary *params = @{
                                 @"pageNo" : pageNo,
                                 @"pageSize" : pageSize
                                 };
        [ProgressHUD show:nil];
        [[MeAPIRequest sharedInstance] getUserCollectedPosts:params success:^(NSArray *postList) {
            [ProgressHUD dismiss];
            if(postList) {
                [self.postArray addObjectsFromArray:postList];
                if(postList.count >= self.pageSize) {
                    [self.tableView.mj_footer endRefreshing];
                    self.pageNo ++;
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [ProgressHUD dismiss];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            [TSMessage showNotificationWithTitle:[error localizedDescription] subtitle:nil type:TSMessageNotificationTypeError];
//            AttentionView *attention = [[AttentionView alloc]initTitle:[error localizedDescription]];
//            [self.view addSubview:attention];
            [self.tableView reloadData];
        }];
    }
}

//获取主页任务列表
- (void)getCollectedTasks {
    if(!self.taskArray) {
        self.taskArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.taskArray removeAllObjects];
    [ProgressHUD show:nil];
    NSDictionary *params = @{
                             @"pageNo" : @"1",
                             @"pageSize" : @"10"
                             };
    [[MeAPIRequest sharedInstance] getUserCollectedTasks:params success:^(NSArray *taskArray) {
        [ProgressHUD dismiss];
        if(taskArray) {
            [self.taskArray addObjectsFromArray:taskArray];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [ProgressHUD dismiss];
//        [TSMessage showNotificationWithTitle:[error localizedDescription] subtitle:nil type:TSMessageNotificationTypeError];
//        AttentionView *attention = [[AttentionView alloc]initTitle:[error localizedDescription]];
//        [self.view addSubview:attention];
        [self.tableView reloadData];
    }];
}

//获取主页相应主题的帖子列表
- (void)getCollectedPosts {
    if(!self.postArray) {
        self.postArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.postArray removeAllObjects];
    [SVProgressHUD showWithStatus:@"正在我收藏的帖子..." maskType:SVProgressHUDMaskTypeClear];
    NSDictionary *params = @{
                             @"pageNo" : @"1",
                             @"pageSize" : @"30"
                             };
    [[MeAPIRequest sharedInstance] getUserCollectedPosts:params success:^(NSArray *postList) {
        [SVProgressHUD dismiss];
        if(postList) {
            [self.postArray addObjectsFromArray:postList];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
//        [TSMessage showNotificationWithTitle:[error localizedDescription] subtitle:nil type:TSMessageNotificationTypeError];
//        AttentionView *attention = [[AttentionView alloc]initTitle:[error localizedDescription]];
//        [self.view addSubview:attention];
        [self.tableView reloadData];
    }];
}


- (void)createUI {
    CGFloat buttonWidth = (SCREEN_WIDTH - 2 * TRANS_VALUE(0.0f)) / 2;
    CGFloat buttonHeight = TRANS_VALUE(35.0f);
    self.postButton = [[TopTabButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f), 0.0f, buttonWidth, buttonHeight)];
    [self.postButton setTitle:@"脑洞"];
    [self.view addSubview:self.postButton];
    self.taskButton = [[TopTabButton alloc] initWithFrame:CGRectMake(TRANS_VALUE(0.0f) + buttonWidth, 0, buttonWidth, buttonHeight)];
    [self.taskButton setTitle:@"任务"];
    [self.view addSubview:self.taskButton];
    
//    self.postButton.bottomBorderView.backgroundColor = [UIColor whiteColor];
//    self.taskButton.bottomBorderView.backgroundColor = [UIColor whiteColor];
    
    
    
    //实例化表单控件
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, buttonHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f - buttonHeight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = I_BACKGROUND_COLOR;
//    self.tableView.backgroundColor =[UIColor redColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MyRefreshHeader *header = [MyRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MyRefreshFooter *footer = [MyRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
    
    //设置tableview分割线
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.postButton addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.taskButton addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.postButton setSelected:YES];
    [self.taskButton setSelected:NO];
    [self.tableView reloadData];
    
}

@end
