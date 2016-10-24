//
//  UIButton+WF.m
//  WeiXin
//
//  Created by Yong Feng Guo on 14-11-18.
//  Copyright (c) 2014年 Fung. All rights reserved.
//

#import "UIButton+HL.h"
#import "UIImage+HL.h"

@implementation UIButton (HL)

- (void)setStretchedN_BG:(NSString *)nbg H_BG:(NSString *)hbg {
    [self setBackgroundImage:[UIImage stretchedImageWithName:nbg] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage stretchedImageWithName:hbg] forState:UIControlStateHighlighted];
}

- (void)setN_BG:(NSString *)nbg H_BG:(NSString *)hbg {
    [self setBackgroundImage:[UIImage imageNamed:nbg] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:hbg] forState:UIControlStateHighlighted];
}

- (void)setN_Image:(NSString *)nImage H_Image:(NSString *)hImage {
    [self setImage:[UIImage imageNamed:nImage] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:hImage] forState:UIControlStateHighlighted];
}

@end
