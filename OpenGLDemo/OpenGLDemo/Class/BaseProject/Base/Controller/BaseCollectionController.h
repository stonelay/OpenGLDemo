//
//  BaseCollectionController.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/22.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "ScrollableController.h"

@interface BaseCollectionController : ScrollableController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *contentCollectionView;

// 需要子类 实现  重写layout
- (void)reloadData;

- (void)couldScrollToFooter:(BOOL)couldScrollToFooter;

@end
