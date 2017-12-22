//
//  MeViewModel.m
//  MeiXun
//
//  Created by taotao on 2017/8/16.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "MeViewModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ChargeModel.h"

@implementation MeViewModel


/**
 *  发送一个POST请求
 *  查询充值明细
 */
+ (void)ReqCharegeWithResult:(ReqReusltBlock)result;
{
    NSString *token = [MDataUtil shareInstance].accModel.token;
    NSString *userId = [MDataUtil shareInstance].accModel.userId;
    NSDictionary *params = @{kParamTokenType:token,kParamUserIdType:userId};
    [MNetworkUtil GETWithURL:kChargeUrl params:params reqSuccess:^(id data) {
        if ([data count] > 0) {
            NSArray *array = [ChargeModel mj_objectArrayWithKeyValuesArray:data];
            result(ReqResultSuccType,array);
        }else{
            [SVProgressHUD showErrorWithStatus:@"暂无数据"];
            result(ReqResultFailType,@"暂无数据");
        }
    } reqFail:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        result(ReqResultFailType,msg);
    }];
}

 
/**
 *  发送一个GET请求
 *  获取用基本信息 - 网龄 + 余额
 */
+ (void)ReqUserInfoWithParams:(id)params result:(ReqReusltBlock)result
{
    [MNetworkUtil GETWithURL:kUserInfoUrl params:params reqSuccess:^(id data) {
        MAccModel *model = [MAccModel mj_objectWithKeyValues:data];
        result(ReqResultSuccType,model);
    } reqFail:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        result(ReqResultFailType,msg);
    }];
}




/**
*  发送一个POST
*  请求修改手机号 - 绑定手机号
*/
+ (void)ReqRebindingWithParams:(id)params result:(ReqReusltBlock)result
{
    [MNetworkUtil POSTWithURL:kRebindingUrl params:params reqSuccess:^(id data) {
        result(ReqResultSuccType,data);
    } reqFail:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        result(ReqResultFailType,msg);
    }];
}

/**
 *  发送一个POST请求
 *  请求修改密码
 */
+ (void)ReqModifyPwdWithParams:(id)params result:(ReqReusltBlock)result;
{
    [MNetworkUtil POSTWithURL:kModifyPwdUrl params:params reqSuccess:^(id data) {
        result(ReqResultSuccType,data);
    } reqFail:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        result(ReqResultFailType,msg);
    }];
}

/**
 *  发送一个POST请求
 *  提交意见反馈
 */

+ (void)submitFeedBackWithParams:(id)params result:(ReqReusltBlock)result
{
    [MNetworkUtil POSTWithURL:kFeedbackUrl params:params reqSuccess:^(id data) {
        result(ReqResultSuccType,data);
    } reqFail:^(NSString *msg) {
        [SVProgressHUD showWithStatus:msg];
        result(ReqResultFailType,msg);
    }];
}

/**
 *  发送一个POST请求
 *  提交内购凭证
 */

+ (void)submitIAPReceiptWithParams:(id)params result:(ReqReusltBlock)result
{
    [MNetworkUtil POSTWithURL:kReceiptkUrl params:params reqSuccess:^(id data) {
        result(ReqResultSuccType,data);
    } reqFail:^(NSString *msg) {
//        [SVProgressHUD showInfoWithStatus:msg];
        result(ReqResultFailType,msg);
    }];
}

/**
 *  发送一个POST请求
 *  购买时新建一条订单,请求订单信息。
 */

+ (void)RequestOrderIDWithParams:(id)params result:(ReqReusltBlock)result
{
    [MNetworkUtil POSTWithURL:kOrderIDUrl params:params reqSuccess:^(id data) {
        result(ReqResultSuccType,data);
    } reqFail:^(NSString *msg) {
        [SVProgressHUD showInfoWithStatus:msg];
        result(ReqResultFailType,msg);
    }];
}

/*
*  发送一个POST请求
*  消息列表
*/
+ (void)ReqMsgsWithParams:(id)params result:(ReqReusltBlock)result
{
    [MNetworkUtil POSTWithURL:kMessageUrl params:params reqSuccess:^(id data) {
        result(ReqResultSuccType,data);
    } reqFail:^(NSString *msg) {
        [SVProgressHUD showInfoWithStatus:msg];
        result(ReqResultFailType,msg);
    }];
}
@end
