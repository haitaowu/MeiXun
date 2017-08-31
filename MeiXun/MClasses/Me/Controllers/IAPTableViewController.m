//
//  IAPTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/31.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "IAPTableViewController.h"
#import "MProductButton.h"

@interface IAPTableViewController ()
@property(nonatomic,strong) IBOutletCollection(MProductButton) NSArray* products;
@property (nonatomic,strong)MProductButton *selectedProduct;
@end

@implementation IAPTableViewController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - selectors
- (IBAction)tapProduct:(MProductButton*)sender
{
    if (sender.selected == NO) {
        sender.selected = YES;
        self.selectedProduct = sender;
        for (MProductButton *product in self.products) {
            if (product.tag != sender.tag) {
                product.selected = NO;
            }
        }
    }
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}


@end
