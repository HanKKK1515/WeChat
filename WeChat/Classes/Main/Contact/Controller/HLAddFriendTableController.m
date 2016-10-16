//
//  HLAddFriendTableController.m
//  WeChat
//
//  Created by 韩露露 on 2016/10/16.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLAddFriendTableController.h"

@interface HLAddFriendTableController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

- (IBAction)back:(UIBarButtonItem *)sender;
- (IBAction)search;
@end

@implementation HLAddFriendTableController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.searchField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupBackground];
}

// 设置输入框和按钮的背景图片。
- (void)setupBackground {
    self.searchField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.searchField addLeftViewWithImage:@"add_friend_searchicon"];
    self.searchField.delegate = self;
    
    [self.searchBtn setStretchedN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)search {
    if (![self.searchField isTelphoneNum]) {
        [SVProgressHUD showErrorWithStatus:@"手机号码格式不正确！"];
        return;
    }
    
    if ([self.searchField.text isEqualToString:[HLUserInfo sharedHLUserInfo].userName]) {
        [SVProgressHUD showErrorWithStatus:@"不能添加自己为好友！"];
        return;
    }
    
    HLXMPPTool *xmppTool = [HLXMPPTool sharedHLXMPPTool];
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@", self.searchField.text, xmppTool.domainName];
    XMPPJID *friendJID = [XMPPJID jidWithString:jidStr];
    
    if ([xmppTool.rosterStorage userExistsWithJID:friendJID xmppStream:xmppTool.stream]) {
        [SVProgressHUD showErrorWithStatus:@"已是好友！"];
        return;
    }
    
    [xmppTool.roster subscribePresenceToUser:friendJID];
    [SVProgressHUD showSuccessWithStatus:@"添加成功！"];
    [self back:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    [self search];
    return YES;
}

@end
