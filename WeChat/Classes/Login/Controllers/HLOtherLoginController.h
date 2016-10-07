//
//  HLOtherLoginController.h
//  WeChat
//
//  Created by 韩露露 on 16/10/2.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLBaseLoginController.h"

typedef NS_ENUM(NSUInteger, HLUseType) {
    HLUseRegister = 1,
    HLUseOtherLogin,
    HLUseFirstLogin
};

@interface HLOtherLoginController : HLBaseLoginController

@property (assign, nonatomic) HLUseType useType;

@end
