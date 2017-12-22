//
//  MsgListTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/9/2.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "MsgListTableViewController.h"
#import "MsgHeader.h"
#import "MeViewModel.h"
#import "UMsgCell.h"
#import "MsgDetailController.h"


#define    kReuseHeader  @"reuseHeader"
static NSString *UMsgCellID = @"UMsgCellID";



@interface MsgListTableViewController ()
@property (nonatomic,strong)NSArray *dataArray;

@end

@implementation MsgListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[MsgHeader class] forHeaderFooterViewReuseIdentifier:kReuseHeader];
    [self setupUI];
    [SVProgressHUD showWithStatus:@"加载数据中..."];
    NSString *userId = [MDataUtil shareInstance].accModel.userId;
    NSDictionary *params = @{kParamUserIdType:userId};
    [MeViewModel ReqMsgsWithParams:params result:^(ReqResultType status, id data) {
        [SVProgressHUD dismiss];
        if (status == ReqResultSuccType) {
            self.dataArray = data;
            [self.tableView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"msgDetailSegue"]) {
        MsgDetailController *destiController = segue.destinationViewController;
        destiController.msgInfo = sender;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - setup ui
- (void)setupUI
{
    // setup tableView cell
    UINib *alertCellNib = [UINib nibWithNibName:@"UMsgCell" bundle:nil];
    [self.tableView registerNib:alertCellNib forCellReuseIdentifier:UMsgCellID];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:UMsgCellID];
    id model = self.dataArray[indexPath.section];
    cell.msgModel = model;
    __weak typeof(self) weakSelf = self;
    cell.readAllBlock = ^(id msgData) {
        [weakSelf performSegueWithIdentifier:@"msgDetailSegue" sender:model];
    };
    return cell;
}


#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id model = self.dataArray[section];
    MsgHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kReuseHeader];
    [header setData:model];
    return header;
}
@end
