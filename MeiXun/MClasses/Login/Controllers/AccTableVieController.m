//
//  AccTableVieController.m
//  MeiXun
//
//  Created by taotao on 2017/8/11.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "AccTableVieController.h"
#import "LoginViewModel.h"

@interface AccTableVieController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accField;

@end

@implementation AccTableVieController
#pragma mark - override methods
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
    if([self validateFieldText]){
        [self reqVaidatePhoneRegisterState];
    }else{
        [SVProgressHUD showInfoWithStatus:@"手机号码格式错误"];
    }
}

#pragma mark - private methods
- (BOOL)validateFieldText
{
    NSString *accTxt = self.accField.text;
    if ([accTxt rightPhoneNumFormat] == NO) {
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - requset server
- (void)reqVaidatePhoneRegisterState
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *accTxt = self.accField.text;
    params[kParamMobile] = accTxt;
    [LoginViewModel ReqPhoneRegisterStateWithParams:params result:^(ReqResultType status, id data) {
        if (status == ReqResultSuccType) {
            MAccModel *accModel = [[MAccModel alloc] init];
            accModel.mobile = accTxt;
            [MDataUtil shareInstance].accModel = accModel;
            if ([data isEqualToString:@"1"]) {
                
                [self performSegueWithIdentifier:@"enterPwdSegue" sender:nil];
            }else{
                [self performSegueWithIdentifier:@"codeSegue" sender:nil];
            }
        }
    }];
}

#pragma mark - setup UI 
- (void)setupAccViewUI
{
    self.accField.leftViewMode = UITextFieldViewModeAlways;
    self.accField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
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
