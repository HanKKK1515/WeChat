//
//  HLChatViewController.m
//  倾聊
//
//  Created by 韩露露 on 2016/10/19.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLChatViewController.h"
#import "HLChatViewCell.h"
#import "HLCustomKeyboard.h"


@interface HLChatViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UITextViewDelegate, HLCustomKeyboardDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *emotionBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottom; // 输入框下面的底线
@property (strong, nonatomic) NSFetchedResultsController *resultController;
@property (assign, nonatomic) CGRect keyboardFrame; // 键盘的Frame
@property (strong, nonatomic) HLCustomKeyboard *customKeyboard; // 用Xib自定义的键盘
@property (assign, nonatomic, getter = isShowKeyboard) BOOL showKeyboard; // 键盘是否已经显示

- (IBAction)back:(UIBarButtonItem *)sender;
- (IBAction)voiceOrText;
- (IBAction)emotionOrText;
- (IBAction)moreOrText;
@end

@implementation HLChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.jid.user;
    self.textView.delegate = self;
    self.textView.layoutManager.allowsNonContiguousLayout = NO; // 防止输入多行时文字上下跳跃
    
    self.bottom.backgroundColor = HLColor(61, 187, 3, 1);
    
    [self setupKeyboardFrame];
    
    [UIInputView getKeyboardDefaultSize];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupKeyboardFrame {
    HLUserInfo *userInfo = [HLUserInfo sharedHLUserInfo];
    if (userInfo.keyboardHeight <= 0) {
        CGFloat keyboardH = [UIInputView getKeyboardDefaultSize].height;
        userInfo.keyboardHeight = keyboardH;
        [userInfo saveUserInfoData];
        self.keyboardFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, keyboardH);
    } else {
        self.keyboardFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, userInfo.keyboardHeight);
    }
}

- (void)keyboardWillChange:(NSNotification *)notif {
    NSDictionary *userInfo = notif.userInfo;
    self.keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (self.view.h == self.keyboardFrame.origin.y) {
        [self restoreKeyboard];
    }
    
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.bottomConstraint.constant = self.view.h - self.keyboardFrame.origin.y;
    } completion:^(BOOL finished) {
        [self scrollToBottom];
    }];
    
    HLUserInfo *user = [HLUserInfo sharedHLUserInfo];
    user.keyboardHeight = self.keyboardFrame.size.height;
    [user saveUserInfoData];
}

// 还原到系统键盘
- (void)restoreKeyboard {
    self.textView.inputView = nil;
    self.customKeyboard.keyboardType = HLKeyboardStatusSystem;
    [self.voiceBtn setN_Image:@"ToolViewInputVoice" H_Image:@"ToolViewInputVoiceHL"];
    [self.emotionBtn setN_Image:@"ToolViewEmotion" H_Image:@"ToolViewEmotionHL"];
    [self.moreBtn setN_Image:@"TypeSelectorBtn_Black" H_Image:@"TypeSelectorBtnHL_BlackHL"];
}

- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)voiceOrText {
    if (self.bottomConstraint.constant) {
        [self.textView resignFirstResponder];
        [self.voiceBtn setN_Image:@"ToolViewInputText" H_Image:@"ToolViewInputTextHL"];
    } else {
        [self.textView becomeFirstResponder];
        [self.voiceBtn setN_Image:@"ToolViewInputVoice" H_Image:@"ToolViewInputVoiceHL"];
    }
    [self.emotionBtn setN_Image:@"ToolViewEmotion" H_Image:@"ToolViewEmotionHL"];
    [self.moreBtn setN_Image:@"TypeSelectorBtn_Black" H_Image:@"TypeSelectorBtnHL_BlackHL"];
}

- (IBAction)emotionOrText {
    [self changeKeyboardType:HLKeyboardStatusEmotion button:self.emotionBtn imageName:@"ToolViewEmotion" imageNameHL:@"ToolViewEmotionHL"];
    [self.voiceBtn setN_Image:@"ToolViewInputVoice" H_Image:@"ToolViewInputVoiceHL"];
    [self.moreBtn setN_Image:@"TypeSelectorBtn_Black" H_Image:@"TypeSelectorBtnHL_Black"];
}

- (IBAction)moreOrText {
    [self changeKeyboardType:HLKeyboardStatusMore button:self.moreBtn imageName:@"TypeSelectorBtn_Black" imageNameHL:@"TypeSelectorBtnHL_Black"];
    [self.voiceBtn setN_Image:@"ToolViewInputVoice" H_Image:@"ToolViewInputVoiceHL"];
    [self.emotionBtn setN_Image:@"ToolViewEmotion" H_Image:@"ToolViewEmotionHL"];
}

// 判断键盘的显示类型
- (void)changeKeyboardType:(HLKeyboardStatusType)type button:(UIButton *)btn imageName:(NSString *)name imageNameHL:(NSString *)nameHL {
    if (self.customKeyboard.keyboardType == HLKeyboardStatusSystem) {
        [self.textView resignFirstResponder];
        
        if (type == HLKeyboardStatusSystem) {
            
        } else if (type == HLKeyboardStatusEmotion) {
            [btn setN_Image:@"ToolViewInputText" H_Image:@"ToolViewInputTextHL"];
            self.customKeyboard.keyboardType = HLKeyboardStatusEmotion;
        } else if (type == HLKeyboardStatusMore) {
            [btn setN_Image:@"ToolViewInputText" H_Image:@"ToolViewInputTextHL"];
            self.customKeyboard.keyboardType = HLKeyboardStatusMore;
        }
        self.textView.inputView = self.customKeyboard;
        self.customKeyboard.frame = self.keyboardFrame;
        
        [self.textView becomeFirstResponder];
    } else if (self.customKeyboard.keyboardType == HLKeyboardStatusEmotion) {
        if (type == HLKeyboardStatusSystem) {
            
        } else if (type == HLKeyboardStatusEmotion) {
            [self.textView resignFirstResponder];
            
            [btn setN_Image:name H_Image:nameHL];
            self.customKeyboard.keyboardType = HLKeyboardStatusSystem;
            self.textView.inputView = nil;
            
            [self.textView becomeFirstResponder];
        } else if (type == HLKeyboardStatusMore) {
            [btn setN_Image:@"ToolViewInputText" H_Image:@"ToolViewInputTextHL"];
            self.customKeyboard.keyboardType = HLKeyboardStatusMore;
        }
    } else if (self.customKeyboard.keyboardType == HLKeyboardStatusMore) {
        if (type == HLKeyboardStatusSystem) {
            
        } else if (type == HLKeyboardStatusEmotion) {
            [btn setN_Image:@"ToolViewInputText" H_Image:@"ToolViewInputTextHL"];
            self.customKeyboard.keyboardType = HLKeyboardStatusEmotion;
        } else if (type == HLKeyboardStatusMore) {
            [self.textView resignFirstResponder];
            
            [btn setN_Image:name H_Image:nameHL];
            self.customKeyboard.keyboardType = HLKeyboardStatusSystem;
            self.textView.inputView = nil;
            
            [self.textView becomeFirstResponder];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scrollToBottom];
}

#pragma mark - UITableView数据源和代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMPPMessageArchiving_Message_CoreDataObject *msgObj = self.resultController.fetchedObjects[indexPath.row];
    BOOL show = YES;
    if (indexPath.row > 0) {
        XMPPMessageArchiving_Message_CoreDataObject *previousMsgObj = self.resultController.fetchedObjects[indexPath.row -1];
        if ([msgObj.timestamp timeIntervalSinceDate:previousMsgObj.timestamp] < 180) {
            show = NO;
        }
    }
    return [HLChatViewCell cellWithTableView:tableView indexPath:indexPath msgArchivingObj:msgObj showTime:show];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSString *text = textView.text;
    if ([text isEqualToString:@"\n"]) {
        [SVProgressHUD showErrorWithStatus:@"不能发送空的内容！"];
        textView.text = nil;
        return;
    }
    
    if (text.length > 0 && [[text substringFromIndex:text.length - 1] isEqualToString:@"\n"]) {
        XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.jid];
        [msg addBody:[textView.text substringToIndex:text.length -1]];
        [[HLXMPPTool sharedHLXMPPTool].stream sendElement:msg];
        textView.text = nil;
    }
    
    CGFloat textViewHeight = textView.contentSize.height;
    if (textViewHeight <= 60 && textViewHeight >= 34) {
        self.textViewHeightConstraint.constant = textViewHeight;
        [textView scrollRangeToVisible:NSMakeRange(0,0)];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if ([anObject isMemberOfClass:XMPPMessageArchiving_Message_CoreDataObject.class]) {
        XMPPMessageArchiving_Message_CoreDataObject *msgObj = anObject;
        if (msgObj.body.length > 0) {
            [self.tableView reloadData];
            [self scrollToBottom];
        }
    }
}

- (void)scrollToBottom {
    NSInteger lastRow = self.resultController.fetchedObjects.count - 1;
    if (lastRow > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


#pragma mark - HLCustomKeyboardDelegate

- (void)customKeyboard:(HLCustomKeyboard *)customKeyboard didSelectItem:(NSString *)imageName {
    NSLog(@"%@", imageName);
}

/**
 *  懒加载
 */
- (NSFetchedResultsController *)resultController {
    if (!_resultController) {
        HLXMPPTool *tool = [HLXMPPTool sharedHLXMPPTool];
        
        NSManagedObjectContext *context = tool.messageStorage.mainThreadManagedObjectContext;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
        
        NSString *freind = [NSString stringWithFormat:@"%@@%@", self.jid.user, tool.domainName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@", freind];
        request.predicate = predicate;
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
        request.sortDescriptors = @[sort];
        
        _resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        _resultController.delegate = self;
        NSError *error = nil;
        if (![_resultController performFetch:&error]) {
            HLLog(@"获取聊天数据失败：%@", error.localizedDescription);
        }
    }
    return _resultController;
}

- (HLCustomKeyboard *)customKeyboard {
    if (!_customKeyboard) {
        _customKeyboard = [HLCustomKeyboard keyboard];
        _customKeyboard.delegate = self;
        _customKeyboard.keyboardType = HLKeyboardStatusSystem;
    }
    return _customKeyboard;
}

@end
