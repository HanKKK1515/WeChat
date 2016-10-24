//
//  HLXMPPTool.h
//  WeChat
//
//  Created by 韩露露 on 2016/10/7.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework/XMPPFramework.h>
#import "Singleton.h"
#import "XMPPvCardTemp.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPMessageArchivingCoreDataStorage.h"

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

@property (strong, nonatomic) XMPPStream *stream;
@property (strong, nonatomic) XMPPvCardTempModule *vCarTemp; // 名片模块
@property (strong, nonatomic) XMPPRoster *roster; // 花名册模块
@property (strong, nonatomic) XMPPRosterCoreDataStorage *rosterStorage; // 花名册数据存储
@property (strong, nonatomic) XMPPvCardAvatarModule *vCarAvatar; // 头像模块
@property (strong, nonatomic) XMPPMessageArchivingCoreDataStorage *messageStorage; // 消息存储模块
@property (strong, nonatomic) XMPPMessageArchiving *messageArchiving; // 消息模块
@property (strong, nonatomic) NSString *domainName;

- (void)userLogin:(HLLoginResult)block; // 登录
- (void)userLogout:(HLLogoutResult)block; // 注销
- (void)userRegister:(HLRegisterResult)block; // 注册
- (void)teardown; // 销毁

@end
