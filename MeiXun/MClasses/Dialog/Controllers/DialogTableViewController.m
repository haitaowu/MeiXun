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

@end

@implementation DialogTableViewController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBase];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"%s",__FUNCTION__);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - setup UI 
- (void)setupBase
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarSelecteItem) name:kFirstTabbarItemSelectedNotification object:nil];
    MKeyboard *keyboard = [MKeyboard showMKeyboard];
}

#pragma mark - selectors
- (void)tabbarSelecteItem
{
    HTLog(@"select dialog item tabbar ");
    MKeyboard *keyboard = [MKeyboard showMKeyboard];
}

@end
