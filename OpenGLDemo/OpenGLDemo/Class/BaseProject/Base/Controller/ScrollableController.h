//
//  ScrollableController.h
//  LayZhangDemo
//
//  Created by LayZhang on 2017/9/19.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "BaseController.h"

typedef NS_ENUM(NSInteger, ScrollViewRefreshType) {
    ScrollViewRefreshTypeNone               = 1 << 0,
    ScrollViewRefreshTypeHeader             = 1 << 1,
    ScrollViewRefreshTypeFooter             = 1 << 2,
};

@interface ScrollableController : BaseController

@property (nonatomic, assign) ScrollViewRefreshType scrollViewRefreshType;

@property (nonatomic, assign) BOOL      isBackToTop;
@property (nonatomic, strong) UIButton  *backToTopButton;
@property (nonatomic, assign) CGFloat   lastPosition;
@property (nonatomic, strong) NSString  *wp;

- (void)willRefresh;
- (void)doRefresh;
- (void)didRefresh;

- (void)willLoadMore;
- (void)doLoadMore;
- (void)didLoadMore;

- (void)loadData;

@end
