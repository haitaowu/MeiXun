//
//  ModifyPwdTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/13.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "ModifyPwdTableViewController.h"
#import "MeViewModel.h"

@interface ModifyPwdTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPwdField;
@property (weak, nonatomic) IBOutlet UITextField *updatePwdField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdField;

@end

@implementation ModifyPwdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - selectors
- (IBAction)tapConfirmBtn:(id)sender {
    NSString *oldTxt = self.oldPwdField.text;
    if ([oldTxt emptyStr] == YES) {
        [SVProgressHUD showInfoWithStatus:@"请输入原始密码"];
    }
    
    NSString *updatePwdTxt = self.updatePwdField.text;
    if ([updatePwdTxt emptyStr] == YES) {
        [SVProgressHUD showInfoWithStatus:@"请输入新密码"];
        return;
    }
    
    NSString *confirmPwdTxt = self.confirmPwdField.text;
    if ([confirmPwdTxt emptyStr] == YES) {
        [SVProgressHUD showInfoWithStatus:@"请输入确认密码"];
        return;
    }
    
    if ([updatePwdTxt isEqualToString:confirmPwdTxt] == NO) {
        [SVProgressHUD showInfoWithStatus:@"两次密码不一致"];
        return;
    }
    NSString *token = [MDataUtil shareInstance].accModel.token;
    NSString *userId = [MDataUtil shareInstance].accModel.userId;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *oldEncryptPwd = [MDataUtil encryptStringWithStr:oldTxt];
    NSString *updateEncryptPwd = [MDataUtil encryptStringWithStr:updatePwdTxt];
    params[kParamUserIdType] = userId;
    params[kParamOldPassword] = oldEncryptPwd;
    params[kParamNewPassword] = updateEncryptPwd;
    params[kParamClientType] = kParamClientTypeiOS;
    params[kParamTokenType] = token;
    [self reqModifyPwdWithParams:params];
}

#pragma mark - requset server
- (void)reqModifyPwdWithParams:(NSDictionary*)params
{
    [MeViewModel ReqModifyPwdWithParams:params result:^(ReqResultType status, id data) {
        if (status == ReqResultSuccType) {
            [SVProgressHUD showSuccessWithStatus:@"修改密码成功"];
            HTLog(@"modify pwd success ");
            [[NSNotificationCenter defaultCenter] postNotificationName:kModifyPwdSuccNotification object:nil];
        }
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
