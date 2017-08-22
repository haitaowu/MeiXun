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

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self setupNavigationBarUI];
    //1.
//    UIStoryboard *login = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    UIViewController *rootController = [login instantiateViewControllerWithIdentifier:@"LoginNavController"];
//    self.window.rootViewController = rootController;
//    [self.window makeKeyAndVisible];
    
   //2.
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MTabbarController *rootController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MTabbarController"];
    [rootController setDelegate:self];
    self.window.rootViewController = rootController;
    [self.window makeKeyAndVisible];
    
    [[MDataUtil shareInstance] loadContactsWithBlock:^{
        
    }];
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


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    HTLog(@"tabbar controller selected index = %ld",tabBarController.selectedIndex);
    if (tabBarController.selectedIndex == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kFirstTabbarItemSelectedNotification object:nil];
    }
}


#pragma mark - private methods
- (void)setupNavigationBarUI
{
    [[UINavigationBar appearance] setTintColor:MNavBarColor];
    //未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MNavBarColor} forState:UIControlStateSelected];
}

@end
