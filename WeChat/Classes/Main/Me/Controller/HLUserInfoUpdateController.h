//
//  HLUserInfoUpdateController.h
//  WeChat
//
//  Created by 韩露露 on 2016/10/14.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HLUpdateCellType) {
    HLUpdateCellTypeOther,
    HLUpdateCellTypePhone,
    HLUpdateCellTypeMail
};

@class HLUserInfoUpdateController;
@protocol HLUserInfoUpdateControllerDelegate <NSObject>

@optional
- (void)userInfoDidChange;

@end

@interface HLUserInfoUpdateController : UIViewController

@property (weak, nonatomic) id<HLUserInfoUpdateControllerDelegate> delegate;
@property (weak, nonatomic) UITableViewCell *cell;
@property (assign, nonatomic) HLUpdateCellType updateCellType;

@end
