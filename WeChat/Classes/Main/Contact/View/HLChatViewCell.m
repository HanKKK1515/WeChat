//
//  HLChatViewCell.m
//  WeChat
//
//  Created by 韩露露 on 2016/10/21.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLChatViewCell.h"
#import "HLReceiveViewCell.h"
#import "HLSendViewCell.h"

@implementation HLChatViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexpath msgArchivingObj:(XMPPMessageArchiving_Message_CoreDataObject *)msgObj showTime:(BOOL)show {
    
    UIImage *defaultHeadimage = [UIImage imageNamed:@"fts_default_headimage"];
    if (msgObj.isOutgoing) {
        HLSendViewCell *sendCell = [tableView dequeueReusableCellWithIdentifier:@"sendCell" forIndexPath:indexpath];
        NSData *photo = [[HLXMPPTool sharedHLXMPPTool].vCarAvatar photoDataForJID:msgObj.bareJid];
        sendCell.icon.image = photo.length > 0 ? [UIImage imageWithData:photo] : defaultHeadimage;
        sendCell.msgLabel.text = msgObj.body;
        if (show) {
            sendCell.msgTime.text = [NSDate timeIntervarWithDate:msgObj.timestamp];
            sendCell.timeConstraintH.constant = 20;
        } else {
            sendCell.timeConstraintH.constant = 0;
        }
        return sendCell;
    } else {
        HLReceiveViewCell *receiveCell = [tableView dequeueReusableCellWithIdentifier:@"receiveCell" forIndexPath:indexpath];
        NSData *localPhoto = [HLUserInfo sharedHLUserInfo].photo;
        receiveCell.icon.image = localPhoto.length > 0 ? [UIImage imageWithData:localPhoto] : defaultHeadimage;
        receiveCell.msgLabel.text = msgObj.body;
        if (show) {
            receiveCell.msgTime.text = [NSDate timeIntervarWithDate:msgObj.timestamp];
            receiveCell.timeConstraintH.constant = 20;
        } else {
            receiveCell.timeConstraintH.constant = 0;
        }
        return receiveCell;
    }
}

@end
