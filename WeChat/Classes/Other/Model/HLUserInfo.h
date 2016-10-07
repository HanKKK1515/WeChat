//
//  HLUserInfo.h
//  WeChat
//
//  Created by 韩露露 on 16/10/5.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface HLUserInfo : NSObject

singleton_interface(HLUserInfo);

@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *pwd;
@property (copy, nonatomic) NSString *previousUserName;

- (void)loadUserInfoData;
- (void)saveUserInfoData;

@end
