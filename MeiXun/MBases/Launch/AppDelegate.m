//
//  AppDelegate.m
//  MeiXun
//
//  Created by taotao on 2017/8/11.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "AppDelegate.h"
#import "MDataUtil.h"
#import "MTabbarController.h"
#import "MDataManagerUtil.h"
#import "ADViewController.h"
#import "UMessage.h"


#define kUmengAliasType             @"MX_type_user_phone"

@interface AppDelegate ()<UITabBarControllerDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self setupAppearUI];
   
    if([[MDataUtil shareInstance] userIsLogin] == YES){
        [self setupLoginedViews];
    }else{
        [[MDataUtil shareInstance] loadContactsWithBlock:^{
        }];
        [self setupUnLoginUI];
    }
    [self.window makeKeyAndVisible];
    [MDataUtil checkUnCompletionTransAndSubmit];
    
//
//    NSString *locationStr = [[MDataManagerUtil shareInstance] locationForNumber:@"1806195"];
//    HTLog(@"location = %@",locationStr);
    
    [self setupUmengWithOptions:launchOptions];
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAppWillBecomeInActiveNoti object:nil];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAppWillEnterForegroundNoti object:nil];
    [[MDataUtil shareInstance] archiveContactsToLocal];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

#pragma mark - setup  UI 
//显示主界面。
- (void)showMainTabView
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MTabbarController *rootController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MTabbarController"];
    [rootController setDelegate:self];
    self.window.rootViewController = rootController;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rebindingSuccess) name:kRebindingSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess) name:kLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess) name:kModifyPwdSuccNotification object:nil];
}

//登录之后的界面设置。
- (void)setupLoginedViews
{
    //3.ad
    ADViewController *rootController = [[ADViewController alloc] init];
    self.window.rootViewController = rootController;
    __block typeof(self) blockSelf = self;
    [[MDataUtil shareInstance] loadContactsWithBlock:^{
        //2.
        [blockSelf showMainTabView];
        [[MDataUtil shareInstance] archiveContactsToLocal];
    }];
    
}


//显示未登录界面
- (void)setupUnLoginUI
{
    //1.
    UIStoryboard *login = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *rootController = [login instantiateViewControllerWithIdentifier:@"LoginNavController"];
    self.window.rootViewController = rootController;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kLoginSuccessNotification object:nil];
}

#pragma mark - UITabBarController delegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    HTLog(@"tabbar controller selected index = %ld",tabBarController.selectedIndex);
    if (tabBarController.selectedIndex == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kFirstTabbarItemSelectedNotification object:nil];
    }
}

#pragma mark - private methods
- (void)setupAppearUI
{
    //1.navigation bar appear
    [[UINavigationBar appearance] setTintColor:MNavBarColor];
    //未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MNavBarColor} forState:UIControlStateSelected];
    //2.SVProgressHUD appear
    [SVProgressHUD setBackgroundColor:MRGBA(0, 0, 0, 0.5)];
    [SVProgressHUD setForegroundColor:MRGBA(255, 255, 255, 1)];
    [SVProgressHUD setMinimumDismissTimeInterval:0.1];
}

//重新绑定切换手机号码成功
- (void)logoutSuccess
{
    MAccModel *model = [MDataUtil shareInstance].accModel;
    [UMessage removeAlias:model.mobile type:kUmengAliasType response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
    }];
    [[MDataUtil shareInstance] archiveAccModel:nil];
    [self setupUnLoginUI];
}

- (void)rebindingSuccess
{
    [[MDataUtil shareInstance] archiveAccModel:nil];
    [self setupUnLoginUI];
}

//登录成功
- (void)loginSuccess
{
    [self showMainTabView];
    MAccModel *model = [MDataUtil shareInstance].accModel;
    [UMessage addAlias:model.mobile type:kUmengAliasType response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        if (error) {
            HTLog(@"add alias error = %@",error);
        }
    }];
 
}

- (void)setupUmengWithOptions:(NSDictionary *)launchOptions
{
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
    //初始化方法,也可以使用(void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary * )launchOptions httpsenable:(BOOL)value;这个方法，方便设置https请求。
    NSString *appkey = @"59eed1dc07fe656685000031";
//    [UMessage startWithAppkey:appkey launchOptions:launchOptions httpsEnable:YES];
    [UMessage startWithAppkey:appkey launchOptions:launchOptions];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];

    //iOS10必须加下面这段代码。
    if (@available(iOS 10,*)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate=self;
        UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                //这里可以添加一些自己的逻辑
            } else {
                //点击不允许
                //这里可以添加一些自己的逻辑
            }
        }];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    HTLog(@"device token = %@",deviceToken);
    HTLog(@"deviceToken-->%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""] stringByReplacingOccurrencesOfString: @" " withString: @""]);
    [UMessage registerDeviceToken:deviceToken];
}

//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
//{
//    HTLog(@"device token = %@",error);
//    HTLog(@"device token = %@",error);
//}

#pragma mark - Umeng UNUserNotificationCenterDelegate
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
    
    HTLog(@"did recived Notification = %@",userInfo);
    
    //    self.userInfo = userInfo;
    //    //定制自定的的弹出框
    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    //    {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
    //                                                            message:@"Test On ApplicationStateActive"
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"确定"
    //                                                  otherButtonTitles:nil];
    //
    //        [alertView show];
    //
    //    }
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
//        id rootController = self.window.rootViewController;
//        if ([rootController isKindOfClass:[MTabbarController class]]) {
//            MTabbarController *tabbarControl = (MTabbarController*)rootController;
//            tabbarControl.selectedIndex = 2;
//            [[NSNotificationCenter defaultCenter] postNotificationName:kRecivedUmengNotifcation object:nil];
//        }
//
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        id rootController = self.window.rootViewController;
        if ([rootController isKindOfClass:[MTabbarController class]]) {
            MTabbarController *tabbarControl = (MTabbarController*)rootController;
            if (tabbarControl.selectedIndex == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kDialogRecivedUmengNotifcation object:nil];
            }else{
                tabbarControl.selectedIndex = 2;
                [[NSNotificationCenter defaultCenter] postNotificationName:kRecivedUmengNotifcation object:nil];
            }
        }
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

@end
