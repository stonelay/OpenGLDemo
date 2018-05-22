//
//  BaseHeadInstController.h
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/26.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "BaseCollectionController.h"
#import "InstViewLayout.h"

@interface BaseHeadInstController : BaseCollectionController <InstFlowLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

- (void)registCell;

- (NSInteger)itemCountInSection:(NSInteger)section;// 非 head item count
- (NSInteger)headerSectionCount;
- (NSInteger)itemSectionCount;

@end
