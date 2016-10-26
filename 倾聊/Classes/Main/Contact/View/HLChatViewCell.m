//
//  HLChatViewCell.m
//  倾聊
//
//  Created by 韩露露 on 2016/10/21.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLChatViewCell.h"
#import "HLReceiveViewCell.h"
#import "HLSendViewCell.h"

@implementation HLChatViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexpath msgArchivingObj:(XMPPMessageArchiving_Message_CoreDataObject *)msgObj showTime:(BOOL)show {
    if (msgObj.isOutgoing) {
        HLSendViewCell *sendCell = [tableView dequeueReusableCellWithIdentifier:@"sendCell" forIndexPath:indexpath];
        [sendCell setupContentWithMsgObj:msgObj showTime:show];
        return sendCell;
    } else {
        HLReceiveViewCell *receiveCell = [tableView dequeueReusableCellWithIdentifier:@"receiveCell" forIndexPath:indexpath];
        [receiveCell setupContentWithMsgObj:msgObj showTime:show];
        return receiveCell;
    }
}

@end
