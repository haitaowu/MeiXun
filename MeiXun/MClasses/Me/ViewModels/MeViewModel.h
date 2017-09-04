//
//  MeViewModel.h
//  MeiXun
//
//  Created by taotao on 2017/8/16.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNetworkUtil.h"


@interface MeViewModel : NSObject

/**
 *  发送一个POST请求
 *  查询充值明细
 */
+ (void)ReqCharegeWithResult:(ReqReusltBlock)result;


/**
 *  发送一个GET请求
 *  获取用基本信息 - 网龄 + 余额
 */
+ (void)ReqUserInfoWithParams:(id)params result:(ReqReusltBlock)result;













/**
 *  发送一个POST
 *  请求修改手机号
 */
+ (void)ReqRebindingWithParams:(id)params result:(ReqReusltBlock)result;


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
@end
