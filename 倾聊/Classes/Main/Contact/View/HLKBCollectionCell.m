//
//  HLKBCollectionCell.m
//  倾聊
//
//  Created by 韩露露 on 2016/10/26.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLKBCollectionCell.h"

@implementation HLKBCollectionCell
+ (instancetype)itemWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    static NSString *headerId = @"keyboardItem";
    return [collectionView dequeueReusableCellWithReuseIdentifier:headerId forIndexPath:indexPath];
}
@end
