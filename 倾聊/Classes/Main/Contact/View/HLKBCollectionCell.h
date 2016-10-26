//
//  HLKBCollectionCell.h
//  倾聊
//
//  Created by 韩露露 on 2016/10/26.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLKBCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

+ (instancetype)itemWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
@end
