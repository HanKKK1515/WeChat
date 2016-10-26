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

@interface HLCustomKeyboard () <UICollectionViewDelegate, UICollectionViewDataSource, HLKBCollectionFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIPageControl *pageVC;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) HLKBCollectionFlowLayout *keyboardFL;

@property (strong, nonatomic) NSArray *componentIcons;
@property (strong, nonatomic) NSArray *emjIcons;
@end

@implementation HLCustomKeyboard

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
        keyboardFL.rowNo = 2;
        keyboardFL.colNo = 4;
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
        NSString *iconName = nil;
        if (self.keyboardType == HLKeyboardStatusEmotion) {
            iconName = self.emjIcons[indexPath.item];
        } else if (self.keyboardType == HLKeyboardStatusMore) {
            HLKeyboardItemModel *model = self.componentIcons[indexPath.item];
            iconName = model.icon;
        }
        
        [self.delegate customKeyboard:self didSelectItem:iconName];
    }
}

- (void)setKeyboardType:(HLKeyboardStatusType)keyboardType {
    _keyboardType = keyboardType;
    if (self.keyboardType == HLKeyboardStatusEmotion) {
        self.pageVC.numberOfPages = self.emjIcons.count / 8;
        self.keyboardFL.labelH = 0;
    } else if (self.keyboardType == HLKeyboardStatusMore) {
        self.pageVC.numberOfPages = self.componentIcons.count / 8;
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
