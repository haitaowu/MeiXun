//
//  MNetworkUtil.h
//  MeiXun
//
//  Created by taotao on 2017/8/16.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^ReqSucess)(id data);
typedef void(^ReqFail)(NSString* msg);




@interface MNetworkUtil : NSObject
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param fail 请求失败后的回调
 */
+ (void)POSTWithURL:(NSString *)url params:(id)params reqSuccess:(ReqSucess)success reqFail:(ReqFail)fail;

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param fail 请求失败后的回调
 */
+ (void)GETWithURL:(NSString *)url params:(id)params reqSuccess:(ReqSucess)success reqFail:(ReqFail)fail;
@end
