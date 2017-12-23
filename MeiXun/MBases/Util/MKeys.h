//
//  MKeys.h
//  MeiXun
//
//  Created by taotao on 2017/8/12.
//  Copyright © 2017年 taotao. All rights reserved.
//


//parameters
#define      kParamClientTypeiOS                   @"2"
#define      kParamMobile                   @"mobile"
#define      kParamUserName                 @"userName"
#define      kParamPassword                 @"password"
#define      kParamOldPassword              @"oldPassword"
#define      kParamNewPassword              @"newPassword"
#define      kParamClientType               @"clientType"
#define      kParamUserIdType               @"userId"
#define      kParamTokenType                @"token"
#define      kParamOldMobile                @"oldMobile"
#define      kParamNewMobile                @"newMobile"
#define      kParamVariCode                @"variCode"
#define      kParamFeedback                @"feedback"
#define      kParamQuota                   @"quota"
#define      kParamReceipt                 @"receipt"
/**
 *0，注册  1，登录    2，修改手机号    3，忘记密码
 */
#define      kParamSendType                 @"sendType"

//主叫号码    主叫号码要和userI的对应的号码一致
#define      kParamCallingMobile            @"callingMobile"
//被叫号码
#define      kParamCalledMobile            @"calledMobile"


#define      kReceiptKey                           @"kReceiptKey"
#define      kPayNo                                @"payNo"
#define      kUnCompletObjKey                      @"kUnCompletObjKey"
#define      kUnCompletionTransKey                 @"kUnCompletionTransKey"

//request server return data key
#define      kReturnCode                 @"code"
#define      kReturnMsg                  @"msg"
#define      kReturnData                 @"data"


//notification
#define     kClickTabbarItemNotification                    @"ClickTabbarItemNotification"
#define     kFirstTabbarItemSelectedNotification            @"kFirstTabbarItemSelectedNotification"

#define     kLoginSuccessNotification                       @"kLoginSuccessNotification"

#define     kRebindingSuccessNotification                   @"kRebindingSuccessNotification"
#define     kLogoutNotification                             @"kLogoutNotification"
#define     kModifyPwdSuccNotification                      @"kModifyPwdSuccNotification"

#define     kAppWillBecomeInActiveNoti                      @"kAppWillBecomeInActiveNoti"
#define     kAppWillEnterForegroundNoti                     @"kAppWillEnterForegroundNoti"

#define     kRecivedUmengNotifcation                     @"kRecivedUmengNotifcation"
#define     kDialogRecivedUmengNotifcation         @"kDialogRecivedUmengNotifcation"




#define     kBaseUrl                                  @"http://106.14.7.180:8180/mxc-api/rest/"
//#define     kBaseUrl                                  @"http://analysis.vicp.net:8090/mxc-api/rest/"



//登录中心的路径
//登录
#define     kLoginUrl                   [NSString stringWithFormat:@"%@%@",kBaseUrl,kLoginSubUrl]
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
#define     kValidateCodeUrl            [NSString stringWithFormat:@"%@%@",kBaseUrl,kValidateCodeSubUrl]
#define     kValidateCodeSubUrl         @"userService/validateVariCode"
//获取用基本信息
#define     kAccInfoUrl                 [NSString stringWithFormat:@"%@%@",kBaseUrl,kValidateCodeSubUrl]
#define     kAccInfoSubUrl              @"userService/getUserInfo"
//找回密码
#define     kGetPwdBackUrl              [NSString stringWithFormat:@"%@%@",kBaseUrl,kGetPwdBackSubUrl]
#define     kGetPwdBackSubUrl           @"userService/retrievePassword"



//我
//充值明细
#define     kChargeUrl              [NSString stringWithFormat:@"%@%@",kBaseUrl,kChargeSubUrl]
#define     kChargeSubUrl           @"cardService/rechargeDetail"

//用户的基本信息
#define     kUserInfoUrl              [NSString stringWithFormat:@"%@%@",kBaseUrl,kUserInfoSubUrl]
#define     kUserInfoSubUrl           @"userService/getUserInfo"

//拨打电话
#define     kDialogUrl              [NSString stringWithFormat:@"%@%@",kBaseUrl,kDialogSubUrl]
#define     kDialogSubUrl           @"callService/callThirdParty"

//显示公告的接口
#define     kNoticeUrl              [NSString stringWithFormat:@"%@%@",kBaseUrl,kNoticeSubUrl]
#define     kNoticeSubUrl           @"noticeService/getNoticeContent"

//1.获取用户消息接口
#define     kMessageUrl              [NSString stringWithFormat:@"%@%@",kBaseUrl,kMessageSubUrl]
#define     kMessageSubUrl           @"messageService/getUserMessages"


//重新绑定手机号
#define     kRebindingUrl              [NSString stringWithFormat:@"%@%@",kBaseUrl,kRebindingSubUrl]
#define     kRebindingSubUrl           @"userService/modifyMobile"


//意见反馈
#define     kFeedbackUrl              [NSString stringWithFormat:@"%@%@",kBaseUrl,kFeedbackSubUrl]
#define     kFeedbackSubUrl           @"userService/giveFeedback"

//在线充值
#define     kReceiptkUrl              [NSString stringWithFormat:@"%@%@",kBaseUrl,kReceiptSubUrl]
#define     kReceiptSubUrl           @"cardService/newRechargeOnline"

//在线充值
#define     kOrderIDUrl              [NSString stringWithFormat:@"%@%@",kBaseUrl,kOrderIDSubUrl]
#define     kOrderIDSubUrl           @"cardService/iosOnlineData"



