//
//  DraftBoxViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 16/3/24.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "DraftBoxViewController.h"
#import "DraftBoxTableViewCell.h"
#import "DraftInfoDao.h"
#import "CommentDraftDao.h"
#import "DraftInfo.h"
#import "PostViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>

#define KBottomBarHeight CONVER_VALUE(70.0f)

@interface DraftBoxViewController ()<UITableViewDataSource,UITableViewDelegate> {
    UITableViewCellEditingStyle selectEditingStyle;
}
@property (weak, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) UIBarButtonItem *manageBarBtnItem;
@property (strong, nonatomic) UIBarButtonItem *cancelBarBtnItem;
@property (weak, nonatomic) UIView *bottomView;
@property (weak, nonatomic) UIButton *allSelectBtn;
@property (weak, nonatomic) UIButton *deleteBtn;

@property (strong, nonatomic) NSMutableArray *myTableViewArr;
@property (strong, nonatomic) NSMutableArray *selectedIndexArr;
@end

@implementation DraftBoxViewController
#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self addTargetAction];
    [self requestData];
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
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
    selectEditingStyle = UITableViewCellEditingStyleDelete;
    [self.view addSubview:self.bottomView];
}

- (void)addTargetAction {
    [self.allSelectBtn addTarget:self action:@selector(allSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)requestData {
    [SVProgressHUD showWithStatus:@"正在获取草稿列表..." maskType:SVProgressHUDMaskTypeClear];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSArray *tempArr = [[[DraftInfoDao sharedInstance] getMsgDraftInfos] copy];
        [self.myTableViewArr removeAllObjects];
        [self.myTableViewArr addObjectsFromArray:[self parseArray:tempArr]];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [SVProgressHUD dismiss];
            [self.myTableView reloadData];
            [self updateBarBtnItem];
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSArray *tempArr = [[[CommentDraftDao sharedInstance] getCommentDraftList] copy];
//        [self.myTableViewArr addObjectsFromArray:[self parseArray:tempArr]];
        dispatch_async(dispatch_get_main_queue(), ^{
//            // 更新界面
//            [SVProgressHUD dismiss];
//            [self.myTableView reloadData];
//            [self updateBarBtnItem];
        });
    });

}

- (NSArray *)parseArray:(NSArray *)array {
    //数组排序
    array = (NSMutableArray *)[array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYYMMddHHmmssSSS"];// yyyy-MM-dd HH:mm:ss
        NSString *objFirstStr = [self convertNull:((DraftInfo *)obj1).createTime];
        NSString *objSecondStr = [self convertNull:((DraftInfo *)obj2).createTime];
        if (objFirstStr.length == 0) {
            objFirstStr = @"00000000000000";//0000-00-00 00:00:00
        }
        if (objSecondStr.length == 0) {
            objSecondStr = @"00000000000000";
        }
        NSDate *date1 = [formatter dateFromString:objFirstStr];
        NSDate *date2 = [formatter dateFromString:objSecondStr];
        NSComparisonResult result = [date1 compare:date2];
        return result == NSOrderedAscending;
    }];
    return array;
}

- (void)manageBarBtnAction {
    if (self.myTableViewArr.count == 0) { return;}
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
//    [self updateEditingArr];
}

- (void)updateBarBtnItem {
    if (self.myTableViewArr.count > 0) {
        if (self.myTableView.allowsSelectionDuringEditing) {
            self.navigationItem.rightBarButtonItem = self.cancelBarBtnItem;
            return;
        }
        if(self.myTableView.editing) {
        } else{
            self.navigationItem.rightBarButtonItem = self.manageBarBtnItem;
        }
    } else{
        self.navigationItem.rightBarButtonItem = nil;
    }
//    [self.myTableView reloadData];
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

- (void)allSelectAction:(UIButton *)btn
{
    if(self.myTableViewArr.count >0) {
        btn.selected = !btn.selected;
        [self.selectedIndexArr removeAllObjects];
        for (NSInteger i=0; i<self.myTableViewArr.count; i++) {
            DraftBoxTableViewCell *cell = (DraftBoxTableViewCell *)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.mSelected = btn.selected;
            if (btn.selected) {
                [self.selectedIndexArr addObject:[NSNumber numberWithInteger:i]];
            }
        }
        [self.myTableView reloadData];
    }
}

- (void)deleteAction {
    NSMutableArray *msgDetailArr = [NSMutableArray array];
    NSMutableArray *indexPathArr = [NSMutableArray array];
    for (NSNumber *tempNum in self.selectedIndexArr) {
        [msgDetailArr addObject:[self.myTableViewArr objectAtIndex:[tempNum integerValue]]];
        [indexPathArr addObject:[NSIndexPath indexPathForRow:[tempNum integerValue] inSection:0]];
    }
    [self deleteDrafts:msgDetailArr];
    [self.myTableViewArr removeObjectsInArray:msgDetailArr];
    [self.myTableView deleteRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationLeft];
    [self.selectedIndexArr removeAllObjects];
    [self cancelBarBtnAction];
}

//删除草稿箱数据
- (void)deleteDrafts:(NSArray *)draftArr {
    if (draftArr.count > 0) {
        for(NSObject *tempInfo in draftArr) {
            if([tempInfo isKindOfClass:[DraftInfo class]]) {
                BOOL isDelete = [[DraftInfoDao sharedInstance] deleteMsgWithDraftInfo:(DraftInfo *)tempInfo];
                if (!isDelete) {
                    NSLog(@"删除草稿箱数据失败===%@",((DraftInfo *)tempInfo).createTime);
                }
            } else if([tempInfo isKindOfClass:[CommentDraftInfo class]]) {
                BOOL isDelete = [[CommentDraftDao sharedInstance] deleteCommentDraftInfo:(CommentDraftInfo *)tempInfo];
                if (!isDelete) {
                    NSLog(@"删除草稿箱数据失败===%@",((DraftInfo *)tempInfo).createTime);
                }
            }
        }
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
    return self.myTableViewArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DraftBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_DraftBoxTableViewCell forIndexPath:indexPath];
    cell.myDraftInfo = (DraftInfo *)[self.myTableViewArr objectAtIndex:indexPath.row];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DraftInfo *myInfo = (DraftInfo *)[self.myTableViewArr objectAtIndex:indexPath.row];
//    CGFloat cellHeight = [self heightForString:@"草稿箱是用来存放暂时性的文件，待修改内容的编辑文件或存放草稿的地方。草稿箱有实际的和虚拟的，实物就是一个箱子，只是它的用途决定的。" fontSize:15.0 andWidth:SCREEN_WIDTH-40.0];
    CGFloat cellHeight = [self heightForString:myInfo.content fontSize:15.0 andWidth:SCREEN_WIDTH-90.0];
    if(cellHeight <= 40.0) {
        cellHeight = 40.0;
    }
    cellHeight += 65.0;
    return cellHeight;
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

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willBeginEditingRowAtIndexPath");
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didEndEditingRowAtIndexPath");
    [self updateBarBtnItem];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DraftInfo *info = (DraftInfo *)self.myTableViewArr[indexPath.row];
        [self deleteDrafts:[NSArray arrayWithObject:info]];
        [self.myTableViewArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row < self.myTableViewArr.count) {
        DraftInfo *tempInfo = (DraftInfo *)self.myTableViewArr[indexPath.row];
        if(tableView.editing) {
            DraftBoxTableViewCell *cell = (DraftBoxTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.mSelected = !cell.mSelected;
            tempInfo.isSelected = cell.mSelected;
            [self.myTableViewArr replaceObjectAtIndex:indexPath.row withObject:tempInfo];
            if (cell.mSelected) {
                [self.selectedIndexArr addObject:[NSNumber numberWithInteger:indexPath.row]];
            }else{
                [self.selectedIndexArr removeObject:[NSNumber numberWithInteger:indexPath.row]];
            }
        } else {
            //TODO -- 跳转到帖子页面
            PostViewController *postViewController = [[PostViewController alloc] init];
            postViewController.type = PostSourceTypeDraft;
            postViewController.draftInfo = tempInfo;
            [self.navigationController pushViewController:postViewController animated:YES];
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
        [tmpTableView registerClass:[DraftBoxTableViewCell class] forCellReuseIdentifier:kCellIdentifier_DraftBoxTableViewCell];
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [tmpTableView setTableFooterView:view];
        [self.view addSubview:(_myTableView = tmpTableView)];
    }
    return _myTableView;
}

- (UIBarButtonItem *)manageBarBtnItem {
    if (!_manageBarBtnItem) {
        _manageBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"管理"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(manageBarBtnAction)];
    }
    return _manageBarBtnItem;
}

- (UIBarButtonItem *)cancelBarBtnItem {
    if(!_cancelBarBtnItem) {
        _cancelBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarBtnAction)];
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
        [tempBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tempBtn setImage:[UIImage imageNamed:@"ic_message_off"] forState:UIControlStateNormal];
        [tempBtn setImage:[UIImage imageNamed:@"ic_message_on"] forState:UIControlStateHighlighted];
        [tempBtn setImage:[UIImage imageNamed:@"ic_message_on"] forState:UIControlStateSelected];
        [tempBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
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

- (NSMutableArray *)myTableViewArr {
    if (!_myTableViewArr) {
        _myTableViewArr = [NSMutableArray array];
    }
    return _myTableViewArr;
}

- (NSMutableArray *)selectedIndexArr {
    if (!_selectedIndexArr) {
        _selectedIndexArr = [NSMutableArray array];
    }
    return _selectedIndexArr;
}

@end
