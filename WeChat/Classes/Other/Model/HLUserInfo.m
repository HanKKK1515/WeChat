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
    HLUserInfo *userInfo = [HLUserInfo sharedHLUserInfo];
    userInfo.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    userInfo.pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
}

- (void)saveUserInfoData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.userName forKey:@"userName"];
        [defaults setObject:self.pwd forKey:@"pwd"];
        [defaults synchronize];
    });
}

@end