//
//  FeedbackTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/13.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "FeedbackTableViewController.h"
#import "MeViewModel.h"
#import "CustomTextView.h"



@interface FeedbackTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accField;
@property (weak, nonatomic) IBOutlet CustomTextView *contentTxtView;

@end

@implementation FeedbackTableViewController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentTxtView.placeholder = @"说点什么吧";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - selectors
- (IBAction)tapSubmitBtn:(id)sender {
    NSString *accTxt = self.accField.text;
    if ([accTxt emptyStr] == YES) {
        [SVProgressHUD showInfoWithStatus:@"请输入账号"];
    }
    
    NSString *contentTxt = self.contentTxtView.text;
    if ([contentTxt emptyStr] == YES) {
        [SVProgressHUD showInfoWithStatus:@"请输入你的意见"];
        return;
    }
    
    NSString *token = [MDataUtil shareInstance].accModel.token;
    NSString *userId = [MDataUtil shareInstance].accModel.userId;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kParamUserIdType] = userId;
    params[kParamTokenType] = token;
    params[kParamUserName] = accTxt;
    params[kParamFeedback] = contentTxt;
    [self submitUserFeedbackWithParams:params];
}

#pragma mark - requset server
- (void)submitUserFeedbackWithParams:(NSDictionary*)params
{
    [MeViewModel submitFeedBackWithParams:params result:^(ReqResultType status, id data) {
        if (status == ReqResultSuccType) {
            [SVProgressHUD showSuccessWithStatus:@"谢谢你的反馈"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
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
