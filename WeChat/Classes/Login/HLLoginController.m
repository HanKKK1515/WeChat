//
//  HLLoginController.m
//  WeChat
//
//  Created by 韩露露 on 16/10/2.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLoginController.h"
#import "CategoryWF.h"

@interface HLLoginController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)clickLogin;
@end

@implementation HLLoginController

static const CGFloat loginLeftMarginPhone = 20;
static const CGFloat loginRightMarginPhone = 20;
static const CGFloat loginLeftMarginPadV = 100;
static const CGFloat loginRightMarginPadV = 100;
static const CGFloat loginLeftMarginPadH = 200;
static const CGFloat loginRightMarginPadH = 200;

- (void)viewDidLoad {
    [super viewDidLoad];
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
            default:
                self.leftConstraint.constant = loginLeftMarginPadV;
                self.rightConstraint.constant = loginRightMarginPadV;
                break;
        }
    }
}

// 设置输入框和按钮的背景图片。
- (void)setupBackground {
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.loginBtn setStretchedN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)clickLogin {
    
}

@end
