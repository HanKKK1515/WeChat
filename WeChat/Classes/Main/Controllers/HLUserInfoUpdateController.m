//
//  HLUserInfoUpdateController.m
//  WeChat
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
    UIView *leftUserView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, self.textField.h)];
    self.textField.leftView = leftUserView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
