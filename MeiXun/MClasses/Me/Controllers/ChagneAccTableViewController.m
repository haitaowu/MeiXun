//
//  ChagneAccTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/13.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "ChagneAccTableViewController.h"
#import "LoginViewModel.h"

@interface ChagneAccTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@end

@implementation ChagneAccTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - selectors
- (IBAction)tapNextBtn:(id)sender {
    [self.view endEditing:YES];
    NSString *pwdTxt = self.pwdField.text;
    if ([pwdTxt emptyStr] == YES) {
        [SVProgressHUD showInfoWithStatus:@"请输入登录密码"];
    }
    
    NSString *accTxt = self.accField.text;
    if ([accTxt rightPhoneNumFormat] == NO) {
        [SVProgressHUD showInfoWithStatus:@"手机号码格式错误"];
        return;
    }
    
    [self reqLoginAccWithPwd:pwdTxt phone:@"phone"];
}

#pragma mark - requset server
- (void)reqLoginAccWithPwd:(NSString*)pwdTxt phone:(NSString*)phone
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *encryptPwd = [MDataUtil encryptStringWithStr:pwdTxt];
    params[kParamUserName] = phone;
    params[kParamPassword] = encryptPwd;
    params[kParamClientType] = kParamClientTypeiOS;
    [LoginViewModel ReqLoginWithParams:params result:^(ReqResultType status, id data) {
        HTLog(@"login data = %@",data);
        //        [MDataUtil shareInstance].accModel = data;
        [[MDataUtil shareInstance] archiveAccModel:data];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
    }];
}


#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }else{
        return 20;
    }
}

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
