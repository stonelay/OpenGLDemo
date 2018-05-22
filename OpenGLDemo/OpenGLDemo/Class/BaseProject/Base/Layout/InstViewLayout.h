//
//  InstViewLayout.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/25.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InstFlowLayoutDelegate;


@interface InstViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<InstFlowLayoutDelegate> delegate;

@end


@protocol InstFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>

- (NSInteger)collectionView:(UICollectionView *)collectionView
                     layout:(InstViewLayout *)layout
   numberOfColumnsInSection:(NSInteger)section;


@end
