//
//  HLKeyboardItemModel.h
//  倾聊
//
//  Created by 韩露露 on 2016/10/26.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLKeyboardItemModel : NSObject

@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *title;

+ (instancetype)iconWithDict:(NSDictionary *)dict;

@end
