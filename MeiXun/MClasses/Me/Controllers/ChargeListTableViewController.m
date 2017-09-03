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

#define    kReuseHeader  @"reuseHeader"

@interface ChargeListTableViewController ()
@property (nonatomic,strong)NSArray *dataArray;

@end

@implementation ChargeListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[MchargeListHeader class] forHeaderFooterViewReuseIdentifier:kReuseHeader];
    
    [MeViewModel ReqCharegeWithResult:^(ReqResultType status, id data) {
        if (status == ReqResultSuccType) {
            self.dataArray = data;
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
