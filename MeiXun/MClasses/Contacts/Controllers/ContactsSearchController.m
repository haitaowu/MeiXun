//
//  ContactsSearchController.m
//  MeiXun
//
//  Created by taotao on 2017/8/18.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "ContactsSearchController.h"
#import "ContactsCell.h"
#import "PersonModel.h"
#import "CallingViewController.h"


@interface ContactsSearchController ()
@property(nonatomic,strong) NSMutableArray *searchArray;
@property (nonatomic,copy) NSString *keyword;

@end

@implementation ContactsSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}


#pragma mark - setup ui
- (void)setupUI
{
    // setup tableView cell
//    UINib *alertCellNib = [UINib nibWithNibName:@"ContactsCell" bundle:nil];
//    [self.tableView registerNib:alertCellNib forCellReuseIdentifier:ContactsCellID];
}

#pragma mark - public methods
- (void)searchWithKeyword:(NSString*)keyword
{
    self.keyword = keyword;
    if(keyword.length <= 0){
        self.searchArray = nil;
        [self.tableView reloadData];
    }else{
        [self searchPersonsWithKeyword:keyword];
    }
}

#pragma mark - private methods
- (void)searchPersonsWithKeyword:(NSString*)keyword
{
    self.searchArray = [NSMutableArray array];
    NSArray *contacts = [[MDataUtil shareInstance] contacts];
    for (NSArray *array in contacts) {
        for (PersonModel *model in array) {
            if ((model.name != nil) && ([model.name containsString:keyword])) {
                [self.searchArray addObject:model];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    PersonModel *model = self.searchArray[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;

}

#pragma mark - UITableView --- Table view  delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PersonModel *model = self.searchArray[indexPath.row];
    if (self.selectedPersonBlock != nil) {
        self.selectedPersonBlock(model);
    }
}


@end
