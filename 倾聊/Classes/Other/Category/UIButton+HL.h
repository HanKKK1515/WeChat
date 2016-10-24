//
//  UIButton+WF.h
//  WeiXin
//
//  Created by Yong Feng Guo on 14-11-18.
//  Copyright (c) 2014年 Fung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (HL)

/**
 * 设置普通状态与高亮状态的背景图片， 拉伸。
 */
- (void)setStretchedN_BG:(NSString *)nbg H_BG:(NSString *)hbg;
/**
 * 设置普通状态与高亮状态的背景图片， 不拉伸。
 */
- (void)setN_BG:(NSString *)nbg H_BG:(NSString *)hbg;
/**
 * 设置普通状态与高亮状态的image图片， 不拉伸。
 */
- (void)setN_Image:(NSString *)nImage H_Image:(NSString *)hImage;

@end
