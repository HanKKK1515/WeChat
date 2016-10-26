//
//  HLCustomKeyboard.h
//  倾聊
//
//  Created by 韩露露 on 2016/10/21.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HLKeyboardStatusType) {
    HLKeyboardStatusSystem, // 系统键盘
    HLKeyboardStatusEmotion, // 表情键盘
    HLKeyboardStatusMore, // 图片、相机、录音等更多键盘
};

@class HLCustomKeyboard;
@protocol HLCustomKeyboardDelegate <NSObject>

@optional
- (void)customKeyboard:(HLCustomKeyboard *)customKeyboard didSelectItem:(NSString *)imageName;

@end

@interface HLCustomKeyboard : UIView

@property (assign, nonatomic) HLKeyboardStatusType keyboardType;
@property (weak, nonatomic) id<HLCustomKeyboardDelegate> delegate;

+ (instancetype)keyboard;

@end
