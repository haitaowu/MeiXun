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

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self setupAppearUI];
   
    if([[MDataUtil shareInstance] userIsLogin] == YES){
        [self setupLoginedViews];
    }else{
        [self setupUnLoginUI];
    }
    [self.window makeKeyAndVisible];
    
    
//
//    NSString *locationStr = [[MDataManagerUtil shareInstance] locationForNumber:@"1806195"];
//    HTLog(@"location = %@",locationStr);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

#pragma mark - setup  UI 
//显示登录之后的主界面。
- (void)showMainTabView
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MTabbarController *rootController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MTabbarController"];
    [rootController setDelegate:self];
    self.window.rootViewController = rootController;
}

- (void)setupLoginedViews
{
    //3.ad
    ADViewController *rootController = [[ADViewController alloc] init];
    self.window.rootViewController = rootController;
    __block typeof(self) blockSelf = self;
    [[MDataUtil shareInstance] loadContactsWithBlock:^{
        //2.
        [blockSelf showMainTabView];
    }];
}

- (void)setupUnLoginUI
{
    [[MDataUtil shareInstance] loadContactsWithBlock:^{
    }];
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

- (void)loginSuccess
{
    [self showMainTabView];
 
}

@end
