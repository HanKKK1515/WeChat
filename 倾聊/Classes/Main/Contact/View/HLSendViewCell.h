//
//  HLSendViewCell.h
//  倾聊
//
//  Created by 韩露露 on 2016/10/21.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLChatViewCell.h"

@interface HLSendViewCell : HLChatViewCell

- (void)setupContentWithMsgObj:(XMPPMessageArchiving_Message_CoreDataObject *)msgObj showTime:(BOOL)show;

@end
