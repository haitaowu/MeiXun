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
 *  发送一个POST请求
 *  提交意见反馈
 */

+ (void)submitFeedBackWithParams:(id)params result:(ReqReusltBlock)result;



/**
 *  发送一个POST请求
 *  提交内购凭证
 */

+ (void)submitIAPReceiptWithParams:(id)params result:(ReqReusltBlock)result;



/**
 *  发送一个POST请求
 *  购买时新建一条订单,请求订单信息。
 */

+ (void)RequestOrderIDWithParams:(id)params result:(ReqReusltBlock)result;


/**
 *  发送一个POST
 *  请求修改手机号
 */
+ (void)ReqRebindingWithParams:(id)params result:(ReqReusltBlock)result;


/**
 *  发送一个POST请求
 *  请求修改密码
 */
+ (void)ReqModifyPwdWithParams:(id)params result:(ReqReusltBlock)result;


/**
 *  发送一个POST请求
 *  找回密码
 */
//+ (void)ReqPwdBackWithParams:(id)params result:(ReqReusltBlock)result;


@end
