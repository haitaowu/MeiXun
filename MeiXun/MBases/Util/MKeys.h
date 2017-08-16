//
//  MKeys.h
//  MeiXun
//
//  Created by taotao on 2017/8/12.
//  Copyright © 2017年 taotao. All rights reserved.
//

//notification
#define     kClickTabbarItemNotification                    @"ClickTabbarItemNotification"
#define     kFirstTabbarItemSelectedNotification            @"kFirstTabbarItemSelectedNotification"




#define     kBaseUrl                                        @"http://abase/mxc-api/rest/"



//登录中心的路径
//登录
#define     kLoginUrl                   [NSString stringWithFormat:@"%@%@",kBaseUrl,kBaseUrl]
#define     kLoginSubUrl                @"userService/login"
//注册
#define     kRegisterUrl                [NSString stringWithFormat:@"%@%@",kBaseUrl,kRegisterSubUrl]
#define     kRegisterSubUrl             @"userService/register"
//获取手机验证码
#define     kGetCodeUrl                 [NSString stringWithFormat:@"%@%@",kBaseUrl,kGetCodeSubUrl]
#define     kGetCodeSubUrl              @"userService/getRegVariCode"
//修改密码
#define     kModifyPwdUrl               [NSString stringWithFormat:@"%@%@",kBaseUrl,kModifyPwdSubUrl]
#define     kModifyPwdSubUrl            @"userService/modifyPassword"
//修改手机号
#define     kModifyPhoneUrl             [NSString stringWithFormat:@"%@%@",kBaseUrl,kModifyPhoneSubUrl]
#define     kModifyPhoneSubUrl          @"userService/modifyMobile"
//验证手机号是否已注册
#define     kRegisterStateUrl           [NSString stringWithFormat:@"%@%@",kBaseUrl,kRegisterStateSubUrl]
#define     kRegisterStateSubUrl        @"userService/isRegisterMobile"
//验证手机验证码
#define     kValidateCodeUrl            [NSString stringWithFormat:@"%@%@",kBaseUrl,kRegisterSubUrl]
#define     kValidateCodeSubUrl         @"userService/validateVariCode"
//获取用基本信息
#define     kAccInfoUrl                 [NSString stringWithFormat:@"%@%@",kBaseUrl,kValidateCodeSubUrl]
#define     kAccInfoSubUrl              @"userService/getUserInfo"
//找回密码
#define     kGetPwdBackUrl              [NSString stringWithFormat:@"%@%@",kBaseUrl,kGetPwdBackSubUrl]
#define     kGetPwdBackSubUrl           @"userService/retrievePassword"



