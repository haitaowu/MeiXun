//
//  LoginCodeTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/12.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "LoginCodeTableViewController.h"

@interface LoginCodeTableViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *enterLabels;
@property (weak, nonatomic) IBOutlet UITextField *enterField;
@property (weak, nonatomic) IBOutlet UIView *againEnterView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

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

#pragma mark - selectors
//提交验证码
- (IBAction)tapSubmitBtn:(id)sender {
    HTLog(@"sumit ");
}
//发送验证码
- (IBAction)tapCodeBtn:(id)sender {
    HTLog(@"get code btn clicked ");
}

//再次发送验证码
- (IBAction)tapReCodeBtn:(id)sender {
    HTLog(@"reget code btn clicked ");
}

#pragma mark - setup UI 
- (void)setupViewUI
{
    for (UILabel *label in self.enterLabels) {
        label.layer.borderWidth = 1;
        label.layer.borderColor = [UIColor grayColor].CGColor;
    }
    [self.enterField addTarget:self action:@selector(txtStrDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - selectors
- (IBAction)tapEnterBtn:(id)sender {
    [self.enterField becomeFirstResponder];
}
- (void)txtStrDidChange:(UITextField*)sender
{
    NSString *txt = sender.text;
    if (txt.length > 4) {
        NSRange range = NSMakeRange(0, 4);
        txt = [txt substringWithRange:range];
        sender.text = txt;
    }
    
    [self.enterLabels enumerateObjectsUsingBlock:^(UILabel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < txt.length) {
            NSString *str = [NSString stringWithFormat:@"%c",[txt characterAtIndex:idx]];
            obj.text = str;
        }else{
            obj.text = @"";
        }
    }];
    
    HTLog(@"textField text = %@",sender.text);
}

#pragma mark - UIScrollView delegate 
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    HTLog(@"text = %@ replaceStr = %@ range = %@",textField.text,string,range.location);
    return YES;
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
