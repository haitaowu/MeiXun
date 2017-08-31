//
//  EnterPwdTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/11.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "EnterPwdTableViewController.h"
#import "LoginViewModel.h"


@interface EnterPwdTableViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UILabel *accLabel;

@end

@implementation EnterPwdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAccViewUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - selectors
- (IBAction)tapNextBtn:(id)sender {
    [self.view endEditing:YES];
    NSString *pwdTxt = self.pwdField.text;
    if ([pwdTxt emptyStr] == YES) {
        [SVProgressHUD showInfoWithStatus:@"请输入登录密码"];
    }else{
        [self reqLoginAccWithPwd:pwdTxt];
    }
    
//    [self performSegueWithIdentifier:@"codeSegue" sender:nil];
//    [self performSegueWithIdentifier:@"enterPwdSegue" sender:nil];
}

- (IBAction)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - requset server
- (void)reqLoginAccWithPwd:(NSString*)pwdTxt
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *encryptPwd = [MDataUtil encryptStringWithStr:pwdTxt];
    params[kParamUserName] = [MDataUtil shareInstance].accModel.mobile;
    params[kParamPassword] = encryptPwd;
    params[kParamClientType] = kParamClientTypeiOS;
    [LoginViewModel ReqLoginWithParams:params result:^(ReqResultType status, id data) {
        HTLog(@"login data = %@",data);
//        [MDataUtil shareInstance].accModel = data;
        [[MDataUtil shareInstance] archiveAccModel:data];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
    }];
}

#pragma mark - setup UI 
- (void)setupAccViewUI
{
    self.pwdField.leftViewMode = UITextFieldViewModeAlways;
    self.pwdField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    
    MAccModel *accModel = [MDataUtil shareInstance].accModel;
    NSString *desTxt = self.accLabel.text;
    desTxt = [NSString stringWithFormat:@"%@%@",accModel.mobile,desTxt];
    self.accLabel.text = desTxt;
    
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

#pragma mark - UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
