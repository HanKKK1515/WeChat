//
//  AppDelegate.h
//  WeChat
//
//  Created by 韩露露 on 16/10/1.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HLLoginResultType) {
    HLLoginResultSuccess, // 登录成功
    HLLoginResultFailure, // 登录失败
    HLLoginResultNetError // 网络连接失败
};

typedef NS_ENUM(NSInteger, HLLogoutResultType) {
    HLLogoutResultSuccess, // 注销成功
    HLLogoutResultNetError // 网络连接失败
};

typedef void (^HLLoginResult)(HLLoginResultType result);
typedef void (^HLLogoutResult)(HLLogoutResultType result);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)userLogin:(HLLoginResult)block;
- (void)userLogout:(HLLogoutResult)block;

@end

