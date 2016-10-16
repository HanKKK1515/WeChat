//
//  HLNavigationController.m
//  WeChat
//
//  Created by 韩露露 on 2016/10/15.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLNavigationController.h"

@interface HLNavigationController ()

@end

@implementation HLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
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

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
}

@end
