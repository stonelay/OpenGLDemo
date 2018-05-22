//
//  BaseHeadInstController.m
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/26.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "BaseHeadInstController.h"
#import "DefaultInstCell.h"
#import "DefaultInstHeadCell.h"

@interface BaseHeadInstController ()
@end

@implementation BaseHeadInstController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - override
- (void)addCollectionView {
    InstViewLayout *layout = [[InstViewLayout alloc] init];
    layout.delegate = self;
    
    CGFloat top = self.isHideNavigationBar ? 0 : NAVBARHEIGHT;
    self.contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, top, SCREENWIDTH, SCREENHEIGHT - top) collectionViewLayout:layout];
    
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.backgroundColor = ZLClearColor;
    
    [self registCell];
    
    [self.view addSubview:self.contentCollectionView];
}

#pragma mark - private method
- (void)registCell {
    [self.contentCollectionView registerClass:[DefaultInstCell class]
                   forCellWithReuseIdentifier:[DefaultInstCell cellIdentifier]];
    [self.contentCollectionView registerClass:[DefaultInstHeadCell class]
                   forCellWithReuseIdentifier:[DefaultInstHeadCell cellIdentifier]];
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZLLog(@"didSelectItemAtIndexPath: %@", indexPath);
}

#pragma mark - property
- (UICollectionViewCell *)cellForHeaderAtIndexPath:(NSIndexPath *)indexPath {
    DefaultInstHeadCell *headerCell =
    [DefaultInstHeadCell dequeueCellForCollection:self.contentCollectionView
                                                 forIndexPath:indexPath];
    headerCell.cellData = @"DefaultInstHeadCell";
    return headerCell;
}

- (UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DefaultInstCell *cell =
    [DefaultInstCell dequeueCellForCollection:self.contentCollectionView
                                 forIndexPath:indexPath];
    cell.cellData = @"DefaultInstCell";
    return cell;
}

- (CGSize)sizeForHeaderAtIndexPath:(NSIndexPath*)indexPath {
    return CGSizeMake(SCREENWIDTH, [[DefaultInstHeadCell heightForCell:nil] floatValue]);
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREENWIDTH, [[DefaultInstCell heightForCell:[NSString stringWithFormat:@"%ld", (long)indexPath.item]] floatValue]);
}

// 非 head item count
- (NSInteger)itemCountInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)headerSectionCount {
    return 0;
}

- (NSInteger)itemSectionCount {
    return 0;
}

#pragma mark - InstViewDelegateFlowLayout
// 列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(InstViewLayout *)layout numberOfColumnsInSection:(NSInteger)section {
    if ([self headerSectionCount] > section) {
        return 1;
    }
    return 2;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self headerSectionCount] > section) {
        return 1;
    }
    return [self itemCountInSection:section];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self headerSectionCount] + [self itemSectionCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self headerSectionCount] > indexPath.section) {
        return [self cellForHeaderAtIndexPath:indexPath];
    } else {
        return [self cellForItemAtIndexPath:indexPath];
    }
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section >= [self headerSectionCount]) {
        [self didSelectItemAtIndexPath:indexPath];
//    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(InstViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if ([self headerSectionCount] > section) {
        return 0;
    }
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(InstViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if ([self headerSectionCount] > section) {
        return 0;
    }
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(InstViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if ([self headerSectionCount] > section) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(0, 5, 10, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(InstViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self headerSectionCount] > indexPath.section) {
        return [self sizeForHeaderAtIndexPath:indexPath];
    }
    return [self sizeForItemAtIndexPath:indexPath];
}


@end
