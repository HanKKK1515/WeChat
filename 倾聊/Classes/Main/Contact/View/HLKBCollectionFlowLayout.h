//
//  HLKBCollectionFlowLayout.h
//  倾聊
//
//  Created by 韩露露 on 2016/10/26.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HLKBCollectionFlowLayout;
@protocol HLKBCollectionFlowLayoutDelegate <NSObject>

@optional
- (void)KBCollectionFlowLayout:(HLKBCollectionFlowLayout *)KBCollectionFowLayout currentItem:(NSUInteger)item;

@end

@interface HLKBCollectionFlowLayout : UICollectionViewFlowLayout

@property (weak, nonatomic) id<HLKBCollectionFlowLayoutDelegate> delegate;
@property (assign, nonatomic) int rowNo; // 行数
@property (assign, nonatomic) int colNo; // 列数
@property (assign, nonatomic) CGFloat labelH; // 文字标签的高度

@end
