//
//  HLUserInfo.m
//  WeChat
//
//  Created by 韩露露 on 16/10/5.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLUserInfo.h"

@implementation HLUserInfo

static HLUserInfo *_userInfo = nil;

singleton_implementation(HLUserInfo);

- (void)loadUserInfoData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    HLUserInfo *userInfo = [HLUserInfo sharedHLUserInfo];
    userInfo.userName = [defaults objectForKey:@"userName"];
    userInfo.pwd = [defaults objectForKey:@"pwd"];
    userInfo.previousUserName = [defaults objectForKey:@"previousUserName"];
    userInfo.photo = [defaults objectForKey:@"photo"];
    userInfo.keyboardHeight = [defaults floatForKey:@"keyboardHeight"];
}

- (void)saveUserInfoData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.userName forKey:@"userName"];
        [defaults setObject:self.pwd forKey:@"pwd"];
        [defaults setObject:self.previousUserName forKey:@"previousUserName"];
        [defaults setObject:self.photo forKey:@"photo"];
        [defaults setFloat:self.keyboardHeight forKey:@"keyboardHeight"];
        [defaults synchronize];
    });
}

@end
