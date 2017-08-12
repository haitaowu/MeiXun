//
//  AccTableVieController.m
//  MeiXun
//
//  Created by taotao on 2017/8/11.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "AccTableVieController.h"

@interface AccTableVieController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accField;

@end

@implementation AccTableVieController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAccViewUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - selectors
- (IBAction)tapNextBtn:(id)sender {
    [self.view endEditing:YES];
    [self performSegueWithIdentifier:@"codeSegue" sender:nil];
}


#pragma mark - setup UI 
- (void)setupAccViewUI
{
    self.accField.leftViewMode = UITextFieldViewModeAlways;
    self.accField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
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
