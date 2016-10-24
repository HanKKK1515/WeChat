//
//  UIImage+WF.h
//  WeiXin
//
//  Created by Yong Feng Guo on 14-11-19.
//  Copyright (c) 2014年 Fung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HL)

/**
 *返回中心拉伸的图片
 */
+ (UIImage *)stretchedImageWithName:(NSString *)name;
+ (UIImage *)resizableImage:(NSString *)name;
@end
