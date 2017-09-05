//
//  SetPwdTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/9/5.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "SetPwdTableViewController.h"
#import "LoginViewModel.h"

@interface SetPwdTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *pwdAgainField;

@end

@implementation SetPwdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - selectors
- (IBAction)tapConfirmBtn:(id)sender {
    NSString *pwdTxt = self.pwdField.text;
    if ([pwdTxt emptyStr] == YES) {
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return;
    }
    
    NSString *pwdAgainTxt = self.pwdAgainField.text;
    if ([pwdAgainTxt emptyStr] == YES) {
        [SVProgressHUD showInfoWithStatus:@"请再次输入密码"];
        return;
    }
    
    if ([pwdAgainTxt isEqualToString:pwdTxt] == NO) {
        [SVProgressHUD showInfoWithStatus:@"两次输入密码不一致"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *encryptPwd = [MDataUtil encryptStringWithStr:pwdTxt];
    params[kParamVariCode] = self.variCode;
    params[kParamMobile] = [MDataUtil shareInstance].accModel.mobile;
    params[kParamPassword] = encryptPwd;
    params[kParamClientType] = kParamClientTypeiOS;
    
    if ([self.reqType isEqualToString:@"0"]) {
        HTLog(@"register new account params = %@",params);
        [self reqRegisterAccWith:params];
    }
    
    if ([self.reqType isEqualToString:@"3"]) {
        [self reqGetPwdBackWith:params];
    }
}

#pragma mark - requset server
//忘记密码 - 找回密码
- (void)reqGetPwdBackWith:(NSDictionary*)params
{
    [LoginViewModel ReqPwdBackWithParams:params result:^(ReqResultType status, id data) {
        HTLog(@"login data = %@",data);
        if (status == ReqResultSuccType) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            HTLog(@"get pwd back success");
        }
        //        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
    }];
}

//注册
- (void)reqRegisterAccWith:(NSDictionary*)params
{
    [LoginViewModel ReqRegisterWithParams:params result:^(ReqResultType status, id data) {
        HTLog(@"login data = %@",data);
        if (status == ReqResultSuccType) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            HTLog(@" register account success");
        }
        //        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
    }];
}


#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
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
