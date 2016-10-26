//
//  HLKeyboardItemModel.m
//  倾聊
//
//  Created by 韩露露 on 2016/10/26.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLKeyboardItemModel.h"

@implementation HLKeyboardItemModel

+ (instancetype)iconWithDict:(NSDictionary *)dict {
    HLKeyboardItemModel *model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}


@end
