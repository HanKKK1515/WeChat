//
//  HLMeTableController.m
//  WeChat
//
//  Created by 韩露露 on 16/10/4.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLMeTableController.h"

@interface HLMeTableController ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *wexinName;

- (IBAction)logout:(UIBarButtonItem *)sender;
@end

@implementation HLMeTableController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    XMPPvCardTemp *myVCardTemp = [HLXMPPTool sharedHLXMPPTool].vCarTemp.myvCardTemp;
    if (myVCardTemp.photo) {
        self.icon.image = [UIImage imageWithData:myVCardTemp.photo];
    }
    self.nickName.text = myVCardTemp.nickname;
    self.wexinName.text = [HLUserInfo sharedHLUserInfo].userName;
}

- (IBAction)logout:(UIBarButtonItem *)sender {
    __weak typeof(self) selfWeak = self;
    [[HLXMPPTool sharedHLXMPPTool] userLogout:^(HLLogoutResultType result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (result) {
                case HLLogoutResultSuccess: // 跳到登录界面
                    [selfWeak logoutSuccess];
                    break;
                case HLLogoutResultNetError:
                    [SVProgressHUD showErrorWithStatus:@"网络连接不稳定"];
                    break;
            }
        });
    }];
}

- (void)logoutSuccess {
    self.view.window.rootViewController = [UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController;
    HLUserInfo *userInfo = [HLUserInfo sharedHLUserInfo];
    userInfo.pwd = @"";
    [userInfo saveUserInfoData];
}

- (void)dealloc {
    HLLog(@"HLMeTableController");
}

@end
