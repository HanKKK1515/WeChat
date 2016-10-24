//
//  UIInputView+HL.h
//  WeChat
//
//  Created by 韩露露 on 2016/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIInputView (HL)

// 获取键盘高度
+ (CGSize)getKeyboardDefaultSize;

// 获取数字键盘高度
+ (CGSize)getKeyboardNumberSize;

@end

/**
 * 高度值其实就只有两种类型，一个是Default一个是Number
 * ①以下几种键盘类型几乎一样，键盘高度也是一样的
 * UIKeyboardTypeAlphabet
 *
 * UIKeyboardTypeASCIICapable
 * UIKeyboardTypeDefault
 * UIKeyboardTypeEmailAddress
 * UIKeyboardTypeNamePhonePad
 * UIKeyboardTypeNumbersAndPunctuation（数字和标点符号）
 * UIKeyboardTypeTwitter
 * UIKeyboardTypeURL
 * UIKeyboardTypeWebSearch
 * 12.9吋: 768 * 1024 = 313; 1024 * 768 = 398;
 * 9.7 吋: 768 * 1024 = 313; 1024 * 768 = 398;
 * 7.9 吋: 768 * 1024 = 313; 1024 * 768 = 398;
 * 5.5 吋: 414 * 736 = 271; 736 * 414 = 194;
 * 4.7 吋: 375 * 667 = 258; 667 * 375 = 194;
 * 4.0 吋: 320 * 568 = 253; 568 * 320 = 193;
 *
 * ②以下几种键盘为数字类型的键盘，键盘高度也是一样的
 * UIKeyboardTypeDecimalPad（带小数点的数字键盘）
 * UIKeyboardTypeNumberPad（纯数字键盘）
 * UIKeyboardTypePhonePad（带*+#,;的数字键盘）
 * 12.9吋: 768 * 1024 = 313; 1024 * 768 = 398;
 * 9.7 吋: 768 * 1024 = 313; 1024 * 768 = 398;
 * 7.9 吋: 768 * 1024 = 313; 1024 * 768 = 398;
 * 5.5 吋: 414 * 736 = 226; 736 * 414 = 162;
 * 4.7 吋: 375 * 667 = 216; 667 * 375 = 162;
 * 4.0 吋: 320 * 568 = 216; 568 * 320 = 162;
 */
