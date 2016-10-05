//
//  HLOtherLoginController.m
//  WeChat
//
//  Created by 韩露露 on 16/10/2.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLOtherLoginController.h"


@interface HLOtherLoginController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBtn;

- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)clickLogin;

@end

@implementation HLOtherLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    HLUserInfo *userInfo = [HLUserInfo sharedHLUserInfo];
    if (userInfo.userName.length == 0 && userInfo.pwd.length == 0) {
        self.cancelBtn.enabled = NO;
        self.cancelBtn.title = @"";
    } else {
        self.cancelBtn.enabled = YES;
        self.cancelBtn.title = @"取消";
    }
    
    // 判断设备以及iPad横竖屏，调整登录框的大小。
    [self statusBarOrientationDidChange];
    // 设置输入框和按钮的背景图片。
    [self setupBackground];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationDidChange) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

// 判断设备以及iPad横竖屏，调整登录框的大小。
- (void)statusBarOrientationDidChange {
    UIUserInterfaceIdiom userInterfaceIdiom = [UIDevice currentDevice].userInterfaceIdiom;
    if (userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftConstraint.constant = loginLeftMarginPhone;
        self.rightConstraint.constant = loginRightMarginPhone;
    } else if (userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
        switch (statusBarOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                self.leftConstraint.constant = loginLeftMarginPadH;
                self.rightConstraint.constant = loginRightMarginPadH;
                break;
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
                self.leftConstraint.constant = loginLeftMarginPadV;
                self.rightConstraint.constant = loginRightMarginPadV;
                break;
            default:
                break;
        }
    }
}

// 设置输入框和按钮的背景图片。
- (void)setupBackground {
    self.userField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.loginBtn setStretchedN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    self.userField.delegate = self;
    self.pwdField.delegate = self;
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickLogin {
    [self.view endEditing:NO];
    
    HLUserInfo *userInfo = [HLUserInfo sharedHLUserInfo];
    userInfo.userName = self.userField.text;
    userInfo.pwd = self.pwdField.text;
    [userInfo saveUserInfoData];
    
    [SVProgressHUD showWithStatus:@"正在登录。。。"];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app userLogin:^(HLLoginResultType result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (result) {
                case HLLoginResultFailure:
                    [self loginFailure];
                    break;
                case HLLoginResultSuccess: // 跳到主界面
                    [self loginSuccess];
                    break;
                case HLLoginResultNetError:
                    [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
            }
        });
    }];
}

- (void)loginFailure {
    [SVProgressHUD showErrorWithStatus:@"登录失败，帐号或者密码错误。"];
    HLUserInfo *userInfo = [HLUserInfo sharedHLUserInfo];
    userInfo.pwd = @"";
    [userInfo saveUserInfoData];
}

- (void)loginSuccess {
    self.view.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.userField]) {
        [self.pwdField becomeFirstResponder];
    } else if ([textField isEqual:self.pwdField]) {
        [self clickLogin];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    HLLog(@"HLOtherLoginController");
}

@end
