//
//  HLReceiveViewCell.m
//  倾聊
//
//  Created by 韩露露 on 2016/10/21.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLReceiveViewCell.h"
#import "UIImageView+WebCache.h"

@interface HLReceiveViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *receiveImage;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeConstraintH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoRightConstraint;

@end

@implementation HLReceiveViewCell

- (void)setupContentWithMsgObj:(XMPPMessageArchiving_Message_CoreDataObject *)msgObj showTime:(BOOL)show {
    UIImage *defaultHeadimage = [UIImage imageNamed:@"fts_default_headimage"];
    NSData *photo = [[HLXMPPTool sharedHLXMPPTool].vCarAvatar photoDataForJID:msgObj.bareJid];
    self.icon.image =  photo.length > 0 ? [UIImage imageWithData:photo] : defaultHeadimage;
    self.msgLabel.text = msgObj.body;
    
    NSString *msgType = [msgObj.message attributeStringValueForName:@"msgType"];
    if ([msgType isEqualToString:@"text"]) {
        self.msgLabel.hidden = NO;
        self.msgLabel.text = msgObj.body;
        [self changePhotoConstraintPriority:UILayoutPriorityDefaultLow];
        self.receiveImage.image = [UIImage stretchedImageWithName:@"chat_recive_nor"];
    } else if ([msgType isEqualToString:@"image"]) {
        self.msgLabel.hidden = YES;
        [self changePhotoConstraintPriority:999];
        [self.receiveImage sd_setImageWithURL:[NSURL URLWithString:msgObj.body] placeholderImage:[UIImage imageNamed:@"lodaing"]];
    }
    
    if (show) {
        self.msgTime.text = [NSDate timeIntervarWithDate:msgObj.timestamp];
        self.timeConstraintH.constant = 20;
    } else {
        self.timeConstraintH.constant = 0;
    }
}

- (void)changePhotoConstraintPriority:(UILayoutPriority)priority {
    if (self.photoTopConstraint.priority != priority) {
        self.photoTopConstraint.priority = priority;
    }
    if (self.photoRightConstraint.priority != priority) {
        self.photoRightConstraint.priority = priority;
    }
    if (self.photoLeftConstraint.priority != priority) {
        self.photoLeftConstraint.priority = priority;
    }
}

@end
