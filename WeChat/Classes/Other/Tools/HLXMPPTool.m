//
//  HLXMPPTool.m
//  WeChat
//
//  Created by 韩露露 on 2016/10/7.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLXMPPTool.h"
#import <XMPPFramework/XMPPFramework.h>
#import "XMPPvCardCoreDataStorage.h" // 本地CoreData名片信息的存储
#import "XMPPvCardTempModule.h" // 电子名片的获取和读取


@interface HLXMPPTool () <XMPPStreamDelegate> {
    HLLoginResult _loginBlock;
    HLLogoutResult _logoutBlock;
    HLRegisterResult _registerBlock;
}

@property (strong, nonatomic) XMPPStream *stream;
@property (strong, nonatomic) XMPPvCardAvatarModule *vCarAvatar;
@property (strong, nonatomic) XMPPvCardTempModule *vCarTemp;
@property (strong, nonatomic) XMPPvCardCoreDataStorage *vCarStorage;

@end

@implementation HLXMPPTool

singleton_implementation(HLXMPPTool);

#pragma mark - 用户登录
- (void)userLogin:(HLLoginResult)block {
    _loginBlock = block;
    self.stream.tag = @"login";
    [self connectHost];
}

#pragma mark - 用户注册
- (void)userRegister:(HLRegisterResult)block {
    _registerBlock = block;
    self.stream.tag = @"register";
    [self connectHost];
}

#pragma mark - 用户注销
- (void)userLogout:(HLLogoutResult)block {
    _logoutBlock = block;
    if ([self.stream isDisconnected]) {
        if (_logoutBlock) _logoutBlock(HLLogoutResultNetError);
    } else {
        // 发送离线状态
        XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
        [self.stream sendElement:presence];
        // 与服务器断开连接
        [self.stream disconnect];
        if (_logoutBlock) return _logoutBlock(HLLogoutResultSuccess);
    }
}

- (void)connectHost {
    [self.stream disconnect];
    NSString *userName = [HLUserInfo sharedHLUserInfo].userName;
    self.stream.myJID = [XMPPJID jidWithUser:userName domain:@"hllmac.local" resource:@"iphone"];
    // 连接至服务器。
    NSError *error = nil;
    if (![self.stream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        HLLog(@"连接服务器出错：%@", error.localizedDescription);
    }
}

#pragma mark - XMPPStreamDelegate
// 连接服务器成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    HLLog(@"连接服务器成功\n");
    NSString *userPwd = [HLUserInfo sharedHLUserInfo].pwd;
    NSError *error = nil;
    // 发送密码
    if ([self.stream.tag isEqualToString:@"login"]) {
        [self.stream authenticateWithPassword:userPwd error:&error];
    } else if ([self.stream.tag isEqualToString:@"register"]) {
        [self.stream registerWithPassword:userPwd error:&error];
    }
    if (error) {
        NSLog(@"登录／注册失败：%@", error.localizedDescription);
    }
}

// 密码验证成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    HLLog(@"密码验证成功\n");
    if (_loginBlock) _loginBlock(HLLoginResultSuccess);
    // 发送在线状态
    XMPPPresence *presence = [XMPPPresence presence];
    [self.stream sendElement:presence];
}

// 密码验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    HLLog(@"密码验证失败:%@", error.description);
    if (_loginBlock) _loginBlock(HLLoginResultFailure);
}

// 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    HLLog(@"注册成功\n");
    if (_registerBlock) _registerBlock(HLRegisterResultSuccess);
}

// 注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error {
    HLLog(@"注册失败:%@", error);
    if (_registerBlock) _registerBlock(HLRegisterResultFailure);
}

// 已断开服务器
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    HLLog(@"已断开服务器:%@", error.localizedDescription);
    if (error) {
        if (_loginBlock) _loginBlock(HLLoginResultNetError);
        if (_logoutBlock) _logoutBlock(HLLogoutResultNetError);
        if (_registerBlock) _registerBlock(HLRegisterResultNetError);
    }
}

- (XMPPStream *)stream {
    if (!_stream) {
        _stream = [[XMPPStream alloc] init];
        _stream.hostName = @"hllmac.local";
        _stream.hostPort = 5222;
        [_stream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        
        [self vCarTemp];
        [self vCarAvatar];
    }
    return _stream;
}

- (XMPPvCardCoreDataStorage *)vCarStorage {
    if (!_vCarStorage) {
        _vCarStorage = [XMPPvCardCoreDataStorage sharedInstance];
    }
    return _vCarStorage;
}

- (XMPPvCardTempModule *)vCarTemp {
    if (!_vCarTemp) {
        _vCarTemp = [[XMPPvCardTempModule alloc] initWithvCardStorage:self.vCarStorage];
        [_vCarTemp activate:self.stream];
    }
    return _vCarTemp;
}

- (XMPPvCardAvatarModule *)vCarAvatar {
    if (!_vCarAvatar) {
        _vCarAvatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:self.vCarTemp];
        [_vCarAvatar activate:self.stream];
    }
    return _vCarAvatar;
}

@end
