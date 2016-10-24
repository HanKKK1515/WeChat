//
//  HLXMPPTool.m
//  倾聊
//
//  Created by 韩露露 on 2016/10/7.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLXMPPTool.h"
#import "XMPPReconnect.h"


@interface HLXMPPTool () <XMPPStreamDelegate, XMPPRosterDelegate> {
    HLLoginResult _loginBlock;
    HLLogoutResult _logoutBlock;
    HLRegisterResult _registerBlock;
}

@property (strong, nonatomic) XMPPReconnect *reconnect; // 自动连接模块
@property (strong, nonatomic) XMPPvCardCoreDataStorage *vCarStorage; // 名片数据存储
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
    self.stream.myJID = [XMPPJID jidWithUser:userName domain:self.domainName resource:@"iphone"];
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


#pragma mark - XMPPRosterDelegate
// 加好友回调函数
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    // available: 表示处于在线状态(通知好友在线)
    // unavailable: 表示处于离线状态（通知好友下线）
    // subscribe: 表示发出添加好友的申请（添加好友请求）
    // unsubscribe: 表示发出删除好友的申请（删除好友请求）
    // unsubscribed: 表示拒绝添加对方为好友（拒绝添加对方为好友）
    // error: 表示presence信息报中包含了一个错误消息。（出错）
    NSString *type = presence.type;
    // 发送请求者
    NSString *fromUser = [presence from].user;
    // 接收者
    NSString *toUser = [presence to].user;
    if ([fromUser isEqualToString:toUser]) {
        [SVProgressHUD showErrorWithStatus:@"不能加自己为好友！"];
        return;
    }
    
    if ([type isEqualToString:@"subscribe"]) {
        HLLog(@"申请添加好友！");
    } else if ([type isEqualToString:@"unsubscribe"]) {
        HLLog(@"申请删除好友！");
        // 接受添加好友请求,发送type=@"subscribed"表示已经同意添加好友请求并添加到好友花名册中
        [self.roster acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
    } else if ([type isEqualToString:@"unsubscribed"]) {
        HLLog(@"拒绝添加好友！");
    }
}

// 添加好友同意后调用
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterPush:(XMPPIQ *)iq {
    NSLog(@"添加成功!!!didReceiveRosterPush -> :%@",iq.description);
    
    DDXMLElement *query = [iq elementsForName:@"query"][0];
    DDXMLElement *item = [query elementsForName:@"item"][0];
    
    NSString *subscription = [[item attributeForName:@"subscription"] stringValue];
    // 对方请求添加我为好友且我已同意
    if ([subscription isEqualToString:@"from"]) {// 对方关注我
        NSLog(@"我已同意对方添加我为好友的请求");
    }
    // 我成功添加对方为好友
    else if ([subscription isEqualToString:@"to"]) {// 我关注对方
        NSLog(@"我成功添加对方为好友，即对方已经同意我添加好友的请求");
    } else if ([subscription isEqualToString:@"remove"]) {
        
    }
}

// 已经互为好友以后调用
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item {
    NSString *subscription = [item attributeStringValueForName:@"subscription"];
    if ([subscription isEqualToString:@"both"]) {
        NSLog(@"双方已经互为好友");
    }
}

- (void)teardown {
    // 移除代理
    [self.stream removeDelegate:self];
    // 终止激活状态
    [self.vCarTemp deactivate];
    [self.vCarAvatar deactivate];
    [self.reconnect deactivate];
    [self.roster deactivate];
    [self.messageArchiving deactivate];
    // 断开连接
    [self.stream disconnect];
    // 清空资源
    self.stream = nil;
    self.vCarStorage = nil;
    self.vCarAvatar = nil;
    self.vCarTemp = nil;
    self.reconnect = nil;
    self.roster = nil;
    self.rosterStorage = nil;
    self.messageArchiving = nil;
    self.messageStorage = nil;
}

#pragma mark - 添加模块

- (XMPPStream *)stream {
    if (!_stream) {
        _stream = [[XMPPStream alloc] init];
        _stream.hostName = self.domainName;
        _stream.hostPort = 5222;
        [_stream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        
        [self vCarTemp]; // 关联名片模块并激活
        [self vCarAvatar]; // 关联头像模块并激活
        [self reconnect]; // 关联自动连接模块
        [self roster]; // 关联花名册模块
        [self messageArchiving]; // 关联消息模块
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

- (XMPPReconnect *)reconnect {
    if (!_reconnect) {
        _reconnect = [[XMPPReconnect alloc] init];
        [_reconnect activate:self.stream];
    }
    return _reconnect;
}

- (XMPPRosterCoreDataStorage *)rosterStorage {
    if (!_rosterStorage) {
        _rosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    }
    return _rosterStorage;
}

- (XMPPRoster *)roster {
    if (!_roster) {
        _roster = [[XMPPRoster alloc] initWithRosterStorage:self.rosterStorage];
        [_roster activate:self.stream];
    }
    return _roster;
}

- (XMPPMessageArchivingCoreDataStorage *)messageStorage {
    if (!_messageStorage) {
        _messageStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    }
    return _messageStorage;
}

- (XMPPMessageArchiving *)messageArchiving {
    if (!_messageArchiving) {
        _messageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:self.messageStorage];
        [_messageArchiving activate:self.stream];
    }
    return _messageArchiving;
}

- (NSString *)domainName {
    return @"hllmac.local";
}

@end
