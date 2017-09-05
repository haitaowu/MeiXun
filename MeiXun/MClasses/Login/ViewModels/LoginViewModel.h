//
//  LoginViewModel.h
//  MeiXun
//
//  Created by taotao on 2017/8/16.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNetworkUtil.h"


@interface LoginViewModel : NSObject
/**
 *  发送一个GET请求
 *  验证手机号码是否已经注册
 */
+ (void)ReqPhoneRegisterStateWithParams:(id)params result:(ReqReusltBlock)result;

/**
 *  发送一个POST请求
 *  请求登录
 */
+ (void)ReqLoginWithParams:(id)params result:(ReqReusltBlock)result;


/**
 *  发送一个GET请求
 *  请求验证码
 */
+ (void)ReqPhoneCodeWithParams:(id)params result:(ReqReusltBlock)result;


/**
 *  发送一个POST请求
 *  请求注册
 */
+ (void)ReqRegisterWithParams:(id)params result:(ReqReusltBlock)result;

/**
 *  发送一个POST请求
 *  找回密码
 */
+ (void)ReqPwdBackWithParams:(id)params result:(ReqReusltBlock)result;

/**
 *  发送一个GET请求
 *  验证手机验证码
 */
+ (void)ReqValidatePhoneCodeWithParams:(id)params result:(ReqReusltBlock)result;
@end
