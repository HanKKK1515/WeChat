//
//  HLBaseLoginController.m
//  倾聊
//
//  Created by 韩露露 on 16/10/6.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLBaseLoginController.h"


@implementation HLBaseLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupLoginViewSize) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - 子类需重写的方法
- (void)setupLoginViewSize {
}

- (void)textFieldDidChange {
}

#pragma mark - 登录
- (void)userLogin {
    [SVProgressHUD showWithStatus:@"正在登录……"];
    __weak typeof(self) selfWeak = self;
    [[HLXMPPTool sharedHLXMPPTool] userLogin:^(HLLoginResultType result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (result) {
                case HLLoginResultFailure:
                    [selfWeak failureWithText:@"帐号或密码错误!"];
                    break;
                case HLLoginResultSuccess: // 跳到主界面
                    [selfWeak loginSuccess];
                    break;
                case HLLoginResultNetError:
                    [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                    break;
            }
        });
    }];
}

- (void)loginSuccess {
    self.view.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
    HLUserInfo *userInfo = [HLUserInfo sharedHLUserInfo];
    userInfo.photo = [HLXMPPTool sharedHLXMPPTool].vCarTemp.myvCardTemp.photo;
    userInfo.previousUserName = @"";
    [userInfo saveUserInfoData];
}


#pragma mark - 注册
- (void)userRegister {
    [SVProgressHUD showWithStatus:@"正在注册……"];
    __weak typeof(self) selfWeak = self;
    [[HLXMPPTool sharedHLXMPPTool] userRegister:^(HLRegisterResultType result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (result) {
                case HLRegisterResultFailure:
                    [selfWeak failureWithText:@"帐号被占用或不合法!"];
                    break;
                case HLRegisterResultSuccess:
                    [selfWeak registerSuccess];
                    break;
                case HLRegisterResultNetError:
                    [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                    break;
            }
        });
    }];
}

- (void)registerSuccess {
    [self userLogin];
}

- (void)failureWithText:(NSString *)text {
    [SVProgressHUD showErrorWithStatus:text];
    
    HLUserInfo *userInfo = [HLUserInfo sharedHLUserInfo];
    if (userInfo.previousUserName) {
        userInfo.userName = userInfo.previousUserName;
        userInfo.previousUserName = @"";
    }
    userInfo.pwd = @"";
    [userInfo saveUserInfoData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    HLLog(@"HLBaseLoginController");
}

@end
