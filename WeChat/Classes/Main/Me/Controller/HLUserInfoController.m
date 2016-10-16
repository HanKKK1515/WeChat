//
//  HLUserInfoController.m
//  WeChat
//
//  Created by 韩露露 on 2016/10/13.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLUserInfoController.h"
#import "HLUserInfoUpdateController.h"

typedef NS_ENUM(NSUInteger, HLCellType) {
    HLCellNone,
    HLCellIcon,
    HLCellShowVC,
    HLCellORCode,
    HLCellAddress,
    HLCellSex,
    HLCellArea,
    HLCellSelfdom,
    HLCellLinkedIn
};

@interface HLUserInfoController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, HLUserInfoUpdateControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *iconCell; // 头像
@property (weak, nonatomic) IBOutlet UITableViewCell *nickNameCell; // 昵称
@property (weak, nonatomic) IBOutlet UITableViewCell *weixinNameCell; // 微信号
@property (weak, nonatomic) IBOutlet UITableViewCell *ORCodeCell; // 二维码
@property (weak, nonatomic) IBOutlet UITableViewCell *addressCell; // 我的地址
@property (weak, nonatomic) IBOutlet UITableViewCell *orgNameCell; // 公司名
@property (weak, nonatomic) IBOutlet UITableViewCell *orgUnitCell; // 公司部门
@property (weak, nonatomic) IBOutlet UITableViewCell *postCell; // 公司职位
@property (weak, nonatomic) IBOutlet UITableViewCell *phoneCell; // 公司电话
@property (weak, nonatomic) IBOutlet UITableViewCell *emailCell; // 邮箱
@property (weak, nonatomic) IBOutlet UITableViewCell *sexCell; // 性别
@property (weak, nonatomic) IBOutlet UITableViewCell *areaCell; // 地区
@property (weak, nonatomic) IBOutlet UITableViewCell *selfdomCell; // 个性签名
@property (weak, nonatomic) IBOutlet UITableViewCell *linkedInCell; // 领英

- (IBAction)back:(UIBarButtonItem *)sender;
@end

@implementation HLUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUserInfo];
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.sectionFooterHeight = 5;
}

- (void)setupUserInfo {
    XMPPvCardTemp *myVCardTemp = [HLXMPPTool sharedHLXMPPTool].vCarTemp.myvCardTemp;
    
    self.iconCell.tag = HLCellIcon;
    UIImageView *iconView = [self.iconCell.contentView viewWithTag:1];
    if (myVCardTemp.photo) {
        iconView.image = [UIImage imageWithData:myVCardTemp.photo];
    }
    
    self.nickNameCell.tag = HLCellShowVC;
    self.nickNameCell.detailTextLabel.text = myVCardTemp.nickname;
    
    self.weixinNameCell.tag = HLCellNone;
    self.weixinNameCell.detailTextLabel.text = [HLUserInfo sharedHLUserInfo].userName;
    
    self.ORCodeCell.tag = HLCellORCode;
    
    self.addressCell.tag = HLCellAddress;
    
    self.orgNameCell.tag = HLCellShowVC;
    self.orgNameCell.detailTextLabel.text = myVCardTemp.orgName;
    
    self.orgUnitCell.tag = HLCellShowVC;
    self.orgUnitCell.detailTextLabel.text = myVCardTemp.orgUnits.lastObject;
    
    self.postCell.tag = HLCellShowVC;
    self.postCell.detailTextLabel.text = myVCardTemp.title;
    
    self.phoneCell.tag = HLCellShowVC;
    self.phoneCell.detailTextLabel.text = myVCardTemp.telecomsAddresses.lastObject; // 电话号码返回为nil
    
    self.emailCell.tag = HLCellShowVC;
    self.emailCell.detailTextLabel.text = myVCardTemp.mailer;
    
    self.sexCell.tag = HLCellSex;
    
    self.areaCell.tag = HLCellArea;
    
    self.selfdomCell.tag = HLCellSelfdom;
    
    self.linkedInCell.tag = HLCellLinkedIn;
}

- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (cell.tag) {
        case HLCellNone:
            break;
        case HLCellIcon:
            [self setupIcon];
            break;
        case HLCellShowVC:
            [self performSegueWithIdentifier:@"showVC" sender:cell];
            break;
        case HLCellORCode:HLLog(@"二维码");
            break;
        case HLCellAddress:HLLog(@"我的地址");
            break;
        case HLCellSelfdom:HLLog(@"个性签名");
            break;
        case HLCellArea:HLLog(@"地区");
            break;
        case HLCellSex:HLLog(@"性别");
            break;
        case HLCellLinkedIn:HLLog(@"领英");
            break;
    }
}

- (void)showPickerWithType:(UIImagePickerControllerSourceType)sourceType {
    if (sourceType == UIImagePickerControllerSourceTypeCamera && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:NO completion:nil];
}

- (void)setupIcon {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPickerWithType:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *actionPhotoLib = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionCamera];
    [alert addAction:actionPhotoLib];
    [alert addAction:actionCancel];
    [self presentViewController:alert animated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImageView *iconView = [self.iconCell.contentView viewWithTag:1];
    UIImage *icon = info[UIImagePickerControllerEditedImage];
    if (icon && iconView) {
        iconView.image = icon;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self userInfoDidChange];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id dest = segue.destinationViewController;
    if ([dest isMemberOfClass:HLUserInfoUpdateController.class]) {
        HLUserInfoUpdateController *updateVC = dest;
        updateVC.cell = sender;
        updateVC.delegate = self;
        
        if (sender == self.phoneCell) {
            updateVC.updateCellType = HLUpdateCellTypePhone;
        } else if (sender == self.emailCell) {
            updateVC.updateCellType = HLUpdateCellTypeMail;
        } else {
            updateVC.updateCellType = HLUpdateCellTypeOther;
        }
    }
}

- (void)userInfoDidChange {
    XMPPvCardTempModule *vCardTempModule = [HLXMPPTool sharedHLXMPPTool].vCarTemp;
    XMPPvCardTemp *vCardTemp = vCardTempModule.myvCardTemp;
    UIImageView *iconView = [self.iconCell.contentView viewWithTag:1];
    vCardTemp.photo = UIImageJPEGRepresentation(iconView.image, 0.8);
    vCardTemp.nickname = self.nickNameCell.detailTextLabel.text;
    vCardTemp.orgName = self.orgNameCell.detailTextLabel.text;
    vCardTemp.title = self.postCell.detailTextLabel.text;
    vCardTemp.mailer = self.emailCell.detailTextLabel.text;
    
    NSString *orgUnit = self.orgUnitCell.detailTextLabel.text;
    if (orgUnit.length > 0) {
        vCardTemp.orgUnits = @[orgUnit];
    }
    NSString *telecom = self.phoneCell.detailTextLabel.text;
    if (telecom.length > 0) {
        vCardTemp.telecomsAddresses = @[telecom];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [vCardTempModule updateMyvCardTemp:vCardTemp];
    });
}

- (void)dealloc {
    HLLog(@"HLUserInfoController");
}

@end
