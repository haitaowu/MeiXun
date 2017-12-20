//
//  DialogViewModel.h
//  MeiXun
//
//  Created by taotao on 2017/8/16.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNetworkUtil.h"


@interface DialogViewModel : NSObject

/*
 *  发送一个POST请求
 *  拨打电话
 */
+ (void)ReqDialogWithParams:(id)params result:(ReqReusltBlock)result;


/*
 *  发送一个GET请求
 *  公告
 */
+ (void)ReqNoticeWithResult:(ReqReusltBlock)result;


@end
