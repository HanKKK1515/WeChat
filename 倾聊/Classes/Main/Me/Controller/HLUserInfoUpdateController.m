//
//  HLUserInfoUpdateController.m
//  倾聊
//
//  Created by 韩露露 on 2016/10/14.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLUserInfoUpdateController.h"

@interface HLUserInfoUpdateController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *save;
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)back:(UIBarButtonItem *)sender;
- (IBAction)clickSave:(UIBarButtonItem *)sender;
@end

@implementation HLUserInfoUpdateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.textField.delegate = self;
    
    self.title = self.cell.textLabel.text;
    
    self.textField.text = self.cell.detailTextLabel.text;
    [self.textField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickSave:(UIBarButtonItem *)sender {
    if (self.updateCellType == HLUpdateCellTypePhone && !self.textField.isTelphoneNum) {
        [SVProgressHUD showErrorWithStatus:@"电话号码格式不正确！"];
        return;
    } else if (self.updateCellType == HLUpdateCellTypeMail && !self.textField.isMailbox) {
        [SVProgressHUD showErrorWithStatus:@"邮箱格式不正确！"];
        return;
    }
    
    self.cell.detailTextLabel.text = self.textField.text;
    if ([self.delegate respondsToSelector:@selector(userInfoDidChange)]) {
        [self.delegate userInfoDidChange];
    }
    [self back:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self clickSave:nil];
    return YES;
}

- (void)textFieldDidChange {
    self.save.enabled = self.textField.text.length > 0;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
