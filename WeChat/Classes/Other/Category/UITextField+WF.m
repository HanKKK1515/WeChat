//
//  UITextField+WF.m
//  WeiXin
//
//  Created by Yong Feng Guo on 14-11-21.
//  Copyright (c) 2014年 Fung. All rights reserved.
//

#import "UITextField+WF.h"
#import <objc/message.h>


@implementation UITextField (WF)

- (void)addLeftViewWithImage:(NSString *)image {
    // 密码输入框左边图片
    UIImageView *lockIv = [[UIImageView alloc] init];
    // 设置尺寸
    CGRect imageBound = self.bounds;
    // 宽度高度一样
    imageBound.size.width = imageBound.size.height;
    lockIv.bounds = imageBound;
    // 设置图片
    lockIv.image = [UIImage imageNamed:image];
    // 设置图片居中显示
    lockIv.contentMode = UIViewContentModeCenter;
    // 添加TextFiled的左边视图
    self.leftView = lockIv;
    // 设置TextField左边的总是显示
    self.leftViewMode = UITextFieldViewModeAlways;
}

// 电话号码简单判断
- (BOOL)isTelphoneNum {
    NSString *telRegex = @"^1[3578]\\d{9}$";
    NSPredicate *prediate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    return [prediate evaluateWithObject:self.text];
}

// 邮箱简单判断
- (BOOL)isMailbox {
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [emailTest evaluateWithObject:self.text];
}

// 只要此类被项目引用，程序启动时就会调用这个方法,在此方法中设置交换方法，扩充类功能。
+ (void)load {
    Method initWithFrame = class_getInstanceMethod(self, sel_getUid("initWithFrame:"));
    Method hl_initWithFrame = class_getInstanceMethod(self, sel_getUid("hl_initWithFrame:"));
    
    // 交换两个方法的实现部分。
    // 即调用initWithFrame就会执行hl_initWithFrame的实现，调用hl_initWithFrame就会执行initWithFrame的实现。
    method_exchangeImplementations(initWithFrame, hl_initWithFrame);
    
    Method initWithCoder = class_getInstanceMethod(self, sel_getUid("initWithCoder:"));
    Method hl_initWithCoder = class_getInstanceMethod(self, sel_getUid("hl_initWithCoder:"));
    method_exchangeImplementations(initWithCoder, hl_initWithCoder);
    
}

- (instancetype)hl_initWithFrame:(CGRect)frame {
    [self setupInitializeData];
    return [self hl_initWithFrame:frame];
}

- (instancetype)hl_initWithCoder:(NSCoder *)aDecoder {
    [self setupInitializeData];
    return [self hl_initWithCoder:aDecoder];
}

// 初始化时监听文字的改变
- (void)setupInitializeData {
    self.hans = -1;
    self.other = -1;
    [self addTarget:self action:@selector(searchDidChange:) forControlEvents:UIControlEventEditingChanged];
}

// 限制输入汉字和字符长度
- (void)limitHansLength:(int)hans otherLength:(int)other {
    self.hans = hans; // 设置中文状态下的限制字数
    self.other = other; // 设置状态下的限制字数
}

- (void)searchDidChange:(UITextField *)textField {
    // 判断输入状态是否为英文
    if (![textField.textInputMode.primaryLanguage isEqualToString:@"en-US"]) {
        // 过滤掉输入时高亮状态下的情况
        if (!textField.markedTextRange && (self.hans >= 0) && (textField.text.length > self.hans)) {
            [self setCaretPositionWithTextField:textField limit:self.hans];
        }
    } else { // 英文输入状态下
        if ((self.other >= 0) && (textField.text.length > self.other)) {
            [self setCaretPositionWithTextField:textField limit:self.other];
        }
    }
}

- (void)setCaretPositionWithTextField:(UITextField *)textField limit:(NSUInteger)length {
    UITextPosition *selectedPosition = textField.selectedTextRange.start; // 拿到截取之前的光标位置
    textField.text = [textField.text substringToIndex:length]; // 截取限制字数以内的文本
    textField.selectedTextRange = [textField textRangeFromPosition:selectedPosition toPosition:selectedPosition]; // 恢复光标的位置
}

- (void)setHans:(NSInteger)hans {
    // id object：给哪个对象添加属性。
    // const void *key：属性名称。
    // id value：属性值。
    // objc_AssociationPolicy policy：属性的保存策略，是一个枚举，相当于assign、retain、copy等。
    objc_setAssociatedObject(self, @"hans", @(hans), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)hans {
    return [objc_getAssociatedObject(self, @"hans") integerValue];
}

- (void)setOther:(NSInteger)other {
    objc_setAssociatedObject(self, @"other", @(other), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)other {
    return [objc_getAssociatedObject(self, @"other") integerValue];
}

@end
