//
//  DialogViewModel.m
//  MeiXun
//
//  Created by taotao on 2017/8/16.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "DialogViewModel.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation DialogViewModel


/**
 *  发送一个POST请求
 *  拨打电话
 */
+ (void)ReqDialogWithParams:(id)params result:(ReqReusltBlock)result
{
    [MNetworkUtil POSTWithURL:kDialogUrl params:params reqSuccess:^(id data) {
        result(ReqResultSuccType,data);
    } reqFail:^(NSString *msg) {
        [SVProgressHUD showInfoWithStatus:msg];
        result(ReqResultFailType,msg);
    }];
}

/*
 *  发送一个GET请求
 *  公告
 */
+ (void)ReqNoticeWithResult:(ReqReusltBlock)result
{
    [MNetworkUtil GETWithURL:kNoticeUrl params:nil reqSuccess:^(id data) {
        result(ReqResultSuccType,data);
    } reqFail:^(NSString *msg) {
        [SVProgressHUD showInfoWithStatus:msg];
        result(ReqResultFailType,msg);
    }];
}

@end
