//
//  AppDelegate.m
//  WeChat
//
//  Created by 韩露露 on 16/10/1.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "AppDelegate.h"
#import <XMPPFramework/XMPPFramework.h>
#import "SVProgressHUD.h"

@interface AppDelegate () <XMPPStreamDelegate> {
    HLLoginResult _loginBlock;
    HLLogoutResult _logoutBlock;
}

@property (strong, nonatomic) XMPPStream *stream;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    return YES;
}

- (void)userLogin:(HLLoginResult)block {
    _loginBlock = block;
    // 从沙盒中获取用户名和密码。
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    self.stream.myJID = [XMPPJID jidWithUser:userName domain:@"hllmac.local" resource:@"iphone"];
    // 连接至服务器。
    NSError *error = nil;
    if (![self.stream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        printf("连接服务器出错：%s\n", error.localizedDescription.UTF8String);
    }
}

#pragma mark - XMPPStreamDelegate

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    printf("连接服务器成功\n");
    // 发送密码
    NSString *userPwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPwd"];
    NSError *error = nil;
    if (![self.stream authenticateWithPassword:userPwd error:&error]) {
        printf("密码验证失败\n");
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    printf("密码验证成功\n");
    if (_loginBlock) {
        _loginBlock(HLLoginResultSuccess);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 加载首页storyboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = storyboard.instantiateInitialViewController;
    });
    // 发送在线状态
    XMPPPresence *presence = [XMPPPresence presence];
    [self.stream sendElement:presence];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    printf("密码验证失败\n");
    if (_loginBlock) {
        _loginBlock(HLLoginResultFailure);
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    printf("已断开服务器\n");
}

- (void)userLogout:(HLLogoutResult)block {
    _logoutBlock = block;
    // 发送离线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.stream sendElement:presence];
    // 与服务器断开连接
    [self.stream disconnect];
}

- (XMPPStream *)stream {
    if (!_stream) {
        _stream = [[XMPPStream alloc] init];
        [_stream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    return _stream;
}

@end
