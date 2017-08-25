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
@property (nonatomic,assign) BOOL cellEditEnable;
@property (nonatomic,strong)UIBarButtonItem *leftBarItem;

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

-(CallingViewController *)callController
{
    if(_callController == nil)
    {
        _callController = [[CallingViewController alloc] init];
    }
    return _callController;
}

-(UIBarButtonItem *)leftBarItem
{
    if(_leftBarItem == nil)
    {
        _leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(tapLeftBarItem)];
    }
    return _leftBarItem;
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
        _keyboard.dialogBlock = ^(NSString *phoneNum) {
            [blockSelf callPhoneNumber:phoneNum];
        };
    }
    return _keyboard;
}

#pragma mark - private methods
- (void)callPhoneNumber:(NSString*)phoneNum
{
    __block typeof(self) blockSelf = self;
    PersonModel *model = [[MDataUtil shareInstance] queryPersonWithPhone:phoneNum];
    [[MDataUtil shareInstance] saveRecordWithContact:model phone:phoneNum];
    [self.callController showViewWithModel:model phone:phoneNum cancel:^{
        [blockSelf.tableView reloadData];
    }];
    
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
    
    //2.2rightBarButtonItem set
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(tapRightBarItem)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
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
//    MKeyboard *keyboard = [MKeyboard showMKeyboard];
    [self.keyboard showView];
}

- (void)tapLeftBarItem
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"清除所有通话记录" otherButtonTitles:nil];
    actionSheet.tag = 99;
    [actionSheet showInView:self.view];
}

- (void)tapRightBarItem
{
    NSArray *records = [[MDataUtil shareInstance] records];
    if ([records count] <= 0) {
            return;
    }
    self.cellEditEnable = !self.cellEditEnable;
    [self updateNavigationBarItemState];
}

- (void)updateNavigationBarItemState
{
    [self.tableView setEditing:self.cellEditEnable animated:YES];
    if (self.cellEditEnable == YES) {
        self.navigationItem.leftBarButtonItem = self.leftBarItem;
        self.navigationItem.rightBarButtonItem.title = @"完成";
    }else{
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
}

#pragma mark - UIAction sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = actionSheet.tag;
    if (tag == 99) {
       if(buttonIndex == 0){
           HTLog(@"clear all record data");
           NSMutableArray *records = [[MDataUtil shareInstance] records];
           [records removeAllObjects];
           [self.tableView reloadData];
           [[MDataUtil shareInstance] updateRecordDataAfterDeleteRecord];
//           [self tapRightBarItem];
           self.cellEditEnable = NO;
           [self updateNavigationBarItemState];
       }
    }else{
        if(buttonIndex > 0){
            NSString *callPhone = self.selectedRecord.phone;
            HTLog(@"called number is %@",callPhone);
            [[MDataUtil shareInstance] saveRecordWithPhone:callPhone];
            __block typeof(self) blockSelf = self;
            [self.callController showViewWithModel:self.selectedRecord phone:callPhone cancel:^{
                [[UIApplication sharedApplication] setStatusBarHidden:NO];
                [blockSelf.tableView reloadData];
            }];
        }
        
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HTLog(@"commit tableviewcelleditingStyle delete ");
        NSMutableArray *records = [[MDataUtil shareInstance] records];
        [records removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        [[MDataUtil shareInstance] updateRecordDataAfterDeleteRecord];
        if ([records count] == 0) {
            self.cellEditEnable = NO;
            [self updateNavigationBarItemState];
        }
    }
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
    return 70;
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
