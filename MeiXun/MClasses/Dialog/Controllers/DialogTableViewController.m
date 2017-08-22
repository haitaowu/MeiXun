//
//  DialogTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/15.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "DialogTableViewController.h"
#import "MKeyboard.h"


@interface DialogTableViewController ()
@property (nonatomic,strong)MKeyboard *keyboard;
@end

@implementation DialogTableViewController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBase];
    [self.keyboard showView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *records = [[MDataUtil shareInstance] records];
    HTLog(@"records.count = %ld",[records count]);
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

#pragma mark - selectors
- (void)tabbarSelecteItem
{
    HTLog(@"select dialog item tabbar ");
//    MKeyboard *keyboard = [MKeyboard showMKeyboard];
    [self.keyboard showView];
}

@end
