//
//  ChargeSuccViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "ChargeSuccViewController.h"

@interface ChargeSuccViewController ()


@end

@implementation ChargeSuccViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
}

- (IBAction)tapFinishedBtn:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
