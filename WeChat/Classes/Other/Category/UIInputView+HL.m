//
//  UIInputView+HL.m
//  WeChat
//
//  Created by 韩露露 on 2016/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "UIInputView+HL.h"

@implementation UIInputView (HL)

+ (CGSize)getKeyboardDefaultSize {
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (size.width == 768 && size.height == 1024) {
        size.height = 313; // iPad竖
    } else if (size.width == 1024 && size.height == 768) {
        size.height = 398; // iPad横
    } else if (size.width == 414 && size.height == 736) {
        size.height = 271; // 5.5竖
    } else if (size.width == 736 && size.height == 414) {
        size.height = 194; // 5.5横
    } else if (size.width == 375 && size.height == 667) {
        size.height = 258; // 4.7竖
    } else if (size.width == 667 && size.height == 375) {
        size.height = 194; // 4.7横
    } else if (size.width == 320 && size.height == 568) {
        size.height = 253; // 4.0竖
    } else if (size.width == 568 && size.height == 320) {
        size.height = 193; // 4.0横
    } else if (size.width < size.height) {
        size.height = 258; // 未知竖
    } else if (size.width > size.height) {
        size.height = 194; // 未知横
    }
    return size;
}

+ (CGSize)getKeyboardNumberSize {
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (size.width == 768 && size.height == 1024) {
        size.height = 313; // iPad竖
    } else if (size.width == 1024 && size.height == 768) {
        size.height = 398; // iPad横
    } else if (size.width == 414 && size.height == 736) {
        size.height = 226; // 5.5竖
    } else if (size.width == 736 && size.height == 414) {
        size.height = 162; // 5.5横
    } else if (size.width < size.height) {
        size.height = 216; // 其他竖
    } else if (size.width > size.height) {
        size.height = 162; // 其他横
    }
    return size;
}

@end
