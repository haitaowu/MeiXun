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
#import "DialogViewModel.h"


@interface CallingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonatomic,strong)id model;
@property (nonatomic,copy)NSString* calledPhone;
@property (nonatomic,copy) CancelBlock cancelBlock;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

@end

@implementation CallingViewController

- (void)showViewWithModel:(id)model phone:(NSString*)phone cancel:(CancelBlock)cancelBlock
{
    self.calledPhone = phone;
    self.cancelBlock = cancelBlock;
    self.model = model;
    [self showView];
    [self callPhoneNumber:phone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomeInActive) name:kAppWillBecomeInActiveNoti object:nil];
    [super viewWillAppear:animated];
    [self setupUIWithModel:self.model phone:self.calledPhone];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - setup UI 
- (void)setupUIWithModel:(id)model phone:(NSString*)phone
{
    if ([model isKindOfClass:[PersonModel class]]) {
        PersonModel *person = (PersonModel*)model;
        self.nameLabel.text = person.name;
        self.phoneLabel.text = phone;
        if (person.avatarData != nil) {
            UIImage *image = [UIImage imageWithData:person.avatarData];
            self.avatarView.image = image;
        }else{
            UIImage *img = [UIImage imageNamed:@"icon_user_hd"];
            self.avatarView.image = img;
        }
    }else if ([model isKindOfClass:[RecordModel class]]) {
        RecordModel *record = (RecordModel*)model;
        self.nameLabel.text = record.name;
        self.phoneLabel.text = phone;
        if (record.avatarData != nil) {
            UIImage *image = [UIImage imageWithData:record.avatarData];
            self.avatarView.image = image;
        }else{
            UIImage *img = [UIImage imageNamed:@"icon_user_hd"];
            self.avatarView.image = img;
        }
    }else{
        self.nameLabel.text = phone;
        self.phoneLabel.text = phone;
        UIImage *img = [UIImage imageNamed:@"icon_user_hd"];
        self.avatarView.image = img;
    }
}

#pragma mark - request  server
- (void)callPhoneNumber:(NSString*)phoneNum
{
    NSString *token = [MDataUtil shareInstance].accModel.token;
    NSString *userId = [MDataUtil shareInstance].accModel.userId;
    NSString *callingPhone = [MDataUtil shareInstance].accModel.mobile;
    NSDictionary *params = @{kParamTokenType:token,kParamUserIdType:userId,kParamCallingMobile:callingPhone,kParamCalledMobile:phoneNum};
    [DialogViewModel ReqDialogWithParams:params result:^(ReqResultType status, id data) {
        //现在返回的结果是
#warning ---    被叫号码格式错误
        /**
         callingMobile = 18061955875;
         token = B209D542774709B5;
         userId = "9632cab1-272c-11e7-aa66-00163e1aa2b0";
         */
        HTLog(@"request success response data = %@",data);
        if (status == ReqResultSuccType) {
            
        }else{
            [self disappearView];
        }
    }];
}

#pragma mark - selectors
- (IBAction)tapCancelBtn:(id)sender {
    [self disappearView];
    if (self.cancelBlock != nil) {
        self.cancelBlock();
    }
}

//程序回到后台。
- (void)appWillBecomeInActive
{
    [self tapCancelBtn:nil];
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
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView animateWithDuration:0.1 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}



@end
