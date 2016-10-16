//
//  HLOtherLoginController.m
//  WeChat
//
//  Created by 韩露露 on 16/10/2.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLOtherLoginController.h"


@interface HLOtherLoginController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *registerBtn;

- (IBAction)cancel;
- (IBAction)clickRegister:(UIBarButtonItem *)sender;
- (IBAction)clickLogin;
@end

@implementation HLOtherLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 根据控制器的用途设置界面
    [self setupVC];
    // 判断设备以及iPad横竖屏，调整登录框的大小。
    [self setupLoginViewSize];
    // 设置输入框和按钮的背景图片。
    [self setupBackground];
    
    [self.userField becomeFirstResponder];
}

// 根据控制器的用途设置界面
- (void)setupVC {
    if (self.useType == HLUseRegister) {
        self.cancelBtn.hidden = NO;
        self.registerBtn.title = @"登录";
        [self.loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    } else if (self.useType == HLUseOtherLogin) {
        self.cancelBtn.hidden = NO;
        self.registerBtn.title = @"注册";
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    } else if (self.useType == HLUseFirstLogin) {
        self.cancelBtn.hidden = YES;
        self.registerBtn.title = @"注册";
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
}

// 判断设备以及iPad横竖屏，调整登录框的大小。
- (void)setupLoginViewSize {
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
            default:
                self.leftConstraint.constant = loginLeftMarginPadV;
                self.rightConstraint.constant = loginRightMarginPadV;
                break;
        }
    }
}

// 设置按钮状态
- (void)textFieldDidChange {
    self.loginBtn.enabled = self.pwdField.text.length > 0 && self.userField.text.length > 0;
}
// 设置输入框和按钮的背景图片。
- (void)setupBackground {
    self.userField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    UIView *leftUserView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, self.userField.h)];
    UIView *LeftPwdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, self.pwdField.h)];
    self.userField.leftView = leftUserView;
    self.pwdField.leftView = LeftPwdView;
    self.userField.leftViewMode = UITextFieldViewModeAlways;
    self.pwdField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.loginBtn setStretchedN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    self.userField.delegate = self;
    self.pwdField.delegate = self;
}

- (IBAction)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickRegister:(UIBarButtonItem *)sender {
    BOOL isRegister = [sender.title isEqualToString:@"注册"];
    sender.title = isRegister ? @"登录" : @"注册";
    [self.loginBtn setTitle:isRegister ? @"注册" : @"登录" forState:UIControlStateNormal];
    if (isRegister) {
        self.useType = HLUseRegister;
    } else {
        self.useType = HLUseOtherLogin;
    }
}

- (IBAction)clickLogin {
    [self.view endEditing:NO];
    if (![self.userField isTelphoneNum]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码！"];
        return;
    }
    
    HLUserInfo *userInfo = [HLUserInfo sharedHLUserInfo];
    userInfo.previousUserName = userInfo.userName;
    userInfo.userName = self.userField.text;
    userInfo.pwd = self.pwdField.text; // [self.pwdField.text md5String];
    [userInfo saveUserInfoData];
    
    if (self.useType == HLUseFirstLogin || self.useType == HLUseOtherLogin) {
        [super userLogin];
    } else {
        [super userRegister];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.userField]) {
        [self.pwdField becomeFirstResponder];
    } else if ([textField isEqual:self.pwdField]) {
        [self clickLogin];
    }
    return YES;
}

- (void)setUseType:(HLUseType)useType {
    _useType = useType;
}

- (void)dealloc {
    HLLog(@"HLOtherLoginController");
}

@end
