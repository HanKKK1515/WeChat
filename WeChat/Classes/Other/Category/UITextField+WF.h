//
//  UITextField+WF.h
//  WeiXin
//
//  Created by Yong Feng Guo on 14-11-21.
//  Copyright (c) 2014年 Fung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (WF)
@property NSInteger hans;
@property NSInteger other;
/**
 * 添加文件输入框左边的View,添加图片
 */
- (void)addLeftViewWithImage:(NSString *)image;

/**
 * 判断是否为手机号码
 */
- (BOOL)isTelphoneNum;

/**
 * 判断是否为邮箱
 */
- (BOOL)isMailbox;

/**
 * 限制输入汉字和字符长度
 */
- (void)limitHansLength:(int)hans otherLength:(int)other;
@end
