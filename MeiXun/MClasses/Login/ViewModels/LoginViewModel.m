//
//  LoginViewModel.m
//  MeiXun
//
//  Created by taotao on 2017/8/16.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "LoginViewModel.h"
#import "MNetworkUtil.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation LoginViewModel
/**
 *  发送一个GET请求
 *  验证手机号码是否已经注册
 */
+ (void)ReqPhoneRegisterStateWithParams:(id)params result:(ReqReusltBlock)result
{
    [MNetworkUtil GETWithURL:kRegisterStateUrl params:params reqSuccess:^(id data) {
        result(ReqResultSuccType,data);
    } reqFail:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        result(ReqResultFailType,msg);
    }];
}

/**
 *  发送一个POST请求
 *  请求登录
 */
+ (void)ReqLoginWithParams:(id)params result:(ReqReusltBlock)result
{
    [MNetworkUtil POSTWithURL:kLoginUrl params:params reqSuccess:^(id data) {
        MAccModel *model = [MAccModel mj_objectWithKeyValues:data];
        result(ReqResultSuccType,model);
    } reqFail:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        result(ReqResultFailType,msg);
    }];
}

/**
 *  发送一个GET请求
 *  请求验证码
 */
+ (void)ReqPhoneCodeWithParams:(id)params result:(ReqReusltBlock)result
{
    [MNetworkUtil GETWithURL:kGetCodeUrl params:params reqSuccess:^(id data) {
        result(ReqResultSuccType,data);
    } reqFail:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        result(ReqResultFailType,msg);
    }];
}

/**
 *  发送一个POST请求
 *  请求注册
 */
+ (void)ReqRegisterWithParams:(id)params result:(ReqReusltBlock)result
{
    [MNetworkUtil POSTWithURL:kRegisterUrl params:params reqSuccess:^(id data) {
        result(ReqResultSuccType,data);
    } reqFail:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        result(ReqResultFailType,msg);
    }];
}

/**
 *  发送一个POST请求
 *  找回密码
 */
+ (void)ReqPwdBackWithParams:(id)params result:(ReqReusltBlock)result
{
    [MNetworkUtil POSTWithURL:kGetPwdBackUrl params:params reqSuccess:^(id data) {
        result(ReqResultSuccType,data);
    } reqFail:^(NSString *msg) {
        [SVProgressHUD showWithStatus:msg];
        result(ReqResultFailType,msg);
    }];
}


@end
