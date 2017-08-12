//
//  LoginCodeTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/12.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "LoginCodeTableViewController.h"

@interface LoginCodeTableViewController ()
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *enterLabels;
@property (weak, nonatomic) IBOutlet UITextField *enterField;

@end

@implementation LoginCodeTableViewController
#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - setup UI 
- (void)setupViewUI
{
    for (UILabel *label in self.enterLabels) {
        label.layer.borderWidth = 1;
        label.layer.borderColor = [UIColor grayColor].CGColor;
    }
}

#pragma mark - selectors
- (IBAction)tapEnterBtn:(id)sender {
    [self.enterField becomeFirstResponder];
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

#pragma mark - UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


@end
