//
//  DialogTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/15.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "DialogTableViewController.h"
#import "MKeyboard.h"
#import "RecordCell.h"
#import "RecordModel.h"
#import "CallingViewController.h"


static NSString *RecordCellID = @"RecordCellID";

@interface DialogTableViewController ()<UIActionSheetDelegate>
@property (nonatomic,strong)RecordModel *selectedRecord;
@property (nonatomic,strong)MKeyboard *keyboard;
@property (nonatomic,strong)CallingViewController *callController;

@end

@implementation DialogTableViewController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBase];
    [self setupUI];
    [self.keyboard showView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(MKeyboard *)keyboard
{
    if(_keyboard== nil)
    {
        __block typeof(self) blockSelf = self;
        _keyboard = [MKeyboard showMKeyboard];
        _keyboard.selectItemBlock = ^(NSInteger itemIdx) {
            blockSelf.tabBarController.selectedIndex = itemIdx;
        };
    }
    return _keyboard;
}

#pragma mark - setup UI 
- (void)setupBase
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarSelecteItem) name:kFirstTabbarItemSelectedNotification object:nil];
//    MKeyboard *keyboard = [MKeyboard showMKeyboard];
}


- (void)setupUI
{
    // setup tableView cell
    UINib *alertCellNib = [UINib nibWithNibName:@"RecordCell" bundle:nil];
    [self.tableView registerNib:alertCellNib forCellReuseIdentifier:RecordCellID];
    
}

//显示可以拨打的电话号码。
- (void)showPhoneNumberWithRecord:(RecordModel*)recordModel
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择号码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:recordModel.phone];
    [actionSheet showInView:self.view];
}


#pragma mark - selectors
- (void)tabbarSelecteItem
{
    HTLog(@"select dialog item tabbar ");
//    MKeyboard *keyboard = [MKeyboard showMKeyboard];
    [self.keyboard showView];
}

#pragma mark - UIAction sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex > 0){
        NSString *callPhone = self.selectedRecord.phone;
        HTLog(@"called number is %@",callPhone);
        [[MDataUtil shareInstance] saveRecordWithPhone:callPhone];
        CallingViewController *callController = [[CallingViewController alloc] init];
        __block typeof(self) blockSelf = self;
        [callController showViewWithModel:self.selectedRecord phone:callPhone cancel:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [blockSelf.tableView reloadData];
        }];
        self.callController = callController;
    }
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *records = [[MDataUtil shareInstance] records];
    return [records count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:RecordCellID];
    NSArray *records = [[MDataUtil shareInstance] records];
    RecordModel *model = records[indexPath.row];
    cell.recordModel = model;
    //    __block typeof(self) blockSelf = self;
    //    cell.cellBlock = ^(id vaccine) {
    //        [blockSelf performSegueWithIdentifier:@"vaccineDetailSegue" sender:data];
    //    };
    
    return cell;
    
}

#pragma mark - UITableView --- Table view  delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSArray *contacts = [[[MDataUtil shareInstance] contacts] objectAtIndex:indexPath.section];
    NSArray *records = [[MDataUtil shareInstance] records];
    RecordModel *model = records[indexPath.row];
    self.selectedRecord = model;
    [self showPhoneNumberWithRecord:model];
//    [self showContactPhoneNumbersWithPerson:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

@end
