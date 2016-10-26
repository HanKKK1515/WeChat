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
@property (weak, nonatomic) IBOutlet UIPageControl *pageVC;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (strong, nonatomic) NSArray *icons;
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
    return self.icons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HLKBCollectionCell *cell = [HLKBCollectionCell itemWithCollectionView:collectionView indexPath:indexPath];
    HLKeyboardItemModel *model = self.icons[indexPath.item];
    cell.icon.image = [UIImage imageNamed:model.icon];
    cell.textLabel.text = model.title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(customKeyboard:didSelectItem:)]) {
        HLKeyboardItemModel *model = self.icons[indexPath.item];
        [self.delegate customKeyboard:self didSelectItem:model.icon];
    }
}

- (NSArray *)icons {
    if (!_icons) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"keyboard.plist" ofType:nil];
        NSArray *iconDict = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *iconModel = [NSMutableArray array];
        for (NSDictionary *dict in iconDict) {
            HLKeyboardItemModel *model = [HLKeyboardItemModel iconWithDict:dict];
            [iconModel addObject:model];
        }
        _icons = iconModel;
    }
    return _icons;
}
    
@end
