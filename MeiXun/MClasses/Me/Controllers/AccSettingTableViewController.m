//
//  AccSettingTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/13.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "AccSettingTableViewController.h"

@interface AccSettingTableViewController ()

@end

@implementation AccSettingTableViewController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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

@end
