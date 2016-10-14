//
//  AppDelegate.m
//  WeChat
//
//  Created by 韩露露 on 16/10/1.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "AppDelegate.h"
#import "HLOtherLoginController.h"

#define HLTabBarItemColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self setupSVProgressHUD];
    [self setupNavigationBar];
    [self setupTabBar];
    [self setupFirstPage];
    return YES;
}

// 设置提示框样式
- (void)setupSVProgressHUD {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
}

// 设置导航栏样式
- (void)setupNavigationBar {
    UINavigationBar *appearance = [UINavigationBar appearance];
    [appearance setBackgroundImage:[UIImage imageNamed:@"topbarbg_Nav"] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *fontAttribNav = [NSMutableDictionary dictionary];
    fontAttribNav[NSForegroundColorAttributeName] = [UIColor whiteColor];
    fontAttribNav[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    appearance.titleTextAttributes = fontAttribNav;
    
    appearance.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *fontAttribItem = [NSMutableDictionary dictionary];
    fontAttribItem[NSFontAttributeName] = [UIFont boldSystemFontOfSize:16];
    fontAttribItem[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:fontAttribItem forState:UIControlStateDisabled];
}

// 设置标签栏样式
- (void)setupTabBar {
    UITabBar *tabBar = [UITabBar appearance];
    tabBar.backgroundImage = [UIImage imageNamed:@"tabbar_background"];
    tabBar.tintColor = HLTabBarItemColor(61, 187, 3, 1);
    
    UITabBarItem *item = [UITabBarItem appearance];
    NSMutableDictionary *fontAttribItem = [NSMutableDictionary dictionary];
    fontAttribItem[NSFontAttributeName] = [UIFont boldSystemFontOfSize:12];
    [item setTitleTextAttributes:fontAttribItem forState:UIControlStateNormal];
}

// 程序启动后选择首页面
- (void)setupFirstPage {
    HLUserInfo *userInfo = [HLUserInfo sharedHLUserInfo];
    [userInfo loadUserInfoData];
    if (userInfo.userName.length > 0 && userInfo.pwd.length > 0) {
        __weak typeof(self) selfWeak = self;
        [[HLXMPPTool sharedHLXMPPTool] userLogin:^(HLLoginResultType result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (result) {
                    case HLLoginResultFailure:
                        [SVProgressHUD showErrorWithStatus:@"登录失败，帐号或者密码错误。"];
                        selfWeak.window.rootViewController = [UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController;
                        break;
                    case HLLoginResultSuccess: // 跳到主界面
                        selfWeak.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
                        break;
                    case HLLoginResultNetError:
                        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                        selfWeak.window.rootViewController = [UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController;
                        break;
                }
            });
        }];
    } else if (userInfo.userName > 0) {
        self.window.rootViewController = [UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController;
    } else {
        UIStoryboard *storybaord = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UINavigationController *otherLoginNav = [storybaord instantiateViewControllerWithIdentifier:@"otherLoginNav"];
        HLOtherLoginController *otherLoginVc = otherLoginNav.viewControllers.lastObject;
        otherLoginVc.useType = HLUseFirstLogin;
        self.window.rootViewController = otherLoginNav;
    }
}

@end
