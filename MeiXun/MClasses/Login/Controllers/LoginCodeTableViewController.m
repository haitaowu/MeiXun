//
//  LoginCodeTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/12.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "LoginCodeTableViewController.h"
#import "LoginViewModel.h"

#define  kCountingNum               6

@interface LoginCodeTableViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *enterLabels;
@property (weak, nonatomic) IBOutlet UITextField *enterField;
@property (weak, nonatomic) IBOutlet UIView *againEnterView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *reqCodeBtn;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger count;

@end

@implementation LoginCodeTableViewController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = kCountingNum;
    [self setupViewUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopCountingTimer];
}

#pragma mark - selectors
//提交验证码
- (IBAction)tapSubmitBtn:(id)sender {
    HTLog(@"sumit ");
    [self performSegueWithIdentifier:@"pwdSegue" sender:nil];
}

//发送验证码
- (IBAction)tapCodeBtn:(id)sender {
    HTLog(@"get code btn clicked ");
    self.countLabel.hidden = NO;
    self.reqCodeBtn.hidden = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startCountingDown) userInfo:nil repeats:YES];
    [self reqValidateCode];
}

//再次发送验证码
- (IBAction)tapReCodeBtn:(id)sender {
    HTLog(@"reget code btn clicked ");
}

- (void)startCountingDown
{
    self.count = self.count - 1;
    if (self.count <= 0) {
        [self stopCountingTimer];
    }else{
        NSString *countStr = [NSString stringWithFormat:@"%ldS",self.count];
        HTLog(@"counting Down str ====== %@",countStr);
        [self.countLabel setText:countStr];
    }
}

#pragma mark - private methods
- (void)stopCountingTimer
{
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.againEnterView.hidden = NO;
    self.countLabel.hidden = YES;
}

#pragma mark - setup UI 
- (void)setupViewUI
{
    self.againEnterView.hidden = YES;
    self.countLabel.hidden = YES;
    self.reqCodeBtn.hidden = NO;
    
    for (UILabel *label in self.enterLabels) {
        label.layer.borderWidth = 1;
        label.layer.borderColor = [UIColor grayColor].CGColor;
    }
    [self.enterField addTarget:self action:@selector(txtStrDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - selectors
- (IBAction)tapEnterBtn:(id)sender {
    [self.enterField becomeFirstResponder];
}

- (void)txtStrDidChange:(UITextField*)sender
{
    NSString *txt = sender.text;
    if (txt.length > 4) {
        NSRange range = NSMakeRange(0, 4);
        txt = [txt substringWithRange:range];
        sender.text = txt;
    }
    
    [self.enterLabels enumerateObjectsUsingBlock:^(UILabel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < txt.length) {
            NSString *str = [NSString stringWithFormat:@"%c",[txt characterAtIndex:idx]];
            obj.text = str;
        }else{
            obj.text = @"";
        }
    }];
    HTLog(@"textField text = %@",sender.text);
}

#pragma mark - requset server
/**
 *请求验证码
 *0，注册  1，登录    2，修改手机号    3，忘记密码
 */
- (void)reqValidateCode
{
    NSString *mobile = [MDataUtil shareInstance].accModel.mobile;
    NSDictionary *params = @{kParamMobile:mobile,kParamSendType:@"0"};
    [LoginViewModel ReqPhoneCodeWithParams:params result:^(ReqResultType status, id data) {
        if (status == ReqResultSuccType) {
            [SVProgressHUD showInfoWithStatus:@"请求验证码成功，请耐心等待"];
        }
    }];
}
#pragma mark - UIScrollView delegate 
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    HTLog(@"text = %@ replaceStr = %@ range = %@",textField.text,string,range.location);
    return YES;
}
#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
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
