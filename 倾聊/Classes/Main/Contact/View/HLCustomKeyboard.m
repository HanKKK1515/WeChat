//
//  HLCustomKeyboard.h
//  倾聊
//
//  Created by 韩露露 on 2016/10/21.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLCustomKeyboard.h"
#import "HLKBCollectionFlowLayout.h"
#import "HLKeyboardItemModel.h"
#import "HLKBCollectionCell.h"

@interface HLCustomKeyboard () <UICollectionViewDelegate, UICollectionViewDataSource, HLKBCollectionFlowLayoutDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIPageControl *pageVC;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) HLKBCollectionFlowLayout *keyboardFL;

@property (strong, nonatomic) NSArray *componentIcons;
@property (strong, nonatomic) NSArray *emjIcons;
@end

@implementation HLCustomKeyboard

static const int colNo = 4;
static const int rowNo = 2;

+ (instancetype)keyboard {
    return [[NSBundle mainBundle] loadNibNamed:@"HLCustomKeyboard" owner:nil options:nil].lastObject;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundImage.image = [UIImage stretchedImageWithName:@"keyboard_bg"];
        
        HLKBCollectionFlowLayout *keyboardFL = [[HLKBCollectionFlowLayout alloc] init];
        keyboardFL.delegate = self;
        keyboardFL.rowNo = rowNo;
        keyboardFL.colNo = colNo;
        self.keyboardFL = keyboardFL;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:keyboardFL];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView = collectionView;
        [self insertSubview:collectionView atIndex:0];
        
        [collectionView registerNib:[UINib nibWithNibName:@"HLKBCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"keyboardItem"];
    }
    return self;
}

- (void)layoutSubviews {
    self.collectionView.frame = self.frame;
}

- (void)KBCollectionFlowLayout:(HLKBCollectionFlowLayout *)KBCollectionFowLayout currentItem:(NSUInteger)item {
    self.pageVC.currentPage = item;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.keyboardType == HLKeyboardStatusEmotion) {
        return self.emjIcons.count;
    } else if (self.keyboardType == HLKeyboardStatusMore) {
        return self.componentIcons.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HLKBCollectionCell *cell = [HLKBCollectionCell itemWithCollectionView:collectionView indexPath:indexPath];
    if (self.keyboardType == HLKeyboardStatusEmotion) {
        cell.icon.image = [UIImage imageNamed:self.emjIcons[indexPath.item]];
        cell.textLabel.text = nil;
    } else if (self.keyboardType == HLKeyboardStatusMore) {
        HLKeyboardItemModel *model = self.componentIcons[indexPath.item];
        cell.icon.image = [UIImage imageNamed:model.icon];
        cell.textLabel.text = model.title;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(customKeyboard:didSelectItem:)]) {
        if (self.keyboardType == HLKeyboardStatusEmotion) {
            NSString *iconName = self.emjIcons[indexPath.item];
            [self.delegate customKeyboard:self didSelectItem:[UIImage imageNamed:iconName]];
        } else if (self.keyboardType == HLKeyboardStatusMore) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            switch (indexPath.item) {
                case 1:
                case 6:
                case 9:
                case 12:
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                case 4:
                case 7:
                case 10:
                case 14:
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 3:
                case 5:
                case 8:
                case 11:
                case 13:
                case 15:
                    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    break;
                case 16:
                    [SVProgressHUD showWithStatus:@"此功能暂未开放"];
                    break;
            }
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.delegate customKeyboard:self didSelectItem:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)setKeyboardType:(HLKeyboardStatusType)keyboardType {
    _keyboardType = keyboardType;
    if (self.keyboardType == HLKeyboardStatusEmotion) {
        self.pageVC.numberOfPages = self.emjIcons.count / (rowNo * colNo);
        self.keyboardFL.labelH = 0;
    } else if (self.keyboardType == HLKeyboardStatusMore) {
        self.pageVC.numberOfPages = self.componentIcons.count / (rowNo * colNo);
        self.keyboardFL.labelH = 20;
    }
    [self.collectionView reloadData];
}

- (NSArray *)componentIcons {
    if (!_componentIcons) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"keyboard.plist" ofType:nil];
        NSArray *iconDict = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *iconModel = [NSMutableArray array];
        for (NSDictionary *dict in iconDict) {
            HLKeyboardItemModel *model = [HLKeyboardItemModel iconWithDict:dict];
            [iconModel addObject:model];
        }
        _componentIcons = iconModel;
    }
    return _componentIcons;
}

- (NSArray *)emjIcons {
    if (!_emjIcons) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"emoji_monkey.plist" ofType:nil];
        _emjIcons = [NSArray arrayWithContentsOfFile:path];
    }
    return _emjIcons;
}
    
@end
