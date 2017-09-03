//
//  MeTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/13.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "MeTableViewController.h"
#import "MeViewModel.h"

@interface MeTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *leftMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *netAgeLabel;

@end

@implementation MeTableViewController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self reqUserInfo];
}

#pragma mark - requset server
- (void)reqUserInfo
{
    NSString *token = [MDataUtil shareInstance].accModel.token;
    NSString *userId = [MDataUtil shareInstance].accModel.userId;
    NSDictionary *params = @{kParamTokenType:token,kParamUserIdType:userId};
    [MeViewModel ReqUserInfoWithParams:params result:^(ReqResultType status, id data) {
        if (status == ReqResultSuccType) {
            HTLog(@"user info = %@",data);
            [self setupUIWithData:data];
        }
    }];
}

#pragma mark - setup UI 
- (void)setupUIWithData:(MAccModel*)accModel
{
    
    NSString *netStr = [NSString stringWithFormat:@"%@",accModel.netAge];
    self.netAgeLabel.text = netStr;

    CGFloat balance = [accModel.balance floatValue];
    NSString *balanceStr = [NSString stringWithFormat:@"%.2f美讯卡",balance];
    self.leftMoneyLabel.text = balanceStr;
}


#pragma mark - UITableView --- Table view  delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }else{
        return 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}


@end
