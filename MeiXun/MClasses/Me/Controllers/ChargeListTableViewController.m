//
//  ChargeListTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/9/2.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "ChargeListTableViewController.h"
#import "MchargeListHeader.h"
#import "MeViewModel.h"
#import "ChargeCell.h"



#define    kReuseHeader  @"reuseHeader"
static NSString *ChargeCellID = @"ChargeCellID";



@interface ChargeListTableViewController ()
@property (nonatomic,strong)NSArray *dataArray;

@end

@implementation ChargeListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[MchargeListHeader class] forHeaderFooterViewReuseIdentifier:kReuseHeader];
    [self setupUI];
    [SVProgressHUD showWithStatus:@"加载数据中..."];
    [MeViewModel ReqCharegeWithResult:^(ReqResultType status, id data) {
        [SVProgressHUD dismiss];
        if (status == ReqResultSuccType) {
            self.dataArray = data;
            [self.tableView reloadData];
        }
    }];
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
    UINib *alertCellNib = [UINib nibWithNibName:@"ChargeCell" bundle:nil];
    [self.tableView registerNib:alertCellNib forCellReuseIdentifier:ChargeCellID];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChargeCell *cell = [tableView dequeueReusableCellWithIdentifier:ChargeCellID];
    ChargeModel *model = self.dataArray[indexPath.section];
    cell.chargeModel = model;
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
    ChargeModel *model = self.dataArray[section];
    MchargeListHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kReuseHeader];
    [header setData:model];
    return header;
}
@end
