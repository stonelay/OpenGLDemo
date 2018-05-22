//
//  InstViewLayout.m
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/25.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "InstViewLayout.h"

@interface InstViewLayout()

/**
 * 每一个section 的 frame
 * path         sectionRects[sectionIndex]
 * elements     CGRect
 */
@property (nonatomic, strong) NSMutableArray *sectionRects;
/**
 * section 每列 的 frame
 * path         columnRectsInSection[sectionIndex][columnIndex][itemIndex]
 * elements     CGRect
 */
@property (nonatomic, strong) NSMutableArray *columnRectsInSection;
/**
 * item attributes
 * path         layoutItemAttributes[sectionIndex][itemIndex]
 * elements     CGRect
 */
@property (nonatomic, strong) NSMutableArray *layoutItemAttributes;
/**
 * 追加的 headerView footerView
 * @{ UICollectionElementKindSectionHeader:[NSMutableArray array],
      UICollectionElementKindSectionFooter:[NSMutableArray array] }
 * path         headerFooterItemAttributes[kind][sectionIndex]
 * elements     UICollectionViewLayoutAttributes {frame}
 */
@property (nonatomic, strong) NSDictionary *headerFooterItemAttributes;
/**
 * section 边距
 * path         sectionInsetses[sectionIndex]
 * elements     UIEdgeInsets
 */
@property (nonatomic, strong) NSMutableArray *sectionInsetses;
/**
 * 当前 边距 更新UI 需要
 */
@property (nonatomic) UIEdgeInsets currentEdgeInsets;

@end

@implementation InstViewLayout

#pragma mark - layout override

- (CGSize)collectionViewContentSize {
    [super collectionViewContentSize];
    CGRect lastSectionRect = [[self.sectionRects lastObject] CGRectValue];
    CGSize lastSize = CGSizeMake(self.collectionView.width, CGRectGetMaxY(lastSectionRect));
    return lastSize;
}

- (void)prepareLayout {
    
    NSUInteger numberOfSections = self.collectionView.numberOfSections;
    self.sectionRects = [[NSMutableArray alloc] initWithCapacity:numberOfSections];
    self.columnRectsInSection = [[NSMutableArray alloc] initWithCapacity:numberOfSections];
    self.layoutItemAttributes = [[NSMutableArray alloc] initWithCapacity:numberOfSections];
    self.sectionInsetses = [[NSMutableArray alloc] initWithCapacity:numberOfSections];
    self.headerFooterItemAttributes = @{UICollectionElementKindSectionHeader:[NSMutableArray array], UICollectionElementKindSectionFooter:[NSMutableArray array]};
    
    for (NSUInteger section = 0; section < numberOfSections; ++section) {
        NSUInteger itemsInSection = [self.collectionView numberOfItemsInSection:section];
        [self.layoutItemAttributes addObject:[NSMutableArray array]];
        [self prepareLayoutInSection:section numberOfItems:itemsInSection];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(NSIndexPath *)indexPath {
    return self.headerFooterItemAttributes[kind][indexPath.section];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutItemAttributes[indexPath.section][indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self searchVisibleLayoutAttributesInRect:rect];
}

#pragma mark - items attributes
- (NSArray *)searchVisibleLayoutAttributesInRect:(CGRect)rect {
    NSMutableArray *itemAttrs = [[NSMutableArray alloc] init];
    // 检测 所有 要显示在界面的 sectionrect 索引
    NSIndexSet *visibleSections = [self sectionIndexesInRect:rect];
    [visibleSections enumerateIndexesUsingBlock:^(NSUInteger sectionIdx, BOOL *stop) {
        
        // 需要显示在 界面的 item index
        for (UICollectionViewLayoutAttributes *itemAttr in self.layoutItemAttributes[sectionIdx]) {
            CGRect itemRect = itemAttr.frame;
            itemAttr.zIndex = 1;
            BOOL isVisible = CGRectIntersectsRect(rect, itemRect);
            if (isVisible)
                [itemAttrs addObject:itemAttr];
        }
        
        // 需要显示在 界面的 footer index
        if ([self.headerFooterItemAttributes[UICollectionElementKindSectionFooter] count] > sectionIdx) {
            UICollectionViewLayoutAttributes *footerAttribute = self.headerFooterItemAttributes[UICollectionElementKindSectionFooter][sectionIdx];
            BOOL isVisible = CGRectIntersectsRect(rect, footerAttribute.frame);
            if (isVisible && footerAttribute)
                [itemAttrs addObject:footerAttribute];
            self.currentEdgeInsets = UIEdgeInsetsZero;
        } else {
            self.currentEdgeInsets = [self.sectionInsetses[sectionIdx] UIEdgeInsetsValue];
        }
        
        // 需要显示在 界面的 header index
        if([self.headerFooterItemAttributes[UICollectionElementKindSectionHeader] count] > sectionIdx) {
            UICollectionViewLayoutAttributes *headerAttribute = self.headerFooterItemAttributes[UICollectionElementKindSectionHeader][sectionIdx];
            
            UICollectionViewLayoutAttributes *lastCell = [itemAttrs lastObject];
            
            if(headerAttribute)
                [itemAttrs addObject:headerAttribute];
            
            [self updateHeaderAttributes:headerAttribute lastCellAttributes:lastCell];
        }
    }];
    return itemAttrs;
}

- (void)updateHeaderAttributes:(UICollectionViewLayoutAttributes *)attributes
            lastCellAttributes:(UICollectionViewLayoutAttributes *)lastCellAttributes {
    CGRect currentBounds = self.collectionView.bounds;
    attributes.zIndex = 1024;
    attributes.hidden = NO;
    
    CGPoint origin = attributes.frame.origin;
    
    CGFloat sectionMaxY = CGRectGetMaxY(lastCellAttributes.frame) - attributes.frame.size.height + self.currentEdgeInsets.bottom;
    
    CGFloat y = CGRectGetMaxY(currentBounds) - currentBounds.size.height + self.collectionView.contentInset.top;
    
    CGFloat maxY = MIN(MAX(y, attributes.frame.origin.y), sectionMaxY);
    
    origin.y = maxY;
    
    attributes.frame = (CGRect){
        origin,
        attributes.frame.size
    };
}

// 在显示界面的 section 索引
- (NSIndexSet *)sectionIndexesInRect:(CGRect)rect {
    CGRect theRect = rect;
    NSMutableIndexSet *visibleIndexes = [[NSMutableIndexSet alloc] init];
    NSUInteger numberOfSections = self.collectionView.numberOfSections;
    for (NSUInteger sectionIdx = 0; sectionIdx < numberOfSections; ++sectionIdx) {
        CGRect sectionRect = [self.sectionRects[sectionIdx] CGRectValue];
        BOOL isVisible = CGRectIntersectsRect(theRect, sectionRect);
        if (isVisible)
            [visibleIndexes addIndex:sectionIdx];
    }
    return visibleIndexes;
}

#pragma mark - Private Methods

- (void)prepareLayoutInSection:(NSUInteger)section numberOfItems:(NSUInteger)items {
    UICollectionView *collectionView = self.collectionView;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    
    // 获取 前一个 rect, 在 sectionRects 中
    CGRect previousSectionRect = [self rectForSectionAtIndex:indexPath.section - 1];
    CGRect sectionRect;
    sectionRect.origin.x = 0;
    sectionRect.origin.y = CGRectGetMaxY(previousSectionRect);
    sectionRect.size.width = collectionView.width;
    
    // 计算 header 的高度
    CGFloat headerHeight = 0.0f;
    
    // 检查 是否实现了 flowLayout, 若有head, headerHeight  要考虑进去
    if([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        
        CGRect headerFrame;
        headerFrame.origin.x = 0.0f;
        headerFrame.origin.y = sectionRect.origin.y;
        
        CGSize headerSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section];
        headerFrame.size = headerSize;
        
        UICollectionViewLayoutAttributes *headerAttributes =
        [UICollectionViewLayoutAttributes
         layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
         withIndexPath:indexPath];
        headerAttributes.frame = headerFrame;
        
        headerHeight = headerFrame.size.height;
        [self.headerFooterItemAttributes[UICollectionElementKindSectionHeader] addObject:headerAttributes];
    }
    
    // 计算 item 内容的rect
    UIEdgeInsets sectionInsets = UIEdgeInsetsZero;
    
    // flowLayout section inset
    if([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        sectionInsets = [self.delegate collectionView:collectionView layout:self insetForSectionAtIndex:section];
    }
    
    [self.sectionInsetses addObject:[NSValue valueWithUIEdgeInsets:sectionInsets]];
    
    // section 之间的距离 和 item 之间的距离
    CGFloat lineSpacing = 0.0f;
    CGFloat interitemSpacing = 0.0f;
    
    if([self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        lineSpacing = [self.delegate collectionView:collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    
    if([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        interitemSpacing = [self.delegate collectionView:collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    
    CGRect itemsContentRect;
    itemsContentRect.origin.x = sectionInsets.left;
    itemsContentRect.origin.y = headerHeight + sectionInsets.top;
    
    NSUInteger numberOfColumns = [self.delegate collectionView:collectionView layout:self numberOfColumnsInSection:section];
    itemsContentRect.size.width = collectionView.width - (sectionInsets.left + sectionInsets.right);
    
    // 每列的宽度
    CGFloat columnSpace = itemsContentRect.size.width - (interitemSpacing * (numberOfColumns - 1));
    CGFloat columnWidth = (columnSpace/numberOfColumns);
    
    [self.columnRectsInSection addObject:[NSMutableArray arrayWithCapacity:numberOfColumns]];
    // 有多列 布局
    for (NSUInteger colIdx = 0; colIdx < numberOfColumns; ++colIdx)
        [self.columnRectsInSection[section] addObject:[NSMutableArray array]];
    
    // 分配 item 的布局
    for (NSInteger itemIdx = 0; itemIdx < items; ++itemIdx) {
        NSIndexPath *itemPath = [NSIndexPath indexPathForItem:itemIdx inSection:section];
        NSInteger destColumnIdx = [self preferredColumnIndexInSection:section];
        NSInteger destRowInColumn = [self numberOfItemsForColumn:destColumnIdx inSection:section];
        CGFloat lastItemInColumnOffsetY = [self lastItemOffsetYForColumn:destColumnIdx inSection:section];
        
        // 需要考虑 一开始要加上之前的 section的bottom
        if (destRowInColumn == 0) {
            lastItemInColumnOffsetY += sectionRect.origin.y;
        }
        
        // 计算 item rect
        CGRect itemRect;
        itemRect.origin.x = itemsContentRect.origin.x + destColumnIdx * (interitemSpacing + columnWidth);
        itemRect.origin.y = lastItemInColumnOffsetY + (destRowInColumn > 0 ? lineSpacing: sectionInsets.top);
        itemRect.size.width = columnWidth;
        itemRect.size.height = columnWidth;
        
        // 宽度 确定, 自定义高度
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
            CGSize itemSize = [self.delegate collectionView:collectionView layout:self sizeForItemAtIndexPath:itemPath];
            itemRect.size.height = itemSize.height;
        }
        
        UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemPath];
        itemAttributes.frame = itemRect;
        [self.layoutItemAttributes[section] addObject:itemAttributes];
        [self.columnRectsInSection[section][destColumnIdx] addObject:[NSValue valueWithCGRect:itemRect]];
    }
    
    // 这个 获取的是 maxY
    itemsContentRect.size.height = [self heightOfItemsInSection:indexPath.section] + sectionInsets.bottom;
    
    // 计算 footer 高度
    CGFloat footerHeight = 0.0f;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        CGRect footerFrame;
        footerFrame.origin.x = 0;
        footerFrame.origin.y = itemsContentRect.size.height;
        
        CGSize footerSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:indexPath.section];
        footerFrame.size.height = footerSize.height;
        footerFrame.size.width = footerSize.width;
        
        UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes
                                                              layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                              withIndexPath:indexPath];
        footerAttributes.frame = footerFrame;
        
        footerHeight = footerFrame.size.height;
        
        [self.headerFooterItemAttributes[UICollectionElementKindSectionFooter] addObject:footerAttributes];
    }
    
    if (section > 0) {
        // maxY --> minY
        itemsContentRect.size.height -= sectionRect.origin.y;
    }
    
    sectionRect.size.height = itemsContentRect.size.height + footerHeight;
    
    [self.sectionRects addObject:[NSValue valueWithCGRect:sectionRect]];
}

// 一个个计算 添加
- (CGRect)rectForSectionAtIndex:(NSInteger)sectionIdx {
    if (sectionIdx < 0 || sectionIdx >= self.sectionRects.count)
        return CGRectZero;
    return [self.sectionRects[sectionIdx] CGRectValue];
}

- (NSInteger)preferredColumnIndexInSection:(NSInteger)sectionIdx {
    NSUInteger shortestColumnIdx = 0;
    CGFloat heightOfShortestColumn = CGFLOAT_MAX;
    for (NSUInteger columnIdx = 0; columnIdx < [self.columnRectsInSection[sectionIdx] count]; ++columnIdx) {
        // 若 高度最短的那一列
        CGFloat columnHeight = [self lastItemOffsetYForColumn:columnIdx inSection:sectionIdx];
        if (columnHeight < heightOfShortestColumn) {
            shortestColumnIdx = columnIdx;
            heightOfShortestColumn = columnHeight;
        }
    }
    return shortestColumnIdx;
}

- (CGFloat)lastItemOffsetYForColumn:(NSInteger)columnIdx inSection:(NSInteger)sectionIdx {
    NSArray *itemsInColumn = self.columnRectsInSection[sectionIdx][columnIdx];
    if (itemsInColumn.count == 0) {
        // 获取 当前列 headview 的高度
        if([self.headerFooterItemAttributes[UICollectionElementKindSectionHeader] count] > sectionIdx) {
            CGRect headerFrame = [self.headerFooterItemAttributes[UICollectionElementKindSectionHeader][sectionIdx] frame];
            return headerFrame.size.height;
        }
        return 0.0f;
    } else {
        CGRect lastItemRect = [[itemsInColumn lastObject] CGRectValue];
        return CGRectGetMaxY(lastItemRect);
    }
}

// 这一列的 rect count
- (NSInteger)numberOfItemsForColumn:(NSInteger)columnIdx inSection:(NSInteger)sectionIdx {
    return [self.columnRectsInSection[sectionIdx][columnIdx] count];
}

// 当前 section中 最 长的 那个colum
- (CGFloat)heightOfItemsInSection:(NSUInteger)sectionIdx {
    CGFloat maxHeightBetweenColumns = 0.0f;
    NSArray *columnsInSection = self.columnRectsInSection[sectionIdx];
    for (NSUInteger columnIdx = 0; columnIdx < columnsInSection.count; ++columnIdx) {
        CGFloat heightOfColumn = [self lastItemOffsetYForColumn:columnIdx inSection:sectionIdx];
        maxHeightBetweenColumns = MAX(maxHeightBetweenColumns, heightOfColumn);
    }
    return maxHeightBetweenColumns;
}


@end
