//
//  BaseCollectionCell.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/22.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionCell : UICollectionViewCell

@property (nonatomic, strong) id cellData;

+ (NSString *)cellIdentifier;
+ (NSNumber *)heightForCell:(id)cellData;
+ (NSNumber *)widthForCell:(id)cellData;
+ (instancetype)dequeueCellForCollection:(UICollectionView *)collectionView
                            forIndexPath:(NSIndexPath *)indexPath;
- (void)reloadData;

- (void)cellAddSubview:(UIView *)view;

@end
