//
//  ChargeListTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/9/2.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "ChargeListTableViewController.h"
#import "MchargeListHeader.h"

#define    kReuseHeader  @"reuseHeader"

@interface ChargeListTableViewController ()

@end

@implementation ChargeListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[MchargeListHeader class] forHeaderFooterViewReuseIdentifier:kReuseHeader];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
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
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MchargeListHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kReuseHeader];
    [header setData:@"2017-06-19"];
    return header;
}
@end
