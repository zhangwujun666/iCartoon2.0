//
//  EditInfoViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 15/12/20.
//  Copyright © 2015年 wonders. All rights reserved.
//

#import "EditInfoViewController.h"
#import "NickNameViewController.h"
#import "SignatureViewController.h"
#import "BirthdayViewController.h"
#import "Context.h"
#import "CommonUtils.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <TSMessages/TSMessage.h>
#import "UserAPIRequest.h"
#import "UIImageView+Webcache.h"
#import "AttentionView.h"

#import "BloodTypeView.h"
#import "CCActionSheet.h"  //血型选择器
#import "GenderView.h"   //性别选择器


@interface EditInfoViewController () <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate ,CCActionSheetDelegate, GenderViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (assign, nonatomic) BOOL viewPoped;

@property (strong, nonatomic) UIImage *avatarImage;
@property (strong, nonatomic) NSString *sexIndex;
@property (strong, nonatomic) NSString *bloodTypeIndex;

@property (assign,nonatomic)  BOOL save;//页面出现前 判断是否是从我的窝传过来
@property (nonatomic,strong) UIImageView *avatarImageView;

@property (nonatomic,strong) NSString *isfreeze;
@property (nonatomic,strong) NSString *thaw_date;
@property (nonatomic,strong) NSString *thaw_time;
@property (nonatomic,strong)NSString * isshow;
@property (nonatomic,strong)NSString * isshowfree;

@end

@implementation EditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _save = NO;
    // Do any additional setup after loading the view.
    NSString *isfreeze = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfreeze"];
    NSString *thaw_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_date"];
    NSString *thaw_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"thaw_time"];
    NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"];
    
    //    NSLog(@"%@------%@-----%@",isfreeze,thaw_time,thaw_date);
    self.isfreeze = isfreeze;
    self.thaw_date = thaw_date;
    self.thaw_time = thaw_time;
    self.isshow = isshow;

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"编辑资料";
    [self setBackNavgationItem];
    [self createUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    
     [self  saveInfoAction];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [self  saveInfoAction];
}

- (void)viewDidDisappear:(BOOL)animated{
    
     [super viewDidDisappear:animated];
    
    [self  saveInfoAction];
    
}

#pragma mark - Action 
- (void)avatarTapAction {
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

    //TODO -- 修改头像
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    actionSheet.tag = 10001;
    [actionSheet showInView:self.view];
}
+ (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}
- (void)saveInfoAction {
    //TODO -- 保存用户信息
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if(self.avatarImage) {
        NSData *imgData = UIImageJPEGRepresentation(self.avatarImage, 0.25);
        NSString *base64Str = [imgData base64EncodedStringWithOptions:0];
        NSString *imageStr = [NSString stringWithFormat:@"data:image/jpeg;base64,%@", base64Str];
       [params setObject:imageStr forKey:@"base64Avatar"];
    }
    NSString *nickname = [Context sharedInstance].nickname;
    BOOL emjon = [EditInfoViewController stringContainsEmoji:nickname];
    if (emjon) {
        AttentionView * attention = [[AttentionView alloc]initTitle:@"昵称不能有表情符号！"];
        [self.view addSubview:attention];
        return;
    }
    if(nickname) {
        [params setObject:nickname forKey:@"nickName"];
    }
    NSString *signature = [Context sharedInstance].signature;
    if(signature) {
        [params setObject:signature forKey:@"signature"];
    }
    NSString *birthday = [Context sharedInstance].birthday;
    if(birthday) {
        [params setObject:birthday forKey:@"birthday"];
    }
    
    if(self.sexIndex) {
        [params setObject:self.sexIndex forKey:@"gender"];
    }
    if(self.bloodTypeIndex) {
        NSString *bloodType = @"未知";
        if(!self.bloodTypeIndex) {
            bloodType = @"未知";
        } else if ([self.bloodTypeIndex isEqualToString:@"1"]) {
            bloodType = @"A";
        } else if ([self.bloodTypeIndex isEqualToString:@"2"]) {
            bloodType = @"B";
        } else if ([self.bloodTypeIndex isEqualToString:@"3"]) {
            bloodType = @"O";
        } else if ([self.bloodTypeIndex isEqualToString:@"4"]) {
            bloodType = @"AB";
        } else if ([self.bloodTypeIndex isEqualToString:@"5"]) {
            bloodType = @"AK";
        }
        [params setObject:bloodType forKey:@"bloodType"];
    }
    [[UserAPIRequest sharedInstance] updateUserInfo:params success:^(CommonInfo *resultInfo) {
//        NSLog(@"-----------%@",resultInfo.message);
        if(resultInfo && [resultInfo isSuccess]) {
            [self loadUserInfo];
            
            if (_save) {
                
                [self saveSuc];
            }

        } else {
            AttentionView * attention = [[AttentionView alloc]initTitle:@"保存失败！" andtitle2:@""];
            attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
            attention.label1.frame=CGRectMake(5, 15, 220, 40);
            UIWindow * window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:attention];
        }
    } failure:^(NSError *error) {
        [self loadUserInfo];
        AttentionView * attention = [[AttentionView alloc]initTitle:[NSString stringWithFormat:@"%@",error.localizedDescription] andtitle2:@""];
        attention.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-115, [UIScreen mainScreen].bounds.size.height/2-150, 230, 70);
        attention.label1.frame=CGRectMake(5, 15, 220, 40);
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:attention];
    }];
}
- (void)loadUserInfo {
    NSDictionary *params = @{};
    if(![Context sharedInstance].token) {
        [Context sharedInstance].userInfo = nil;
        [self.tableView reloadData];
        return;
    }

    [[UserAPIRequest sharedInstance] getUserInfo:params success:^(UserInfo *userInfo) {
        if(userInfo) {
            [Context sharedInstance].userInfo = userInfo;
        } else {
            [Context sharedInstance].userInfo = nil;
        }
        UserInfo *tmpUserInfo = [Context sharedInstance].userInfo;
        if(tmpUserInfo) {
            [Context sharedInstance].nickname = tmpUserInfo.nickname;
            [Context sharedInstance].signature = tmpUserInfo.signature;
            if([tmpUserInfo.bloodType.uppercaseString isEqualToString:@"A"]) {
                self.bloodTypeIndex = @"1";
            } else if([tmpUserInfo.bloodType.uppercaseString isEqualToString:@"B"]) {
                self.bloodTypeIndex = @"2";
            } else if([tmpUserInfo.bloodType.uppercaseString isEqualToString:@"O"]) {
                self.bloodTypeIndex = @"3";
            } else if([tmpUserInfo.bloodType.uppercaseString isEqualToString:@"AB"]) {
                self.bloodTypeIndex = @"4";
            } else if([tmpUserInfo.bloodType.uppercaseString isEqualToString:@"AK"]) {
                self.bloodTypeIndex = @"5";
            }
            NSString *birthdayStr = tmpUserInfo.birthday;
            if(tmpUserInfo.birthday.length >= 10) {
                birthdayStr = [birthdayStr substringWithRange:NSMakeRange(0, 10)];
            }
            [Context sharedInstance].birthday = birthdayStr;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Context sharedInstance].userInfo = nil;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
}


-(void)saveSuc{
    AttentionView * attention = [[AttentionView alloc]initTitle:@"保存成功！"];

    [self.view addSubview:attention];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 1;
    } else {
        return 6;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return TRANS_VALUE(96.0f);
    } else {
        return TRANS_VALUE(48.0f);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return 0.0f;
    } else {
        return TRANS_VALUE(6.0f);
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0f;
    if(section == 1) {
        height = TRANS_VALUE(6.0f);
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    view.backgroundColor = RGBCOLOR(247, 247, 247);
    if(height > 0.0f) {
        UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 0.5f, SCREEN_WIDTH, 0.5f)];
        dividerView.backgroundColor = I_DIVIDER_COLOR;
        [view addSubview:dividerView];
    }
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        UITableViewCell *cell = [self userAvatarCellWithTableView:tableView];
        UILabel *titleLabel = (UILabel *)[cell.contentView.subviews objectAtIndex:0];
//          UIImageView *avatarImageBackView = (UIImageView *)[cell.contentView.subviews objectAtIndex:1];
        if (!self.avatarImageView) {
             self.avatarImageView = (UIImageView *)[cell.contentView.subviews objectAtIndex:2];
        }
        titleLabel.text = @"头像";
        titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
//        avatarImageView.image = [UIImage imageNamed:@"ic_avatar_default"];
        _avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapAction)];
        [_avatarImageView addGestureRecognizer:avatarTap];
        if(self.avatarImage) {
            _avatarImageView.image = self.avatarImage;
        } else {
            if([Context sharedInstance].userInfo.avatar) {
                [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[Context sharedInstance].userInfo.avatar] placeholderImage:[UIImage imageNamed:@"ic_avatar_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image) {
                        self.avatarImage = image;
                    }
                }];
            }
        }
        return cell;
    } else {
        UITableViewCell *cell = [self userInfoCellWithTableView:tableView];
        UILabel *titleLabel = (UILabel *)[cell.contentView.subviews objectAtIndex:0];
        UILabel *infoTextField = (UILabel *)[cell.contentView.subviews objectAtIndex:1];
        if(indexPath.row == 0) {
        UILabel * infoLabel = (UILabel *)[cell.contentView.subviews objectAtIndex:1];
            titleLabel.text = @"昵称";
            titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
            infoTextField.textColor = [UIColor darkTextColor];
            if([Context sharedInstance].nickname) {
                infoLabel.text = [Context sharedInstance].nickname;
                infoLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
                infoLabel.adjustsFontSizeToFitWidth=YES;
                infoLabel.textColor = [UIColor blackColor];
            } else {
                infoTextField.text = @"";
            }
        } else if(indexPath.row == 1) {
            UILabel * signLabel = (UILabel *)[cell.contentView.subviews objectAtIndex:1];
            titleLabel.text = @"签名";
            titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
            infoTextField.textColor = [UIColor darkTextColor];
            if([Context sharedInstance].signature) {
                signLabel.text = [Context sharedInstance].signature;
               signLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
                signLabel.numberOfLines = 0;
                signLabel.textColor = [UIColor blackColor];
               // signLabel.adjustsFontSizeToFitWidth = YES;
            
            } else {
                infoTextField.text = @"";
            }
        } else if(indexPath.row == 2) {
            titleLabel.text = @"性别";
            titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
            infoTextField.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
            
            //infoTextField.textColor = [UIColor darkTextColor];
            
            if(self.sexIndex != nil && [self.sexIndex isEqualToString:@"1"]) {
                infoTextField.text = @"女";
            } else {
                infoTextField.text = @"男";
            }
        } else if(indexPath.row == 3) {
            titleLabel.text = @"血型";
            titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
           // infoTextField.placeholder = @"A、B、O、AB？";
           // infoTextField.textColor = [UIColor darkTextColor];
            infoTextField.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
            if(!self.bloodTypeIndex) {
                infoTextField.text = @"A型";
                self.bloodTypeIndex=@"1";
            } else if ([self.bloodTypeIndex isEqualToString:@"1"]) {
                infoTextField.text = @"A型";
            } else if ([self.bloodTypeIndex isEqualToString:@"2"]) {
                infoTextField.text = @"B型";
            } else if ([self.bloodTypeIndex isEqualToString:@"3"]) {
                infoTextField.text = @"O型";
            } else if ([self.bloodTypeIndex isEqualToString:@"4"]) {
                infoTextField.text = @"AB型";
            }
        } else if(indexPath.row == 4) {
            titleLabel.text = @"生日";
            infoTextField.text = @"1990-01-01";
            titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
            infoTextField.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
            infoTextField.textColor = [UIColor darkTextColor];
            if([Context sharedInstance].birthday) {
                infoTextField.text = [Context sharedInstance].birthday;
            } else {
                infoTextField.text = @"1990-01-01";
                [Context sharedInstance].birthday = infoTextField.text;
            }
        } else {
            titleLabel.text = @"星座";
            infoTextField.text = @"摩羯座";
            titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
            infoTextField.font = [UIFont systemFontOfSize:TRANS_VALUE(14.0f)];
            if([Context sharedInstance].constellation) {
                infoTextField.text = [Context sharedInstance].constellation;
            } else {
                infoTextField.text = @"摩羯座";
            }
            infoTextField.textColor = [UIColor darkTextColor];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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

    if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            NickNameViewController *nicknameViewController = [[NickNameViewController alloc] init];
            nicknameViewController.nickname = [Context sharedInstance].nickname;
            
            nicknameViewController.block =^(){
                
                 _save = YES;
                [self   saveInfoAction];
            };
            [self.navigationController pushViewController:nicknameViewController animated:YES];
        } else if(indexPath.row == 1) {
            SignatureViewController *signatureViewController = [[SignatureViewController alloc] init];
            signatureViewController.signature = [Context sharedInstance].signature;
            
            signatureViewController.block= ^(){
                
                _save = YES;
                [self   saveInfoAction];
                
            };
 
            [self.navigationController pushViewController:signatureViewController animated:YES];
        } else if(indexPath.row == 2) {
    NSArray *array = @[@"性别",@"女",@"男"];
            
    NSInteger  index = [self.sexIndex integerValue];
            
    [[GenderView shareSheet]  gender_actionSheetWithSelectArray:array cancelTitle:@"取消" selectIndex:index delegate:self];
            
        } else if(indexPath.row == 3) {
            
            NSArray *array = @[@"血型",@"A型",@"B型",@"O型",@"AB型"];
            
             NSInteger  index = [self.bloodTypeIndex  integerValue];
            
               [[CCActionSheet shareSheet]  cc_actionSheetWithSelectArray:array cancelTitle:@"取消" selectIndex:index delegate:self];
                    } else if(indexPath.row == 4) {
            BirthdayViewController *birthdayViewController = [[BirthdayViewController alloc] init];
                        
                        birthdayViewController.block = ^(){
                            _save=YES;
                            [self  saveInfoAction];
   
                        };
                        
            [self.navigationController pushViewController:birthdayViewController animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    } else {
        if(indexPath.row < 6) {
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
    }
    
}


- (void)cc_actionSheetDidSelectedIndex:(NSInteger)index AndCCActionSheet:(CCActionSheet *)sheet{

    if(index == 1) {
        self.bloodTypeIndex = @"1";
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self saveSuc];
    } else if(index == 2) {
        self.bloodTypeIndex = @"2";
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self saveSuc];
    } else if(index == 3) {
        self.bloodTypeIndex = @"3";
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self saveSuc];
    } else if(index == 4) {
        self.bloodTypeIndex = @"4";
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self saveSuc];
    } else {
        //self.bloodTypeIndex = nil;
    }

}

#pragma mark -- 性别的选择器
- (void)gender_actionSheetDidSelectedIndex:(NSInteger)index  AndCCActionSheet:(GenderView *)sheet{
    
    if(index == 1) {
        self.sexIndex = @"1";
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self saveSuc];
    } else if(index == 2) {
        self.sexIndex = @"2";
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self saveSuc];
    } else {
//        self.sexIndex = @"2";
    }
 
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSInteger tag = actionSheet.tag;
    if(tag == 10001) {
        //修改头像
        //从界面，从上往下看，依次为0,1,2
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        if (buttonIndex == 0) {
            //拍照
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"系统相机不可用!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                return;
            }
        } else if(buttonIndex == 1) {
            //系统相册
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else {
            return;
        }
        imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePickerController.sourceType];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:imagePickerController animated:YES completion:nil];
            
        });
        
    } else if(tag == 10002) {
        
        if(buttonIndex == 0) {
            self.sexIndex = @"1";
             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if(buttonIndex == 1) {
            self.sexIndex = @"2";
             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            self.sexIndex = @"1";
        }
       

    }else if(tag == 10004) {
//        NSLog(@"buttonIndex = %ld",(long)buttonIndex);
        if(buttonIndex == 0) {
            self.sexIndex = @"2";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if(buttonIndex == 1) {
            self.sexIndex = @"1";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            self.sexIndex = @"2";
        }
        
    }  else if(tag == 10003) {
        if(buttonIndex == 0) {
            self.bloodTypeIndex = @"1";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if(buttonIndex == 1) {
            self.bloodTypeIndex = @"2";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if(buttonIndex == 2) {
            self.bloodTypeIndex = @"3";
             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if(buttonIndex == 3) {
              self.bloodTypeIndex = @"4";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
           // self.bloodTypeIndex = nil;
            
        }

    }else if(tag == 10005) {
        if(buttonIndex == 0) {
            self.bloodTypeIndex = @"2";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if(buttonIndex == 1) {
            self.bloodTypeIndex = @"1";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if(buttonIndex == 2) {
            self.bloodTypeIndex = @"3";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if(buttonIndex == 3) {
            self.bloodTypeIndex = @"4";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            //self.bloodTypeIndex = nil;
        }
        
    }else if(tag == 10006) {
        if(buttonIndex == 0) {
            self.bloodTypeIndex = @"3";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if(buttonIndex == 1) {
            self.bloodTypeIndex = @"1";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if(buttonIndex == 2) {
            self.bloodTypeIndex = @"2";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if(buttonIndex == 3) {
            self.bloodTypeIndex = @"4";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }  else {
           // self.bloodTypeIndex = nil;
        }
        
    }else if(tag == 10007) {
        if(buttonIndex == 0) {
            self.bloodTypeIndex = @"4";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if(buttonIndex == 1) {
            self.bloodTypeIndex = @"1";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if(buttonIndex == 2) {
            self.bloodTypeIndex = @"2";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if(buttonIndex == 3) {
            self.bloodTypeIndex = @"3";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else {
           // self.bloodTypeIndex = nil;
        }
        
   
        
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if(image) {
        self.avatarImage = [CommonUtils fixedOrientationImage:image];
        [self saveInfoAction];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

#pragma mark - UITableViewCell初始化函数
- (UITableViewCell *)userAvatarCellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"userAvatarTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(24.0f), TRANS_VALUE(55.0f), TRANS_VALUE(48.0f))];
        titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(16.0f)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"头像";
        titleLabel.textColor = [UIColor darkTextColor];
        [cell.contentView addSubview:titleLabel];
        UIImageView *avatarImageBackView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(59.0f), TRANS_VALUE(10.0f), TRANS_VALUE(76.0f), TRANS_VALUE(76.0f))];
        avatarImageBackView.clipsToBounds = YES;
        avatarImageBackView.layer.cornerRadius = avatarImageBackView.frame.size.width / 2;
        avatarImageBackView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        avatarImageBackView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:avatarImageBackView];
        if (!self.avatarImageView) {
             self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TRANS_VALUE(62.0f), TRANS_VALUE(13.0f), TRANS_VALUE(70.0f), TRANS_VALUE(70.0f))];
        }
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.width / 2;
        _avatarImageView.backgroundColor = [UIColor lightGrayColor];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:_avatarImageView];
        UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, TRANS_VALUE(96.0f) - 0.5f, SCREEN_WIDTH, 0.5f)];
        dividerView.backgroundColor = I_DIVIDER_COLOR;
        [cell.contentView addSubview:dividerView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (UITableViewCell *)userInfoCellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"userInfoTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(55.0f), TRANS_VALUE(48.0f))];
        titleLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(16.0f)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"头像";
        titleLabel.textColor = [UIColor darkTextColor];
        [cell.contentView addSubview:titleLabel];
        
//        UITextField *infoTextField = [[UITextField alloc] initWithFrame:CGRectMake(TRANS_VALUE(62.0f), TRANS_VALUE(9.0f), TRANS_VALUE(240.0f), TRANS_VALUE(30.0f))];
//        infoTextField.font = [UIFont systemFontOfSize:TRANS_VALUE(16.0f)];
//        //infoTextField.textColor = [UIColor darkTextColor];
//        infoTextField.enabled = NO;
//       // infoTextField.backgroundColor = [UIColor redColor];
//        [cell.contentView addSubview:infoTextField];
        
        
        
        
        UILabel *infoTextField = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(62.0f), TRANS_VALUE(4.0f), TRANS_VALUE(225.0f), TRANS_VALUE(40.0f))];
        infoTextField.font = [UIFont systemFontOfSize:TRANS_VALUE(16.0f)];
          [cell.contentView addSubview:infoTextField];
        
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - Private Method
- (void)loadData {
    //加载数据
    UserInfo *userInfo = [Context sharedInstance].userInfo;
    if(userInfo) {
        [Context sharedInstance].nickname = userInfo.nickname;
        [Context sharedInstance].signature = userInfo.signature;
        if([userInfo.bloodType.uppercaseString isEqualToString:@"A"]) {
            self.bloodTypeIndex = @"1";
        } else if([userInfo.bloodType.uppercaseString isEqualToString:@"B"]) {
            self.bloodTypeIndex = @"2";
        } else if([userInfo.bloodType.uppercaseString isEqualToString:@"O"]) {
            self.bloodTypeIndex = @"3";
        } else if([userInfo.bloodType.uppercaseString isEqualToString:@"AB"]) {
            self.bloodTypeIndex = @"4";
        } else if([userInfo.bloodType.uppercaseString isEqualToString:@"AK"]) {
            self.bloodTypeIndex = @"5";
        }
        [Context sharedInstance].birthday = userInfo.birthday;
        if([userInfo.gender isEqualToString:@"1"]) {
            self.sexIndex = @"1";
        } else {
            self.sexIndex = @"2";
        }
        [self.tableView reloadData];
    } else {
        [self loadUserInfo];
    }
}

- (void)createUI {
    //实例化表单控件
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = I_DIVIDER_COLOR;
    self.tableView.backgroundColor = I_BACKGROUND_COLOR;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TRANS_VALUE(0.0f))];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //设置tableview分割线
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}



@end
