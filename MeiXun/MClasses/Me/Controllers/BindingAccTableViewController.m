//
//  BindingAccTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/13.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "BindingAccTableViewController.h"
#import "MeViewModel.h"
#import "LoginViewModel.h"
#import "UIImage+Extension.h"

#define  kCountingNum               6

@interface BindingAccTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldAccField;
@property (weak, nonatomic) IBOutlet UITextField *bindingAccField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger count;

@end

@implementation BindingAccTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBaseUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopCountingTimer];
}

#pragma mark - setup UI 
- (void)setupBaseUI
{
    //selected state
    [self.codeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateSelected];
    [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    //normal state
    [self.codeBtn setBackgroundImage:[UIImage imageWithColor:MNavBarColor] forState:UIControlStateNormal];
    [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark - selectors
//request er code
- (IBAction)tapRequestCodeBtn:(UIButton*)sender {
    NSString *bindingAccTxt = self.bindingAccField.text;
    if ([self validatePhoneFormat:bindingAccTxt] == NO) {
        [SVProgressHUD showInfoWithStatus:@"新手机号格式错误"];
        return;
    }
    
    if (sender.selected == YES) {
        return;
    }else{
        sender.selected = YES;
        self.count = kCountingNum;
        NSString *beginStr = [NSString stringWithFormat:@"已发送(%dS)",kCountingNum];
        [self.codeBtn setTitle:beginStr forState:UIControlStateSelected];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startCounting) userInfo:nil repeats:YES];
        [self reqBindingValidateCode];
    }
}

- (IBAction)tapConfirmBtn:(id)sender {
    NSString *oldAccTxt = self.oldAccField.text;
    if ([self validatePhoneFormat:oldAccTxt] == NO) {
        [SVProgressHUD showInfoWithStatus:@"原账号格式错误"];
        return;
    }
    
    NSString *bindingAccTxt = self.bindingAccField.text;
    if ([self validatePhoneFormat:bindingAccTxt] == NO) {
        [SVProgressHUD showInfoWithStatus:@"新绑定账号格式错误"];
        return;
    }
    
    NSString *codeTxt = self.codeField.text;
    if(codeTxt.length <= 0){
        [SVProgressHUD showInfoWithStatus:@"输入验证码"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *token = [MDataUtil shareInstance].accModel.token;
    NSString *userId = [MDataUtil shareInstance].accModel.userId;
    params[kParamOldMobile] = oldAccTxt;
    params[kParamNewMobile] = bindingAccTxt;
    params[kParamVariCode] = codeTxt;
    params[kParamUserIdType] = userId;
    params[kParamTokenType] = token;
    [self submitServerWithParams:params];
}


#pragma mark - requset server
- (void)submitServerWithParams:(NSDictionary*)params
{
    [MeViewModel ReqRebindingWithParams:params result:^(ReqResultType status, id data) {
        if (status == ReqResultSuccType) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRebindingSuccessNotification object:nil];
        }
    }];
}

/**
 *请求验证码
 *0，注册  1，登录    2，修改手机号    3，忘记密码
 */
- (void)reqBindingValidateCode
{
    NSString *mobile = [MDataUtil shareInstance].accModel.mobile;
    NSDictionary *params = @{kParamMobile:mobile,kParamSendType:@"2"};
    [LoginViewModel ReqPhoneCodeWithParams:params result:^(ReqResultType status, id data) {
        if (status == ReqResultSuccType) {
            [SVProgressHUD showInfoWithStatus:@"请求验证码成功，请耐心等待"];
        }
    }];
}


#pragma mark - private methods
- (BOOL)validatePhoneFormat:(NSString*)phoneNum
{
    if ([phoneNum rightPhoneNumFormat] == NO) {
        return NO;
    }else{
        return YES;
    }
}

- (void)startCounting
{
    self.count = self.count - 1;
    if (self.count <= 0) {
        [self stopCountingTimer];
    }else{
        NSString *countStr = [NSString stringWithFormat:@"已发送(%ldS)",self.count];
        HTLog(@"counting Down str ====== %@",countStr);
        [self.codeBtn setTitle:countStr forState:UIControlStateSelected];
    }
}

- (void)stopCountingTimer
{
    self.codeBtn.selected = NO;
    NSString *txt = @"发送验证码";
    [self.codeBtn setTitle:txt forState:UIControlStateNormal];
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
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
