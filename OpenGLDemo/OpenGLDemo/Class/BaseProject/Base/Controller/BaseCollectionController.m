//
//  BaseCollectionController.m
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/22.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "BaseCollectionController.h"
#import "BaseCollectionCell.h"
#import "MJRefresh.h"

@interface BaseCollectionController ()

@end

@implementation BaseCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCollectionView];
    [self addRefreshAction];
}

#pragma mark - component
- (void)addCollectionView {
    [self.view addSubview:self.contentCollectionView];
    [self registCell];
}

- (UICollectionView *)contentCollectionView {
    if (!_contentCollectionView) {
        UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];
        
        CGFloat top = self.isHideNavigationBar ? 0 : NAVBARHEIGHT;
        
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, top, SCREENWIDTH, SCREENHEIGHT - top) collectionViewLayout:layout];
        
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.backgroundColor = [UIColor clearColor];
    }
    return _contentCollectionView;
}

#pragma mark - abstract methods

- (void)registCell {
    [self.contentCollectionView registerClass:[BaseCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([BaseCollectionCell class])];
}

- (void)addRefreshAction {
    
    BOOL isAddHeader = (self.scrollViewRefreshType & ScrollViewRefreshTypeHeader) == ScrollViewRefreshTypeHeader;
    BOOL isAddFooter = (self.scrollViewRefreshType & ScrollViewRefreshTypeFooter) == ScrollViewRefreshTypeFooter;
    
    weakSelf(self);
    if (isAddHeader) {
        self.contentCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            strongSelf(self);
            [self willRefresh];
        }];
    }
    
    if (isAddFooter) {
        self.contentCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            strongSelf(self);
            [self willLoadMore];
        }];
    }
}

- (void)couldScrollToFooter:(BOOL)couldScrollToFooter {
    BOOL isAddFooter = (self.scrollViewRefreshType & ScrollViewRefreshTypeFooter) == ScrollViewRefreshTypeFooter;
    if (!isAddFooter) {
        return;
    }
    if (couldScrollToFooter) {
        if (!self.contentCollectionView.mj_footer) {
            weakSelf(self);
            self.contentCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                strongSelf(self);
                [self willLoadMore];
            }];
        }
    } else {
        if (self.contentCollectionView.mj_footer) {
            self.contentCollectionView.mj_footer = nil;
        }
    }
}

- (void)reloadData {
    if (self.contentCollectionView) {
        [self.contentCollectionView reloadData];
    }
}


- (void)willRefresh {
    [super willRefresh];
}

- (void)doRefresh {
    [super doRefresh];
}

- (void)didRefresh {
    [super didRefresh];
    [self.contentCollectionView.mj_header endRefreshing];
}

- (void)willLoadMore {
    [super willLoadMore];
}

- (void)doLoadMore {
    [super doLoadMore];
}

- (void)didLoadMore {
    [super didLoadMore];
    [self.contentCollectionView.mj_footer endRefreshing];
}

#pragma mark - collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseCollectionCell *cell = [BaseCollectionCell dequeueCellForCollection:collectionView
                                                               forIndexPath:indexPath];
    return cell;
}


@end
