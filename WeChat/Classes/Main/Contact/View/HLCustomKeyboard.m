//
//  HLCustomKeyboard.h
//  WeChat
//
//  Created by 韩露露 on 2016/10/21.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLCustomKeyboard.h"

@implementation HLCustomKeyboard

+ (instancetype)keyboard {
    return [[NSBundle mainBundle] loadNibNamed:@"HLCustomKeyboard" owner:nil options:nil].lastObject;
}

@end
