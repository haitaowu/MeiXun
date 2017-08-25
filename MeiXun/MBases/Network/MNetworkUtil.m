//
//  MNetworkUtil.m
//  MeiXun
//
//  Created by taotao on 2017/8/16.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "MNetworkUtil.h"
#import <AFNetworking/AFNetworking.h>


static NSDictionary *failMsg;

#define kReqSuccess             @"S00000"
#define kReqFail                @"F00000"

@implementation MNetworkUtil
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param fail 请求失败后的回调
 */
+ (void)POSTWithURL:(NSString *)url params:(id)params reqSuccess:(ReqSucess)success reqFail:(ReqFail)fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 18;
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *code = responseObject[kReturnCode];
        if ([code isEqualToString:kReqSuccess]) {
            id reqData = responseObject[kReturnData];
            success(reqData);
        }else {
            NSString *msg = responseObject[kReturnMsg];
            fail(msg);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(@"网络不给力哦");
    }];
}



/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param fail 请求失败后的回调
 */
+ (void)GETWithURL:(NSString *)url params:(id)params reqSuccess:(ReqSucess)success reqFail:(ReqFail)fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 18;
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *code = responseObject[kReturnCode];
        if ([code isEqualToString:kReqSuccess]) {
            id reqData = responseObject[kReturnData];
            success(reqData);
        }else {
            NSString *msg = responseObject[kReturnMsg];
            fail(msg);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(@"网络不给力哦");
    }];
}









@end
