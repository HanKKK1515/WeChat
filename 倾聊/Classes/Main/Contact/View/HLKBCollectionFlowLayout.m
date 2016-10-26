//
//  HLKBCollectionFlowLayout.m
//  倾聊
//
//  Created by 韩露露 on 2016/10/26.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLKBCollectionFlowLayout.h"

@implementation HLKBCollectionFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    CGFloat rowMargin = 20;
    CGFloat insetTop = 20;
    CGFloat insetLeft = 10;
    CGFloat insetBottom = 30;
    CGFloat insetRight = 10;
    CGFloat collectionH = self.collectionView.frame.size.height;
    CGFloat collectionW = self.collectionView.frame.size.width;
    
    CGFloat itemH = (collectionH - (self.rowNo - 1) * rowMargin - insetTop - insetBottom) / self.rowNo;
    CGFloat itemW = itemH - self.labelH;
    CGFloat colMargin = (collectionW - itemW * self.colNo - insetLeft - insetRight) / (self.colNo - 1);
    
    self.itemSize = CGSizeMake(itemW, itemH);
    self.minimumInteritemSpacing = rowMargin;
    self.minimumLineSpacing = colMargin;
    self.sectionInset = UIEdgeInsetsMake(insetTop, insetLeft, insetBottom, insetRight);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    CGRect currentRect;
    currentRect.size = self.collectionView.frame.size;
    currentRect.origin = proposedContentOffset;
    NSArray *itemsAttrib = [self layoutAttributesForElementsInRect:currentRect];
    
    CGFloat itemCX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    CGFloat minDistance = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attris in itemsAttrib) {
        if (ABS(attris.center.x - itemCX) < ABS(minDistance)) {
            minDistance = attris.center.x - itemCX;
        }
    }
    NSUInteger item = ((proposedContentOffset.x + minDistance - self.collectionView.frame.size.width * 0.5) / self.collectionView.frame.size.width) + 1;
    if ([self.delegate respondsToSelector:@selector(KBCollectionFlowLayout:currentItem:)]) {
        [self.delegate KBCollectionFlowLayout:self currentItem:item];
    }
    return proposedContentOffset;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    CGFloat changeSizeRect = self.collectionView.frame.size.width * 0.5; // 图片开始放大时的center距离collectionView中心x的距离
    
    CGRect currentFrame; // 可视区域的frame
    currentFrame.size = self.collectionView.frame.size;
    currentFrame.origin = self.collectionView.contentOffset;
    
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5; // 可视区域的center.x
    
    // 获取可视区域内item属性的拷贝
    NSArray *currentItemAttrb = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:currentFrame] copyItems:YES];
    for (UICollectionViewLayoutAttributes *itemAttris in currentItemAttrb) {
        CGFloat distance = ABS(centerX - itemAttris.center.x); // 每个item中心到可视区域的center.x的距离
        CGFloat scale;
        if (distance <= changeSizeRect) {
            scale = 1 - distance * 0.6 / changeSizeRect;
        } else {
            scale = 0.4;
        }
        itemAttris.transform3D = CATransform3DMakeScale(scale, scale, scale);
    }
    return currentItemAttrb;
}

@end
