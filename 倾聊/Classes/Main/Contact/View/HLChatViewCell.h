//
//  HLChatViewCell.h
//  倾聊
//
//  Created by 韩露露 on 2016/10/21.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLChatViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexpath msgArchivingObj:(XMPPMessageArchiving_Message_CoreDataObject *)msgObj showTime:(BOOL)show;

@end
