//
//  ContactsTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/18.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "ContactsSearchController.h"
#import "ContactsCell.h"
#import "PersonModel.h"
#import "CallingViewController.h"

static NSString *ContactsCellID = @"ContactsCellID";

@interface ContactsTableViewController ()<UIActionSheetDelegate,UISearchBarDelegate>
@property (nonatomic,strong)PersonModel *selectedPerson;
@property (nonatomic,strong)CallingViewController *callController;
@property (nonatomic,strong)UISearchController *searchControl;
@property (nonatomic,strong)ContactsSearchController *resultController;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [MDataUtil shareInstance].reloadContactBlock = ^{
        NSLog(@"reload finished ");
        [self.tableView reloadData];
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MDataUtil shareInstance] shouldSynchronizeAddressBookToLocalContacts];
}


#pragma mark - setup ui
- (void)setupUI
{
    // setup tableView cell
    UINib *alertCellNib = [UINib nibWithNibName:@"ContactsCell" bundle:nil];
    [self.tableView registerNib:alertCellNib forCellReuseIdentifier:ContactsCellID];
    
    __block typeof(self) blockSelf = self;
    ContactsSearchController *resultController = [[ContactsSearchController alloc] init];
    resultController.selectedPersonBlock = ^(PersonModel *model) {
        [blockSelf showContactPhoneNumbersWithPerson:model];
    };
    self.definesPresentationContext = true;
    self.resultController = resultController;
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:resultController];
    //取消字 颜色
//    searchController.searchBar.tintColor = kMainBackgroundColor;
    searchController.searchBar.placeholder = @"输入关键字搜索";
    // 颜色
    //    searchController.searchBar.barTintColor = kMainBackgroundColor;
    self.searchControl = searchController;
//    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [barItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    self.searchControl.searchBar.delegate = self;
    [searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = searchController.searchBar;
    
}

#pragma mark - private methods
- (void)showContactPhoneNumbersWithPerson:(PersonModel*)personModel
{
    self.selectedPerson = personModel;
    NSString *name = personModel.name == nil?@"":personModel.name;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:name delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *phone in personModel.phoneNums) {
        [actionSheet addButtonWithTitle:phone];
    }
    [actionSheet showInView:self.view];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if(searchBar.text.length > 0){
        NSString *keyword = searchBar.text;
        [self.resultController searchWithKeyword:keyword];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchBar.text.length <= 0){
        NSString *keyword = searchBar.text;
        [self.resultController searchWithKeyword:keyword];
    }
}

#pragma mark - UIAction sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex > 0){
        NSString *callPhone = self.selectedPerson.phoneNums[buttonIndex - 1];
        HTLog(@"called number is %@",callPhone);
        [[MDataUtil shareInstance] saveRecordWithContact:self.selectedPerson phone:callPhone];
        CallingViewController *callController = [[CallingViewController alloc] init];
        self.callController = callController;
        [callController showViewWithModel:self.selectedPerson phone:callPhone cancel:^{
        }];
    }
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

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[MDataUtil shareInstance] sections];
}

//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    
//}


#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *contacts = [[[MDataUtil shareInstance] contacts] objectAtIndex:indexPath.section];
    PersonModel *model = contacts[indexPath.row];
    [self showContactPhoneNumbersWithPerson:model];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   return [[[MDataUtil shareInstance] sections] objectAtIndex:section];
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
