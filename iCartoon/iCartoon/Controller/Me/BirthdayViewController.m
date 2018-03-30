//
//  BirthdayViewController.m
//  iCartoon
//
//  Created by 寻梦者 on 16/1/14.
//  Copyright © 2016年 wonders. All rights reserved.
//

#import "BirthdayViewController.h"
#import "Context.h"

@interface BirthdayViewController ()

@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (strong, nonatomic) UITextField *birthdayTextField;

@end

@implementation BirthdayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = I_BACKGROUND_COLOR;
    self.navigationItem.title = @"出生年月";
    
    [self setBackNavgationItem];
    [self setBackNavgationItem];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TRANS_VALUE(40.0f), 44.0f)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, CONVER_VALUE(10.0f), 0, CONVER_VALUE(-10.0f))];
    
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:TRANS_VALUE(13)];
    [button addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = self.saveButton;

    
//    self.saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction)];
//    self.navigationItem.rightBarButtonItem = self.saveButton;
    
    [self createUI];
    [self loadData];

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
- (void)saveButtonAction {
    [Context sharedInstance].birthday = self.birthdayTextField.text;
    
    _block();
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dateChangedAction:(id)sender {
    NSDate *select = [self.datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr =  [dateFormatter stringFromDate:select];
    self.birthdayTextField.text = dateStr;
}

#pragma mark - Private Method
- (void)createUI {
    UILabel *birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(TRANS_VALUE(10.0f), 0, TRANS_VALUE(50.0f), TRANS_VALUE(40.0f))];
    birthdayLabel.font = [UIFont systemFontOfSize:TRANS_VALUE(15.0f)];
    birthdayLabel.textColor = I_COLOR_33BLACK;
    birthdayLabel.textAlignment = NSTextAlignmentLeft;
    birthdayLabel.text = @"日期";
    [self.view addSubview:birthdayLabel];
    
    self.birthdayTextField = [[UITextField alloc] initWithFrame:CGRectMake(TRANS_VALUE(60.0f), 0, SCREEN_WIDTH - TRANS_VALUE(70.0f), TRANS_VALUE(40.0f))];
    self.birthdayTextField.font = [UIFont systemFontOfSize:TRANS_VALUE(15.0f)];
    self.birthdayTextField.textColor = I_COLOR_DARKGRAY;
    self.birthdayTextField.textAlignment = NSTextAlignmentRight;
//    self.birthdayTextField.placeholder = @"请添加出生年月";
     self.birthdayTextField.placeholder =[Context sharedInstance].birthday;
    [self.view addSubview:self.birthdayTextField];
    [self.birthdayTextField setEnabled:NO];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - TRANS_VALUE(200.0f), SCREEN_WIDTH, TRANS_VALUE(200.0f))];
    self.datePicker.backgroundColor = [UIColor clearColor];
    self.datePicker.tintColor = I_COLOR_33BLACK;
    [self.view addSubview:self.datePicker];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    self.datePicker.locale = locale;
    
    [self.datePicker addTarget:self action:@selector(dateChangedAction:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)loadData {
//    if(self.birthday) {
//        self.birthdayTextField.text = self.birthday;
    self.birthdayTextField.text=[Context sharedInstance].birthday;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        NSDate *date = [dateFormatter dateFromString:self.birthday];
//    NSLog(@"22222%@",[Context sharedInstance].birthday);
        NSDate *date = [dateFormatter dateFromString:[Context sharedInstance].birthday];
        [self.datePicker setDate:date];
//    }
}

@end
