//
//  HLLoginController.m
//  WeChat
//
//  Created by 韩露露 on 16/10/2.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLoginController.h"
#import "HLOtherLoginController.h"



@interface HLLoginController ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)clickLogin;
- (IBAction)registe;
- (IBAction)otherLogin;
@end

@implementation HLLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 判断设备以及iPad横竖屏，调整登录框的大小。
    [self setupLoginViewSize];
    // 设置帐号显示
    [self setupUser];
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
    self.loginBtn.enabled = self.pwdField.text.length > 0 && self.userLabel.text.length > 0;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 设置输入框和按钮的背景图片。
    [self setupBackground];
}

// 设置输入框和按钮的背景图片。
- (void)setupBackground {
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.pwdField addLeftViewWithImage:@"Card_Lock"];
    
    [self.loginBtn setStretchedN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
}

// 设置帐号显示
- (void)setupUser {
    XMPPvCardTemp *vCardTemp = [HLXMPPTool sharedHLXMPPTool].vCarTemp.myvCardTemp;
    if (vCardTemp.photo) {
        self.icon.image = [UIImage imageWithData:vCardTemp.photo];
    }
    self.userLabel.text = [HLUserInfo sharedHLUserInfo].userName;
    self.pwdField.delegate = self;
}

- (IBAction)clickLogin {
    [self.view endEditing:NO];
    
    HLUserInfo *userInfo = [HLUserInfo sharedHLUserInfo];
    userInfo.pwd = self.pwdField.text; // [self.pwdField.text md5String];
    [userInfo saveUserInfoData];
    
    [super userLogin];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self clickLogin];
    return YES;
}

- (IBAction)registe {
    [self performSegueWithIdentifier:@"loginSegue" sender:@"register"];
}

- (IBAction)otherLogin {
    [self performSegueWithIdentifier:@"loginSegue" sender:@"otherLogin"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id dest = segue.destinationViewController;
    if ([dest isKindOfClass:UINavigationController.class]) {
        UINavigationController *destNav = dest;
        HLOtherLoginController *destVc = destNav.viewControllers.lastObject;
        if ([sender isEqualToString:@"register"]) {
            destVc.useType = HLUseRegister;
        } else if ([sender isEqualToString:@"otherLogin"]) {
            destVc.useType = HLUseOtherLogin;
        }
    }
}

- (void)dealloc {
    HLLog(@"HLLoginController");
}

@end
