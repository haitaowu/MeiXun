//
//  CallingViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/23.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "CallingViewController.h"
#import "PersonModel.h"
#import "RecordModel.h"

@interface CallingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonatomic,strong)id model;
@property (nonatomic,copy)NSString* calledPhone;
@property (nonatomic,copy) CancelBlock cancelBlock;

@end

@implementation CallingViewController
- (void)showViewWithModel:(id)model phone:(NSString*)phone cancel:(CancelBlock)cancelBlock
{
    self.calledPhone = phone;
    self.cancelBlock = cancelBlock;
    self.model = model;
    [self showView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self setupUIWithModel:self.model phone:self.calledPhone];
}

#pragma mark - setup UI 
- (void)setupUIWithModel:(id)model phone:(NSString*)phone
{
    if ([model isKindOfClass:[PersonModel class]]) {
        PersonModel *person = (PersonModel*)model;
        self.nameLabel.text = person.name;
        self.phoneLabel.text = phone;
    }else if ([model isKindOfClass:[RecordModel class]]) {
        RecordModel *record = (RecordModel*)model;
        self.nameLabel.text = record.name;
        self.phoneLabel.text = phone;
    }else{
        self.nameLabel.text = phone;
        self.phoneLabel.text = phone;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - selectors
- (IBAction)tapCancelBtn:(id)sender {
    [self disappearView];
    if (self.cancelBlock != nil) {
        self.cancelBlock();
    }
}

#pragma mark - public methods
- (void)showView
{
    UIWindow *lastWindow = [[[UIApplication sharedApplication] windows] lastObject];
    self.view.frame = lastWindow.bounds;
    self.view.alpha = 0.0;
    [lastWindow addSubview:self.view];
    [UIView animateWithDuration:0.1 animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

- (void)disappearView
{
    [UIView animateWithDuration:0.1 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}



@end
