//
//  HLXMPPTool.h
//  WeChat
//
//  Created by 韩露露 on 2016/10/7.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

typedef NS_ENUM(NSInteger, HLLoginResultType) {
    HLLoginResultSuccess, // 登录成功
    HLLoginResultFailure, // 登录失败
    HLLoginResultNetError // 网络连接失败
};

typedef NS_ENUM(NSInteger, HLLogoutResultType) {
    HLLogoutResultSuccess, // 注销成功
    HLLogoutResultNetError // 网络连接失败
};

typedef NS_ENUM(NSInteger, HLRegisterResultType) {
    HLRegisterResultSuccess, // 注册成功
    HLRegisterResultFailure, // 注册失败
    HLRegisterResultNetError // 网络连接失败
};

typedef void (^HLLoginResult)(HLLoginResultType result);
typedef void (^HLLogoutResult)(HLLogoutResultType result);
typedef void (^HLRegisterResult)(HLRegisterResultType result);

@interface HLXMPPTool : NSObject

singleton_interface(HLXMPPTool);

- (void)userLogin:(HLLoginResult)block;
- (void)userLogout:(HLLogoutResult)block;
- (void)userRegister:(HLRegisterResult)block;

@end
