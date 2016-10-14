//
//  HLUserInfoUpdateController.h
//  WeChat
//
//  Created by 韩露露 on 2016/10/14.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLUserInfoUpdateController;
@protocol HLUserInfoUpdateControllerDelegate <NSObject>

@optional
- (void)userInfoDidChange;

@end

@interface HLUserInfoUpdateController : UIViewController

@property (weak, nonatomic) id<HLUserInfoUpdateControllerDelegate> delegate;
@property (weak, nonatomic) UITableViewCell *cell;

@end
