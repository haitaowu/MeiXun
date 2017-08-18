//
//  ContactsTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/18.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "ContactsCell.h"
#import "PersonModel.h"

static NSString *ContactsCellID = @"ContactsCellID";

@interface ContactsTableViewController ()

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - setup ui
- (void)setupUI
{
    // setup tableView cell
    UINib *alertCellNib = [UINib nibWithNibName:@"ContactsCell" bundle:nil];
    [self.tableView registerNib:alertCellNib forCellReuseIdentifier:ContactsCellID];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[MDataUtil shareInstance] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *contacts = [[[MDataUtil shareInstance] contacts] objectAtIndex:section];
    return [contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactsCellID];
    NSArray *contacts = [[[MDataUtil shareInstance] contacts] objectAtIndex:indexPath.section];
    PersonModel *model = contacts[indexPath.row];
    cell.personModel = model;
//    __block typeof(self) blockSelf = self;
//    cell.cellBlock = ^(id vaccine) {
//        [blockSelf performSegueWithIdentifier:@"vaccineDetailSegue" sender:data];
//    };
    
    return cell;

}


#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    VaccineHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
//    id sectionData = [self.dataArray objectAtIndex:section];
//    NSString *title = [sectionData objectForKey:kVaccineTitleKey];
//    [header headerTitle:title];
//    return header;
//}


@end
