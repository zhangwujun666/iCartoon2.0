//
//  DraftBoxViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "DraftBoxViewController.h"
#import "DraftPostTableViewCell.h"
#import "DraftCommentTableViewCell.h"
#import "DraftInfoDao.h"
#import "CommentDraftDao.h"
#import "DraftPostInfo.h"
#import "DraftCommentInfo.h"
#import "PostViewController.h"
#import "PublishCommentViewController.h"
#import "CustomAlertView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "AttentionView.h"
#import "ProgressHUD.h"
#import "PublishTaskViewController.h"
#define KBottomBarHeight CONVER_VALUE(70.0f)

#import "PublishTaskViewController.h"

@interface DraftBoxViewController () <UITableViewDataSource, UITableViewDelegate,CustomAlertViewDelegate> {
    UITableViewCellEditingStyle selectEditingStyle;
}

@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) UIBarButtonItem *manageBarBtnItem;
@property (strong, nonatomic) UIBarButtonItem *cancelBarBtnItem;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *allSelectBtn;
@property (strong, nonatomic) UIButton *deleteBtn;

@property (strong, nonatomic) NSMutableArray *draftArray;
@property (strong, nonatomic) NSMutableArray *selectedIndexArr;
@property (strong, nonatomic) NSMutableArray *indexArr;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@property (strong, nonatomic)UIImageView *img;
@property (strong, nonatomic)UILabel *lab;
@end

@implementation DraftBoxViewController
#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self addTargetAction];
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDraftData) name:kNotificationRefreshDrafts object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(remove) name:@"remove" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAlert) name:@"showAlert" object:nil];
}
- (void)remove{
    NSIndexPath * index = self.indexArr[0];
    NSMutableArray * arr = [NSMutableArray array];
    [arr removeAllObjects];
    [arr addObject:self.draftArray[index.row]];
    [self deleteDrafts:arr];
    [self.draftArray removeObjectAtIndex:index.row];
    [self.myTableView reloadData];
}
-(void)showAlert{
    AttentionView *attention = [[AttentionView alloc]initTitle:@"保存成功！"];
    [self.view addSubview:attention];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Private Method
- (void)createUI {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setBackNavgationItem];
    self.title = @"我的草稿";
    //添加表单
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - kTopAndStatusBarHeight));
    }];
   // selectEditingStyle = UITableViewCellEditingStyleDelete;
    [self.view addSubview:self.bottomView];
    
    //设置tableview分割线
    if([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }

}

- (void)addTargetAction {
    [self.allSelectBtn addTarget:self action:@selector(allSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)requestData {
    [self.img removeFromSuperview];
    [self.lab removeFromSuperview];
    [ProgressHUD show:nil];
    [self.draftArray removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSArray *tempArr = [[[DraftInfoDao sharedInstance] getMsgDraftInfos] copy];
        [self.draftArray addObjectsFromArray:[self parseArray:tempArr]];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            if (self.draftArray.count==0) {
                self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(120.0f), SCREEN_WIDTH, TRANS_VALUE(160.0f))];
                self.img.contentMode = UIViewContentModeScaleAspectFit;
                self.img.image = [UIImage imageNamed:@"no_data_hint"];
                [self.myTableView addSubview:_img];
                
                self.lab= [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(280.0f), SCREEN_WIDTH, TRANS_VALUE(40.0f))];
                self.lab.textColor = I_COLOR_33BLACK;
                self.lab.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
                self.lab.textAlignment = NSTextAlignmentCenter;
                self.lab.text = @"你暂时还未有草稿…";
                [self.myTableView addSubview:self.lab];
            }

            [ProgressHUD dismiss];
            [self.myTableView reloadData];
            [self  updateBarBtnItem];
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSArray *tempArr = [[[CommentDraftDao sharedInstance] getCommentDraftList] copy];
        [self.draftArray addObjectsFromArray:[self parseArray:tempArr]];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [ProgressHUD dismiss];
            [self.myTableView reloadData];
            [self  updateBarBtnItem];
        });
    });
}

- (void)refreshDraftData {
    [ProgressHUD show:nil];
    [self.draftArray removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSArray *tempArr = [[[DraftInfoDao sharedInstance] getMsgDraftInfos] copy];
        [self.draftArray addObjectsFromArray:[self parseArray:tempArr]];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [ProgressHUD dismiss];
            [self.myTableView reloadData];
            [self updateBarBtnItem];
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSArray *tempArr = [[[CommentDraftDao sharedInstance] getCommentDraftList] copy];
        [self.draftArray addObjectsFromArray:[self parseArray:tempArr]];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [ProgressHUD dismiss];
            [self.myTableView reloadData];
            [self updateBarBtnItem];
        });
    });
    
}

- (NSArray *)parseArray:(NSArray *)array {
    //数组排序
    array = (NSMutableArray *)[array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *objFirstStr = nil;
        if([obj1 isKindOfClass:[DraftPostInfo class]]) {
            objFirstStr = ((DraftPostInfo *)obj1).createTime;
        } else {
            objFirstStr = ((DraftCommentInfo *)obj1).createTime;
        }
        NSString *objSecondStr = nil;
        if([obj2 isKindOfClass:[DraftPostInfo class]]) {
            objSecondStr = ((DraftPostInfo *)obj1).createTime;
        } else {
            objSecondStr = ((DraftCommentInfo *)obj1).createTime;
        }
        NSDate *date1 = [formatter dateFromString:objFirstStr];
        NSDate *date2 = [formatter dateFromString:objSecondStr];
        NSComparisonResult result = [date1 compare:date2];
        return result == NSOrderedAscending;
    }];
    return array;
}

- (void)manageBarBtnAction {
    if (self.draftArray.count == 0) {
        return;
    }
    selectEditingStyle = UITableViewCellEditingStyleNone;
    [self.myTableView setEditing:YES animated:YES];
    [self.myTableView setAllowsSelectionDuringEditing:YES];
    [self updateBarBtnItem];
    [self showBottomView:YES];
}

- (void)cancelBarBtnAction {
    
    selectEditingStyle = UITableViewCellEditingStyleDelete;
    [self.myTableView setEditing:NO animated:YES];
    [self.myTableView setAllowsSelectionDuringEditing:NO];
    [self updateBarBtnItem];
    [self showBottomView:NO];
    //刷新tableView
}

- (void)updateBarBtnItem {
    if (self.draftArray.count > 0) {
        if(self.myTableView.allowsSelectionDuringEditing) {
            self.navigationItem.rightBarButtonItem = self.cancelBarBtnItem;
            return;
        }
        if(!self.myTableView.editing) {
            self.navigationItem.rightBarButtonItem = self.manageBarBtnItem;
        }
    } else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(void)showBottomView:(BOOL)show{
    [UIView animateWithDuration:0.3 animations:^{
        if(show) {
            [self.myTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-kTopAndStatusBarHeight-KBottomBarHeight));
            }];
            [self.bottomView setTransform:CGAffineTransformMakeTranslation(0, -KBottomBarHeight)];
        } else {
            [self.myTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-kTopAndStatusBarHeight));
            }];
            [self.bottomView setTransform:CGAffineTransformIdentity];
        }
    }];
}

- (void)allSelectAction:(UIButton *)btn {
    if(self.draftArray.count >0) {
        btn.selected = !btn.selected;
        [self.selectedIndexArr removeAllObjects];
        for (NSInteger i=0; i<self.draftArray.count; i++) {
            DraftPostTableViewCell *cell = (DraftPostTableViewCell *)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.mSelected = btn.selected;
            if (btn.selected) {
                [self.selectedIndexArr addObject:[NSNumber numberWithInteger:i]];
            }
        }
        [self.myTableView reloadData];
    }
}

- (void)deleteAction {
        [CustomAlertView showWithTitle:@"" delegate:self];
}

//删除草稿箱数据
- (void)deleteDrafts:(NSArray *)draftArr {
    if (draftArr.count > 0) {
        for(NSObject *tempInfo in draftArr) {
            if([tempInfo isKindOfClass:[DraftPostInfo class]]) {
                BOOL isDelete = [[DraftInfoDao sharedInstance] deleteMsgWithDraftInfo:(DraftPostInfo *)tempInfo];
                if (!isDelete) {
                }
            } else if([tempInfo isKindOfClass:[DraftCommentInfo class]]) {
                BOOL isDelete = [[CommentDraftDao sharedInstance] deleteCommentDraftInfo:(DraftCommentInfo *)tempInfo];
                if (!isDelete) {
                }
            }
        }
    }
}

#pragma mark - CustomAlertViewDelegate
- (void)confirmButtonClick {
    NSMutableArray *msgDetailArr = [NSMutableArray array];
    NSMutableArray *indexPathArr = [NSMutableArray array];
    for (NSNumber *tempNum in self.selectedIndexArr) {
        [msgDetailArr addObject:[self.draftArray objectAtIndex:[tempNum integerValue]]];
        [indexPathArr addObject:[NSIndexPath indexPathForRow:[tempNum integerValue] inSection:0]];
    }
    [self deleteDrafts:msgDetailArr];
    [self.draftArray removeObjectsInArray:msgDetailArr];
    [self.myTableView deleteRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationLeft];
    [self.selectedIndexArr removeAllObjects];
    [self cancelBarBtnAction];
}

- (void)cancelButtonClick {
    if([self.myTableView isEditing]) {
        [self.myTableView setEditing:NO animated:YES];
    }
}

- (CGFloat)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    NSDictionary *dics = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]};
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dics context:nil].size;
    return sizeToFit.height;
}

- (NSString*)convertNull:(id)object{
    if(!object) {
        return @"";
    }
    if(object && [object isEqual:[NSNull null]]){
        return @"";
    }else if ([object isKindOfClass:[NSNull class]]){
        return @"";
    } else if (object == nil) {
        return @"";
    }
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    return [object stringValue];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.draftArray != nil ? self.draftArray.count : 0;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *draftItem = [self.draftArray objectAtIndex:indexPath.row];
    if([draftItem isKindOfClass:[DraftPostInfo class]]) {
        DraftPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_DraftPostTableViewCell forIndexPath:indexPath];
        if(!cell) {
            cell = [[DraftPostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier_DraftPostTableViewCell];
        }
        cell.myDraftInfo = (DraftPostInfo *)draftItem;
        return cell;
    } else {
        DraftCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_DraftCommentTableViewCell forIndexPath:indexPath];
        if(!cell) {
            cell = [[DraftCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier_DraftCommentTableViewCell];
        }
        cell.commentDraftInfo = (DraftCommentInfo *)draftItem;
        return cell;
    }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row >= self.draftArray.count) {
        return 0.0f;
    }
    NSObject *draftItem = [self.draftArray objectAtIndex:indexPath.row];
    if([draftItem isKindOfClass:[DraftPostInfo class]]) {
        DraftPostInfo *myInfo = (DraftPostInfo *)draftItem;
        CGFloat cellHeight = [self heightForString:myInfo.content fontSize:CONVER_VALUE(14.0f) andWidth:SCREEN_WIDTH - 90.0];
        if(cellHeight <= 40.0) {
            cellHeight = 40.0;
        }
        cellHeight += 40.0;
        cellHeight = CONVER_VALUE(105.0f);
        return cellHeight;
    } else {
        DraftCommentInfo *myInfo = (DraftCommentInfo *)draftItem;
        CGFloat cellHeight = [self heightForString:myInfo.comment fontSize:15.0 andWidth:SCREEN_WIDTH - 90.0];
        if(cellHeight <= 40.0) {
            cellHeight = 40.0;
        }
        cellHeight += (50.0 + CONVER_VALUE(80.0f));
        cellHeight = CONVER_VALUE(184.0f);
        return cellHeight;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self updateBarBtnItem];
    return selectEditingStyle;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"didEndEditingRowAtIndexPath");
    [self updateBarBtnItem];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [CustomAlertView showWithTitle:@"" delegate:self];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < self.draftArray.count) {
        NSObject *draftItem = [self.draftArray objectAtIndex:indexPath.row];
     
        DraftPostInfo * infor = self.draftArray[indexPath.row];
//         DraftPostInfo * infor1 = self.draftArray[1];
//           NSLog(@"======================%d=========%d",infor.type,infor1.type);
        if([draftItem isKindOfClass:[DraftPostInfo class]]) {
            DraftPostInfo *tempInfo = (DraftPostInfo *)draftItem;
            DraftPostTableViewCell *cell = (DraftPostTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            if(tableView.editing) {
                cell.mSelected = !cell.mSelected;
                tempInfo.isSelected = cell.mSelected;
                [self.draftArray replaceObjectAtIndex:indexPath.row withObject:tempInfo];
                if(cell.mSelected) {
                    [self.selectedIndexArr addObject:[NSNumber numberWithInteger:indexPath.row]];
                } else {
                    [self.selectedIndexArr removeObject:[NSNumber numberWithInteger:indexPath.row]];
                }
            } else {
                if (infor.type == 1) {
                    [self.indexArr removeAllObjects];
                    [self.indexArr addObject:indexPath];
                    PublishTaskViewController *postViewController = [[PublishTaskViewController alloc] init];
                    postViewController.type = PostTaskSourceTypeDraft;
                    postViewController.draftInfo = tempInfo;
                    [self.navigationController pushViewController:postViewController animated:YES];
                }else{
                    [self.indexArr removeAllObjects];
                    [self.indexArr addObject:indexPath];
                    PostViewController *postViewController = [[PostViewController alloc] init];
                    postViewController.type = PostSourceTypeDraft;
                    postViewController.draftInfo = tempInfo;
                    [self.navigationController pushViewController:postViewController animated:YES];
                }
            }
        } else if ([draftItem isKindOfClass:[DraftCommentInfo class]]) {
            DraftCommentInfo *tempInfo = (DraftCommentInfo *)draftItem;
            if(tableView.editing) {
                DraftCommentTableViewCell *cell = (DraftCommentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                cell.mSelected = !cell.mSelected;
                tempInfo.isSelected = cell.mSelected;
                [self.draftArray replaceObjectAtIndex:indexPath.row withObject:tempInfo];
                if(cell.mSelected) {
                    [self.selectedIndexArr addObject:[NSNumber numberWithInteger:indexPath.row]];
                } else {
                    [self.selectedIndexArr removeObject:[NSNumber numberWithInteger:indexPath.row]];
                }
            } else {
                //TODO -- 跳转到帖子页面
                PublishCommentViewController *publishCommentViewController = [[PublishCommentViewController alloc] init];
                publishCommentViewController.postDetailInfo = nil;
                publishCommentViewController.replyCommentInfo = nil;
                publishCommentViewController.draftCommentInfo = tempInfo;
                publishCommentViewController.type = CommentSourceTypeDraft;
                [self.navigationController pushViewController:publishCommentViewController animated:YES];
            }
        }
    }
}

#pragma mark getter && setter
- (UITableView *)myTableView {
    if(!_myTableView) {
        UITableView *tmpTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tmpTableView.backgroundColor = I_BACKGROUND_COLOR;
        tmpTableView.dataSource = self;
        tmpTableView.delegate = self;
        tmpTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [tmpTableView registerClass:[DraftPostTableViewCell class] forCellReuseIdentifier:kCellIdentifier_DraftPostTableViewCell];
        [tmpTableView registerClass:[DraftCommentTableViewCell class] forCellReuseIdentifier:kCellIdentifier_DraftCommentTableViewCell];
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [tmpTableView setTableFooterView:view];
        [self.view addSubview:(_myTableView = tmpTableView)];
    }
    return _myTableView;
}

- (UIBarButtonItem *)manageBarBtnItem {
    if (!_manageBarBtnItem) {
        
       // _manageBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"管理"
//                                         style:UIBarButtonItemStyleBordered
//                                        target:self
//                                        action:@selector(manageBarBtnAction)];
         UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), 44.0f)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, CONVER_VALUE(10.0f), 0, CONVER_VALUE(-10.0f))];
        [button setTitle:@"管理" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(13)];
        [button addTarget:self action:@selector(manageBarBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _manageBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:button];
      
    }
    return _manageBarBtnItem;
}

- (UIBarButtonItem *)cancelBarBtnItem {
    if(!_cancelBarBtnItem) {
//        _cancelBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarBtnAction)];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), 44.0f)];
        [ button setTitleEdgeInsets:UIEdgeInsetsMake(0, CONVER_VALUE(10.0f), 0, CONVER_VALUE(-10.0f))];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(13)];
        [button addTarget:self action:@selector(cancelBarBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _cancelBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    return _cancelBarBtnItem;
}

- (UIView *)bottomView {
    if(!_bottomView) {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kTopAndStatusBarHeight, SCREEN_WIDTH, KBottomBarHeight)];
        tempView.backgroundColor = [UIColor whiteColor];
        [tempView addSubview:self.allSelectBtn];
        [tempView addSubview:self.deleteBtn];
        [self.view addSubview:(_bottomView = tempView)];
    }
    return _bottomView;
}

- (UIButton *)allSelectBtn {
    if(!_allSelectBtn) {
        UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(CONVER_VALUE(10.0f), CONVER_VALUE(20.0f), CONVER_VALUE(70.0f), CONVER_VALUE(25.0f))];
        [tempBtn setBackgroundColor:[UIColor clearColor]];
        [tempBtn setTitle:@"全选" forState:UIControlStateNormal];
        [tempBtn.titleLabel setFont:[UIFont systemFontOfSize:CONVER_VALUE(15.0f)]];
        [tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tempBtn setImage:[UIImage imageNamed:@"ic_message_off"] forState:UIControlStateNormal];
        [tempBtn setImage:[UIImage imageNamed:@"ic_message_on"] forState:UIControlStateHighlighted];
        [tempBtn setImage:[UIImage imageNamed:@"ic_message_on"] forState:UIControlStateSelected];
        [tempBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -CONVER_VALUE(25.0f), 0, 0)];
        [self.view addSubview:(_allSelectBtn = tempBtn)];
    }
    return _allSelectBtn;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(CONVER_VALUE(90.0f), CONVER_VALUE(10.0f), CONVER_VALUE(275.0f), CONVER_VALUE(50.0f))];
        [tempBtn setBackgroundColor:UIColorFromRGB(0xE10C21)];
        [tempBtn setTitle:@"删除" forState:UIControlStateNormal];
        [tempBtn setImage:[UIImage imageNamed:@"ic_me_delete"] forState:UIControlStateNormal];
        [tempBtn setImage:[UIImage imageNamed:@"ic_me_delete"] forState:UIControlStateSelected];
        [tempBtn setImage:[UIImage imageNamed:@"ic_me_delete"] forState:UIControlStateHighlighted];
        tempBtn.layer.cornerRadius = CONVER_VALUE(50.0f) / 2;
        tempBtn.clipsToBounds = YES;
        [tempBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [self.view addSubview:(_deleteBtn = tempBtn)];
    }
    return _deleteBtn;
}

- (NSMutableArray *)draftArray {
    if (!_draftArray) {
        _draftArray = [NSMutableArray array];
    }
    return _draftArray;
}

- (NSMutableArray *)selectedIndexArr {
    if (!_selectedIndexArr) {
        _selectedIndexArr = [NSMutableArray array];
    }
    return _selectedIndexArr;
}
- (NSMutableArray *)indexArr{
    if (!_indexArr) {
        _indexArr = [NSMutableArray array];
    }
    return _indexArr;
}
@end
